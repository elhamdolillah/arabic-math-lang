#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 15: مُجمّع يجمّع ⊙ (قراءة من stdin)
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مولد_v10 = """مصدر ≔ ⊙
نوع ≔ رمز(مصدر، 4)
⎕ "global _start"
⎕ "section .bss"
⎕ "    buf resb 256"
⎕ "section .text"
⎕ "_start:"
⎕ "    mov rdi, 0"
⎕ "    mov rsi, buf"
⎕ "    mov rdx, 256"
⎕ "    mov rax, 0"
⎕ "    syscall"
⎕ "    mov rdi, 1"
⎕ "    mov rsi, buf"
⎕ "    mov rdx, rax"
⎕ "    mov rax, 1"
⎕ "    syscall"
⎕ "    mov rax, 60"
⎕ "    xor rdi, rdi"
⎕ "    syscall"
"""

print("=" * 50)
print("المرحلة 15: مُجمّع يجمّع ⊙")
print("=" * 50)
print("\n🔧 تجميع المولّد v10...")
ر = حلل_رموز(برنامج_مولد_v10)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen11.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen11.asm', '-o', 'gen11.o'], check=True)
subprocess.run(['ld', 'gen11.o', '-o', 'gen11'], check=True)
print("✅ تم تجميع المولّد v10")

print("\n🧪 اختبارات End-to-End:")
tests = [
    ("⎕ ⊙", "مرحبا", "مرحبا"),
    ("⎕ ⊙", "hello", "hello"),
    ("⎕ ⊙", "test123", "test123"),
]

failed = 0
for inp, stdin_data, expected in tests:
    result = subprocess.run(['./gen11'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('e2e15.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'e2e15.asm', '-o', 'e2e15.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'e2e15.o', '-o', 'e2e15'], check=True, capture_output=True)
        result = subprocess.run(['./e2e15'], capture_output=True, text=True, input=stdin_data + "\n")
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {inp} + stdin='{stdin_data}' → {out}")
        else:
            print(f"  ❌ {inp} + stdin='{stdin_data}' → متوقع '{expected}', فعلي '{out}'")
            print(f"     Assembly المولّد:\n{generated}")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        print(f"     Assembly المولّد:\n{generated}")
        failed += 1

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 15 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع العربي يدعم القراءة من stdin عبر ⊙!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
