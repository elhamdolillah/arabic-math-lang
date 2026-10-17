#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 6: End-to-End — المُجمّع يولّد برنامجاً قابلاً للتنفيذ
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
# المُجمّع المولّد v2 (نفس المرحلة 5)
# ═══════════════════════════════════════════════════════════
برنامج_مولد_v2 = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
موضع ≔ 4
أ ≔ 0
م ≔ 1
μ م = 1 : ﴿ حرف ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف ≠ 32 ⋄ أ ≔ م ؟ أ · 10 + حرف - 48 : أ ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
عملية ≔ رمز(مصدر، موضع + 1)
موضع ≔ موضع + 3
ب ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول_م ⋄ حرف ≔ م ؟ رمز(مصدر، موضع) : 32 ⋄ ب ≔ م ؟ ب · 10 + حرف - 48 : ب ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
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
print("المرحلة 6: End-to-End")
print("=" * 50)

print("\n🔧 تجميع المولّد...")
ر = حلل_رموز(برنامج_مولد_v2)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen3.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen3.asm', '-o', 'gen3.o'], check=True)
subprocess.run(['ld', 'gen3.o', '-o', 'gen3'], check=True)
print("✅ تم تجميع المولّد")

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
    ("⎕ 12 + 34", "46"),
    ("⎕ 9 - 4",   "5"),
    ("⎕ 3 * 7",   "21"),
    ("⎕ 100 + 200", "300"),
    ("⎕ 50 - 25", "25"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./gen3'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('e2e.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'e2e.asm', '-o', 'e2e.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'e2e.o', '-o', 'e2e'], check=True, capture_output=True)
        result = subprocess.run(['./e2e'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {inp} → {out}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 6 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع العربي يولّد برامج تُجمَّع وتُشغَّل بنجاح!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
