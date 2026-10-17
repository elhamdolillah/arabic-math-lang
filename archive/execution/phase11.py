#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 11: Bootstrap مُصغّر — مُجمّع يجمّع مُجمّعاً أبسط
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

مجمّع_مصغّر = """مصدر ≔ ⊙
أ ≔ رمز(مصدر، 4) - 48
عملية ≔ رمز(مصدر، 6)
ب ≔ رمز(مصدر، 8) - 48
⎕ "mov rax, " ⊕ نص(أ)
⎕ "mov rbx, " ⊕ نص(ب)
عملية_نص ≔ "add rax, rbx"
م ≔ عملية = 45
عملية_نص ≔ م ؟ "sub rax, rbx" : عملية_نص
م ≔ عملية = 42
عملية_نص ≔ م ؟ "imul rax, rbx" : عملية_نص
⎕ عملية_نص
"""

print("=" * 50)
print("المرحلة 11: Bootstrap مُصغّر")
print("=" * 50)
print("\n🔧 الخطوة 1: تجميع المُجمّع المصغّر بواسطة math_complete.py...")
ر = حلل_رموز(مجمّع_مصغّر)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('bootstrap.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'bootstrap.asm', '-o', 'bootstrap.o'], check=True)
subprocess.run(['ld', 'bootstrap.o', '-o', 'bootstrap'], check=True)
print("✅ تم تجميع المُجمّع المصغّر (bootstrap)")

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

print("\n🧪 الخطوة 2: المُجمّع المصغّر يجمّع برامج:")
tests = [
    ("⎕ 2 + 3", "5"),
    ("⎕ 9 - 4", "5"),
    ("⎕ 3 * 7", "21"),
    ("⎕ 5 + 5", "10"),
    ("⎕ 8 - 3", "5"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./bootstrap'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    full_asm = preamble + generated + "\n" + print_int_routine + exit_code
    with open('boot_out.asm', 'w') as f:
        f.write(full_asm)
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'boot_out.asm', '-o', 'boot_out.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'boot_out.o', '-o', 'boot_out'], check=True, capture_output=True)
        result = subprocess.run(['./boot_out'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {inp} → {out}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        failed += 1

print("\n🔍 الخطوة 3: تحليل إمكانية الـ Bootstrap الكامل...")
print("   المُجمّع المصغّر يستخدم:")
print("   - ⊙ (قراءة من stdin)")
print("   - رمز() (استخراج بايت)")
print("   - نص() (تحويل عدد لنص)")
print("   - ⊕ (دمج نصوص)")
print("   - ؟ : (شرط)")
print("   - ⎕ (طباعة)")
print("")
print("   لتجميع نفسه، يحتاج دعم كل هذه الميزات.")
print("   الخطوة التالية: توسيع المُجمّع ليدعم هذه الميزات.")

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 11 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع المصغّر يعمل ويجمّع برامج بنجاح!")
    print("الخطوة التالية: توسيعه حتى يجمّع نفسه (Bootstrap كامل)")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
