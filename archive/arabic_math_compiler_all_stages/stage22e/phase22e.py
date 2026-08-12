#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 22e: C_full — المُجمّع الموحّد
الدستور: ﴿واعتصموا بحبل الله جميعاً﴾
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
# C₁: لتجميع أسطر Bootstrap
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
# C_full: المُجمّع الموحّد
# ═══════════════════════════════════════════════════════════
# يجمّع: ⎕ "نص" | ⎕ "نص1" ⊕ "نص2" | ⎕ "نص" × N
#
# بنية UTF-8 بعد علامة الاقتباس الثانية:
#   ⊕: مسافة(1) + E2 8A 95(3) + مسافة(1) + "(1) → نص٢ من موضع+7
#   ×: مسافة(1) + C3 97(2) + مسافة(1) + N(1)  → N من موضع+5
#
# البايت الأول بعد المسافة (موضع+2):
#   226 (0xE2) → ⊕
#   195 (0xC3) → ×

C_full_source = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
موضع ≔ 5
نص١ ≔ ""
م ≔ 1
μ م = 1 : ﴿ حرف_عدد ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف_عدد ≠ 34 ⋄ حرف_نص ≔ م ؟ نص_رمز(حرف_عدد) : "" ⋄ نص١ ≔ م ؟ نص١ ⊕ حرف_نص : نص١ ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
موضع_بايت ≔ موضع + 2
بايت_نوع ≔ موضع_بايت < طول_م ؟ رمز(مصدر، موضع_بايت) : 0
م ≔ بايت_نوع = 226
نوع_دمج ≔ م ؟ 1 : 0
م ≔ بايت_نوع = 195
نوع_حلقة ≔ م ؟ 1 : 0
موضع٢ ≔ نوع_دمج ؟ موضع + 7 : موضع
نص٢ ≔ ""
م ≔ نوع_دمج
μ م = 1 : ﴿ حرف_عدد ≔ م ؟ رمز(مصدر، موضع٢) : 34 ⋄ م ≔ حرف_عدد ≠ 34 ⋄ حرف_نص ≔ م ؟ نص_رمز(حرف_عدد) : "" ⋄ نص٢ ≔ م ؟ نص٢ ⊕ حرف_نص : نص٢ ⋄ موضع٢ ≔ م ؟ موضع٢ + 1 : موضع٢ ﴾
تكرار ≔ نوع_حلقة ؟ رمز(مصدر، موضع + 5) - 48 : 1
نص_كامل ≔ نوع_دمج ؟ نص١ ⊕ نص٢ : نص١
طول_نص ≔ حجم(نص_كامل)
علامة ≔ نص_رمز(34)
⎕ "global _start"
⎕ "section .data"
⎕ "msg db " ⊕ علامة ⊕ نص_كامل ⊕ علامة
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
# تجميع C₁ و C_full
# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 22e: C_full — المُجمّع الموحّد")
print("الدستور: ﴿واعتصموا بحبل الله جميعاً﴾")
print("=" * 70)

print("\n🔧 تجميع C₁...")
ر = حلل_رموز(C1_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c1_22e.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c1_22e.asm', '-o', 'c1_22e.o'], check=True)
subprocess.run(['ld', 'c1_22e.o', '-o', 'c1_22e'], check=True)
print("✅ تم تجميع C₁")

print("\n🔧 تجميع C_full...")
ر = حلل_رموز(C_full_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c_full.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c_full.asm', '-o', 'c_full.o'], check=True)
subprocess.run(['ld', 'c_full.o', '-o', 'c_full'], check=True)
print("✅ تم تجميع C_full")

# ═══════════════════════════════════════════════════════════
# اختبار 1: C_full يجمّع ⎕ "نص" بسيط
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🧪 اختبار 1: C_full يجمّع ⎕ \"نص\" بسيط")
print("=" * 70)

failed = 0
tests_simple = [
    ('⎕ "Hello, World!"', "Hello, World!"),
    ('⎕ "مرحبا بالعالم"', "مرحبا بالعالم"),
    ('⎕ "بسم الله الرحمن الرحيم"', "بسم الله الرحمن الرحيم"),
]

for inp, expected in tests_simple:
    result = subprocess.run(['./c_full'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('full_test.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'full_test.asm', '-o', 'full_test.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'full_test.o', '-o', 'full_test'], check=True, capture_output=True)
        result = subprocess.run(['./full_test'], capture_output=True, text=True)
        out = result.stdout
        if out.rstrip() == expected:
            print(f"  ✅ {inp} → {out.rstrip()}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out.rstrip()}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# اختبار 2: C_full يجمّع ⊕ (دمج)
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🧪 اختبار 2: C_full يجمّع ⊕ (دمج)")
print("=" * 70)

tests_concat = [
    ('⎕ "hello" ⊕ "world"', "helloworld"),
    ('⎕ "مرحبا" ⊕ "بالعالم"', "مرحبابالعالم"),
    ('⎕ "msg db " ⊕ "test"', "msg db test"),
]

for inp, expected in tests_concat:
    result = subprocess.run(['./c_full'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('full_test.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'full_test.asm', '-o', 'full_test.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'full_test.o', '-o', 'full_test'], check=True, capture_output=True)
        result = subprocess.run(['./full_test'], capture_output=True, text=True)
        out = result.stdout
        if out.rstrip() == expected:
            print(f"  ✅ {inp} → {out.rstrip()}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out.rstrip()}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# اختبار 3: C_full يجمّع × (حلقة)
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🧪 اختبار 3: C_full يجمّع × (حلقة)")
print("=" * 70)

tests_loop = [
    ('⎕ "x" × 3', "xxx"),
    ('⎕ "ab" × 2', "abab"),
    ('⎕ "*" × 5', "*****"),
]

for inp, expected in tests_loop:
    result = subprocess.run(['./c_full'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('full_test.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'full_test.asm', '-o', 'full_test.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'full_test.o', '-o', 'full_test'], check=True, capture_output=True)
        result = subprocess.run(['./full_test'], capture_output=True, text=True)
        out = result.stdout
        if out.rstrip() == expected:
            print(f"  ✅ {inp} → {out.rstrip()}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out.rstrip()}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# اختبار 4: C₁ يجمّع أسطر من مصدر C_full (Bootstrap)
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🔥 اختبار 4: C₁ يجمّع أسطر من مصدر C_full (Bootstrap)")
print("=" * 70)

full_self_lines = [
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
    ('⎕ "mov rcx, " ⊕ "1"', "mov rcx, 1"),
    ('⎕ "mov rdx, " ⊕ "5"', "mov rdx, 5"),
    ('⎕ "msg db " ⊕ "test"', "msg db test"),
]

bootstrap_count = 0
for inp, expected in full_self_lines:
    result = subprocess.run(['./c1_22e'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('full_self.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'full_self.asm', '-o', 'full_self.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'full_self.o', '-o', 'full_self'], check=True, capture_output=True)
        result = subprocess.run(['./full_self'], capture_output=True, text=True)
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
# تحليل الـ Bootstrap
# ═══════════════════════════════════════════════════════════
full_lines = len(C_full_source.strip().split('\n'))
bootstrap_pct = bootstrap_count / full_lines * 100

print(f"\n📐 تحليل الـ Bootstrap:")
print(f"   إجمالي أسطر C_full: {full_lines}")
print(f"   أسطر جمّعها C₁ من مصدر C_full: {bootstrap_count}")
print(f"   نسبة Bootstrap: {bootstrap_pct:.1f}%")

print(f"\n📊 ملخص Bootstrap التراكمي:")
print(f"   C₀ (نص):        47.6%")
print(f"   C₁ (+ ⊕):       46.2%")
print(f"   C_cond (+ ؟):   66.7%")
print(f"   C_loop (+ μ):   64.3%")
print(f"   C_full (موحّد): {bootstrap_pct:.1f}%")

print(f"\n📖 الدستور القرآني المطبق:")
print(f"   ﴿واعتصموا بحبل الله جميعاً﴾ — التوحيد يجمع الفرق")
print(f"   ﴿كن فيكون﴾ — أمر واحد فيولّد كل شيء")
print(f"   ﴿وآتوا كل ذي حق حقه﴾ — المسافات محفوظة")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 22e نجحت!")
    print(f"   C_full يجمّع 3 صيغ: ⎕ \"نص\" + ⊕ + ×")
    print(f"   C₁ يجمّع {bootstrap_count} أسطر من مصدر C_full ({bootstrap_pct:.1f}%)")
    print(f"   الخطوة التالية: 22f — Bootstrap كامل 100%")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)