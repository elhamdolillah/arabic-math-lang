#!/usr/bin/env python3
import hashlib,json,os,re,subprocess,sys,time
from pathlib import Path
from datetime import datetime,timezone
ROOT=Path('/srv/mal/auto/smollm_mal'); ROOT.mkdir(parents=True,exist_ok=True)
STATE=ROOT/'state.json'; LOG=ROOT/'events.jsonl'; REPORT=ROOT/'hourly_report.md'; LOCK=ROOT/'run.lock'
OUT=ROOT/'conversions'; OUT.mkdir(exist_ok=True)
SCAN=[Path('/srv/mal/candle-mal/src'),Path('/srv/mal/compiler/src'),Path('/srv/mal/isolated_tensor_runtime')]
EXT={'.c','.h','.rs','.py','.mal'}
SKIP={'target','build','venv','.git','cache','__pycache__'}

def now(): return datetime.now(timezone.utc).isoformat()
def disk():
 s=os.statvfs('/'); free=s.f_bavail*s.f_frsize; total=s.f_blocks*s.f_frsize
 return int((total-free)*100/total), free//1024

def log(x):
 x={'ts':now(),**x}; LOG.open('a').write(json.dumps(x,ensure_ascii=False)+'\n'); return x
def load():
 try:return json.loads(STATE.read_text())
 except:return {'items':{},'last_cycle':None}
def save(x): STATE.write_text(json.dumps(x,ensure_ascii=False,indent=2))
def sha(p):
 h=hashlib.sha256(); h.update(p.read_bytes()); return h.hexdigest()
def candidates():
 out=[]
 for base in SCAN:
  if not base.exists(): continue
  for p in base.rglob('*'):
   if p.is_file() and p.suffix in EXT and not any(x in SKIP for x in p.parts):
    try:
     if p.stat().st_size<=2_000_000: out.append(p)
    except: pass
 return sorted(out,key=lambda p:(p.suffix,str(p)))
def function_names(src):
 return re.findall(r'\b(?:static\s+|inline\s+)*(?:void|int|float|double|size_t|bool|uint\w*|int\w*)\s+([A-Za-z_]\w*)\s*\([^;{}]*\)\s*\{',src)
def classify(p):
 b=p.read_bytes(); before=len(b); ext=p.suffix
 if ext=='.mal': return {'status':'MAL_NATIVE_SOURCE','reason':'already MAL','output_bytes':before}
 if ext!='.c': return {'status':'MANUAL_REQUIRED','reason':f'no safe deterministic translator for {ext}','output_bytes':0}
 src=b.decode('utf-8','replace'); names=function_names(src)
 if not names:return {'status':'MANUAL_REQUIRED','reason':'no C function definitions','output_bytes':0}
 # Only scalar, pointer-free functions are eligible for current deterministic translator.
 eligible=[]; blocked=[]
 for n in names:
  m=re.search(r'(?:void|int|float|double|size_t|bool|uint\w*|int\w*)\s+'+re.escape(n)+r'\s*\((.*?)\)\s*\{',src,re.S)
  frag=m.group(0) if m else ''
  if any(x in frag for x in ('[','*','->','for(','while(','switch(')): blocked.append(n)
  else: eligible.append(n)
 if not eligible:return {'status':'MANUAL_REQUIRED','reason':'array/pointer/control-flow requires type-directed lowering','functions':names,'blocked':blocked,'output_bytes':0}
 # Record a conservative MAL stub only for scalar functions; never overwrite source.
 out=OUT/(p.name+'.mal.probe'); text='\n'.join(f'// candidate: {n}\n// status: scalar AST candidate; parity required before activation' for n in eligible)+'\n'; out.write_text(text)
 return {'status':'CANDIDATE_RECORDED','functions':eligible,'blocked':blocked,'output_bytes':len(text)}
def cycle():
 if LOCK.exists(): return log({'status':'SKIPPED_LOCK'})
 LOCK.write_text(str(os.getpid()))
 try:
  used,free=disk(); st=load(); st['last_cycle']=now(); st['disk']={'used_percent':used,'free_kb':free}
  if used>=95 or free<1048576:
   st['status']='PAUSED_DISK_GUARD'; save(st); return log({'status':'PAUSED_DISK_GUARD','used_percent':used,'free_kb':free})
  if subprocess.run(['systemctl','is-active','--quiet','mal-training-window.service']).returncode==0:
   st['status']='PAUSED_TRAINING'; save(st); return log({'status':'PAUSED_TRAINING'})
  for p in candidates():
   key=str(p); digest=sha(p); old=st['items'].get(key)
   if old and old.get('sha256')==digest: continue
   result=classify(p); item={'path':key,'sha256':digest,'source_bytes':p.stat().st_size,**result,'updated_at':now()}
   st['items'][key]=item; st['status']='RUNNING'; save(st); return log(item)
  st['status']='IDLE_NO_NEW_FILES'; save(st); return log({'status':st['status'],'candidate_count':len(candidates())})
 finally:
  try:LOCK.unlink()
  except:pass
def hourly():
 events=[]
 if LOG.exists():
  cutoff=time.time()-3600
  for line in LOG.read_text().splitlines():
   try:
    x=json.loads(line); ts=datetime.fromisoformat(x['ts']).timestamp()
    if ts>=cutoff: events.append(x)
   except: pass
 counts={}
 for x in events: counts[x.get('status','UNKNOWN')]=counts.get(x.get('status','UNKNOWN'),0)+1
 used,free=disk(); lines=[f'# SmolLM2 MAL hourly report — {now()}','',f'- Disk: **{used}% used**, {free} KB free',f'- Events in last hour: **{len(events)}**','', '## Status counts','']
 for k,v in sorted(counts.items()): lines.append(f'- `{k}`: {v}')
 lines += ['', '## Latest events','']
 for x in events[-20:]: lines.append(f"- `{x.get('status')}` — `{x.get('path','')}` — source={x.get('source_bytes','-')}B output={x.get('output_bytes','-')}B; {x.get('reason','')}")
 lines += ['', '## Policy','', 'Only deterministic, non-destructive, one-item-per-cycle processing is enabled. Files requiring pointer/array/control-flow lowering remain `MANUAL_REQUIRED`; no source is deleted or replaced.']
 REPORT.write_text('\n'.join(lines)+'\n')
 return REPORT
if __name__=='__main__':
 print(hourly() if '--hourly' in sys.argv else json.dumps(cycle(),ensure_ascii=False))
