#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 22: Bootstrap كامل — الخطوة الأولى
مُجمّع C₀ مكتوب بلغة عربية يجمّع ⎕ "نص"
ثم نختبر: هل C₀ يجمّع جزءاً من نفسه؟
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
# C₀: مُجمّع مكتوب بلغة عربية يجمّع ⎕ "نص"
# ═══════════════════════════════════════════════════════════
# هذا هو أبسط مُجمّع ممكن:
#   يقرأ سطر ⎕ "نص"
#   يستخرج النص بين علامتي الاقتباس
#   يولّد Assembly يطبعه

C0_source = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
موضع ≔ 5
نص_م ≔ ""
م ≔ 1
μ م = 1 : ﴿ حرف_عدد ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف_عدد ≠ 34 ⋄ حرف_نص ≔ م ؟ نص_رمز(حرف_عدد) : "" ⋄ نص_م ≔ م ؟ نص_م ⊕ حرف_نص : نص_م ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
طول_نص ≔ حجم(نص_م)
علامة ≔ نص_رمز(34)
⎕ "global _start"
⎕ "section .data"
⎕ "msg db " ⊕ علامة ⊕ نص_م ⊕ علامة
⎕ "section .text"
⎕ "_start:"
⎕ "    mov rax, 1"
⎕ "    mov rdi, 1"
⎕ "    lea rsi, [msg]"
⎕ "    mov rdx, " ⊕ نص(طول_نص)
⎕ "    syscall"
⎕ "    mov rax, 60"
⎕ "    xor rdi, rdi"
⎕ "    syscall"
"""

# ═══════════════════════════════════════════════════════════
# الخطوة 1: تجميع C₀ بواسطة math_complete.py
# ═══════════════════════════════════════════════════════════
print("=" * 60)
print("المرحلة 22: Bootstrap كامل — الخطوة الأولى")
print("=" * 60)

print("\n🔧 الخطوة 1: تجميع C₀ بواسطة math_complete.py...")
ر = حلل_رموز(C0_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c0.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c0.asm', '-o', 'c0.o'], check=True)
subprocess.run(['ld', 'c0.o', '-o', 'c0'], check=True)
print("✅ تم تجميع C₀")

# ═══════════════════════════════════════════════════════════
# الخطوة 2: C₀ يجمّع برامج عادية
# ═══════════════════════════════════════════════════════════
print("\n🧪 الخطوة 2: C₀ يجمّع برامج عادية:")
tests_normal = [
    ('⎕ "Hello, World!"', "Hello, World!"),
    ('⎕ "مرحبا بالعالم"', "مرحبا بالعالم"),
    ('⎕ "بسم الله الرحمن الرحيم"', "بسم الله الرحمن الرحيم"),
]

failed = 0
for inp, expected in tests_normal:
    result = subprocess.run(['./c0'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('c0_test.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'c0_test.asm', '-o', 'c0_test.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'c0_test.o', '-o', 'c0_test'], check=True, capture_output=True)
        result = subprocess.run(['./c0_test'], capture_output=True, text=True)
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
# الخطوة 3: C₀ يجمّع أسطر من مصدر نفسه (Bootstrap!)
# ═══════════════════════════════════════════════════════════
print("\n🔥 الخطوة 3: C₀ يجمّع أسطر من مصدر نفسه!")

# الأسطر من مصدر C₀ التي بصيغة ⎕ "نص"
self_lines = [
    ('⎕ "global _start"', "global _start"),
    ('⎕ "section .data"', "section .data"),
    ('⎕ "section .text"', "section .text"),
    ('⎕ "_start:"', "_start:"),
    ('⎕ "    mov rax, 1"', "    mov rax, 1"),
    ('⎕ "    mov rdi, 1"', "    mov rdi, 1"),
    ('⎕ "    syscall"', "    syscall"),
    ('⎕ "    mov rax, 60"', "    mov rax, 60"),
    ('⎕ "    xor rdi, rdi"', "    xor rdi, rdi"),
]

bootstrap_count = 0
for inp, expected in self_lines:
    result = subprocess.run(['./c0'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('c0_self.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'c0_self.asm', '-o', 'c0_self.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'c0_self.o', '-o', 'c0_self'], check=True, capture_output=True)
        result = subprocess.run(['./c0_self'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {inp} → {out}")
            bootstrap_count += 1
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# تحليل الـ Bootstrap
# ═══════════════════════════════════════════════════════════
total_lines = len(C0_source.strip().split('\n'))
bootstrap_pct = bootstrap_count / total_lines * 100

print(f"\n📐 تحليل الـ Bootstrap:")
print(f"   إجمالي أسطر C₀: {total_lines}")
print(f"   أسطر جمّعها C₀ من نفسه: {bootstrap_count}")
print(f"   نسبة Bootstrap: {bootstrap_pct:.1f}%")

print("\n" + "=" * 60)
if failed == 0:
    print(f"🎉 المرحلة 22 (الخطوة الأولى) نجحت!")
    print(f"   C₀ يجمّع {bootstrap_count} أسطر من نفسه ({bootstrap_pct:.1f}%)")
    print(f"   الخطوة التالية: توسيع C₀ ليدعم ⊕ و ؟ : و μ")
    print(f"   الهدف: C يجمّع 100% من نفسه")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)