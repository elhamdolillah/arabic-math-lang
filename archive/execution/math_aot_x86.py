import sys

# --- Lexer & Parser (من النواة الرياضية) ---
أرقام_القيم = {"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"٠":0,"١":1,"٢":2,"٣":3,"٤":4,"٥":5,"٦":6,"٧":7,"٨":8,"٩":9}
رموز_العمليات = {"≔":"≔","≡":"≡","+":"+","-":"-","·":"·","*":"·","×":"·","⎕":"⎕"}
أسماء_بديلة = {"اطبع":"⎕","⎕":"⎕"}

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
            i+=2; ت,i=حلل_تعبير(رموز,i); return ("أسند",اسم,ت),i
    raise Exception("بيان غير معروف")

def حلل_تعبير(رموز,i): return حلل_جمع(رموز,i)
def حلل_جمع(رموز,i):
    ي,i=حلل_ضرب(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in ["+","-"]:
        ع=رموز[i][1]; i+=1; م,i=حلل_ضرب(رموز,i); ي=("ثنائية",ع,ي,م)
    return ي,i
def حلل_ضرب(رموز,i):
    ي,i=حلل_عامل(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in ["·","*","×"]:
        i+=1; م,i=حلل_عامل(رموز,i); ي=("ثنائية","·",ي,م)
    return ي,i
def حلل_عامل(رموز,i):
    if i>=len(رموز): raise Exception("عامل مفقود")
    ن,ق=رموز[i]
    if ن=="عدد": return ("عدد",ق),i+1
    if ن=="معرف": return ("متغير",ق),i+1
    raise Exception("عامل غير متوقع")

# --- AOT x86_64 Code Generator ---
def compile_expr(ت, var_map):
    ن = ت[0]
    if ن == "عدد":
        return [f"    mov rax, {ت[1]}"]
    if ن == "متغير":
        idx = var_map[ت[1]]
        return [f"    mov rax, [vars + {idx*8}]"]
    if ن == "ثنائية":
        left = compile_expr(ت[2], var_map)
        right = compile_expr(ت[3], var_map)
        op = ت[1]
        code = []
        code.extend(left)
        code.append("    push rax")
        code.extend(right)
        code.append("    pop rbx") # rbx = left, rax = right
        if op == "+":
            code.append("    add rax, rbx")
        elif op == "-":
            code.append("    sub rbx, rax")
            code.append("    mov rax, rbx")
        elif op == "·":
            code.append("    imul rax, rbx")
        return code
    raise Exception(f"تعبير غير مدعوم في AOT: {ن}")

def compile_program(برنامج):
    var_map = {}
    var_count = 0
    asm = []
    asm.append("global _start")
    asm.append("section .bss")
    asm.append("    vars resq 256")
    asm.append("    num_buf resb 32")
    asm.append("")
    asm.append("section .text")
    
    # Helper: print_int (sys_write) - FIXED VERSION
    asm.append("print_int:")
    asm.append("    push rax")
    asm.append("    push rcx")
    asm.append("    push rdx")
    asm.append("    push rsi")
    asm.append("    push rdi")
    asm.append("    mov rbx, 10")
    asm.append("    mov rcx, 0")
    asm.append("    lea rdi, [num_buf + 31]")
    asm.append(".loop:")
    asm.append("    xor rdx, rdx")
    asm.append("    div rbx")
    asm.append("    add dl, '0'")
    asm.append("    dec rdi")
    asm.append("    mov [rdi], dl")
    asm.append("    inc rcx")
    asm.append("    test rax, rax")
    asm.append("    jnz .loop")
    asm.append("    mov byte [rdi], 10 ; append newline")
    asm.append("    inc rcx")
    asm.append("    mov rsi, rdi       ; ✅ rsi = buffer pointer (start of string)")
    asm.append("    mov rdi, 1         ; ✅ rdi = stdout (fd 1)")
    asm.append("    mov rax, 1         ; ✅ rax = sys_write")
    asm.append("    mov rdx, rcx       ; ✅ rdx = length")
    asm.append("    syscall")
    asm.append("    pop rdi")
    asm.append("    pop rsi")
    asm.append("    pop rdx")
    asm.append("    pop rcx")
    asm.append("    pop rax")
    asm.append("    ret")
    asm.append("")
    
    asm.append("_start:")
    
    for بيان in برنامج:
        ن = بيان[0]
        if ن == "أسند" or ن == "عرف":
            اسم = بيان[1]
            if اسم not in var_map:
                var_map[اسم] = var_count
                var_count += 1
            idx = var_map[اسم]
            code = compile_expr(بيان[2], var_map)
            asm.extend(code)
            asm.append(f"    mov [vars + {idx*8}], rax")
        elif ن == "اطبع":
            code = compile_expr(بيان[1], var_map)
            asm.extend(code)
            asm.append("    call print_int")
            
    # sys_exit(0)
    asm.append("")
    asm.append("    mov rax, 60        ; sys_exit")
    asm.append("    xor rdi, rdi       ; status 0")
    asm.append("    syscall")
    
    return "\n".join(asm)

def شغل_و_ولد(نص):
    ر = حلل_رموز(نص)
    ب = حلل_برنامج(ر)
    return compile_program(ب)

# --- Test AOT generation ---
مصدر = """
س ≔ ٢ + ٣
ص ≔ ١٠ - ٤
ض ≔ س · ص
⎕ ض
"""

asm_code = شغل_و_ولد(مصدر)
with open("math_program.asm", "w") as f:
    f.write(asm_code)

print("✅ تم توليد math_program.asm بنجاح")
