#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
اختبارات المرحلة 44: الأنواع الجبرية (Algebraic Data Types)
نتائج متوقعة: 3، 7، 25، 12، 75، 12، 2، 42، 120
"""
import sys, subprocess, os
sys.path.insert(0, '.')
os.chdir(os.path.dirname(os.path.abspath(__file__)) or '.')
from math_complete import *

passed = 0
failed = 0

def run(name, source, expected, desc=""):
    global passed, failed
    try:
        ر = حلل_رموز(source)
        ب = حلل_برنامج(ر)
        asm = compile_program(ب)
        with open(f'{name}.asm', 'w') as f: f.write(asm)
        subprocess.run(['nasm','-f','elf64',f'{name}.asm','-o',f'{name}.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld',f'{name}.o','-o',name],
                       check=True, capture_output=True)
        r = subprocess.run([f'./{name}'], capture_output=True, text=True, timeout=10)
        out = r.stdout.strip()
        if out == expected:
            print(f"  [✅] {name}: {out}  ({desc})")
            passed += 1
        else:
            print(f"  [❌] {name}: المتوقع '{expected}'، الناتج '{out}'  ({desc})")
            failed += 1
    except Exception as e:
        print(f"  [❌] {name}: {e}  ({desc})")
        failed += 1

print("=" * 60)
print("  المرحلة 44: الأنواع الجبرية (ADTs)")
print("=" * 60)

# 1: تعريف نوع وبناء قيمة + ناتج 3
run("t44_basic",
    '''نوع نقطة : ﴿ نقطة(س، ص) ﴾
ن ≔ نقطة(3، 4)
⎕ نص(3)''',
    "3", "تعريف نوع وبناء")

# 2: تطابق مع باني واحد
run("t44_match_single",
    '''نوع نقطة : ﴿ نقطة(س، ص) ﴾
ن ≔ نقطة(3، 4)
نتيجة ≔ طابق ن : ﴿ نقطة(س، ص) ⇒ س + ص ﴾
⎕ نص(نتيجة)''',
    "7", "تطابق مع باني واحد")

# 3: بناة متعددة — دائرة(5) ⇒ ن·ن
run("t44_multi_ctor",
    '''نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾
ش ≔ دائرة(5)
نتيجة ≔ طابق ش : ﴿ دائرة(ن) ⇒ ن · ن ⋄ مستطيل(ع، ا) ⇒ ع · ا ﴾
⎕ نص(نتيجة)''',
    "25", "بناة متعددة (دائرة)")

# 4: بناة متعددة — مستطيل(3،4)
run("t44_multi_values",
    '''نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾
ش ≔ مستطيل(3، 4)
نتيجة ≔ طابق ش : ﴿ دائرة(ن) ⇒ ن · ن ⋄ مستطيل(ع، ا) ⇒ ع · ا ﴾
⎕ نص(نتيجة)''',
    "12", "مستطيل(3،4)")

# 5: دالة مع ADT — مساحة(دائرة(5)) = 3·5·5
run("t44_function",
    '''نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾
مساحة ≡ λش. طابق ش : ﴿ دائرة(ن) ⇒ 3 · ن · ن ⋄ مستطيل(ع، ا) ⇒ ع · ا ﴾
⎕ نص(مساحة(دائرة(5)))''',
    "75", "دالة مع ADT")

# 6: ثلاثة بناة — مثلث(3،4،5) ⇒ أ+ب+ج
run("t44_three_ctors",
    '''نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ⋄ مثلث(أ، ب، ج) ﴾
ش ≔ مثلث(3، 4، 5)
نتيجة ≔ طابق ش : ﴿ دائرة(ن) ⇒ 1 ⋄ مستطيل(ع، ا) ⇒ 2 ⋄ مثلث(أ، ب، ج) ⇒ أ + ب + ج ﴾
⎕ نص(نتيجة)''',
    "12", "ثلاثة بناة")

# 7: بناة بلا معاملات — أحمر ⋄ أزرق ⋄ أخضر
run("t44_zero_args",
    '''نوع لون : ﴿ أحمر ⋄ أزرق ⋄ أخضر ﴾
ل ≔ أزرق
نتيجة ≔ طابق ل : ﴿ أحمر ⇒ 1 ⋄ أزرق ⇒ 2 ⋄ أخضر ⇒ 3 ﴾
⎕ نص(نتيجة)''',
    "2", "بناة بلا معاملات")

# 8: نوع الخيار — بعض(42) ⋄ لاشيء
run("t44_option",
    '''نوع خيار : ﴿ بعض(ق) ⋄ لاشيء ﴾
خ ≔ بعض(42)
نتيجة ≔ طابق خ : ﴿ بعض(ق) ⇒ ق ⋄ لاشيء ⇒ 0 ﴾
⎕ نص(نتيجة)''',
    "42", "نوع الخيار Option")

# 9: توافق عكسي — مضروب(5)
run("t44_compat",
    '''مضروب ≡ λن. طابق ن : ﴿ 0 ⇒ 1 ⋄ س ⇒ س · مضروب(س - 1) ﴾
⎕ نص(مضروب(5))''',
    "120", "توافق عكسي (المضروب)")

# الملخص
print()
print("=" * 60)
total = passed + failed
print(f"  النتائج: {passed}/{total} ناجحة")
if failed == 0:
    print("  🎉 جميع اختبارات المرحلة 44 نجحت!")
else:
    print(f"  {failed} اختبار(ات) فشلت")
print("=" * 60)

if failed > 0:
    sys.exit(1)
