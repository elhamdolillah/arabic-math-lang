#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 9: متغيرات ديناميكية — lookup حقيقي بالاسم
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مولد_v5 = """سطر١ ≔ ⊙
سطر٢ ≔ ⊙
سطر٣ ≔ ⊙
طول١ ≔ حجم(سطر١)
طول٢ ≔ حجم(سطر٢)
أ ≔ 0
ب ≔ 0
اسم١ ≔ رمز(سطر١، 1)
موضع ≔ 7
قيمة ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول١ ⋄ حرف ≔ م ؟ رمز(سطر١، موضع) : 32 ⋄ قيمة ≔ م ؟ قيمة · 10 + حرف - 48 : قيمة ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
م ≔ اسم١ = 163
أ ≔ م ؟ قيمة : أ
م ≔ اسم١ = 168
ب ≔ م ؟ قيمة : ب
اسم٢ ≔ رمز(سطر٢، 1)
موضع ≔ 7
قيمة ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول٢ ⋄ حرف ≔ م ؟ رمز(سطر٢، موضع) : 32 ⋄ قيمة ≔ م ؟ قيمة · 10 + حرف - 48 : قيمة ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
م ≔ اسم٢ = 163
أ ≔ م ؟ قيمة : أ
م ≔ اسم٢ = 168
ب ≔ م ؟ قيمة : ب
اسم_س ≔ رمز(سطر٣، 5)
عملية ≔ رمز(سطر٣، 7)
اسم_ص ≔ رمز(سطر٣، 10)
قيمة_س ≔ 0
م ≔ اسم_س = 163
قيمة_س ≔ م ؟ أ : قيمة_س
م ≔ اسم_س = 168
قيمة_س ≔ م ؟ ب : قيمة_س
قيمة_ص ≔ 0
م ≔ اسم_ص = 163
قيمة_ص ≔ م ؟ أ : قيمة_ص
م ≔ اسم_ص = 168
قيمة_ص ≔ م ؟ ب : قيمة_ص
عملية_نص ≔ "add rax, rbx"
م ≔ عملية = 45
عملية_نص ≔ م ؟ "sub rax, rbx" : عملية_نص
م ≔ عملية = 42
عملية_نص ≔ م ؟ "imul rax, rbx" : عملية_نص
⎕ "mov rax, " ⊕ نص(قيمة_س)
⎕ "mov rbx, " ⊕ نص(قيمة_ص)
⎕ عملية_نص
"""

print("=" * 50)
print("المرحلة 9: متغيرات ديناميكية")
print("=" * 50)
print("\n🔧 تجميع المولّد v5...")
ر = حلل_رموز(برنامج_مولد_v5)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen6.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen6.asm', '-o', 'gen6.o'], check=True)
subprocess.run(['ld', 'gen6.o', '-o', 'gen6'], check=True)
print("✅ تم تجميع المولّد v5")

preamble = """global _start
section .bss
    num_buf resb 32
section .text
_start:
"""

print_int_routine = """
print_int:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    mov rbx, 10
    mov rcx, 0
    xor r8, r8
    test rax, rax
    jns .positive
    neg rax
    mov r8, 1
.positive:
    lea rdi, [num_buf + 31]
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .loop
    test r8, r8
    jz .no_sign
    dec rdi
    mov byte [rdi], '-'
    inc rcx
.no_sign:
    mov rsi, rdi
    mov byte [rsi + rcx], 10
    inc rcx
    mov rdi, 1
    mov rax, 1
    mov rdx, rcx
    syscall
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
"""

exit_code = """
    call print_int
    mov rax, 60
    xor rdi, rdi
    syscall
"""

print("\n🧪 اختبارات End-to-End:")
tests = [
    ("أ ≔ 5\nب ≔ 3\n⎕ أ + ب", "8"),
    ("أ ≔ 12\nب ≔ 34\n⎕ أ + ب", "46"),
    ("ب ≔ 9\nأ ≔ 4\n⎕ أ - ب", "-5"),
    ("أ ≔ 3\nب ≔ 7\n⎕ أ * ب", "21"),
    ("ب ≔ 100\nأ ≔ 200\n⎕ أ + ب", "300"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./gen6'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('e2e9.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'e2e9.asm', '-o', 'e2e9.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'e2e9.o', '-o', 'e2e9'], check=True, capture_output=True)
        result = subprocess.run(['./e2e9'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {repr(inp)} → {out}")
        else:
            print(f"  ❌ {repr(inp)} → متوقع '{expected}', فعلي '{out}'")
            print(f"     Assembly المولّد: {generated}")
            failed += 1
    except Exception as e:
        print(f"  ❌ {repr(inp)} → خطأ: {e}")
        failed += 1

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 9 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع العربي يدعم متغيرات ديناميكية مع lookup حقيقي!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
