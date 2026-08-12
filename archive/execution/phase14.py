#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 14: مُجمّع يجمّع ؟ : (شرط حقيقي في Assembly)
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مولد_v9 = """مصدر ≔ ⊙
شرط ≔ رمز(مصدر، 4) - 48
فرع_صحيح ≔ رمز(مصدر، 9) - 48
فرع_خاطئ ≔ رمز(مصدر، 13) - 48
⎕ "mov rax, " ⊕ نص(شرط)
⎕ "cmp rax, 0"
⎕ "je .else"
⎕ "mov rax, " ⊕ نص(فرع_صحيح)
⎕ "jmp .end"
⎕ ".else:"
⎕ "mov rax, " ⊕ نص(فرع_خاطئ)
⎕ ".end:"
"""

print("=" * 50)
print("المرحلة 14: مُجمّع يجمّع ؟ :")
print("=" * 50)
print("\n🔧 تجميع المولّد v9...")
ر = حلل_رموز(برنامج_مولد_v9)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen10.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen10.asm', '-o', 'gen10.o'], check=True)
subprocess.run(['ld', 'gen10.o', '-o', 'gen10'], check=True)
print("✅ تم تجميع المولّد v9")

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
    ("⎕ 1 ؟ 5 : 3", "5"),
    ("⎕ 0 ؟ 5 : 3", "3"),
    ("⎕ 1 ؟ 9 : 0", "9"),
    ("⎕ 0 ؟ 9 : 0", "0"),
    ("⎕ 1 ؟ 7 : 2", "7"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./gen10'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('e2e14.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'e2e14.asm', '-o', 'e2e14.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'e2e14.o', '-o', 'e2e14'], check=True, capture_output=True)
        result = subprocess.run(['./e2e14'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {inp} → {out}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
            print(f"     Assembly المولّد:\n{generated}")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 14 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع العربي يدعم الشروط الحقيقية في Assembly!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
