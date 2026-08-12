#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 3: المُجمّع المصغّر بلغتنا العربية الرياضية
يقرأ مصدراً حسابياً ويحسبه — مكتوب بلغتنا، لا Python
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

برنامج_مجمّع = """مصدر ≔ ⊙
أ ≔ رمز(مصدر، 4) - 48
عملية ≔ رمز(مصدر، 6)
ب ≔ رمز(مصدر، 8) - 48
نتيجة ≔ أ + ب
م ≔ عملية = 45
نتيجة ≔ م ؟ أ - ب : نتيجة
م ≔ عملية = 42
نتيجة ≔ م ؟ أ · ب : نتيجة
⎕ نص(نتيجة)
"""

print("=" * 50)
print("المرحلة 3: المُجمّع المصغّر بلغتنا")
print("=" * 50)
print("\n📝 البرنامج (بلغتنا العربية):")
print(برنامج_مجمّع)
print("🔧 التجميع...")
ر = حلل_رموز(برنامج_مجمّع)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('mini.asm', 'w', encoding='utf-8') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'mini.asm', '-o', 'mini.o'], check=True)
subprocess.run(['ld', 'mini.o', '-o', 'mini'], check=True)
print("✅ تم تجميع المُجمّع المصغّر")

tests = [
    ("⎕ 2 + 3", "5"),
    ("⎕ 9 - 4", "5"),
    ("⎕ 3 * 7", "21"),
    ("⎕ 0 + 0", "0"),
    ("⎕ 5 * 5", "25"),
    ("⎕ 8 - 3", "5"),
]
failed = 0
print("\n🧪 الاختبارات:")
for inp, expected in tests:
    result = subprocess.run(['./mini'], capture_output=True, text=True, input=inp + "\n")
    out = result.stdout.strip()
    if out == expected:
        print(f"  ✅ {inp} → {out}")
    else:
        print(f"  ❌ {inp} → متوقع '{expected}', فعلي '{out}'")
        failed += 1
print("\n" + "=" * 50)
if failed == 0:
    print(f"🎉 المرحلة 3 نجحت! ({len(tests)}/{len(tests)})")
    print("المُجمّع المصغّر مكتوب بلغتنا العربية ويعمل!")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)
