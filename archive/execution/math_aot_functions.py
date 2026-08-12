import sys

# --- Lexer & Parser (Full Version with Functions) ---
أرقام_القيم = {"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"٠":0,"١":1,"٢":2,"٣":3,"٤":4,"٥":5,"٦":6,"٧":7,"٨":8,"٩":9}
رموز_العمليات = {
    "≔":"≔","≡":"≡","+":"+","-":"-","·":"·","*":"·","×":"·",
    "⟨":"⟨","⟩":"⟩","(":"(",")":")",",":",","،":",",":":":",".":".",
    "⎕":"⎕"
}
رموز_يونانية = {"λ":"λ"}
أسماء_بديلة = {"دالة":"λ","λ":"λ","اطبع":"⎕","⎕":"⎕"}
عمليات_الجمع = {"+":"+","-":"-"}
عمليات_الضرب = {"·":"·"}

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

def حلل_تعبير(رموز,i): return حلل_جمع(رموز,i)
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
                if رموز[i][0]!="معرف": raise Exception("اسم معامل مطلوب")
                معلمون.append(رموز[i][1]); i+=1
                if رموز[i][1]==",": i+=1; continue
                if رموز[i][1]==")": i+=1; break
        else:
            if رموز[i][0]!="معرف": raise Exception("معامل مطلوب بعد λ")
            معلمون.append(رموز[i][1]); i+=1
        if رموز[i][1]!=".": raise Exception(". مطلوبة")
        i+=1; جسم,i=حلل_تعبير(رموز,i)
        return ("دالة",معلمون,جسم),i
    if ن=="عملية" and ق=="(":
        i+=1; ت,i=حلل_تعبير(رموز,i)
        if رموز[i][1]!=")": raise Exception(") مطلوبة")
        return ت,i+1
    if ن=="معرف":
        اسم=ق; i+=1
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1; وس=[]
            if i<len(رموز) and رموز[i][1]==")": return ("استدعاء",اسم,وس),i+1
            while True:
                و,i=حلل_تعبير(رموز,i); وس.append(و)
                if رموز[i][1]==",": i+=1; continue
                if رموز[i][1]==")": i+=1; break
            return ("استدعاء",اسم,وس),i
        return ("متغير",اسم),i
    raise Exception("عامل غير متوقع")

# --- AOT x86_64 Code Generator with Functions ---
ARG_REGS = ["rdi", "rsi", "rdx", "rcx", "r8", "r9"]

def compile_expr(ت, env, funcs):
    ن = ت[0]
    if ن == "عدد":
        return [f"    mov rax, {ت[1]}"]
    if ن == "متغير":
        if ت[1] in env["locals"]:
            return [f"    mov rax, [rbp - {env['locals'][ت[1]]}]"]
        else:
            return [f"    mov rax, [vars + {env['globals'][ت[1]]*8}]"]
    if ن == "ثنائية":
        left = compile_expr(ت[2], env, funcs)
        right = compile_expr(ت[3], env, funcs)
        op = ت[1]
        code = left + ["    push rax"] + right + ["    pop rbx"]
        if op == "+": code.append("    add rax, rbx")
        elif op == "-": code.append("    sub rbx, rax"); code.append("    mov rax, rbx")
        elif op == "·": code.append("    imul rax, rbx")
        return code
    if ن == "استدعاء":
        اسم = ت[1]; args = ت[2]
        code = []
        for arg in args:
            code.extend(compile_expr(arg, env, funcs))
            code.append("    push rax")
        for j in range(len(args)-1, -1, -1):
            if j < len(ARG_REGS): code.append(f"    pop {ARG_REGS[j]}")
        if اسم in env["locals"]:
            code.append(f"    mov r10, [rbp - {env['locals'][اسم]}]")
        else:
            code.append(f"    mov r10, [vars + {env['globals'][اسم]*8}]")
        code.append("    call r10")
        return code
    raise Exception(f"تعبير غير مدعوم: {ن}")

def compile_program(برنامج):
    asm = ["global _start", "section .bss", "    vars resq 256", "    num_buf resb 32", "", "section .text"]
    
    # print_int helper (Fixed sys_write)
    asm += [
        "print_int:", "    push rax", "    push rbx", "    push rcx", "    push rdx", "    push rsi", "    push rdi",
        "    mov rbx, 10", "    mov rcx, 0", "    lea rdi, [num_buf + 31]", ".loop:", "    xor rdx, rdx", "    div rbx",
        "    add dl, '0'", "    dec rdi", "    mov [rdi], dl", "    inc rcx", "    test rax, rax", "    jnz .loop",
        "    mov rsi, rdi", "    mov byte [rsi + rcx], 10", "    inc rcx", "    mov rdi, 1", "    mov rax, 1",
        "    mov rdx, rcx", "    syscall", "    pop rdi", "    pop rsi", "    pop rdx", "    pop rcx", "    pop rbx",
        "    pop rax", "    ret", "", "_start:"
    ]
    
    var_map = {}; var_count = 0; funcs = {}; func_idx = 0
    global_code = []; func_bodies = []
    env = {"globals": var_map, "locals": {}}
    
    for بيان in برنامج:
        ن = بيان[0]
        if ن in ["عرف", "أسند"]:
            اسم = بيان[1]
            if اسم not in var_map: var_map[اسم] = var_count; var_count += 1
            if بيان[2][0] == "دالة":
                label = f"func_{func_idx}"; funcs[اسم] = label; func_idx += 1
                fc = [f"{label}:", "    push rbp", "    mov rbp, rsp"]
                params = بيان[2][1]; body = بيان[2][2]
                local_env = {"globals": var_map, "locals": {}}
                stack_size = len(params) * 8
                if stack_size % 16 != 0: stack_size += 8
                fc.append(f"    sub rsp, {stack_size}")
                for j, p in enumerate(params):
                    local_env["locals"][p] = (j + 1) * 8
                    if j < len(ARG_REGS): fc.append(f"    mov [rbp - {(j+1)*8}], {ARG_REGS[j]}")
                fc.extend(compile_expr(body, local_env, funcs))
                fc += ["    leave", "    ret"]
                func_bodies.extend(fc)
                global_code += [f"    mov rax, {label}", f"    mov [vars + {var_map[اسم]*8}], rax"]
            else:
                global_code.extend(compile_expr(بيان[2], env, funcs))
                global_code.append(f"    mov [vars + {var_map[اسم]*8}], rax")
        elif ن == "اطبع":
            global_code.extend(compile_expr(بيان[1], env, funcs))
            global_code.append("    call print_int")
            
    asm += global_code + ["", "    mov rax, 60", "    xor rdi, rdi", "    syscall", ""] + func_bodies
    return "\n".join(asm)

def build_and_run(name, source, expected):
    ر = حلل_رموز(source)
    ب = حلل_برنامج(ر)
    asm = compile_program(ب)
    with open(f"{name}.asm", "w") as f: f.write(asm)
    import os
    os.system(f"nasm -f elf64 {name}.asm -o {name}.o")
    os.system(f"ld {name}.o -o {name}")
    out = os.popen(f"./{name}").read().strip()
    if out == expected:
        print(f"✅ AOT Functions ({name}): {out}")
    else:
        print(f"❌ AOT Functions ({name}): Expected {expected}, Got {out}")
        sys.exit(1)

# --- Tests ---
build_and_run("test_func1", "تربيع ≡ λس. س · س\nن ≔ تربيع(٥)\n⎕ ن", "25")
build_and_run("test_func2", "جمع ≡ λ(س, ص). س + ص\n⎕ جمع(٢, ٣)", "5")
print("🎉 اختبارات الدوال في AOT نجحت بنجاح!")
