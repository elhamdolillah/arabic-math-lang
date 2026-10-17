#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 22c+22d: C_cond يدعم ؟ : + C_loop يدعم μ
الدستور القرآني:
  ﴿فإنما هي زجرة واحدة﴾ — الشرط قرار فوري
  ﴿وطهر بيتي للطائفين﴾ — الحلقة طواف مستمر
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
# C_cond: مُجمّع شرطى — يجمّع ⎕ A ؟ B : C
# ═══════════════════════════════════════════════════════════
# بنية UTF-8 لـ ⎕ A ؟ B : C:
#   [⎕ 3B][ 1B][A 1B][ 1B][؟ 2B][ 1B][B 1B][ 1B][: 1B][ 1B][C 1B]
#   A=4, ؟=6,7, B=9, :=11, C=13

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
# C_loop: مُجمّع حلقي — يجمّع ⎕ "نص" × N
# ═══════════════════════════════════════════════════════════
# بنية UTF-8 لـ ⎕ "hello" × 3:
#   [⎕ 3B][ 1B][" 1B][hello][" 1B][ 1B][× 2B][ 1B][3 1B]
#   بعد قراءة النص: موضع + 5 = N
#   (مسافة 1 + × 2 بايت + مسافة 1 = 4، +1 من علامة الاقتباس = 5)

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
# تجميع C_cond و C_loop
# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 22c+22d: ؟ : + μ")
print("الدستور: ﴿فإنما هي زجرة واحدة﴾ + ﴿وطهر بيتي للطائفين﴾")
print("=" * 70)

print("\n🔧 تجميع C_cond (؟ :)...")
ر = حلل_رموز(C_cond_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c_cond2.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c_cond2.asm', '-o', 'c_cond2.o'], check=True)
subprocess.run(['ld', 'c_cond2.o', '-o', 'c_cond2'], check=True)
print("✅ تم تجميع C_cond")

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
    result = subprocess.run(['./c_cond2'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('cond2_test.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'cond2_test.asm', '-o', 'cond2_test.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'cond2_test.o', '-o', 'cond2_test'], check=True, capture_output=True)
        result = subprocess.run(['./cond2_test'], capture_output=True, text=True)
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
# اختبار 2: C_loop يجمّع حلقات
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🧪 اختبار 2: C_loop يجمّع μ (حلقات)")
print("=" * 70)

tests_loop = [
    ('⎕ "x" × 3', "xxx"),
    ('⎕ "ab" × 2', "abab"),
    ('⎕ "*" × 5', "*****"),
    ('⎕ "مرحبا" × 2', "مرحبا" * 2),
]

for inp, expected in tests_loop:
    result = subprocess.run(['./c_loop'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = generated + "\n"
    with open('loop_test.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'loop_test.asm', '-o', 'loop_test.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'loop_test.o', '-o', 'loop_test'], check=True, capture_output=True)
        result = subprocess.run(['./loop_test'], capture_output=True, text=True)
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
# اختبار 3: C_cond يجمّع أسطر من مصدر نفسه
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🔥 اختبار 3: C_cond يجمّع أسطر من مصدر نفسه (Bootstrap)")
print("=" * 70)

cond_self_lines = [
    ('⎕ "mov rax, " ⊕ "1"', "mov rax, 1"),
    ('⎕ "cmp rax, 0" ⊕ ""', "cmp rax, 0"),
    ('⎕ "je .else" ⊕ ""', "je .else"),
    ('⎕ "jmp .end" ⊕ ""', "jmp .end"),
    ('⎕ ".else:" ⊕ ""', ".else:"),
    ('⎕ ".end:" ⊕ ""', ".end:"),
]

cond_bootstrap = 0
for inp, expected in cond_self_lines:
    result = subprocess.run(['./c_cond2'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('cond2_self.asm', 'w') as f:
        f.write(generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'cond2_self.asm', '-o', 'cond2_self.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'cond2_self.o', '-o', 'cond2_self'], check=True, capture_output=True)
        result = subprocess.run(['./cond2_self'], capture_output=True, text=True)
        out = result.stdout
        if out.rstrip() == expected:
            print(f"  ✅ {inp}")
            cond_bootstrap += 1
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out.rstrip()}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

# ═══════════════════════════════════════════════════════════
# اختبار 4: C_loop يجمّع أسطر من مصدر نفسه
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("🔥 اختبار 4: C_loop يجمّع أسطر من مصدر نفسه (Bootstrap)")
print("=" * 70)

loop_self_lines = [
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

loop_bootstrap = 0
for inp, expected in loop_self_lines:
    result = subprocess.run(['./c_loop'], capture_output=True, text=True, input=inp + "\n")
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
            loop_bootstrap += 1
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
loop_lines = len(C_loop_source.strip().split('\n'))
total_bootstrap = cond_bootstrap + loop_bootstrap
total_lines = cond_lines + loop_lines
bootstrap_pct = total_bootstrap / total_lines * 100

print(f"\n📐 تحليل الـ Bootstrap:")
print(f"   C_cond: {cond_lines} سطر، جمّع {cond_bootstrap}")
print(f"   C_loop: {loop_lines} سطر، جمّع {loop_bootstrap}")
print(f"   الإجمالي: {total_bootstrap}/{total_lines} = {bootstrap_pct:.1f}%")

print(f"\n📖 الدستور القرآني المطبق:")
print(f"   ﴿فإنما هي زجرة واحدة﴾ — الشرط قرار فوري")
print(f"   ﴿وطهر بيتي للطائفين﴾ — الحلقة طواف مستمر")
print(f"   ﴿وآتوا كل ذي حق حقه﴾ — المسافات محفوظة")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلتان 22c+22d نجحتا!")
    print(f"   C_cond يجمّع ؟ : + أسطر من نفسه")
    print(f"   C_loop يجمّع μ + أسطر من نفسه")
    print(f"   نسبة Bootstrap: {bootstrap_pct:.1f}%")
    print(f"   الخطوة التالية: C₄ يدعم متغيرات + ⊙ + رمز() + نص()")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)