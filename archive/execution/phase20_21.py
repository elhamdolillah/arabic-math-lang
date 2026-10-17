#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 20-21: مُجمّعات تستخدم ؟ : و μ في منطق التجميع
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
# C₃: مُجمّع يستخدم ؟ : (شرط) في منطق التجميع
# ═══════════════════════════════════════════════════════════
# الصيغة المدعومة:
#   ⎕ شرط ؟ قيمة_صح : قيمة_خطأ
#   حيث شرط, قيمة_صح, قيمة_خطأ أرقام مفردة

C3_source = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
شرط ≔ رمز(مصدر، 4) - 48
موضع ≔ 9
قيمة_صح ≔ 0
م ≔ 1
μ م = 1 : ﴿ حرف ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف ≠ 32 ⋄ قيمة_صح ≔ م ؟ قيمة_صح · 10 + حرف - 48 : قيمة_صح ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
موضع ≔ موضع + 3
قيمة_خطأ ≔ 0
م ≔ 1
μ م = 1 : ﴿ م ≔ موضع < طول_م ⋄ حرف ≔ م ؟ رمز(مصدر، موضع) : 32 ⋄ قيمة_خطأ ≔ م ؟ قيمة_خطأ · 10 + حرف - 48 : قيمة_خطأ ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
⎕ "mov rax, " ⊕ نص(شرط)
⎕ "cmp rax, 0"
⎕ "je .else"
⎕ "mov rax, " ⊕ نص(قيمة_صح)
⎕ "jmp .end"
⎕ ".else:"
⎕ "mov rax, " ⊕ نص(قيمة_خطأ)
⎕ ".end:"
"""

# ═══════════════════════════════════════════════════════════
# C₄: مُجمّع يستخدم μ و ﴿⋄﴾ (حلقة) في منطق التجميع
# ═══════════════════════════════════════════════════════════
# الصيغة المدعومة:
#   μ س < N : ﴿ ⎕ "نص" ﴾
#   حيث N رقم و "نص" سلسلة نصية
#   يطبع "نص" عدد N من المرات

C4_source = """مصدر ≔ ⊙
طول_م ≔ حجم(مصدر)
موضع ≔ 8
حد ≔ 0
م ≔ 1
μ م = 1 : ﴿ حرف ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف ≠ 32 ⋄ حد ≔ م ؟ حد · 10 + حرف - 48 : حد ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
موضع ≔ موضع + 12
نص_م ≔ ""
م ≔ 1
μ م = 1 : ﴿ حرف_عدد ≔ رمز(مصدر، موضع) ⋄ م ≔ حرف_عدد ≠ 34 ⋄ حرف_نص ≔ م ؟ نص_رمز(حرف_عدد) : "" ⋄ نص_م ≔ م ؟ نص_م ⊕ حرف_نص : نص_م ⋄ موضع ≔ م ؟ موضع + 1 : موضع ﴾
طول_نص ≔ حجم(نص_م)
علامة ≔ نص_رمز(34)
⎕ "section .data"
⎕ "msg db " ⊕ علامة ⊕ نص_م ⊕ علامة
⎕ "section .text"
⎕ "mov rcx, " ⊕ نص(حد)
⎕ ".loop:"
⎕ "push rcx"
⎕ "mov rax, 1"
⎕ "mov rdi, 1"
⎕ "lea rsi, [msg]"
⎕ "mov rdx, " ⊕ نص(طول_نص)
⎕ "syscall"
⎕ "pop rcx"
⎕ "dec rcx"
⎕ "jnz .loop"
"""

# ═══════════════════════════════════════════════════════════
# تجميع C₃ و C₄
# ═══════════════════════════════════════════════════════════
print("=" * 60)
print("المرحلة 20-21: مُجمّعات تستخدم ؟ : و μ")
print("=" * 60)

print("\n🔧 تجميع C₃ (يستخدم ؟ :)...")
ر = حلل_رموز(C3_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c3.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c3.asm', '-o', 'c3.o'], check=True)
subprocess.run(['ld', 'c3.o', '-o', 'c3'], check=True)
print("✅ تم تجميع C₃")

print("\n🔧 تجميع C₄ (يستخدم μ)...")
ر = حلل_رموز(C4_source)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('c4.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'c4.asm', '-o', 'c4.o'], check=True)
subprocess.run(['ld', 'c4.o', '-o', 'c4'], check=True)
print("✅ تم تجميع C₄")

# ═══════════════════════════════════════════════════════════
# اختبار C₃: يولّد قفزات مشروطة
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 60)
print("🧪 اختبارات C₃ (يستخدم ؟ :)")
print("=" * 60)

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

tests_c3 = [
    ("⎕ 1 ؟ 5 : 3", "5"),
    ("⎕ 0 ؟ 5 : 3", "3"),
    ("⎕ 1 ؟ 9 : 0", "9"),
    ("⎕ 0 ؟ 9 : 0", "0"),
]

failed = 0
for inp, expected in tests_c3:
    result = subprocess.run(['./c3'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('test_c3.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'test_c3.asm', '-o', 'test_c3.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'test_c3.o', '-o', 'test_c3'], check=True, capture_output=True)
        result = subprocess.run(['./test_c3'], capture_output=True, text=True)
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
# اختبار C₄: يولّد حلقات
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 60)
print("🧪 اختبارات C₄ (يستخدم μ)")
print("=" * 60)

tests_c4 = [
    ('μ س < 3 : ﴿ ⎕ "x" ﴾', "xxx"),
    ('μ س < 2 : ﴿ ⎕ "ab" ﴾', "abab"),
    ('μ س < 5 : ﴿ ⎕ "*" ﴾', "*****"),
]

for inp, expected in tests_c4:
    result = subprocess.run(['./c4'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = "global _start\n" + generated + "\nmov rax, 60\nxor rdi, rdi\nsyscall\n"
    with open('test_c4.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'test_c4.asm', '-o', 'test_c4.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', 'test_c4.o', '-o', 'test_c4'], check=True, capture_output=True)
        result = subprocess.run(['./test_c4'], capture_output=True, text=True)
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
# تحليل التغطية
# ═══════════════════════════════════════════════════════════
c3_lines = len(C3_source.strip().split('\n'))
c4_lines = len(C4_source.strip().split('\n'))
c3_features = "؟ : (شرط) + μ (حلقة) + ⊕ (دمج)"
c4_features = "μ (حلقة) + ﴿⋄﴾ (كتلة) + ⊕ (دمج)"

print("\n" + "=" * 60)
print("📐 تحليل التغطية")
print("=" * 60)
print(f"\nC₃ ({c3_lines} سطر): {c3_features}")
print(f"C₄ ({c4_lines} سطر): {c4_features}")

print("\n" + "=" * 60)
if failed == 0:
    print(f"🎉 المرحلتان 20-21 نجحتا! ({len(tests_c3) + len(tests_c4)}/{len(tests_c3) + len(tests_c4)})")
    print("\n📊 الميزات المدعومة في مُجمّعات بلغتنا:")
    print("   ✅ ⊙ (قراءة)")
    print("   ✅ رمز() (استخراج بايت)")
    print("   ✅ نص() (تحويل عدد لنص)")
    print("   ✅ نص_رمز() (تحويل بايت لنص)")
    print("   ✅ ⊕ (دمج نصوص)")
    print("   ✅ ؟ : (شرط حقيقي)")
    print("   ✅ μ (حلقة while)")
    print("   ✅ ﴿⋄﴾ (كتلة)")
    print("   ✅ ⎕ (طباعة)")
    print("\n🏆 جميع الميزات الأساسية متوفرة للـ Bootstrap الكامل!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)