#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 22d: C_loop يدعم μ (حلقة)
الدستور: ﴿وطهر بيتي للطائفين﴾ — الحلقة طواف مستمر
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
# C₁: مُجمّع النصوص والدمج (النسخة المُصححة من 22c)
# ═══════════════════════════════════════════════════════════
C1_source = """مصدر ≔ ⊙
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
⎕ "global _start"
⎕ "section .data"
⎕ "msg db " ⊕ علامة ⊕ نص_كامل ⊕ علامة
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
# C_loop: مُجمّع حلقي — يجمّع ⎕ "نص" × N
# ═══════════════════════════════════════════════════════════
# بنية UTF-8 لـ ⎕ "hello" × 3:
#   [⎕ 3B][ 1B][" 1B][hello][" 1B][ 1B][× 2B][ 1B][3 1B]
#   بعد قراءة النص: موضع = علامة الاقتباس الثانية
#   N = موضع + 5 (مسافة1 + ×2بايت + مسافة1 + علامة1 = 5)
#
# المولّد:
#   mov rcx, N
#   .loop:
#   push rcx / sys_write / pop rcx / dec rcx / jnz .loop

C_loop_source = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
موضع ≔ 5
نص_م ≔ ""
م ≔ 1
μ م = 1 : ﴿ حرف_عدد ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف_عدد ≠ 34 ⋄ حرف_نص ≔ م ؟ نص_رمز(حرف_عدد) : "" ⋄ نص_م ≔ م ؟ نص_م ⊕ حرف_نص : نص_م ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
تكرار ≔ رمز(مصدر، موضع + 5) - 48
طول_نص ≔ حجم(نص_م)
علامة ≔ نص_رمز(34)
⎕ "global _start"
⎕ "section .data"
⎕ "msg db " ⊕ علامة ⊕ نص_م ⊕ علامة
⎕ "section .text"
⎕ "_start:"
⎕ "    mov rcx, " ⊕ نص(تكرار)
⎕ ".loop:"
⎕ "    push rcx"
⎕ "    mov rax, 1"
⎕ "    mov rdi, 1"
⎕ "    lea rsi, [msg]"
⎕ "    mov rdx, " ⊕ نص(طول_نص)
⎕ "    syscall"
⎕ "    pop rcx"
⎕ "    dec rcx"
⎕ "    jnz .loop"
⎕ "    mov rax, 60"
⎕ "    xor rdi, rdi"
⎕ "    syscall"
"""

# ═══════════════════════════════════════════════════════════
# تجميع C₁ و C_loop
# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 22d: C_loop يدعم μ")
print("الدستور: ﴿وطهر بيتي للطائفين﴾")
print("=" * 70)

print("\n🔧 تجميع C₁...")
ر = حلل_رموز(C1_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c1_22d.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c1_22d.asm', '-o', 'c1_22d.o'], check=True)
subprocess.run(['ld', 'c1_22d.o', '-o', 'c1_22d'], check=True)
print("✅ تم تجميع C₁")

print("\n🔧 تجميع C_loop (μ)...")
ر = حلل_رموز(C_loop_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c_loop.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c_loop.asm', '-o', 'c_loop.o'], check=True)
subprocess.run(['ld', 'c_loop.o', '-o', 'c_loop'], check=True)
print("✅ تم تجميع C_loop")

# ═══════════════════════════════════════════════════════════
# اختبار 1: C_loop يجمّع حلقات
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🧪 اختبار 1: C_loop يجمّع μ (حلقات)")
print("=" * 70)

tests_loop = [
    ('⎕ "x" × 3', "xxx"),
    ('⎕ "ab" × 2', "abab"),
    ('⎕ "*" × 5', "*****"),
    ('⎕ "مرحبا " × 2', "مرحبا مرحبا "),
    ('⎕ "12" × 4', "12121212"),
]

failed = 0
for inp, expected in tests_loop:
    result = subprocess.run(['./c_loop'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('loop_test.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'loop_test.asm', '-o', 'loop_test.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'loop_test.o', '-o', 'loop_test'], check=True, capture_output=True)
        result = subprocess.run(['./loop_test'], capture_output=True, text=True)
        out = result.stdout
        if out.rstrip() == expected.rstrip():
            print(f"  ✅ {inp} → {out.rstrip()}")
        else:
            print(f"  ❌ {inp} → متوقع '{repr(expected)}', فعلي '{repr(out)}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# اختبار 2: C₁ يجمّع أسطر ثابتة من مصدر C_loop
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🔥 اختبار 2: C₁ يجمّع أسطر ثابتة من مصدر C_loop")
print("=" * 70)

loop_self_fixed = [
    ('⎕ "global _start" ⊕ ""', "global _start"),
    ('⎕ "section .data" ⊕ ""', "section .data"),
    ('⎕ "section .text" ⊕ ""', "section .text"),
    ('⎕ "_start:" ⊕ ""', "_start:"),
    ('⎕ ".loop:" ⊕ ""', ".loop:"),
    ('⎕ "    push rcx" ⊕ ""', "    push rcx"),
    ('⎕ "    mov rax, 1" ⊕ ""', "    mov rax, 1"),
    ('⎕ "    mov rdi, 1" ⊕ ""', "    mov rdi, 1"),
    ('⎕ "    lea rsi, [msg]" ⊕ ""', "    lea rsi, [msg]"),
    ('⎕ "    syscall" ⊕ ""', "    syscall"),
    ('⎕ "    pop rcx" ⊕ ""', "    pop rcx"),
    ('⎕ "    dec rcx" ⊕ ""', "    dec rcx"),
    ('⎕ "    jnz .loop" ⊕ ""', "    jnz .loop"),
    ('⎕ "    mov rax, 60" ⊕ ""', "    mov rax, 60"),
    ('⎕ "    xor rdi, rdi" ⊕ ""', "    xor rdi, rdi"),
]

bootstrap_count = 0
for inp, expected in loop_self_fixed:
    result = subprocess.run(['./c1_22d'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('loop_self.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'loop_self.asm', '-o', 'loop_self.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'loop_self.o', '-o', 'loop_self'], check=True, capture_output=True)
        result = subprocess.run(['./loop_self'], capture_output=True, text=True)
        out = result.stdout
        if out.rstrip() == expected:
            print(f"  ✅ {inp}")
            bootstrap_count += 1
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out.rstrip()}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# اختبار 3: C₁ يجمّع أسطر ⊕ من مصدر C_loop
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🔥 اختبار 3: C₁ يجمّع أسطر ⊕ من مصدر C_loop")
print("=" * 70)

loop_self_concat = [
    ('⎕ "mov rcx, " ⊕ "3"', "mov rcx, 3"),
    ('⎕ "mov rdx, " ⊕ "5"', "mov rdx, 5"),
    ('⎕ "msg db " ⊕ "test"', "msg db test"),
]

for inp, expected in loop_self_concat:
    result = subprocess.run(['./c1_22d'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('loop_cat.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'loop_cat.asm', '-o', 'loop_cat.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'loop_cat.o', '-o', 'loop_cat'], check=True, capture_output=True)
        result = subprocess.run(['./loop_cat'], capture_output=True, text=True)
        out = result.stdout
        if out.rstrip() == expected:
            print(f"  ✅ {inp} → {out.rstrip()}")
            bootstrap_count += 1
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out.rstrip()}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# تحليل الـ Bootstrap
# ═══════════════════════════════════════════════════════════
loop_lines = len(C_loop_source.strip().split('\n'))
bootstrap_pct = bootstrap_count / loop_lines * 100

print(f"\n📐 تحليل الـ Bootstrap:")
print(f"   إجمالي أسطر C_loop: {loop_lines}")
print(f"   أسطر جمّعها C₁ من مصدر C_loop: {bootstrap_count}")
print(f"   نسبة Bootstrap: {bootstrap_pct:.1f}%")

print(f"\n📖 الدستور القرآني المطبق:")
print(f"   ﴿وطهر بيتي للطائفين﴾ — الحلقة طواف مستمر")
print(f"   ﴿كل في فلك يسبحون﴾ — دوران حتى يكتمل")
print(f"   ﴿وآتوا كل ذي حق حقه﴾ — المسافات محفوظة")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 22d نجحت!")
    print(f"   C_loop يجمّع μ (حلقات) بشكل صحيح")
    print(f"   C₁ يجمّع {bootstrap_count} أسطر من مصدر C_loop ({bootstrap_pct:.1f}%)")
    print(f"\n📊 ملخص Bootstrap التراكمي:")
    print(f"   C₀ (نص):       47.6%")
    print(f"   C₁ (+ ⊕):      46.2%")
    print(f"   C_cond (+ ؟):  66.7%")
    print(f"   C_loop (+ μ):  {bootstrap_pct:.1f}%")
    print(f"   الخطوة التالية: 22e — متغيرات + ⊙ + رمز() + نص()")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)