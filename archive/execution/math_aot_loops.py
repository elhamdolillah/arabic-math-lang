import sys, subprocess

أرقام_القيم = {"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9}
رموز_العمليات = {
    "≔":"≔","≡":"≡","+":"+","-":"-","·":"·","*":"·","×":"·","⊕":"⊕","⎕":"⎕",
    "(":"(",")":")",",":",","،":",",":":":",".":".",
    "⟨":"⟨","⟩":"⟩","<":"<",">":">","=":"=","≠":"≠","؟":"؟",
    "∀":"∀","∈":"∈","μ":"μ"
}
رموز_يونانية = {"λ":"λ","μ":"μ"}
أسماء_بديلة = {"دالة":"λ","λ":"λ","اطبع":"⎕","⎕":"⎕","طالما":"μ","μ":"μ","لكل":"∀","∀":"∀","في":"∈","∈":"∈"}
عمليات_الجمع = {"+":"+","-":"-","⊕":"⊕"}
عمليات_الضرب = {"·":"·"}
عمليات_المقارنة = {"<":"<",">":">","=":"=","≠":"≠"}

def حلل_رموز(نص):
    رموز=[]; i=0; n=len(نص)
    while i<n:
        ح=نص[i]
        if ح.isspace(): i+=1; continue
        ر=أرقام_القيم.get(ح)
        if ر is not None:
            ق=0
            while i<n:
                د=أرقام_القيم.get(نص[i])
                if د is None: break
                ق=ق*10+د; i+=1
            رموز.append(("عدد",ق)); continue
        if ح=='"':
            i+=1; أ=[]
            while i<n and نص[i]!='"': أ.append(نص[i]); i+=1
            if i>=n: raise Exception("نص غير مغلق")
            i+=1; رموز.append(("نص","".join(أ))); continue
        ي=رموز_يونانية.get(ح)
        if ي is not None: رموز.append(("عملية",ي)); i+=1; continue
        if ح.isalpha() or ح=="_":
            ب=i; i+=1
            while i<n and (نص[i].isalpha() or نص[i].isdigit() or نص[i]=="_"): i+=1
            ك=نص[ب:i]; بد=أسماء_بديلة.get(ك)
            if بد is not None: رموز.append(("عملية",بد))
            else: رموز.append(("معرف",ك))
            continue
        ع=رموز_العمليات.get(ح)
        if ع is not None: رموز.append(("عملية",ع)); i+=1; continue
        raise Exception("رمز غير معروف: "+ح)
    return رموز

def حلل_برنامج(رموز):
    ب=[]; i=0
    while i<len(رموز):
        بيان,i=حلل_بيان(رموز,i); ب.append(بيان)
    return ب

def حلل_بيان(رموز,i):
    if i>=len(رموز): raise Exception("بيان مفقود")
    ن,ق=رموز[i]
    if ن=="عملية" and ق=="⎕":
        i+=1; ت,i=حلل_تعبير(رموز,i); return ("اطبع",ت),i
    if ن=="عملية" and ق=="μ":
        i+=1; شرط,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(": مطلوبة بعد μ")
        i+=1; جسم,i=حلل_بيان(رموز,i)
        return ("طالما",شرط,جسم),i
    if ن=="عملية" and ق=="∀":
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception("اسم مطلوب بعد ∀")
        اسم=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!="∈": raise Exception("∈ مطلوبة")
        i+=1; قائمة,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(": مطلوبة")
        i+=1; جسم,i=حلل_بيان(رموز,i)
        return ("لكل",اسم,قائمة,جسم),i
    if ن=="معرف":
        اسم=ق
        if i+1<len(رموز) and رموز[i+1][0]=="عملية" and (رموز[i+1][1]=="≔" or رموز[i+1][1]=="≡"):
            رمز=رموز[i+1][1]; i+=2; ت,i=حلل_تعبير(رموز,i)
            return ("عرف" if رمز=="≡" else "أسند",اسم,ت),i
    raise Exception("بيان غير معروف")

def حلل_تعبير(رموز,i): return حلل_شرطي(رموز,i)
def حلل_شرطي(رموز,i):
    شرط,i=حلل_مقارنة(رموز,i)
    if i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1]=="؟":
        i+=1; صح,i=حلل_شرطي(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(": مطلوبة")
        i+=1; خطأ,i=حلل_شرطي(رموز,i)
        return ("شرطي",شرط,صح,خطأ),i
    return شرط,i
def حلل_مقارنة(رموز,i):
    ي,i=حلل_جمع(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_المقارنة:
        ع=رموز[i][1]; i+=1; م,i=حلل_جمع(رموز,i); ي=("مقارنة",ع,ي,م)
    return ي,i
def حلل_جمع(رموز,i):
    ي,i=حلل_ضرب(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_الجمع:
        ع=رموز[i][1]; i+=1; م,i=حلل_ضرب(رموز,i); ي=("ثنائية",ع,ي,م)
    return ي,i
def حلل_ضرب(رموز,i):
    ي,i=حلل_عامل(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_الضرب:
        i+=1; م,i=حلل_عامل(رموز,i); ي=("ثنائية","·",ي,م)
    return ي,i
def حلل_عامل(رموز,i):
    if i>=len(رموز): raise Exception("عامل مفقود")
    ن,ق=رموز[i]
    if ن=="عدد": return ("عدد",ق),i+1
    if ن=="نص": return ("نص",ق),i+1
    if ن=="عملية" and ق=="λ":
        i+=1; معلمون=[]
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1
            while True:
                if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception("اسم معامل مطلوب")
                معلمون.append(رموز[i][1]); i+=1
                if i>=len(رموز): raise Exception(") مطلوبة")
                if رموز[i][1]==",": i+=1; continue
                if رموز[i][1]==")": i+=1; break
        else:
            if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception("معامل مطلوب بعد λ")
            معلمون.append(رموز[i][1]); i+=1
        if i>=len(رموز) or رموز[i][1]!=".": raise Exception(". مطلوبة")
        i+=1; جسم,i=حلل_تعبير(رموز,i)
        return ("دالة",معلمون,جسم),i
    if ن=="عملية" and ق=="⟨":
        i+=1; ع=[]
        if i<len(رموز) and رموز[i][1]=="⟩": return ("قائمة",ع),i+1
        while True:
            عنصر,i=حلل_تعبير(رموز,i); ع.append(عنصر)
            if i>=len(رموز): raise Exception("⟩ مطلوبة")
            if رموز[i][1]==",": i+=1; continue
            if رموز[i][1]=="⟩": i+=1; break
            raise Exception("فاصلة أو ⟩ مطلوبة")
        return ("قائمة",ع),i
    if ن=="عملية" and ق=="(":
        i+=1; ت,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=")": raise Exception(") مطلوبة")
        return ت,i+1
    if ن=="معرف":
        اسم=ق; i+=1
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1; وس=[]
            if i<len(رموز) and رموز[i][1]==")": return ("استدعاء",اسم,وس),i+1
            while True:
                و,i=حلل_تعبير(رموز,i); وس.append(و)
                if i>=len(رموز): raise Exception(") مطلوبة")
                if رموز[i][1]==",": i+=1; continue
                if رموز[i][1]==")": i+=1; break
            return ("استدعاء",اسم,وس),i
        return ("متغير",اسم),i
    raise Exception("عامل غير متوقع")

def get_free_vars(expr, bound):
    ن=expr[0]
    if ن=="متغير": return {expr[1]} if expr[1] not in bound else set()
    if ن in ["ثنائية","مقارنة"]: return get_free_vars(expr[2],bound)|get_free_vars(expr[3],bound)
    if ن=="دالة": return get_free_vars(expr[2], bound|set(expr[1]))
    if ن=="استدعاء":
        res=set()
        for arg in expr[2]: res|=get_free_vars(arg,bound)
        return res
    if ن=="شرطي": return get_free_vars(expr[1],bound)|get_free_vars(expr[2],bound)|get_free_vars(expr[3],bound)
    if ن=="قائمة":
        res=set()
        for e in expr[1]: res|=get_free_vars(e,bound)
        return res
    return set()

def استنتاج_نوع(expr, type_env):
    ن=expr[0]
    if ن=="نص": return "نص"
    if ن=="عدد": return "عدد"
    if ن=="قائمة": return "قائمة"
    if ن=="ثنائية":
        if expr[1]=="⊕": return "نص"
        if expr[1] in ["+","-","·"]: return "عدد"
        return "مجهول"
    if ن=="مقارنة": return "منطقي"
    if ن=="شرطي":
        t1=استنتاج_نوع(expr[2], type_env)
        if t1!="مجهول": return t1
        return استنتاج_نوع(expr[3], type_env)
    if ن=="متغير": return type_env.get(expr[1], "مجهول")
    if ن=="استدعاء":
        اسم=expr[1]
        if اسم in ["طول","حجم"]: return "عدد"
        if اسم=="ذيل": return "قائمة"
        if اسم in type_env: return type_env[اسم]
        return "مجهول"
    if ن=="دالة": return استنتاج_نوع(expr[2], type_env)
    return "مجهول"

ARG_REGS = ["rdi","rsi","rdx","rcx","r8","r9"]
_counters = {"cond":0,"empty":0,"copy":0,"loop":0}

def compile_expr(expr, env, funcs, env_layout=None):
    ن=expr[0]
    if ن=="عدد": return [f"    mov rax, {expr[1]}"]
    if ن=="نص":
        byts=expr[1].encode('utf-8'); ln=len(byts)
        code=[f"    mov rdi, {8+ln}", "    call arena_alloc"]
        code.append(f"    mov qword [rax], {ln}")
        for k, b in enumerate(byts):
            code.append(f"    mov byte [rax + {8+k}], {b}")
        return code
    if ن=="متغير":
        if env_layout and expr[1] in env_layout: return [f"    mov rax, [r15 + {env_layout[expr[1]]}]"]
        if expr[1] in env["locals"]: return [f"    mov rax, [rbp - {env['locals'][expr[1]]}]"]
        if expr[1] in env["globals"]: return [f"    mov rax, [vars + {env['globals'][expr[1]]*8}]"]
        raise Exception(f"متغير غير معرف: {expr[1]}")
    if ن=="قائمة":
        elems=expr[1]; ln=len(elems)
        code=[f"    mov rdi, {8+ln*8}", "    call arena_alloc"]
        code.append("    push rax")
        code.append(f"    mov qword [rax], {ln}")
        for idx,el in enumerate(elems):
            code.extend(compile_expr(el,env,funcs,env_layout))
            code.append("    mov rcx, rax")
            code.append("    mov rbx, [rsp]")
            code.append(f"    mov [rbx + {8+idx*8}], rcx")
        code.append("    pop rax")
        return code
    if ن=="ثنائية":
        op=expr[1]
        left=compile_expr(expr[2],env,funcs,env_layout)
        right=compile_expr(expr[3],env,funcs,env_layout)
        if op=="⊕":
            _counters["copy"]+=1; k=_counters["copy"]
            code=left+["    push rax"]+right+["    mov r11, rax","    pop r10"]
            code += [
                "    push r10","    push r11",
                "    mov rax, [r10]","    add rax, [r11]","    add rax, 8",
                "    mov rdi, rax","    call arena_alloc","    mov r12, rax",
                "    mov rax, [r10]","    add rax, [r11]","    mov [r12], rax",
                "    mov rax, [r10]","    lea rsi, [r10 + 8]","    lea rdi, [r12 + 8]",
                f".cpy1_{k}:","    test rax, rax",f"    jz .c1d_{k}",
                "    mov cl, [rsi]","    mov [rdi], cl","    inc rsi","    inc rdi","    dec rax",
                f"    jmp .cpy1_{k}",f".c1d_{k}:",
                "    mov rax, [r11]","    lea rsi, [r11 + 8]",
                f".cpy2_{k}:","    test rax, rax",f"    jz .c2d_{k}",
                "    mov cl, [rsi]","    mov [rdi], cl","    inc rsi","    inc rdi","    dec rax",
                f"    jmp .cpy2_{k}",f".c2d_{k}:",
                "    pop r11","    pop r10","    mov rax, r12"]
            return code
        code=left+["    push rax"]+right+["    pop rbx"]
        if op=="+": code.append("    add rax, rbx")
        elif op=="-": code.append("    sub rbx, rax"); code.append("    mov rax, rbx")
        elif op=="·": code.append("    imul rax, rbx")
        return code
    if ن=="مقارنة":
        op=expr[1]
        left=compile_expr(expr[2],env,funcs,env_layout)
        right=compile_expr(expr[3],env,funcs,env_layout)
        code=left+["    push rax"]+right+["    pop rbx"]
        code.append("    cmp rbx, rax"); code.append("    mov rax, 0")
        if op=="<": code.append("    setl al")
        elif op==">": code.append("    setg al")
        elif op=="=": code.append("    sete al")
        elif op=="≠": code.append("    setne al")
        return code
    if ن=="شرطي":
        _counters["cond"]+=1; k=_counters["cond"]
        code=compile_expr(expr[1],env,funcs,env_layout)
        code.append("    cmp rax, 0"); code.append(f"    je .else_{k}")
        code.extend(compile_expr(expr[2],env,funcs,env_layout))
        code.append(f"    jmp .end_{k}"); code.append(f".else_{k}:")
        code.extend(compile_expr(expr[3],env,funcs,env_layout))
        code.append(f".end_{k}:")
        return code
    if ن=="دالة":
        params=expr[1]; body=expr[2]
        bound=set(env["globals"].keys())|set(params)
        free_vars=list(get_free_vars(body,bound))
        inner_label=f"func_{funcs['idx']}"; funcs['idx']+=1
        inner_fc=[f"{inner_label}:","    push rbp","    mov rbp, rsp"]
        stack_size=len(params)*8
        if stack_size%16!=0: stack_size+=8
        if stack_size==0: stack_size=16
        inner_fc.append(f"    sub rsp, {stack_size}")
        inner_env={"globals":env["globals"],"locals":{}}
        inner_env_layout={}
        for j,p in enumerate(params):
            inner_env["locals"][p]=(j+1)*8
            if j<len(ARG_REGS): inner_fc.append(f"    mov [rbp - {(j+1)*8}], {ARG_REGS[j]}")
        for ix,v in enumerate(free_vars): inner_env_layout[v]=8+ix*8
        inner_fc.extend(compile_expr(body,inner_env,funcs,inner_env_layout))
        inner_fc+=["    leave","    ret"]
        funcs['bodies'].extend(inner_fc)
        code=[]
        env_size=8+len(free_vars)*8
        code.append(f"    mov rdi, {env_size}")
        code.append("    call arena_alloc"); code.append("    push rax")
        code.append(f"    mov rcx, {inner_label}"); code.append("    mov [rax], rcx")
        for ix,v in enumerate(free_vars):
            offset=8+ix*8
            if env_layout and v in env_layout: code.append(f"    mov rcx, [r15 + {env_layout[v]}]")
            elif v in env["locals"]: code.append(f"    mov rcx, [rbp - {env['locals'][v]}]")
            elif v in env["globals"]: code.append(f"    mov rcx, [vars + {env['globals'][v]*8}]")
            code.append(f"    mov [rax + {offset}], rcx")
        code.append("    pop rax")
        return code
    if ن=="استدعاء":
        اسم=expr[1]; args=expr[2]
        if اسم=="طول":
            if len(args)!=1: raise Exception("طول تأخذ وسيطاً واحداً")
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    mov rax, [rax]")
            return code
        if اسم=="رأس":
            if len(args)!=1: raise Exception("رأس تأخذ وسيطاً واحداً")
            _counters["empty"]+=1; k=_counters["empty"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code += ["    mov rbx, [rax]","    test rbx, rbx",f"    jz .hemp_{k}",
                     "    mov rax, [rax + 8]",f"    jmp .hdne_{k}",
                     f".hemp_{k}:","    mov rax, 60","    mov rdi, 1","    syscall",f".hdne_{k}:"]
            return code
        if اسم=="ذيل":
            if len(args)!=1: raise Exception("ذيل تأخذ وسيطاً واحداً")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code += ["    mov rcx, [rax]","    test rcx, rcx",f"    jz .taihemp_{k}",
                "    push rax","    dec rcx","    mov rdi, rcx","    shl rdi, 3","    add rdi, 8",
                "    call arena_alloc","    mov r12, rax","    mov [rax], rcx",
                "    pop rsi","    add rsi, 16","    lea rdi, [r12 + 8]",
                f".tcopy_{k}:","    test rcx, rcx",f"    jz .tcd_{k}",
                "    mov rdx, [rsi]","    mov [rdi], rdx","    add rsi, 8","    add rdi, 8","    dec rcx",
                f"    jmp .tcopy_{k}",f".tcd_{k}:","    mov rax, r12",f"    jmp .taine_{k}",
                f".taihemp_{k}:","    mov rax, 60","    mov rdi, 1","    syscall",f".taine_{k}:"]
            return code
        if اسم=="حجم":
            if len(args)!=1: raise Exception("حجم تأخذ وسيطاً واحداً")
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    mov rax, [rax]")
            return code
        if اسم=="ألحق":
            if len(args)!=2: raise Exception("ألحق تأخذ وسيطين")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs,env_layout))
            code += ["    mov r11, rax","    pop r10","    push r10","    push r11",
                "    mov rax, [r10]","    add rax, 1","    mov rdi, rax","    shl rdi, 3","    add rdi, 8",
                "    call arena_alloc","    mov r12, rax",
                "    mov rax, [r10]","    add rax, 1","    mov [r12], rax",
                "    mov rax, [r10]","    lea rsi, [r10 + 8]","    lea rdi, [r12 + 8]",
                f".lcpy_{k}:","    test rax, rax",f"    jz .lcd_{k}",
                "    mov rcx, [rsi]","    mov [rdi], rcx","    add rsi, 8","    add rdi, 8","    dec rax",
                f"    jmp .lcpy_{k}",f".lcd_{k}:","    mov [rdi], r11",
                "    pop r11","    pop r10","    mov rax, r12"]
            return code
        code=[]
        for arg in args:
            code.extend(compile_expr(arg,env,funcs,env_layout))
            code.append("    push rax")
        for j in range(len(args)-1,-1,-1):
            if j<len(ARG_REGS): code.append(f"    pop {ARG_REGS[j]}")
        if اسم in env["locals"]: code.append(f"    mov r10, [rbp - {env['locals'][اسم]}]")
        elif اسم in env["globals"]: code.append(f"    mov r10, [vars + {env['globals'][اسم]*8}]")
        else: raise Exception(f"دالة غير معرفة: {اسم}")
        code.append("    push r15")
        code.append("    mov r15, r10")
        code.append("    mov r10, [r10]")
        code.append("    call r10")
        code.append("    pop r15")
        return code
    raise Exception(f"تعبير غير مدعوم: {ن}")

# ✅ تجميع بيان (يدعم العودية والتكرار)
def compile_stmt(stmt, env, funcs, type_env):
    ن=stmt[0]
    if ن in ["أسند","عرف"]:
        اسم=stmt[1]
        if اسم not in env["globals"]: env["globals"][اسم]=len(env["globals"])
        code=compile_expr(stmt[2],env,funcs)
        code.append(f"    mov [vars + {env['globals'][اسم]*8}], rax")
        return code
    if ن=="اطبع":
        e=stmt[1]
        code=compile_expr(e,env,funcs)
        نوع=استنتاج_نوع(e, type_env)
        code.append("    call print_str" if نوع=="نص" else "    call print_int")
        return code
    if ن=="طالما":
        _counters["loop"]+=1; k=_counters["loop"]
        code=[f".while_{k}:"]
        code.extend(compile_expr(stmt[1],env,funcs))
        code.append("    cmp rax, 0")
        code.append(f"    je .wend_{k}")
        code.extend(compile_stmt(stmt[2],env,funcs,type_env))
        code.append(f"    jmp .while_{k}")
        code.append(f".wend_{k}:")
        return code
    if ن=="لكل":
        _counters["loop"]+=1; k=_counters["loop"]
        متغير=stmt[1]; قائمة=stmt[2]; جسم=stmt[3]
        if متغير not in env["globals"]: env["globals"][متغير]=len(env["globals"])
        code=[]
        code.extend(compile_expr(قائمة,env,funcs))
        code += ["    push rbx","    push r13","    push r14",
                 "    mov r13, rax",
                 "    mov r14, [rax]",
                 "    lea rbx, [rax + 8]",
                 f".fe_{k}:",
                 "    test r14, r14",
                 f"    jz .feend_{k}",
                 "    mov rax, [rbx]",
                 f"    mov [vars + {env['globals'][متغير]*8}], rax"]
        code.extend(compile_stmt(جسم,env,funcs,type_env))
        code += ["    add rbx, 8","    dec r14",f"    jmp .fe_{k}",
                 f".feend_{k}:","    pop r14","    pop r13","    pop rbx"]
        return code
    raise Exception(f"بيان غير مدعوم: {ن}")

def compile_program(برنامج):
    asm=["global _start","section .bss",
         "    vars resq 256","    num_buf resb 32",
         "    arena_ptr resq 1","    arena_mem resb 262144","",
         "section .text"]
    asm += ["arena_alloc:","    mov rax, [arena_ptr]","    add rdi, 15","    and rdi, -16",
            "    add [arena_ptr], rdi","    ret",""]
    asm += ["print_int:","    push rax","    push rbx","    push rcx","    push rdx","    push rsi","    push rdi",
        "    mov rbx, 10","    mov rcx, 0","    lea rdi, [num_buf + 31]",
        ".piloop:","    xor rdx, rdx","    div rbx","    add dl, '0'","    dec rdi","    mov [rdi], dl",
        "    inc rcx","    test rax, rax","    jnz .piloop",
        "    mov rsi, rdi","    mov byte [rsi + rcx], 10","    inc rcx",
        "    mov rdi, 1","    mov rax, 1","    mov rdx, rcx","    syscall",
        "    pop rdi","    pop rsi","    pop rdx","    pop rcx","    pop rbx","    pop rax","    ret",""]
    asm += ["print_str:","    push rax","    push rdx","    push rsi","    push rdi",
        "    mov rsi, rax","    add rsi, 8","    mov rdx, [rax]",
        "    mov rdi, 1","    mov rax, 1","    syscall",
        "    mov rsi, nl_ptr","    mov rdx, 1","    mov rdi, 1","    mov rax, 1","    syscall",
        "    pop rdi","    pop rsi","    pop rdx","    pop rax","    ret",""]
    asm += ["section .data","nl_ptr: db 10","section .text",""]
    asm += ["_start:","    lea rax, [arena_mem]","    mov [arena_ptr], rax",""]
    type_env={}
    for بيان in برنامج:
        if بيان[0] in ["عرف","أسند"]:
            type_env[بيان[1]]=استنتاج_نوع(بيان[2], type_env)
    var_map={}; funcs={"idx":0,"bodies":[]}; global_code=[]
    env={"globals":var_map,"locals":{}}
    for بيان in برنامج:
        global_code.extend(compile_stmt(بيان,env,funcs,type_env))
    asm += global_code+["","    mov rax, 60","    xor rdi, rdi","    syscall",""]+funcs["bodies"]
    return "\n".join(asm)

def build_and_run(name, source, expected):
    try:
        ر=حلل_رموز(source); ب=حلل_برنامج(ر); asm=compile_program(ب)
        with open(f"{name}.asm","w") as f: f.write(asm)
        subprocess.run(["nasm","-f","elf64",f"{name}.asm","-o",f"{name}.o"],check=True,capture_output=True)
        subprocess.run(["ld",f"{name}.o","-o",name],check=True,capture_output=True)
        result=subprocess.run([f"./{name}"],capture_output=True,text=True)
        out=result.stdout.strip()
        if out==expected: print(f"✅ AOT Loops ({name}): {out}")
        else:
            print(f"❌ AOT Loops ({name}): Expected '{expected}', Got '{out}'")
            if result.stderr: print(f"   stderr: {result.stderr.strip()}")
            sys.exit(1)
    except Exception as e:
        print(f"❌ AOT Loops ({name}): Error: {e}"); sys.exit(1)

# --- الاختبارات السابقة (توافق خلفي) ---
build_and_run("t_fact","مضروب ≡ λن. (ن = 1) ؟ 1 : ن · مضروب(ن - 1)\n⎕ مضروب(5)","120")
build_and_run("t_closure","صانع ≡ λس. λص. س + ص\nد ≔ صانع(10)\n⎕ د(5)","15")
build_and_run("t_sum","مجموع ≡ λق. (طول(ق) = 0) ؟ 0 : رأس(ق) + مجموع(ذيل(ق))\nأ ≔ ⟨1,2,3,4⟩\n⎕ مجموع(أ)","10")
build_and_run("t_concat","رحب ≡ λاسم. \"مرحبا \" ⊕ اسم\n⎕ رحب(\"بالعربية\")","مرحبا بالعربية")

# --- اختبارات الحلقات الجديدة ---
build_and_run("t_while","ع ≔ 0\nμ ع < 5 : ع ≔ ع + 1\n⎕ ع","5")
build_and_run("t_foreach","م ≔ 0\n∀ س ∈ ⟨1,2,3,4⟩ : م ≔ م + س\n⎕ م","10")
build_and_run("t_while_sum","ع ≔ 0\nن ≔ 1\nμ ع < 5 : ن ≔ ن · 2\n⎕ ن","16")
build_and_run("t_nested","م ≔ 0\n∀ س ∈ ⟨1,2,3⟩ : ∀ ص ∈ ⟨10,20⟩ : م ≔ م + س + ص\n⎕ م","108")
build_and_run("t_while_fact","ن ≔ 5\nنت ≔ 1\nμ ن > 1 : نت ≔ نت · ن\n⎕ نت","120")
print("🎉 حلقات μ و ∀ في AOT تعمل بنجاح!")
