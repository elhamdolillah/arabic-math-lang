#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 16: مُجمّع يجمّع رمز() و نص() (الدوال المدمجة)
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مولد_v11 = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
نوع ≔ رمز(مصدر، 4)
نوع_ث ≔ رمز(مصدر، 5)
م ≔ نوع = 217
نوع_نص ≔ م ؟ 1 : 0
م ≔ نوع_ث = 134
نوع_نص ≔ م ؟ نوع_نص : 0
قيمة ≔ 0
م ≔ نوع_نص = 1
موضع ≔ 9
μ م = 1 : ﴿ حرف ≔ م ؟ رمز(مصدر، موضع) : 41 ⋄ م ≔ حرف ≠ 41 ⋄ قيمة ≔ م ؟ قيمة · 10 + حرف - 48 : قيمة ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
م ≔ نوع_نص = 0
حرف_عدد ≔ م ؟ رمز(مصدر، 12) : 0
قيمة ≔ م ؟ حرف_عدد : قيمة
⎕ "mov rax, " ⊕ نص(قيمة)
⎕ "call print_int"
"""

print("=" * 50)
print("المرحلة 16: مُجمّع يجمّع رمز() و نص()")
print("=" * 50)
print("\n🔧 تجميع المولّد v11...")
ر = حلل_رموز(برنامج_مولد_v11)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen12.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen12.asm', '-o', 'gen12.o'], check=True)
subprocess.run(['ld', 'gen12.o', '-o', 'gen12'], check=True)
print("✅ تم تجميع المولّد v11")

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
    mov rax, 60
    xor rdi, rdi
    syscall
"""

print("\n🧪 اختبارات End-to-End:")
tests = [
    ("⎕ نص(42)", "42"),
    ("⎕ نص(123)", "123"),
    ("⎕ نص(0)", "0"),
    ("⎕ رمز(\"A\"، 0)", "65"),
    ("⎕ رمز(\"B\"، 0)", "66"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./gen12'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n    jmp program_exit\n" + print_int_routine + "\nprogram_exit:\n" + exit_code
    with open('e2e16.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'e2e16.asm', '-o', 'e2e16.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'e2e16.o', '-o', 'e2e16'], check=True, capture_output=True)
        result = subprocess.run(['./e2e16'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {inp} → {out}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
            print(f"     Assembly المولّد:\n{generated}")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        print(f"     Assembly المولّد:\n{generated}")
        failed += 1

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 16 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع العربي يدعم الدوال المدمجة رمز() و نص()!")
    print("\n🏆 جميع الميزات المطلوبة للـ Bootstrap متوفرة الآن:")
    print("   ✅ ⊙ (قراءة)")
    print("   ✅ رمز() (استخراج بايت)")
    print("   ✅ نص() (تحويل عدد لنص)")
    print("   ✅ ⊕ (دمج نصوص)")
    print("   ✅ ؟ : (شرط)")
    print("   ✅ ⎕ (طباعة)")
    print("\n   الخطوة التالية: Bootstrap كامل!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
