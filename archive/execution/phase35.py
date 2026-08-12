#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 35: شبكات عصبية رمزية (عروة)
الدستور: ﴿فقد استمسك بالعروة الوثقى﴾
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 35: شبكات عصبية رمزية (عروة)")
print("الدستور: ﴿فقد استمسك بالعروة الوثقى﴾")
print("=" * 70)

failed = 0

# ─────────────────────────────────────────────────────────
# اختبار 1: بوابة AND
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 1: بوابة AND (﴿واعتصموا بحبل الله جميعاً﴾)")
برنامج_and = """و ≔ 1
ز ≔ 1
انحياز ≔ 0 - 1
س ≔ 1
ص ≔ 1
ناتج ≔ و · س + ز · ص + انحياز
م ≔ ناتج > 0
⎕ "AND(1,1) = " ⊕ نص(م ؟ 1 : 0)
س ≔ 1
ص ≔ 0
ناتج ≔ و · س + ز · ص + انحياز
م ≔ ناتج > 0
⎕ "AND(1,0) = " ⊕ نص(م ؟ 1 : 0)
س ≔ 0
ص ≔ 0
ناتج ≔ و · س + ز · ص + انحياز
م ≔ ناتج > 0
⎕ "AND(0,0) = " ⊕ نص(م ؟ 1 : 0)
"""

ر = حلل_رموز(برنامج_and)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('nn1.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'nn1.asm', '-o', 'nn1.o'], check=True)
subprocess.run(['ld', 'nn1.o', '-o', 'nn1'], check=True)
result = subprocess.run(['./nn1'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "AND(1,1) = 1" in out and "AND(1,0) = 0" in out and "AND(0,0) = 0" in out:
    print("  ✅ بوابة AND تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 2: بوابة OR
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 2: بوابة OR (﴿فأينما تولوا فثم وجه الله﴾)")
برنامج_or = """و ≔ 1
ز ≔ 1
انحياز ≔ 0
س ≔ 1
ص ≔ 0
ناتج ≔ و · س + ز · ص + انحياز
م ≔ ناتج > 0
⎕ "OR(1,0) = " ⊕ نص(م ؟ 1 : 0)
س ≔ 0
ص ≔ 0
ناتج ≔ و · س + ز · ص + انحياز
م ≔ ناتج > 0
⎕ "OR(0,0) = " ⊕ نص(م ؟ 1 : 0)
س ≔ 1
ص ≔ 1
ناتج ≔ و · س + ز · ص + انحياز
م ≔ ناتج > 0
⎕ "OR(1,1) = " ⊕ نص(م ؟ 1 : 0)
"""

ر = حلل_رموز(برنامج_or)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('nn2.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'nn2.asm', '-o', 'nn2.o'], check=True)
subprocess.run(['ld', 'nn2.o', '-o', 'nn2'], check=True)
result = subprocess.run(['./nn2'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "OR(1,0) = 1" in out and "OR(0,0) = 0" in out and "OR(1,1) = 1" in out:
    print("  ✅ بوابة OR تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 3: بوابة NOT
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 3: بوابة NOT (﴿يبدل الله سيئاتهم حسنات﴾)")
برنامج_not = """و ≔ 0 - 2
انحياز ≔ 1
س ≔ 0
ناتج ≔ و · س + انحياز
م ≔ ناتج > 0
⎕ "NOT(0) = " ⊕ نص(م ؟ 1 : 0)
س ≔ 1
ناتج ≔ و · س + انحياز
م ≔ ناتج > 0
⎕ "NOT(1) = " ⊕ نص(م ؟ 1 : 0)
"""

ر = حلل_رموز(برنامج_not)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('nn3.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'nn3.asm', '-o', 'nn3.o'], check=True)
subprocess.run(['ld', 'nn3.o', '-o', 'nn3'], check=True)
result = subprocess.run(['./nn3'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "NOT(0) = 1" in out and "NOT(1) = 0" in out:
    print("  ✅ بوابة NOT تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 4: شبكة XOR (3 عرى)
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 4: شبكة XOR (﴿ألم نجعل له عينين ولساناً وشفتين﴾)")
برنامج_xor = """س ≔ 1
ص ≔ 0
ناتج_or ≔ س + ص
م_or ≔ ناتج_or > 0
ناتج_nand ≔ 0 - س - ص + 2
م_nand ≔ ناتج_nand > 0
ناتج_and ≔ م_or · 1 + م_nand · 1 - 1
م_xor ≔ ناتج_and > 0
⎕ "XOR(1,0) = " ⊕ نص(م_xor ؟ 1 : 0)
س ≔ 1
ص ≔ 1
ناتج_or ≔ س + ص
م_or ≔ ناتج_or > 0
ناتج_nand ≔ 0 - س - ص + 2
م_nand ≔ ناتج_nand > 0
ناتج_and ≔ م_or · 1 + م_nand · 1 - 1
م_xor ≔ ناتج_and > 0
⎕ "XOR(1,1) = " ⊕ نص(م_xor ؟ 1 : 0)
س ≔ 0
ص ≔ 0
ناتج_or ≔ س + ص
م_or ≔ ناتج_or > 0
ناتج_nand ≔ 0 - س - ص + 2
م_nand ≔ ناتج_nand > 0
ناتج_and ≔ م_or · 1 + م_nand · 1 - 1
م_xor ≔ ناتج_and > 0
⎕ "XOR(0,0) = " ⊕ نص(م_xor ؟ 1 : 0)
"""

ر = حلل_رموز(برنامج_xor)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('nn4.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'nn4.asm', '-o', 'nn4.o'], check=True)
subprocess.run(['ld', 'nn4.o', '-o', 'nn4'], check=True)
result = subprocess.run(['./nn4'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "XOR(1,0) = 1" in out and "XOR(1,1) = 0" in out and "XOR(0,0) = 0" in out:
    print("  ✅ شبكة XOR تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 5: تدريب بسيط (تحديث الأوزان)
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 5: تدريب بسيط (﴿فاعتبروا يا أولي الأبصار﴾)")
برنامج_تدريب = """و ≔ 0
ز ≔ 0
انحياز ≔ 0
معدل ≔ 1
هدف ≔ 1
س ≔ 1
ص ≔ 1
ناتج ≔ و · س + ز · ص + انحياز
م ≔ ناتج > 0
تنبؤ ≔ م ؟ 1 : 0
خطأ ≔ هدف - تنبؤ
و ≔ و + خطأ · س · معدل
ز ≔ ز + خطأ · ص · معدل
انحياز ≔ انحياز + خطأ · معدل
⎕ "قبل التدريب: و=0, ز=0, ب=0"
⎕ "الهدف: 1, التنبؤ: " ⊕ نص(تنبؤ) ⊕ ", الخطأ: " ⊕ نص(خطأ)
⎕ "بعد التدريب: و=" ⊕ نص(و) ⊕ ", ز=" ⊕ نص(ز) ⊕ ", ب=" ⊕ نص(انحياز)
"""

ر = حلل_رموز(برنامج_تدريب)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('nn5.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'nn5.asm', '-o', 'nn5.o'], check=True)
subprocess.run(['ld', 'nn5.o', '-o', 'nn5'], check=True)
result = subprocess.run(['./nn5'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "بعد التدريب: و=1, ز=1, ب=1" in out:
    print("  ✅ التدريب البسيط يعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 6: حفظ الشبكة في ملف
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 6: حفظ الشبكة (﴿في إمام مبين﴾)")
برنامج_حفظ = """ملف ≔ فتح("neural_net.txt")
اكتب_ملف(ملف، "AND: w1=1 w2=1 b=-1")
اكتب_ملف(ملف، " OR: w1=1 w2=1 b=0")
اكتب_ملف(ملف، " NOT: w1=-2 b=1")
اكتب_ملف(ملف، " XOR: 3 perceptrons")
اختم(ملف)
ملف ≔ فتح("neural_net.txt")
محتوى ≔ اقرأ_ملف(ملف، 4096)
اختم(ملف)
⎕ محتوى
"""

ر = حلل_رموز(برنامج_حفظ)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('nn6.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'nn6.asm', '-o', 'nn6.o'], check=True)
subprocess.run(['ld', 'nn6.o', '-o', 'nn6'], check=True)
result = subprocess.run(['./nn6'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "AND: w1=1 w2=1 b=-1" in out and "XOR: 3 perceptrons" in out:
    print("  ✅ حفظ الشبكة يعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ═══════════════════════════════════════════════════════════
# الملخص
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("📖 الدستور القرآني المطبق:")
print("   ﴿فقد استمسك بالعروة الوثقى﴾ — الخلية العصبية")
print("   ﴿واعتصموا بحبل الله جميعاً﴾ — بوابة AND")
print("   ﴿فأينما تولوا فثم وجه الله﴾ — بوابة OR")
print("   ﴿يبدل الله سيئاتهم حسنات﴾ — بوابة NOT")
print("   ﴿ألم نجعل له عينين ولساناً وشفتين﴾ — شبكة XOR")
print("   ﴿فاعتبروا يا أولي الأبصار﴾ — التدريب")
print("   ﴿في إمام مبين﴾ — حفظ الشبكة")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 35 نجحت!")
    print(f"   لغتنا العربية تدعم شبكات عصبية رمزية:")
    print(f"   - بوابة AND (و=1, ز=1, ب=-1)")
    print(f"   - بوابة OR (و=1, ز=1, ب=0)")
    print(f"   - بوابة NOT (و=-2, ب=1)")
    print(f"   - شبكة XOR (3 عرى)")
    print(f"   - تدريب بسيط (تحديث الأوزان)")
    print(f"   - حفظ الشبكة في ملف")
    print(f"\n   الخطوة التالية: المرحلة 36 — التعلم الرمزي (اعتبار)")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)