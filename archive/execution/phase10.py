#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 10: 3 متغيرات + تعبير من 3 حدود + print_int مع دعم السالب
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مولد_v6 = """سطر١ ≔ ⊙
سطر٢ ≔ ⊙
سطر٣ ≔ ⊙
سطر٤ ≔ ⊙
طول١ ≔ حجم(سطر١)
طول٢ ≔ حجم(سطر٢)
طول٣ ≔ حجم(سطر٣)
أ ≔ 0
ب ≔ 0
ج ≔ 0
اسم١ ≔ رمز(سطر١، 1)
موضع ≔ 7
قيمة ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول١ ⋄ حرف ≔ م ؟ رمز(سطر١، موضع) : 32 ⋄ قيمة ≔ م ؟ قيمة · 10 + حرف - 48 : قيمة ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
م ≔ اسم١ = 163
أ ≔ م ؟ قيمة : أ
م ≔ اسم١ = 168
ب ≔ م ؟ قيمة : ب
م ≔ اسم١ = 172
ج ≔ م ؟ قيمة : ج
اسم٢ ≔ رمز(سطر٢، 1)
موضع ≔ 7
قيمة ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول٢ ⋄ حرف ≔ م ؟ رمز(سطر٢، موضع) : 32 ⋄ قيمة ≔ م ؟ قيمة · 10 + حرف - 48 : قيمة ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
م ≔ اسم٢ = 163
أ ≔ م ؟ قيمة : أ
م ≔ اسم٢ = 168
ب ≔ م ؟ قيمة : ب
م ≔ اسم٢ = 172
ج ≔ م ؟ قيمة : ج
اسم٣ ≔ رمز(سطر٣، 1)
موضع ≔ 7
قيمة ≔ 0
מ ≔ 1
μ מ = 1 : ﴿ מ ≔ موضع < طول٣ ⋄ حرف ≔ מ ؟ رمز(سطر٣، موضع) : 32 ⋄ قيمة ≔ מ ؟ قيمة · 10 + حرف - 48 : قيمة ⋄ موضع ≔ מ ؟ موضع + 1 : موضع ﴾
م ≔ اسم٣ = 163
أ ≔ م ؟ قيمة : أ
م ≔ اسم٣ = 168
ب ≔ م ؟ قيمة : ب
م ≔ اسم٣ = 172
ج ≔ م ؟ قيمة : ج
اسم_س ≔ رمز(سطر٤، 5)
عملية١ ≔ رمز(سطر٤، 7)
اسم_ص ≔ رمز(سطر٤، 10)
عملية٢ ≔ رمز(سطر٤، 12)
اسم_ع ≔ رمز(سطر٤، 15)
قيمة_س ≔ 0
م ≔ اسم_س = 163
قيمة_س ≔ م ؟ أ : قيمة_س
م ≔ اسم_س = 168
قيمة_س ≔ م ؟ ب : قيمة_س
م ≔ اسم_س = 172
قيمة_س ≔ م ؟ ج : قيمة_س
قيمة_ص ≔ 0
م ≔ اسم_ص = 163
قيمة_ص ≔ م ؟ أ : قيمة_ص
م ≔ اسم_ص = 168
قيمة_ص ≔ م ؟ ب : قيمة_ص
م ≔ اسم_ص = 172
قيمة_ص ≔ م ؟ ج : قيمة_ص
قيمة_ع ≔ 0
م ≔ اسم_ع = 163
قيمة_ع ≔ م ؟ أ : قيمة_ع
م ≔ اسم_ع = 168
قيمة_ع ≔ م ؟ ب : قيمة_ع
م ≔ اسم_ع = 172
قيمة_ع ≔ م ؟ ج : قيمة_ع
⎕ "mov rax, " ⊕ نص(قيمة_س)
عملية_نص ≔ "add"
م ≔ عملية١ = 45
عملية_نص ≔ م ؟ "sub" : عملية_نص
م ≔ عملية١ = 42
عملية_نص ≔ م ؟ "imul" : عملية_نص
⎕ عملية_نص ⊕ " rax, " ⊕ نص(قيمة_ص)
عملية_نص ≔ "add"
م ≔ عملية٢ = 45
عملية_نص ≔ م ؟ "sub" : عملية_نص
م ≔ عملية٢ = 42
عملية_نص ≔ م ؟ "imul" : عملية_نص
⎕ عملية_نص ⊕ " rax, " ⊕ نص(قيمة_ع)
"""

print("=" * 50)
print("المرحلة 10: 3 متغيرات + print_int مع السالب")
print("=" * 50)
print("\n🔧 تجميع المولّد v6...")
ر = حلل_رموز(برنامج_مولد_v6)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen7.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen7.asm', '-o', 'gen7.o'], check=True)
subprocess.run(['ld', 'gen7.o', '-o', 'gen7'], check=True)
print("✅ تم تجميع المولّد v6")

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
    ("أ ≔ 5\nب ≔ 3\nج ≔ 2\n⎕ أ + ب + ج", "10"),
    ("أ ≔ 12\nب ≔ 34\nج ≔ 54\n⎕ أ + ب + ج", "100"),
    ("أ ≔ 10\nب ≔ 3\nج ≔ 2\n⎕ أ - ب - ج", "5"),
    ("أ ≔ 3\nب ≔ 7\nج ≔ 2\n⎕ أ * ب * ج", "42"),
    ("ب ≔ 100\nأ ≔ 200\nج ≔ 50\n⎕ أ + ب + ج", "350"),
    ("أ ≔ 5\nب ≔ 10\nج ≔ 3\n⎕ أ - ب - ج", "-8"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./gen7'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('e2e10.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'e2e10.asm', '-o', 'e2e10.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'e2e10.o', '-o', 'e2e10'], check=True, capture_output=True)
        result = subprocess.run(['./e2e10'], capture_output=True, text=True)
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
    print(f"🎉 المرحلة 10 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع العربي يدعم 3 متغيرات + تعبير من 3 حدود + أعداد سالبة!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
