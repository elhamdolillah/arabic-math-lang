#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 45: السمات (Traits / Typeclasses)
يقحم 7 patches على math_complete.py:
  P1: كلمات سمة/تطبيق/على في المعجم
  P2: سجلات _trait_registry + _impl_registry
  P3: محلل تعريف سمة في حلل_بيان
  P4: محلل تطبيق سمة على نوع في حلل_بيان (قبل if ق=="طابق": الأول)
  P5: معاملة تعريف_سمة وتطبيق_سمة في compile_stmt_local
  P6: تصريف استدعاءات دوال السمات (dispatch حسب نوع الوسيط الأول)
  P7: توليد أجسام تطبيقات السمات كدوال داخلية في compile_program
"""
import sys, shutil

SRC = 'math_complete.py'
BACKUP = 'math_complete.py.pre_traits.backup'

with open(SRC, 'r', encoding='utf-8') as f:
    c = f.read()

changes = 0

def apply_full(name, anchor, new):
    """استبدال كامل: new يحل محل anchor"""
    global c, changes
    n = c.count(anchor)
    if n != 1:
        print(f"  [WARN] Patch {name}: anchor count={n} — تخطي")
        return
    c = c.replace(anchor, new, 1)
    changes += 1
    print(f"  [+] Patch {name}: OK")

def apply_insert(name, anchor, new):
    """إقحام: new قبل anchor ثم يعاد إلحاق anchor"""
    global c, changes
    n = c.count(anchor)
    if n != 1:
        print(f"  [WARN] Patch {name}: anchor count={n} — تخطي")
        return
    c = c.replace(anchor, new + anchor, 1)
    changes += 1
    print(f"  [+] Patch {name}: OK")

# ═══════════════════════════════════════════════════════════
# P1: كلمات سمة/تطبيق/على في المعجم (استبدال كامل للسطر)
# ═══════════════════════════════════════════════════════════
apply_full('P1_keywords',
      '"طابق":"طابق","حيث":"حيث","شامل":"_","_":"_","نوع":"نوع"',
      '"طابق":"طابق","حيث":"حيث","شامل":"_","_":"_","نوع":"نوع","سمة":"سمة","تطبيق":"تطبيق","على":"على"')

# ═══════════════════════════════════════════════════════════
# P2: سجلات السمات بعد _type_registry
# ═══════════════════════════════════════════════════════════
apply_insert('P2_registries',
      '_type_registry = {}',
      '_trait_registry = {}   # اسم_السمة → [(اسم_الدالة, عدد_المعاملات), ...]\n_impl_registry = {}  # (اسم_السمة, اسم_النوع) → {اسم_الدالة: (وسائط, جسم)}\n')

# ═══════════════════════════════════════════════════════════
# P3: محلل تعريف سمة — بعد سطر تسجيل النوع في حلل_بيان
#    سمة اسم(ن) : ﴿ دالة : ن → نوع ﴾
# ═══════════════════════════════════════════════════════════
apply_insert('P3_trait_def',
      '        globals()[\'_type_registry\'][اسم]=بناة\n        return ("تعريف_نوع", اسم, بناة),i',
      '''        globals()['_type_registry'][اسم]=بناة
        return ("تعريف_نوع", اسم, بناة),i
    if ق=="سمة":
        # المرحلة 45: تعريف سمة — سمة اسم(وسائط) : ﴿ دوال ⟩
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم السمة مطلوب عند {pos_msg(رموز, i)}")
        اسم=رموز[i][1]; i+=1
        معاملات=[]
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1
            while True:
                if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                if رموز[i][1]==")": i+=1; break
                if رموز[i][0]!="معرف": raise Exception(f"اسم معامل مطلوب عند {pos_msg(رموز, i)}")
                معاملات.append(رموز[i][1]); i+=1
                if i<len(رموز) and رموز[i][1]==",": i+=1
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة بعد اسم السمة عند {pos_msg(رموز, i)}")
        i+=1
        if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception(f"﴿ مطلوبة بعد : عند {pos_msg(رموز, i)}")
        i+=1; دوال=[]
        while True:
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="﴾": i+=1; break
            if رموز[i][0]!="معرف": raise Exception(f"اسم دالة مطلوب عند {pos_msg(رموز, i)}")
            اسم_دالة=رموز[i][1]; i+=1
            if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة بعد اسم الدالة عند {pos_msg(رموز, i)}")
            i+=1
            # تخطَّ توقيع الدالة (ن → نص) — استهلك حتى ⋄ أو ﴾
            عمق=0
            while i<len(رموز):
                if رموز[i][1]=="﴿": عمق+=1
                elif رموز[i][1]=="﴾":
                    if عمق==0: break
                    عمق-=1
                elif عمق==0 and رموز[i][1]=="⋄": break
                i+=1
            دوال.append((اسم_دالة, 1))
            if i<len(رموز) and رموز[i][1]=="⋄": i+=1
        globals()['_trait_registry'][اسم]=دوال
        return ("تعريف_سمة", اسم, معاملات, دوال),i
''')

# ═══════════════════════════════════════════════════════════
# P4: محلل تطبيق سمة على نوع — قبل if ق=="طابق": في حلل_بيان
#    anchor يتكرر مرتين (حلل_بيان + حلل_عامل) — splice يدوي للأول
# ═══════════════════════════════════════════════════════════
p4_anchor = '    if ق=="طابق":'
p4_new = '''    if ق=="تطبيق":
        # المرحلة 45: تطبيق سمة على نوع — تطبيق سمة على نوع : ﴿ دالة(وسائط) ≔ تعبير ⟩
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم السمة مطلوب عند {pos_msg(رموز, i)}")
        اسم_سمة=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!="على": raise Exception(f"'على' مطلوبة بعد اسم السمة عند {pos_msg(رموز, i)}")
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم النوع مطلوب عند {pos_msg(رموز, i)}")
        اسم_نوع=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة بعد اسم النوع عند {pos_msg(رموز, i)}")
        i+=1
        if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception(f"﴿ مطلوبة بعد : عند {pos_msg(رموز, i)}")
        i+=1; تطبيقات=[]
        while True:
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="﴾": i+=1; break
            if رموز[i][0]!="معرف": raise Exception(f"اسم دالة مطلوب عند {pos_msg(رموز, i)}")
            اسم_دالة=رموز[i][1]; i+=1
            وسائط=[]
            if i<len(رموز) and رموز[i][1]=="(":
                i+=1
                while True:
                    if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                    if رموز[i][1]==")": i+=1; break
                    if رموز[i][0]!="معرف": raise Exception(f"اسم معامل مطلوب عند {pos_msg(رموز, i)}")
                    وسائط.append(رموز[i][1]); i+=1
                    if i<len(رموز) and رموز[i][1]==",": i+=1
            if i>=len(رموز) or رموز[i][1]!="≔": raise Exception(f"≔ مطلوبة بعد معاملات الدالة عند {pos_msg(رموز, i)}")
            i+=1
            تعبير,i=حلل_تعبير(رموز,i)
            تطبيقات.append((اسم_دالة, وسائط, تعبير))
            if i<len(رموز) and رموز[i][1]=="⋄": i+=1
        globals()['_impl_registry'][(اسم_سمة, اسم_نوع)]={fn: (ar, bd) for fn, ar, bd in تطبيقات}
        return ("تطبيق_سمة", اسم_سمة, اسم_نوع, تطبيقات),i
    if ق=="طابق":'''
if p4_anchor in c and 'تطبيق_سمة' not in c:
    n4 = c.count(p4_anchor)
    if n4 >= 1:
        idx = c.index(p4_anchor)
        c = c[:idx] + p4_new + c[idx + len(p4_anchor):]
        changes += 1
        print('  [+] Patch P4: تطبيق_سمة parser OK')
    else:
        print('  [WARN] Patch P4: anchor غير موجود')
else:
    if 'تطبيق_سمة' in c:
        print('  [=] Patch P4: تطبيق parser موجود')

# ═══════════════════════════════════════════════════════════
# P5: معالجة تعريف_سمة وتطبيق_سمة في compile_stmt_local
#    (قبل if ن=="تعريف_نوع":)
# ═══════════════════════════════════════════════════════════
apply_insert('P5_stmt',
      '    if ن=="تعريف_نوع":',
      '''    if ن=="تعريف_سمة":
        # المرحلة 45: السمة مسجّلة في _trait_registry أثناء التحليل — لا كود
        return []
    if ن=="تطبيق_سمة":
        # المرحلة 45: الدوال الداخلية تُولَّد في compile_program — لا كود هنا
        return []
''')

# ═══════════════════════════════════════════════════════════
# P6: تصريف استدعاء دالة سمة — قبل if اسم=="أس"
#    dispatch: إذا كانت الدالة في سجل السمات ونوع الوسيط الأول
#    باني لنوع معروف → استدعاء الدالة الداخلية __trait__...
#    بنفس convention العادي (r15/call r10)
# ═══════════════════════════════════════════════════════════
apply_insert('P6_trait_call',
      '        اسم=expr[1]; args=expr[2]\n        if اسم=="أس" or اسم=="أُس":',
      '''        اسم=expr[1]; args=expr[2]
        # المرحلة 45: استدعاء دالة سمة — dispatch حسب نوع الوسيط الأول
        _tr_fn = اسم in [fn for _d in _trait_registry.values() for fn, _ in _d]
        if _tr_fn and args:
            _tr_type = None
            if args[0][0]=="استدعاء":
                for _tn, _bs in _type_registry.items():
                    for _bn, _ba in _bs:
                        if _bn == args[0][1]:
                            _tr_type = _tn; break
                    if _tr_type: break
            if _tr_type is None:
                # وسيط متغير: إن وُجد تطبيق واحد فقط لهذه الدالة — استخدمه
                _hits=[(sn,tn) for (sn,tn),im in _impl_registry.items() if اسم in im]
                if len(_hits)==1: _tr_type=_hits[0][1]
            if _tr_type:
                _key=None
                for (sn,tn),im in _impl_registry.items():
                    if tn==_tr_type and اسم in im: _key=(sn,tn); break
                if _key:
                    داخلي = f"__trait__{_key[0]}__{_key[1]}__{اسم}"
                    code=[]
                    for _idx, _arg in enumerate(args):
                        code.extend(compile_expr(_arg, env, funcs, env_layout))
                        if _idx < len(ARG_REGS):
                            code.append(f"    mov {ARG_REGS[_idx]}, rax")
                    code.append(f"    mov r10, [vars + {env['globals'][داخلي]*8}]")
                    code.append("    push r15")
                    code.append("    mov r15, r10")
                    code.append("    mov r10, [r10]")
                    code.append("    call r10")
                    code.append("    pop r15")
                    return code
        if اسم=="أس" or اسم=="أُس":''')


# ═══════════════════════════════════════════════════════════
# P7: توليد أجسام تطبيقات السمات كدوال داخلية في compile_program
#    (إقحام قبل الحلقة الرئيسية بعد إعادة تهيئة var_map النهائي)
# ═══════════════════════════════════════════════════════════
apply_insert('P7_impl_bodies',
      '    for بيان في برنامج:\n        global_code.extend(compile_stmt(بيان,env,funcs,type_env))'.replace('بيان في برنامج', 'بيان in برنامج'),
      '''    var_map={}; funcs={"idx":0,"bodies":[]}; global_code=[]
    env={"globals":var_map,"locals":{}}
    # المرحلة 45: ولّد دوال داخلية لأجسام تطبيقات السمات
    for بيان in برنامج:
        if بيان[0]=="تطبيق_سمة":
            اسم_سمة=بيان[1]; اسم_نوع=بيان[2]; تطبيقات=بيان[3]
            for اسم_دالة, وسائط, تعبير in تطبيقات:
                داخلي = f"__trait__{اسم_سمة}__{اسم_نوع}__{اسم_دالة}"
                if داخلي not in env["globals"]:
                    env["globals"][داخلي]=len(env["globals"])
                params=وسائط
                bound=set(env["globals"].keys())|set(params)
                free_vars=[]
                for _fv in get_free_vars(تعبير,bound):
                    _n= _fv[1] if isinstance(_fv, tuple) else _fv
                    _name= _n if isinstance(_n, str) else (_n[1] if isinstance(_n, tuple) else None)
                    if _name is not None and _name not in bound and _name not in free_vars: free_vars.append(_name)
                inner_label=f"trait_{funcs['idx']}"; funcs['idx']+=1
                inner_env={"globals":env["globals"],"locals":{},"match_locals":{}}
                inner_env_layout={}
                local_counter=[len(params)]
                def inner_collect_match_locals(node, _ie=inner_env, _lc=local_counter):
                    if node is None or not isinstance(node, tuple): return
                    ن=node[0]
                    if ن=="طابق":
                        for نمط,تعبير in node[2]:
                            collect_pattern_vars(نمط, _ie, _lc)
                            inner_collect_match_locals(تعبير, _ie, _lc)
                    elif ن=="دالة": inner_collect_match_locals(node[2], _ie, _lc)
                    elif ن=="كتلة":
                        for s in node[1]: inner_collect_match_locals(s, _ie, _lc)
                        if len(node)>2: inner_collect_match_locals(node[2], _ie, _lc)
                    elif ن=="استدعاء":
                        for a in node[2]: inner_collect_match_locals(a, _ie, _lc)
                    elif ن=="ثنائية":
                        inner_collect_match_locals(node[2], _ie, _lc); inner_collect_match_locals(node[3], _ie, _lc)
                    elif ن in ("مقارنة","شرطي"):
                        for a in node[2:]: inner_collect_match_locals(a, _ie, _lc)
                def collect_pattern_vars(نمط, _e, _lc, _b=bound):
                    if نمط is None: return
                    if نمط[0]=="نمط_متغير":
                        اسم=نمط[1]
                        if اسم not in _e["locals"] and اسم not in _e["match_locals"]:
                            n=_lc[0]; _lc[0]+=1
                            _e["match_locals"][اسم]=(n+1)*8
                    elif نمط[0]=="نمط_شرطي": collect_pattern_vars(نمط[1], _e, _lc)
                    elif نمط[0]=="نمط_قائمة":
                        if نمط[1]:
                            for ع in نمط[1]: collect_pattern_vars(ع, _e, _lc)
                        if نمط[2]: collect_pattern_vars(("نمط_متغير",نمط[2]), _e, _lc)
                    elif نمط[0]=="نمط_باني":
                        for _sp in نمط[2]: collect_pattern_vars(_sp, _e, _lc)
                inner_collect_match_locals(تعبير)
                inner_fc=[f"{inner_label}:","    push rbp","    mov rbp, rsp"]
                for j,p in enumerate(params):
                    inner_env["locals"][p]=(j+1)*8
                for ix,v in enumerate(free_vars): inner_env_layout[v]=8+ix*8
                stack_size=local_counter[0]*8
                if stack_size%16!=0: stack_size+=8
                if stack_size==0: stack_size=16
                inner_fc.append(f"    sub rsp, {stack_size}")
                for j,p in enumerate(params):
                    if j<len(ARG_REGS):
                        inner_fc.append(f"    mov [rbp - {inner_env['locals'][p]}], {ARG_REGS[j]}")
                inner_fc.extend(compile_expr(تعبير,inner_env,funcs,inner_env_layout))
                inner_fc+=["    leave","    ret"]
                funcs['bodies'].extend(inner_fc)
                # خزّن closure في متغير عام
                global_code.append(f"    mov rdi, {8+len(free_vars)*8}")
                global_code.append("    call arena_alloc")
                global_code.append("    push rax")
                global_code.append(f"    mov rcx, {inner_label}")
                global_code.append("    mov [rax], rcx")
                for ix,v in enumerate(free_vars):
                    offset=8+ix*8
                    if v in env["globals"]:
                        global_code.append(f"    mov rcx, [vars + {env['globals'][v]*8}]")
                        global_code.append(f"    mov [rax + {offset}], rcx")
                    else:
                        global_code.append(f"    mov [rax + {offset}], rax")  # unreachable safety
                global_code.append("    pop rax")
                global_code.append(f"    mov [vars + {env['globals'][داخلي]*8}], rax")
''')

# ═══════════════════════════════════════════════════════════
# حفظ بعد التحقق
# ═══════════════════════════════════════════════════════════
print(f"\n  Total changes: {changes}")
try:
    compile(c, SRC, 'exec')
    print("  [OK] Syntax valid")
    with open(SRC, 'w', encoding='utf-8') as f:
        f.write(c)
    print(f"  [OK] Saved ({len(c.splitlines())} lines)")
except SyntaxError as e:
    print(f"  [FAIL] Syntax error: {e}")
    shutil.copy(BACKUP, SRC)
    sys.exit(1)
