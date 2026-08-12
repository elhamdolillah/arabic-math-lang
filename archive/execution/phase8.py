#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 8: برنامج من 3 أسطر مع متغيرين
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مولد_v4 = """سطر١ ≔ ⊙
سطر٢ ≔ ⊙
سطر٣ ≔ ⊙
طول١ ≔ حجم(سطر١)
طول٢ ≔ حجم(سطر٢)
موضع ≔ 7
أ ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول١ ⋄ حرف ≔ م ؟ رمز(سطر١، موضع) : 32 ⋄ أ ≔ م ؟ أ · 10 + حرف - 48 : أ ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
موضع ≔ 7
ب ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول٢ ⋄ حرف ≔ م ؟ رمز(سطر٢، موضع) : 32 ⋄ ب ≔ م ؟ ب · 10 + حرف - 48 : ب ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
عملية ≔ رمز(سطر٣، 7)
عملية_نص ≔ "add rax, rbx"
م ≔ عملية = 45
عملية_نص ≔ م ؟ "sub rax, rbx" : عملية_نص
م ≔ عملية = 42
عملية_نص ≔ م ؟ "imul rax, rbx" : عملية_نص
⎕ "mov rax, " ⊕ نص(أ)
⎕ "mov rbx, " ⊕ نص(ب)
⎕ عملية_نص
"""

print("=" * 50)
print("المرحلة 8: متغيران")
print("=" * 50)
print("\n🔧 تجميع المولّد v4...")
ر = حلل_رموز(برنامج_مولد_v4)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen5.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen5.asm', '-o', 'gen5.o'], check=True)
subprocess.run(['ld', 'gen5.o', '-o', 'gen5'], check=True)
print("✅ تم تجميع المولّد v4")

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
    ("س ≔ 12\nص ≔ 34\n⎕ س + ص", "46"),
    ("س ≔ 9\nص ≔ 4\n⎕ س - ص",   "5"),
    ("س ≔ 3\nص ≔ 7\n⎕ س * ص",   "21"),
    ("س ≔ 100\nص ≔ 200\n⎕ س + ص", "300"),
    ("س ≔ 50\nص ≔ 25\n⎕ س - ص", "25"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./gen5'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('e2e8.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'e2e8.asm', '-o', 'e2e8.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'e2e8.o', '-o', 'e2e8'], check=True, capture_output=True)
        result = subprocess.run(['./e2e8'], capture_output=True, text=True)
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
    print(f"🎉 المرحلة 8 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع العربي يدعم برامج من 3 أسطر مع متغيرين!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
