from __future__ import annotations
import re
from dataclasses import dataclass
from pathlib import Path
_TOKEN=re.compile(r"\r\n|\n|==|!=|>|<|[=+*/()\-]|[^\s=+*/()\-<>!]+",re.UNICODE)
_FORBIDDEN=("eval","exec","unsafe")
_MAX_U64=18_446_744_073_709_551_615
_MAX_LOOP_FUEL=1000
class ReferenceError(Exception): pass
@dataclass(frozen=True)
class Node:
 opcode:str; name:str|None=None; left:int|None=None; right:int|None=None; numeric_value:int=0
class ReferenceParser:
 def __init__(self,source:str)->None:self.tokens=_TOKEN.findall(source);self.index=0;self.nodes:list[Node]=[]
 def take(self)->str:
  if self.index>=len(self.tokens):raise ReferenceError
  x=self.tokens[self.index];self.index+=1;return x
 def peek(self)->str|None:return self.tokens[self.index] if self.index<len(self.tokens) else None
 def skip(self)->None:
  while self.peek() in ("\n","\r\n"):self.take()
 def alloc(self,n:Node)->int:
  if len(self.nodes)>=256:raise ReferenceError
  i=len(self.nodes);self.nodes.append(n);return i
 def parse(self)->int:
  self.skip();root=self.statement()
  while True:
   self.skip()
   if self.peek() is None:return root
   nxt=self.statement();root=self.alloc(Node("SEQUENCE",left=root,right=nxt,numeric_value=self.nodes[nxt].numeric_value))
 def statement(self)->int:
  return {"إذا":self.parse_if,"طالما":self.parse_while,"دالة":self.parse_function}.get(self.peek(),self.parse_declaration)()
 def parse_if(self)->int:
  if self.take()!="إذا":raise ReferenceError
  c=self.comparison()
  if self.take()!="فإن":raise ReferenceError
  self.skip();b=self.statement();self.skip()
  if self.take()!="نهاية":raise ReferenceError
  return self.alloc(Node("IF_STATEMENT",left=c,right=b))
 def parse_while(self)->int:
  if self.take()!="طالما":raise ReferenceError
  c=self.comparison()
  if self.take()!="كرر":raise ReferenceError
  self.skip();b=self.statement();self.skip()
  if self.take()!="نهاية":raise ReferenceError
  return self.alloc(Node("WHILE_LOOP",left=c,right=b))
 def parse_function(self)->int:
  if self.take()!="دالة":raise ReferenceError
  name=self.take()
  if not (name.startswith("بنية_") or name.isidentifier()):raise ReferenceError
  if self.take()!="(":raise ReferenceError
  param=self.take()
  if self.take()!=")" or self.take()!="فإن":raise ReferenceError
  self.skip();p=self.alloc(Node("BIND_SYMBOL",name=param));b=self.statement();self.skip()
  if self.take()!="نهاية":raise ReferenceError
  return self.alloc(Node("FUNCTION_DECL",name=name,left=p,right=b))
 def parse_declaration(self)->int:
  name=self.take()
  if not name.startswith("بنية_") or self.take()!="=":raise ReferenceError
  e=self.comparison();v=self.nodes[e].numeric_value if self.static(e) else 0
  return self.alloc(Node("DECLARE_NODE",name=name,right=e,numeric_value=v))
 def comparison(self)->int:
  x=self.additive()
  while self.peek() in ("==","!=",">","<"):
   op={"==":"EQUAL","!=":"NOT_EQUAL",">":"GREATER_THAN","<":"LESS_THAN"}[self.take()];x=self.alloc(Node(op,left=x,right=self.additive()))
  return x
 def additive(self)->int:
  x=self.multiplicative()
  while self.peek() in ("+","-"):
   op=self.take();y=self.multiplicative();v=0
   if self.static(x) and self.static(y):
    a,b=self.nodes[x].numeric_value,self.nodes[y].numeric_value;v=a+b if op=="+" else a-b
    if not 0<=v<=_MAX_U64:raise ReferenceError
   x=self.alloc(Node("ADD" if op=="+" else "SUBTRACT",left=x,right=y,numeric_value=v))
  return x
 def multiplicative(self)->int:
  x=self.factor()
  while self.peek() in ("*","/"):
   op=self.take();y=self.factor();v=0
   if self.static(x) and self.static(y):
    a,b=self.nodes[x].numeric_value,self.nodes[y].numeric_value
    if op=="/":
     if b==0:raise ReferenceError
     v=a//b
    else:v=a*b
    if not 0<=v<=_MAX_U64:raise ReferenceError
   x=self.alloc(Node("MULTIPLY" if op=="*" else "DIVIDE",left=x,right=y,numeric_value=v))
  return x
 def factor(self)->int:
  t=self.take()
  if t=="(":
   x=self.comparison()
   if self.take()!=")":raise ReferenceError
   return x
  if t.isascii() and t.isdigit():
   v=int(t)
   if v>_MAX_U64:raise ReferenceError
   return self.alloc(Node("LITERAL_NUM",numeric_value=v))
  if not t or t in ("\n","\r\n") or t in _FORBIDDEN:raise ReferenceError
  if self.peek()=="(":
   self.take();arg=self.comparison()
   if self.take()!=")":raise ReferenceError
   return self.alloc(Node("FUNCTION_CALL",name=t,left=arg))
  return self.alloc(Node("BIND_SYMBOL",name=t))
 def static(self,i:int)->bool:
  n=self.nodes[i]
  if n.opcode=="LITERAL_NUM":return True
  if n.opcode=="BIND_SYMBOL":return False
  if n.opcode in {"ADD","SUBTRACT","MULTIPLY","DIVIDE","EQUAL","NOT_EQUAL","GREATER_THAN","LESS_THAN"}:return self.static(n.left) and self.static(n.right)
  return False
class ReferenceEvaluator:
 def __init__(self,nodes:list[Node])->None:self.nodes=nodes;self.scopes:[dict[str,int]]=[{}];self.fuel=_MAX_LOOP_FUEL;self.active:set[str]=set()
 def lookup(self,n:str)->int:
  for scope in reversed(self.scopes):
   if n in scope:return scope[n]
  raise ReferenceError
 def bind(self,n:str,v:int)->None:self.scopes[-1][n]=v
 def find_function(self,i:int,name:str)->tuple[str,int]|None:
  n=self.nodes[i]
  if n.opcode=="FUNCTION_DECL" and n.name==name:return (self.nodes[n.left].name,n.right)
  for c in (n.left,n.right):
   if c is not None:
    f=self.find_function(c,name)
    if f:return f
  return None
 def visit(self,i:int)->int:
  n=self.nodes[i];o=n.opcode
  if o=="LITERAL_NUM":return n.numeric_value
  if o=="BIND_SYMBOL":return self.lookup(n.name)
  if o=="DECLARE_NODE":v=self.visit(n.right);self.bind(n.name,v);return v
  if o=="SEQUENCE":self.visit(n.left);return self.visit(n.right)
  if o=="IF_STATEMENT":return self.visit(n.right) if self.visit(n.left)>0 else 0
  if o=="WHILE_LOOP":
   last=0
   while self.visit(n.left)>0:
    if self.fuel==0:raise ReferenceError
    self.fuel-=1;last=self.visit(n.right)
   return last
  if o=="FUNCTION_DECL":return 0
  if o=="FUNCTION_CALL":
   name=n.name
   if name in self.active:raise ReferenceError
   f=self.find_function(0,name)
   if f is None:raise ReferenceError
   param,body=f;arg=self.visit(n.left);self.scopes.append({});self.bind(param,arg);self.active.add(name)
   try:return self.visit(body)
   finally:self.active.remove(name);self.scopes.pop()
  if o in {"ADD","SUBTRACT","MULTIPLY","DIVIDE"}:
   a,b=self.visit(n.left),self.visit(n.right)
   if o=="ADD":v=a+b
   elif o=="SUBTRACT":v=a-b
   elif o=="MULTIPLY":v=a*b
   else:
    if b==0:raise ReferenceError
    v=a//b
   if not 0<=v<=_MAX_U64:raise ReferenceError
   return v
  if o in {"EQUAL","NOT_EQUAL","GREATER_THAN","LESS_THAN"}:
   a,b=self.visit(n.left),self.visit(n.right);return int({"EQUAL":a==b,"NOT_EQUAL":a!=b,"GREATER_THAN":a>b,"LESS_THAN":a<b}[o])
  raise ReferenceError
def abstain()->dict[str,object]:return {"status":"ABSTAIN","stdout":"STATUS=ABSTAIN\nERROR=UNSUPPORTED_OR_INVALID_SYNTAX\n"}
def reference_case(path:Path)->dict[str,object]:
 source=path.read_text(encoding="utf-8")
 if any(w in source for w in _FORBIDDEN):return abstain()
 try:
  p=ReferenceParser(source);root=p.parse()
  if p.peek() is not None:raise ReferenceError
  value=ReferenceEvaluator(p.nodes).visit(root);r=p.nodes[root]
 except (ReferenceError,ValueError,RecursionError,IndexError,TypeError):return abstain()
 return {"status":"PARSED_EXTENSION_SCOPED","stdout":f"STATUS=EVALUATED\nVALUE={value}\nROOT_NODE_ID={root}\nROOT_OPCODE={r.opcode}\nROOT_RIGHT_NODE_ID={r.right if r.right is not None else 'NONE'}\nTOKEN_COUNT={len(p.tokens)}\nAST_COUNT={len(p.nodes)}\n"}
if __name__=="__main__":raise SystemExit("REFERENCE_MODEL_LIBRARY_ONLY")
