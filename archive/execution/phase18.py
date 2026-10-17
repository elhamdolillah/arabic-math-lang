#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 18: Bootstrap جزئي — المُجمّع يجمّع جزءاً من نفسه
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

C1_source = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
موضع ≔ 5
نص_م ≔ ""
م ≔ 1
μ م = 1 : ﴿ حرف_عدد ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف_عدد ≠ 34 ⋄ حرف_نص ≔ م ؟ نص_رمز(حرف_عدد) : "" ⋄ نص_م ≔ م ؟ نص_م ⊕ حرف_نص : نص_م ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
طول_نص ≔ حجم(نص_م)
علامة ≔ نص_رمز(34)
⎕ "section .data"
⎕ "msg db " ⊕ علامة ⊕ نص_م ⊕ علامة
⎕ "section .text"
⎕ "mov rax, 1"
⎕ "mov rdi, 1"
⎕ "lea rsi, [msg]"
⎕ "mov rdx, " ⊕ نص(طول_نص)
⎕ "syscall"
⎕ "mov rax, 60"
⎕ "xor rdi, rdi"
⎕ "syscall"
"""

print("=" * 50)
print("المرحلة 18: Bootstrap جزئي")
print("=" * 50)
print("\n🔧 الخطوة 1: تجميع C₁...")
ر = حلل_رموز(C1_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c1.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c1.asm', '-o', 'c1.o'], check=True)
subprocess.run(['ld', 'c1.o', '-o', 'c1'], check=True)
print("✅ تم تجميع C₁")

print("\n🧪 الخطوة 2: C₁ يجمّع جزءاً من نفسه:")
self_lines = [
    '⎕ "section .data"',
    '⎕ "section .text"',
    '⎕ "mov rax, 1"',
    '⎕ "mov rdi, 1"',
    '⎕ "syscall"',
]

failed = 0
for line in self_lines:
    result = subprocess.run(['./c1'], capture_output=True, text=True, input=line + "\n")
    generated = result.stdout.strip()
    with open('self_test.asm', 'w') as f:
        f.write("global _start\n" + generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'self_test.asm', '-o', 'self_test.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'self_test.o', '-o', 'self_test'], check=True, capture_output=True)
        result = subprocess.run(['./self_test'], capture_output=True, text=True)
        out = result.stdout.strip()
        expected = line.split('"')[1]
        if out == expected:
            print(f"  ✅ {line} → {out}")
        else:
            print(f"  ❌ {line} → متوقع '{expected}', فعلي '{out}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {line} → خطأ: {e}")
        failed += 1

print("\n📐 الخطوة 3: تحليل الـ Bootstrap:")
total_lines = len(C1_source.strip().split('\n'))
compilable_lines = len(self_lines)
print(f"   إجمالي أسطر C₁: {total_lines}")
print(f"   الأسطر القابلة للتجميع بواسطة C₁: {compilable_lines}")
print(f"   نسبة الـ Bootstrap: {compilable_lines}/{total_lines} = {compilable_lines/total_lines*100:.1f}%")

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 18 نجحت! ({len(self_lines)}/{len(self_lines)})")
    print("المُجمّع C₁ يجمّع جزءاً من نفسه بنجاح!")
    print(f"\n📐 الـ Bootstrap الجزئي: {compilable_lines}/{total_lines} أسطر")
    print("   الخطوة التالية: توسيع C₁ ليدعم المزيد من الميزات")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
