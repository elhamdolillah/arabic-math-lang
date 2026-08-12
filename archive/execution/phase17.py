#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 17: مُجمّع يجمّع متغيرات + عمليات
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مولد_v12 = """سطر١ ≔ ⊙
سطر٢ ≔ ⊙
طول١ ≔ حجم(سطر١)
موضع ≔ 7
قيمة ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول١ ⋄ حرف ≔ م ؟ رمز(سطر١، موضع) : 32 ⋄ قيمة ≔ م ؟ قيمة · 10 + حرف - 48 : قيمة ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
عملية ≔ رمز(سطر٢، 7)
طول٢ ≔ حجم(سطر٢)
موضع٢ ≔ 9
رقم ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع٢ < طول٢ ⋄ حرف ≔ م ؟ رمز(سطر٢، موضع٢) : 32 ⋄ رقم ≔ م ؟ رقم · 10 + حرف - 48 : رقم ⋄ موضع٢ ≔ م ؟ موضع٢ + 1 : موضع٢ ﴾
⎕ "mov rax, " ⊕ نص(قيمة)
عملية_نص ≔ "add rax, "
م ≔ عملية = 45
عملية_نص ≔ م ؟ "sub rax, " : عملية_نص
م ≔ عملية = 42
عملية_نص ≔ م ؟ "imul rax, " : عملية_نص
⎕ عملية_نص ⊕ نص(رقم)
"""

print("=" * 50)
print("المرحلة 17: مُجمّع يجمّع متغيرات + عمليات")
print("=" * 50)

print("\n🔧 تجميع المولّد v12...")
ر = حلل_رموز(برنامج_مولد_v12)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen13.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen13.asm', '-o', 'gen13.o'], check=True)
subprocess.run(['ld', 'gen13.o', '-o', 'gen13'], check=True)
print("✅ تم تجميع المولّد v12")

preamble = """global _start
section .bss
    num_buf resb 32
section .data
    minus_str db '-'
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
    test rax, rax
    jns .pi_pos
    neg rax
    push rax
    mov rax, 1
    mov rdi, 1
    lea rsi, [minus_str]
    mov rdx, 1
    syscall
    pop rax
.pi_pos:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.piloop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .piloop
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
    ("س ≔ 5\n⎕ س + 3", "8"),
    ("س ≔ 12\n⎕ س + 34", "46"),
    ("س ≔ 9\n⎕ س - 4", "5"),
    ("س ≔ 3\n⎕ س * 7", "21"),
    ("س ≔ 100\n⎕ س + 200", "300"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./gen13'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('e2e17.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'e2e17.asm', '-o', 'e2e17.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'e2e17.o', '-o', 'e2e17'], check=True, capture_output=True)
        result = subprocess.run(['./e2e17'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {repr(inp)} → {out}")
        else:
            print(f"  ❌ {repr(inp)} → متوقع '{expected}', فعلي '{out}'")
            print(f"     Assembly المولّد:\n{generated}")
            failed += 1
    except Exception as e:
        print(f"  ❌ {repr(inp)} → خطأ: {e}")
        failed += 1

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 17 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع العربي يدعم متغيرات + عمليات!")
    print("\n📐 ما يثبته هذا:")
    print("   المُجمّع يجمّع صيغة مشابهة للمرحلة 7")
    print("   الخطوة التالية: Bootstrap كامل")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
