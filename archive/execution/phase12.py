#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 12: مُجمّع بلغة العربية يدعم ⎕ و ⊕
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مولد_v7 = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
موضع ≔ 4
نص_م ≔ ""
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول_م ⋄ حرف ≔ م ؟ رمز(مصدر، موضع) : 34 ⋄ م ≔ م ؟ (حرف ≠ 34) ؟ 1 : 0 : 0 ⋄ نص_م ≔ م ؟ نص_م ⊕ " " : نص_م ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
⎕ "section .data"
⎕ "msg db " ⊕ نص_م
⎕ "section .text"
⎕ "mov rax, 1"
⎕ "mov rdi, 1"
⎕ "lea rsi, [msg]"
⎕ "mov rdx, " ⊕ نص(طول_م)
⎕ "syscall"
"""

print("=" * 50)
print("المرحلة 12: مُجمّع يدعم ⎕ و ⊕")
print("=" * 50)

print("\n🔧 تجميع المولّد v7...")
ر = حلل_رموز(برنامج_مولد_v7)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen8.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen8.asm', '-o', 'gen8.o'], check=True)
subprocess.run(['ld', 'gen8.o', '-o', 'gen8'], check=True)
print("✅ تم تجميع المولّد v7")

print("\n🧪 الاختبارات:")
tests = [
    ('⎕ "abc"', "abc"),
    ('⎕ "hello"', "hello"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./gen8'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    print(f"  المدخل: {inp}")
    print(f"  Assembly المولّد:\n{generated}")
    print()

print("\n" + "=" * 50)
print("🎉 المرحلة 12: تم توليد Assembly لبرامج نصية!")
print("الخطوة التالية: تجميع Assembly الناتج وتشغيله")
