#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 22 المُصححة: Bootstrap كامل
مع تطبيق دستور القرآن: ﴿وآتوا كل ذي حق حقه﴾
المسافة لها حق في النص، يجب حفظها
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
# C₀ المُصحح: يحفظ المسافات
# ═══════════════════════════════════════════════════════════
# الدستور: ﴿إنا كل شيء خلقناه بقدر﴾
# المسافة (32) لها قدر وحق، تُحفظ مثل أي بايت آخر
# الشرط الوحيد للتوقف: علامة الاقتباس (34)

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
# تجميع C₀
# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 22 المُصححة: Bootstrap + دستور القرآن")
print("=" * 70)
print("\n📖 الدستور المطبق:")
print("   ﴿وآتوا كل ذي حق حقه﴾ — المسافة لها حق في النص")
print("   ﴿إنا كل شيء خلقناه بقدر﴾ — كل بايت له قدر")

print("\n🔧 تجميع C₀...")
ر = حلل_رموز(C0_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c0.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c0.asm', '-o', 'c0.o'], check=True)
subprocess.run(['ld', 'c0.o', '-o', 'c0'], check=True)
print("✅ تم تجميع C₀")

# ═══════════════════════════════════════════════════════════
# اختبار: C₀ يجمّع برامج عادية
# ═══════════════════════════════════════════════════════════
print("\n🧪 اختبار 1: C₀ يجمّع برامج عادية:")
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
        out = result.stdout
        if out == expected:
            print(f"  ✅ {inp} → {out}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# اختبار: C₀ يجمّع أسطر من مصدر نفسه (Bootstrap)
# ═══════════════════════════════════════════════════════════
print("\n🔥 اختبار 2: C₀ يجمّع أسطر من مصدر نفسه:")

# الأسطر من مصدر C₀ التي بصيغة ⎕ "نص"
self_lines = [
    ('⎕ "global _start"', "global _start"),
    ('⎕ "section .data"', "section .data"),
    ('⎕ "section .text"', "section .text"),
    ('⎕ "_start:"', "_start:"),
    ('⎕ "    mov rax, 1"', "    mov rax, 1"),
    ('⎕ "    mov rdi, 1"', "    mov rdi, 1"),
    ('⎕ "    lea rsi, [msg]"', "    lea rsi, [msg]"),
    ('⎕ "    syscall"', "    syscall"),
    ('⎕ "    mov rax, 60"', "    mov rax, 60"),
    ('⎕ "    xor rdi, rdi"', "    xor rdi, rdi"),
]

bootstrap_count = 0
for _idx, (inp, expected) in enumerate(self_lines):
    result = subprocess.run(['./c0'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    import os; open("dbg_%d.asm" % hash(generated), "w").write(generated + "\n")
    _uid = "%d_%d" % (_idx, hash(generated) & 0xFFFFFF)
    _base = 'c0_self_' + _uid
    with open(_base + '.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', _base + '.asm', '-o', _base + '.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', _base + '.o', '-o', _base], check=True, capture_output=True)
        result = subprocess.run(['./' + _base], capture_output=True, text=True)
        out = result.stdout
        if out == expected:
            print(f"  ✅ {inp} → {out}")
            bootstrap_count += 1
        else:
            print(f"  ❌ {inp} → متوقع '{repr(expected)}', فعلي '{repr(out)}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# اختبار: حفظ المسافات (دستور القرآن)
# ═══════════════════════════════════════════════════════════
print("\n📖 اختبار 3: حفظ المسافات (﴿وآتوا كل ذي حق حقه﴾):")
space_tests = [
    ('⎕ "  hello"', "  hello"),
    ('⎕ "    world"', "    world"),
    ('⎕ "  بسم الله  "', "  بسم الله  "),
]

for inp, expected in space_tests:
    result = subprocess.run(['./c0'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('c0_space.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'c0_space.asm', '-o', 'c0_space.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'c0_space.o', '-o', 'c0_space'], check=True, capture_output=True)
        result = subprocess.run(['./c0_space'], capture_output=True, text=True)
        out = result.stdout
        if out == expected:
            print(f"  ✅ المسافات محفوظة: {repr(inp)}")
        else:
            print(f"  ❌ المسافات مفقودة: {repr(inp)} → متوقع '{repr(expected)}'، فعلي '{repr(out)}'")
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

print(f"\n📖 الدستور القرآني المطبق:")
print(f"   ﴿وآتوا كل ذي حق حقه﴾ — المسافات محفوظة")
print(f"   ﴿إنا كل شيء خلقناه بقدر﴾ — كل بايت له قدر")
print(f"   ﴿كتاب أحكمت آياته﴾ — لا غموض في البنية")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 22 المُصححة نجحت!")
    print(f"   C₀ يجمّع {bootstrap_count} أسطر من نفسه ({bootstrap_pct:.1f}%)")
    print(f"   الدستور القرآني مطبق: المسافات محفوظة")
    print(f"   الخطوة التالية: توسيع C₀ ليدعم ⊕ و ؟ : و μ")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)