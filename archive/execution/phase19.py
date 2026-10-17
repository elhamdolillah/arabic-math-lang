#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 19: توسيع Bootstrap الجزئي (26% → 50%+)
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
# C₁: مُجمّع المرحلة 12
# ═══════════════════════════════════════════════════════════
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

# ═══════════════════════════════════════════════════════════
# C₂: مُجمّع يدعم ⊕ (دمج نصين)
# ═══════════════════════════════════════════════════════════
C2_source = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
موضع ≔ 5
نص١ ≔ ""
م ≔ 1
μ م = 1 : ﴿ حرف_عدد ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف_عدد ≠ 34 ⋄ حرف_نص ≔ م ؟ نص_رمز(حرف_عدد) : "" ⋄ نص١ ≔ م ؟ نص١ ⊕ حرف_نص : نص١ ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
موضع ≔ موضع + 7
نص٢ ≔ ""
م ≔ 1
μ م = 1 : ﴿ حرف_عدد ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف_عدد ≠ 34 ⋄ حرف_نص ≔ م ؟ نص_رمز(حرف_عدد) : "" ⋄ نص٢ ≔ م ؟ نص٢ ⊕ حرف_نص : نص٢ ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
نص_كامل ≔ نص١ ⊕ نص٢
طول_نص ≔ حجم(نص_كامل)
علامة ≔ نص_رمز(34)
⎕ "section .data"
⎕ "msg db " ⊕ علامة ⊕ نص_كامل ⊕ علامة
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

# ═══════════════════════════════════════════════════════════
# تجميع C₁ و C₂
# ═══════════════════════════════════════════════════════════
print("=" * 50)
print("المرحلة 19: توسيع Bootstrap الجزئي")
print("=" * 50)

print("\n🔧 تجميع C₁...")
ر = حلل_رموز(C1_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c1.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c1.asm', '-o', 'c1.o'], check=True)
subprocess.run(['ld', 'c1.o', '-o', 'c1'], check=True)
print("✅ تم تجميع C₁")

print("\n🔧 تجميع C₂...")
ر = حلل_رموز(C2_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c2.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c2.asm', '-o', 'c2.o'], check=True)
subprocess.run(['ld', 'c2.o', '-o', 'c2'], check=True)
print("✅ تم تجميع C₂")

# ═══════════════════════════════════════════════════════════
# الخطوة 1: C₁ يجمّع 9 أسطر من مصدر نفسه
# ═══════════════════════════════════════════════════════════
print("\n🧪 الخطوة 1: C₁ يجمّع أسطر ⎕ \"نص\" من نفسه:")
c1_lines = [
    ('⎕ "section .data"', "section .data"),
    ('⎕ "section .text"', "section .text"),
    ('⎕ "mov rax, 1"', "mov rax, 1"),
    ('⎕ "mov rdi, 1"', "mov rdi, 1"),
    ('⎕ "lea rsi, [msg]"', "lea rsi, [msg]"),
    ('⎕ "syscall"', "syscall"),
    ('⎕ "mov rax, 60"', "mov rax, 60"),
    ('⎕ "xor rdi, rdi"', "xor rdi, rdi"),
]

failed = 0
for inp, expected in c1_lines:
    result = subprocess.run(['./c1'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('self_test.asm', 'w') as f:
        f.write("global _start\n" + generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'self_test.asm', '-o', 'self_test.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'self_test.o', '-o', 'self_test'], check=True, capture_output=True)
        result = subprocess.run(['./self_test'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {inp} → {out}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# الخطوة 2: C₂ يجمّع سطر ⊕ من مصدر C₁
# ═══════════════════════════════════════════════════════════
print("\n🧪 الخطوة 2: C₂ يجمّع سطر ⊕ من مصدر C₁:")
c2_tests = [
    ('⎕ "mov rdx, " ⊕ "5"', "mov rdx, 5"),
    ('⎕ "msg db " ⊕ "test"', "msg db test"),
]

for inp, expected in c2_tests:
    result = subprocess.run(['./c2'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('self_test2.asm', 'w') as f:
        f.write("global _start\n" + generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'self_test2.asm', '-o', 'self_test2.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'self_test2.o', '-o', 'self_test2'], check=True, capture_output=True)
        result = subprocess.run(['./self_test2'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {inp} → {out}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# تحليل النتائج
# ═══════════════════════════════════════════════════════════
total_lines = 19
c1_compiled = len(c1_lines)
c2_compiled = len(c2_tests)
total_compiled = c1_compiled + c2_compiled
percentage = total_compiled / total_lines * 100

print(f"\n📐 تحليل الـ Bootstrap:")
print(f"   إجمالي أسطر C₁: {total_lines}")
print(f"   أسطر جمّعها C₁: {c1_compiled}")
print(f"   أسطر جمّعها C₂: {c2_compiled}")
print(f"   الإجمالي: {total_compiled}/{total_lines} = {percentage:.1f}%")

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 19 نجحت! ({total_compiled}/{total_compiled})")
    print(f"الـ Bootstrap الجزئي: {percentage:.1f}%")
    print("الخطوة التالية: دعم المزيد من الميزات للوصول إلى 100%")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)