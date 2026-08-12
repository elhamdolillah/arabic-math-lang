#!/bin/sh
set -e

cat > math_aot_closures.py <<'PY'
import sys, subprocess

# --- Lexer & Parser (Standardized Numbers 0-9) ---
أرقام_القيم = {"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9}
رموز_العمليات = {
    "≔":"≔","≡":"≡","+":"+","-":"-","·":"·","*":"·","×":"·","⎕":"⎕",
    "(":"(",")":")",",":",",":":":",".","<":"<",">":">","=":"=","≠":"≠","؟":"؟"
}
رموز_يونانية = {"λ":"λ"}
أسماء_بديلة = {"دالة":"λ","λ":"λ","اطبع":"⎕","⎕":"⎕"}
عمليات_الجمع = {"+":"+","-":"-"}
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

# --- Free Variable Analysis ---
def get_free_vars(expr, bound):
    ن = expr[0]
    if ن == "متغير": return {expr[1]} if expr[1] not in bound else set()
    if ن in ["ثنائية","مقارنة"]: return get_free_vars(expr[2],bound)|get_free_vars(expr[3],bound)
    if ن == "دالة": return get_free_vars(expr[2], bound|set(expr[1]))
    if ن == "استدعاء":
        res=set()
        for arg in expr[2]: res|=get_free_vars(arg,bound)
        return res
    if ن == "شرطي": return get_free_vars(expr[1],bound)|get_free_vars(expr[2],bound)|get_free_vars(expr[3],bound)
    return set()

# --- AOT x86_64 Code Generator ---
ARG_REGS = ["rdi","rsi","rdx","rcx","r8","r9"]
_cond_counter = [0]

def compile_expr(expr, env, funcs, env_layout=None):
    ن = expr[0]
    if ن == "عدد": return [f"    mov rax, {expr[1]}"]
    if ن == "متغير":
        if env_layout and expr[1] in env_layout: return [f"    mov rax, [r15 + {env_layout[expr[1]]}]"]
        if expr[1] in env["locals"]: return [f"    mov rax, [rbp - {env['locals'][expr[1]]}]"]
        if expr[1] in env["globals"]: return [f"    mov rax, [vars + {env['globals'][expr[1]]*8}]"]
        raise Exception(f"متغير غير معرف: {expr[1]}")
    if ن == "ثنائية":
        left=compile_expr(expr[2],env,funcs,env_layout); right=compile_expr(expr[3],env,funcs,env_layout)
        op=expr[1]; code=left+["    push rax"]+right+["    pop rbx"]
        if op=="+": code.append("    add rax, rbx")
        elif op=="-": code.append("    sub rbx, rax"); code.append("    mov rax, rbx")
        elif op=="·": code.append("    imul rax, rbx")
        return code
    if ن == "مقارنة":
        left=compile_expr(expr[2],env,funcs,env_layout); right=compile_expr(expr[3],env,funcs,env_layout)
        op=expr[1]; code=left+["    push rax"]+right+["    pop rbx"]
        code.append("    cmp rbx, rax"); code.append("    mov rax, 0")
        if op=="<": code.append("    setl al")
        elif op==">": code.append("    setg al")
        elif op=="=": code.append("    sete al")
        elif op=="≠": code.append("    setne al")
        return code
    if ن == "شرطي":
        _cond_counter[0]+=1; k=_cond_counter[0]
        code=compile_expr(expr[1],env,funcs,env_layout)
        code.append("    cmp rax, 0"); code.append(f"    je .else_{k}")
        code.extend(compile_expr(expr[2],env,funcs,env_layout))
        code.append(f"    jmp .end_{k}"); code.append(f".else_{k}:")
        code.extend(compile_expr(expr[3],env,funcs,env_layout))
        code.append(f".end_{k}:"); return code
    if ن == "دالة":
        params=expr[1]; body=expr[2]
        # ✅ الإصلاح: لا نضمّن env["locals"] في bound
        bound = set(env["globals"].keys()) | set(params)
        free_vars = list(get_free_vars(body, bound))
        inner_label = f"func_{funcs['idx']}"; funcs['idx'] += 1
        
        # 1. Generate Inner Function Code
        inner_fc = [f"{inner_label}:","    push rbp","    mov rbp, rsp"]
        stack_size = len(params)*8
        if stack_size%16!=0: stack_size+=8
        if stack_size==0: stack_size=16
        inner_fc.append(f"    sub rsp, {stack_size}")
        inner_env = {"globals":env["globals"],"locals":{}}
        inner_env_layout = {}
        for j,p in enumerate(params):
            inner_env["locals"][p]=(j+1)*8
            if j<len(ARG_REGS): inner_fc.append(f"    mov [rbp - {(j+1)*8}], {ARG_REGS[j]}")
        for i,v in enumerate(free_vars): inner_env_layout[v]=8+i*8
        inner_fc.extend(compile_expr(body, inner_env, funcs, inner_env_layout))
        inner_fc += ["    leave","    ret"]
        funcs['bodies'].extend(inner_fc)
        
        # 2. Generate Closure Creation (Runtime)
        code = []
        env_size = 8 + len(free_vars)*8
        code.append(f"    mov rdi, {env_size}")
        code.append("    call arena_alloc")
        code.append("    push rax")
        code.append(f"    mov rcx, {inner_label}")
        code.append("    mov [rax], rcx")
        for i,v in enumerate(free_vars):
            offset = 8+i*8
            # ✅ الإصلاح: نتحقق من env_layout أولاً (للإغلاقات المتداخلة)
            if env_layout and v in env_layout:
                code.append(f"    mov rcx, [r15 + {env_layout[v]}]")
            elif v in env["locals"]:
                code.append(f"    mov rcx, [rbp - {env['locals'][v]}]")
            elif v in env["globals"]:
                code.append(f"    mov rcx, [vars + {env['globals'][v]*8}]")
            code.append(f"    mov [rax + {offset}], rcx")
        code.append("    pop rax")
        return code
    if ن == "استدعاء":
        اسم=expr[1]; args=expr[2]; code=[]
        for arg in args:
            code.extend(compile_expr(arg,env,funcs,env_layout)); code.append("    push rax")
        for j in range(len(args)-1,-1,-1):
            if j<len(ARG_REGS): code.append(f"    pop {ARG_REGS[j]}")
        if اسم in env["locals"]: code.append(f"    mov r10, [rbp - {env['locals'][اسم]}]")
        elif اسم in env["globals"]: code.append(f"    mov r10, [vars + {env['globals'][اسم]*8}]")
        else: raise Exception(f"دالة غير معرفة: {اسم}")
        code.append("    push r15")
        code.append("    mov r15, [r10 + 8]")
        code.append("    mov r10, [r10]")
        code.append("    call r10")
        code.append("    pop r15")
        return code
    raise Exception(f"تعبير غير مدعوم: {ن}")

def compile_program(برنامج):
    asm=["global _start","section .bss","    vars resq 256","    num_buf resb 32","    arena_ptr resq 1","    arena_mem resb 65536","","section .text"]
    asm += ["arena_alloc:","    mov rax, [arena_ptr]","    add rdi, 15","    and rdi, -16","    add [arena_ptr], rdi","    ret",""]
    asm += ["print_int:","    push rax","    push rbx","    push rcx","    push rdx","    push rsi","    push rdi",
        "    mov rbx, 10","    mov rcx, 0","    lea rdi, [num_buf + 31]",".loop:","    xor rdx, rdx","    div rbx",
        "    add dl, '0'","    dec rdi","    mov [rdi], dl","    inc rcx","    test rax, rax","    jnz .loop",
        "    mov rsi, rdi","    mov byte [rsi + rcx], 10","    inc rcx","    mov rdi, 1","    mov rax, 1",
        "    mov rdx, rcx","    syscall","    pop rdi","    pop rsi","    pop rdx","    pop rcx","    pop rbx",
        "    pop rax","    ret","","_start:"]
    asm += ["    lea rax, [arena_mem]","    mov [arena_ptr], rax",""]
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
            global_code.extend(compile_expr(بيان[1],env,funcs))
            global_code.append("    call print_int")
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
        if out==expected: print(f"✅ AOT Closures ({name}): {out}")
        else: print(f"❌ AOT Closures ({name}): Expected '{expected}', Got '{out}'"); sys.exit(1)
    except Exception as e:
        print(f"❌ AOT Closures ({name}): Error: {e}"); sys.exit(1)

# --- Tests ---
build_and_run("t_fact","مضروب ≡ λن. (ن = 1) ؟ 1 : ن · مضروب(ن - 1)\n⎕ مضروب(5)","120")
build_and_run("t_closure","صانع ≡ λس. λص. س + ص\nد ≔ صانع(10)\n⎕ د(5)","15")
build_and_run("t_nested","صانع ≡ λس. λص. λع. س + ص + ع\nد ≔ صانع(1)\nه ≔ د(2)\n⎕ ه(3)","6")
print("🎉 الإغلاقات المتداخلة والساحة تعمل بنجاح!")
PY

python3 math_aot_closures.py