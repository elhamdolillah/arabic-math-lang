#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 13: مُجمّع يجمّع ⊕ (دمج نصوص)
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مولد_v8 = """مصدر ≔ ⊙
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

print("=" * 50)
print("المرحلة 13: مُجمّع يجمّع ⊕")
print("=" * 50)
print("\n🔧 تجميع المولّد v8...")
ر = حلل_رموز(برنامج_مولد_v8)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('gen9.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'gen9.asm', '-o', 'gen9.o'], check=True)
subprocess.run(['ld', 'gen9.o', '-o', 'gen9'], check=True)
print("✅ تم تجميع المولّد v8")

print("\n🧪 اختبارات End-to-End:")
tests = [
    ('⎕ "AB" ⊕ "CD"', "ABCD"),
    ('⎕ "hello" ⊕ "world"', "helloworld"),
    ('⎕ "a" ⊕ "b"', "ab"),
    ('⎕ "test" ⊕ "123"', "test123"),
]

failed = 0
for inp, expected in tests:
    result = subprocess.run(['./gen9'], capture_output=True, text=True, input=inp + "\n")
    generated = result.stdout.strip()
    with open('e2e13.asm', 'w') as f:
        f.write("global _start\n" + generated + "\n")
    try:
        subprocess.run(['nasm', '-f', 'elf64', 'e2e13.asm', '-o', 'e2e13.o'], check=True, capture_output=True)
        subprocess.run(['ld', 'e2e13.o', '-o', 'e2e13'], check=True, capture_output=True)
        result = subprocess.run(['./e2e13'], capture_output=True, text=True)
        out = result.stdout.strip()
        if out == expected:
            print(f"  ✅ {inp} → {out}")
        else:
            print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
            print(f"     Assembly المولّد:\n{generated}")
            failed += 1
    except Exception as e:
        print(f"  ❌ {inp} → خطأ: {e}")
        print(f"     Assembly المولّد:\n{generated}")
        failed += 1

print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 13 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع العربي يدعم دمج النصوص عبر ⊕!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
