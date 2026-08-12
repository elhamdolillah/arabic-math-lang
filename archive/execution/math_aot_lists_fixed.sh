#!/bin/sh
set -e

cat > math_aot_lists.py <<'PY'
import sys, subprocess

أرقام_القيم = {"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9}
رموز_العمليات = {
    "≔":"≔","≡":"≡","+":"+","-":"-","·":"·","*":"·","×":"·","⊕":"⊕","⎕":"⎕",
    "(":"(",")":")",",":",","،":",",":":":",".":".",
    "⟨":"⟨","⟩":"⟩","<":"<",">":">","=":"=","≠":"≠","؟":"؟"
}
رموز_يونانية = {"λ":"λ"}
أسماء_بديلة = {"دالة":"λ","λ":"λ","اطبع":"⎕","⎕":"⎕"}
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

def هو_نص(expr):
    ن=expr[0]
    if ن=="نص": return True
    if ن=="ثنائية" and expr[1]=="⊕": return True
    return False

ARG_REGS = ["rdi","rsi","rdx","rcx","r8","r9"]
_counters = {"cond":0,"empty":0,"copy":0}

def compile_expr(expr, env, funcs, env_layout=None):
    ن=expr[0]
    if ن=="عدد": return [f"    mov rax, {expr[1]}"]

    if ن=="نص":
        byts=expr[1].encode('utf-8'); ln=len(byts)
        code=[f"    mov rdi, {8+ln}", "    call arena_alloc"]
        code.append(f"    mov qword [rax], {ln}")
        if ln>0:
            for k in range(0, ln, 8):
                chunk=byts[k:k+8]
                val=int.from_bytes(chunk, 'little')
                off=8+k
                if len(chunk)<8: code.append(f"    mov qword [rax + {off}], 0")
                code.append(f"    mov qword [rax + {off}], {val}")
        return code

    if ن=="متغير":
        if env_layout and expr[1] in env_layout: return [f"    mov rax, [r15 + {env_layout[expr[1]]}]"]
        if expr[1] in env["locals"]: return [f"    mov rax, [rbp - {env['locals'][expr[1]]}]"]
        if expr[1] in env["globals"]: return [f"    mov rax, [vars + {env['globals'][expr[1]]*8}]"]
        raise Exception(f"متغير غير معرف: {expr[1]}")

    if ن=="قائمة":
        elems=expr[1]; ln=len(elems)
        code=[f"    mov rdi, {8+ln*8}", "    call arena_alloc", "    push rax"]
        code.append(f"    mov qword [rax], {ln}")
        for idx,el in enumerate(elems):
            code.extend(compile_expr(el,env,funcs,env_layout))
            code.append(f"    mov [rax + {8+idx*8}], rax")
        code.append("    pop rax")
        return code

    if ن=="ثنائية":
        op=expr[1]
        left=compile_expr(expr[2],env,funcs,env_layout)
        right=compile_expr(expr[3],env,funcs,env_layout)
        if op=="⊕":
            _counters["copy"]+=1; k=_counters["copy"]
            code=left+["    push rax"]+right+["    mov r11, rax","    pop r10"]
            code += ["    push r10","    push r11",
                "    mov rax, [r10]","    add rax, [r11]","    add rax, 8",
                "    mov rdi, rax","    call arena_alloc","    mov rbx, rax",
                "    mov rax, [r10]","    mov [rbx], rax",
                f".cpy1_{k}:","    test rax, rax",f"    jz .c1d_{k}",
                "    mov cl, [r10 + 8]","    mov [rbx + 8], cl",
                "    inc r10","    inc rbx","    dec rax",f"    jmp .cpy1_{k}",f".c1d_{k}:",
                "    mov rax, [r11]",f".cpy2_{k}:","    test rax, rax",f"    jz .c2d_{k}",
                "    mov cl, [r11 + 8]","    mov [rbx + 8], cl",
                "    inc r11","    inc rbx","    dec rax",f"    jmp .cpy2_{k}",f".c2d_{k}:",
                "    pop r11","    pop r10","    mov rax, rbx"]
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
        if اسم=="حجم":
            if len(args)!=1: raise Exception("حجم تأخذ وسيطاً واحداً")
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    mov rax, [rax]")
            return code
        if اسم=="مجموع":
            if len(args)!=1: raise Exception("مجموع تأخذ وسيطاً واحداً")
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
                "    mov rax, [r10]","    add rax, 1",
                "    mov rdi, rax","    shl rdi, 3","    add rdi, 8",
                "    call arena_alloc","    mov rbx, rax",
                "    mov rax, [r10]","    add rax, 1","    mov [rbx], rax",
                "    mov rax, [r10]",f".lcpy_{k}:","    test rax, rax",f"    jz .lcd_{k}",
                "    mov rcx, [r10 + 8]","    mov [rbx + 8], rcx",
                "    add r10, 8","    add rbx, 8","    dec rax",f"    jmp .lcpy_{k}",f".lcd_{k}:",
                "    mov [rbx + 8], r11",
                "    pop r11","    pop r10","    mov rax, rbx"]
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
    var_map={}; funcs={"idx":0,"bodies":[]}; global_code=[]
    env={"globals":var_map,"locals":{}}
    for بيان in برنامج:
        ن=بيان[0]
        if ن in ["عرف","أسند"]:
            اسم=بيان[1]
            if اسم not in var_map: var_map[اسم]=len(var_map)
            global_code.extend(compile_expr(بيان[2],env,funcs))
            global_code.append(f"    mov [vars + {var_map[اسم]*8}], rax")
        elif ن=="اطبع":
            e=بيان[1]
            global_code.extend(compile_expr(e,env,funcs))
            global_code.append("    call print_str" if هو_نص(e) else "    call print_int")
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
        if out==expected: print(f"✅ AOT Lists ({name}): {out}")
        else:
            print(f"❌ AOT Lists ({name}): Expected '{expected}', Got '{out}'")
            if result.stderr: print(f"   stderr: {result.stderr.strip()}")
            sys.exit(1)
    except Exception as e:
        print(f"❌ AOT Lists ({name}): Error: {e}"); sys.exit(1)

build_and_run("t_fact","مضروب ≡ λن. (ن = 1) ؟ 1 : ن · مضروب(ن - 1)\n⎕ مضروب(5)","120")
build_and_run("t_closure","صانع ≡ λس. λص. س + ص\nد ≔ صانع(10)\n⎕ د(5)","15")
build_and_run("t_len","أ ≔ ⟨1,2,3⟩\n⎕ طول(أ)","3")
build_and_run("t_head","أ ≔ ⟨7,8,9⟩\n⎕ رأس(أ)","7")
build_and_run("t_sum","مجموع ≡ λق. (طول(ق) = 0) ؟ 0 : رأس(ق) + مجموع(ذيل(ق))\nأ ≔ ⟨1,2,3,4⟩\n⎕ مجموع(أ)","10")
build_and_run("t_append","أ ≔ ⟨1,2⟩\nب ≔ ألحق(أ, 3)\n⎕ طول(ب)","3")
build_and_run("t_str","⎕ \"مرحبا\"","مرحبا")
build_and_run("t_concat","رحب ≡ λاسم. \"مرحبا \" ⊕ اسم\n⎕ رحب(\"بالعربية\")","مرحبا بالعربية")
build_and_run("t_strsize","⎕ حجم(\"abc\")","3")
print("🎉 القوائم والنصوص في AOT تعمل بنجاح!")
PY

python3 math_aot_lists.py