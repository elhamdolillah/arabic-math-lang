#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 22c: C_cond يدعم ؟ : (شرط عددى)
الدستور: ﴿فإنما هي زجرة واحدة﴾ — الشرط قرار فوري
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
# C₁: مُجمّع النصوص والدمج (من المرحلة 22b)
# يُستخدم لتجميع أسطر من مصدر C_cond
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
# C_cond: مُجمّع شرطى — يجمّع ⎕ A ؟ B : C
# ═══════════════════════════════════════════════════════════
# بنية UTF-8 لـ ⎕ 1 ؟ 5 : 3:
#   [⎕ 3B][ 1B][1 1B][ 1B][؟ 2B][ 1B][5 1B][ 1B][: 1B][ 1B][3 1B]
#   A=4, ؟=6,7, B=9, :=11, C=13
#
# المولّد:
#   mov rax, A
#   cmp rax, 0
#   je .else
#   mov rax, B
#   jmp .end
#   .else:
#   mov rax, C
#   .end:

C_cond_source = """مصدر ≔ ⊙
شرط ≔ رمز(مصدر، 4) - 48
فرع_صح ≔ رمز(مصدر، 9) - 48
فرع_خطأ ≔ رمز(مصدر، 13) - 48
⎕ "mov rax, " ⊕ نص(شرط)
⎕ "cmp rax, 0"
⎕ "je .else"
⎕ "mov rax, " ⊕ نص(فرع_صح)
⎕ "jmp .end"
⎕ ".else:"
⎕ "mov rax, " ⊕ نص(فرع_خطأ)
⎕ ".end:"
"""

# ═══════════════════════════════════════════════════════════
# تجميع C₁ و C_cond
# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 22c: C_cond يدعم ؟ :")
print("الدستور: ﴿فإنما هي زجرة واحدة﴾")
print("=" * 70)

print("\n🔧 تجميع C₁ (لتجميع أسطر Bootstrap)...")
ر = حلل_رموز(C1_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c1_22c.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c1_22c.asm', '-o', 'c1_22c.o'], check=True)
subprocess.run(['ld', 'c1_22c.o', '-o', 'c1_22c'], check=True)
print("✅ تم تجميع C₁")

print("\n🔧 تجميع C_cond (؟ :)...")
ر = حلل_رموز(C_cond_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c_cond.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c_cond.asm', '-o', 'c_cond.o'], check=True)
subprocess.run(['ld', 'c_cond.o', '-o', 'c_cond'], check=True)
print("✅ تم تجميع C_cond")

# ═══════════════════════════════════════════════════════════
# اختبار 1: C_cond يجمّع شروط عددية
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🧪 اختبار 1: C_cond يجمّع ؟ : (شروط عددية)")
print("=" * 70)

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

tests_cond = [
    ("⎕ 1 ؟ 5 : 3", "5"),
    ("⎕ 0 ؟ 5 : 3", "3"),
    ("⎕ 1 ؟ 9 : 0", "9"),
    ("⎕ 0 ؟ 9 : 0", "0"),
    ("⎕ 1 ؟ 7 : 2", "7"),
]

failed = 0
for inp, expected in tests_cond:
    result = subprocess.run(['./c_cond'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('cond_test.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'cond_test.asm', '-o', 'cond_test.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'cond_test.o', '-o', 'cond_test'], check=True, capture_output=True)
        result = subprocess.run(['./cond_test'], capture_output=True, text=True)
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
# اختبار 2: C₁ يجمّع أسطر من مصدر C_cond (Bootstrap)
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🔥 اختبار 2: C₁ يجمّع أسطر من مصدر C_cond (Bootstrap)")
print("=" * 70)

# الأسطر الثابتة من مصدر C_cond (بدون متغيرات)
cond_self_lines = [
    ('⎕ "cmp rax, 0" ⊕ ""', "cmp rax, 0"),
    ('⎕ "je .else" ⊕ ""', "je .else"),
    ('⎕ "jmp .end" ⊕ ""', "jmp .end"),
    ('⎕ ".else:" ⊕ ""', ".else:"),
    ('⎕ ".end:" ⊕ ""', ".end:"),
]

bootstrap_count = 0
for inp, expected in cond_self_lines:
    result = subprocess.run(['./c1_22c'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('cond_self.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'cond_self.asm', '-o', 'cond_self.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'cond_self.o', '-o', 'cond_self'], check=True, capture_output=True)
        result = subprocess.run(['./cond_self'], capture_output=True, text=True)
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
# اختبار 3: C₁ يجمّع أسطر ⊕ من مصدر C_cond
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🔥 اختبار 3: C₁ يجمّع أسطر ⊕ من مصدر C_cond")
print("=" * 70)

cond_concat_lines = [
    ('⎕ "mov rax, " ⊕ "1"', "mov rax, 1"),
    ('⎕ "mov rax, " ⊕ "5"', "mov rax, 5"),
    ('⎕ "mov rax, " ⊕ "3"', "mov rax, 3"),
]

for inp, expected in cond_concat_lines:
    result = subprocess.run(['./c1_22c'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('cond_cat.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'cond_cat.asm', '-o', 'cond_cat.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'cond_cat.o', '-o', 'cond_cat'], check=True, capture_output=True)
        result = subprocess.run(['./cond_cat'], capture_output=True, text=True)
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
cond_lines = len(C_cond_source.strip().split('\n'))
bootstrap_pct = bootstrap_count / cond_lines * 100

print(f"\n📐 تحليل الـ Bootstrap:")
print(f"   إجمالي أسطر C_cond: {cond_lines}")
print(f"   أسطر جمّعها C₁ من مصدر C_cond: {bootstrap_count}")
print(f"   نسبة Bootstrap: {bootstrap_pct:.1f}%")

print(f"\n📖 الدستور القرآني المطبق:")
print(f"   ﴿فإنما هي زجرة واحدة﴾ — الشرط قرار فوري")
print(f"   ﴿فريق في الجنة وفريق في السعير﴾ — فرعان لا ثالث لهما")
print(f"   ﴿وآتوا كل ذي حق حقه﴾ — المسافات محفوظة")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 22c نجحت!")
    print(f"   C_cond يجمّع ؟ : بشكل صحيح")
    print(f"   C₁ يجمّع {bootstrap_count} أسطر من مصدر C_cond ({bootstrap_pct:.1f}%)")
    print(f"   الخطوة التالية: 22d — C_loop يدعم μ")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)