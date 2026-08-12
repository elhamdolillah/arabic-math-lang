#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 29: SQL كامل (اسأل)
الدستور: ﴿فاسأل به خبيراً﴾
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 29: SQL كامل (اسأل)")
print("الدستور: ﴿فاسأل به خبيراً﴾")
print("=" * 70)

failed = 0

# ─────────────────────────────────────────────────────────
# استعلام 1: SELECT COUNT(*) WHERE درجة > 89
# ─────────────────────────────────────────────────────────
print("\n🧪 استعلام 1: SELECT COUNT(*) WHERE درجة > 89")
برنامج_1 = """درجات ≔ ⟨90, 85, 95, 88, 92⟩
نتيجة ≔ 0
∀ س ∈ درجات : ﴿ م ≔ س > 89 ⋄ نتيجة ≔ م ؟ نتيجة + 1 : نتيجة ﴾
⎕ "COUNT(*) WHERE درجة > 89: " ⊕ نص(نتيجة)
"""

ر = حلل_رموز(برنامج_1)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('sql1.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'sql1.asm', '-o', 'sql1.o'], check=True)
subprocess.run(['ld', 'sql1.o', '-o', 'sql1'], check=True)
result = subprocess.run(['./sql1'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "COUNT(*) WHERE درجة > 89: 3" in out:
    print("  ✅ SELECT COUNT WHERE تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# استعلام 2: SELECT MAX(درجة)
# ─────────────────────────────────────────────────────────
print("\n🧪 استعلام 2: SELECT MAX(درجة)")
برنامج_2 = """درجات ≔ ⟨90, 85, 95, 88, 92⟩
أقصى ≔ 0
∀ س ∈ درجات : ﴿ م ≔ س > أقصى ⋄ أقصى ≔ م ؟ س : أقصى ﴾
⎕ "MAX(درجة): " ⊕ نص(أقصى)
"""

ر = حلل_رموز(برنامج_2)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('sql2.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'sql2.asm', '-o', 'sql2.o'], check=True)
subprocess.run(['ld', 'sql2.o', '-o', 'sql2'], check=True)
result = subprocess.run(['./sql2'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "MAX(درجة): 95" in out:
    print("  ✅ SELECT MAX تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# استعلام 3: SELECT MIN(درجة)
# ─────────────────────────────────────────────────────────
print("\n🧪 استعلام 3: SELECT MIN(درجة)")
برنامج_3 = """درجات ≔ ⟨90, 85, 95, 88, 92⟩
أدنى ≔ 999
∀ س ∈ درجات : ﴿ م ≔ س < أدنى ⋄ أدنى ≔ م ؟ س : أدنى ﴾
⎕ "MIN(درجة): " ⊕ نص(أدنى)
"""

ر = حلل_رموز(برنامج_3)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('sql3.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'sql3.asm', '-o', 'sql3.o'], check=True)
subprocess.run(['ld', 'sql3.o', '-o', 'sql3'], check=True)
result = subprocess.run(['./sql3'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "MIN(درجة): 85" in out:
    print("  ✅ SELECT MIN تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# استعلام 4: SELECT AVG(عمر)
# ─────────────────────────────────────────────────────────
print("\n🧪 استعلام 4: SELECT AVG(عمر)")
برنامج_4 = """أعمار ≔ ⟨30, 25, 35, 28, 32⟩
مجموع ≔ مجموع_قائمة(أعمار)
عدد ≔ أحص(أعمار)
متوسط ≔ مجموع ÷ عدد
⎕ "AVG(عمر): " ⊕ نص(متوسط)
"""

ر = حلل_رموز(برنامج_4)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('sql4.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'sql4.asm', '-o', 'sql4.o'], check=True)
subprocess.run(['ld', 'sql4.o', '-o', 'sql4'], check=True)
result = subprocess.run(['./sql4'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "AVG(عمر): 30" in out:
    print("  ✅ SELECT AVG تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# استعلام 5: SELECT SUM(درجة) GROUP BY (درجة > 89)
# ─────────────────────────────────────────────────────────
print("\n🧪 استعلام 5: SELECT SUM GROUP BY")
برنامج_5 = """درجات ≔ ⟨90, 85, 95, 88, 92⟩
مجموع_كبار ≔ 0
مجموع_صغار ≔ 0
∀ س ∈ درجات : ﴿
    م ≔ س > 89 ⋄
    مجموع_كبار ≔ م ؟ مجموع_كبار + س : مجموع_كبار ⋄
    مجموع_صغار ≔ م ؟ مجموع_صغار : مجموع_صغار + س
﴾
⎕ "SUM(كبار > 89): " ⊕ نص(مجموع_كبار)
⎕ "SUM(صغار ≤ 89): " ⊕ نص(مجموع_صغار)
"""

ر = حلل_رموز(برنامج_5)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('sql5.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'sql5.asm', '-o', 'sql5.o'], check=True)
subprocess.run(['ld', 'sql5.o', '-o', 'sql5'], check=True)
result = subprocess.run(['./sql5'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "SUM(كبار > 89): 277" in out and "SUM(صغار ≤ 89): 173" in out:
    print("  ✅ SELECT SUM GROUP BY تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# استعلام 6: تقرير SQL كامل محفوظ في ملف
# ─────────────────────────────────────────────────────────
print("\n🧪 استعلام 6: تقرير SQL محفوظ (﴿وكل صغير وكبير مستطر﴾)")
برنامج_6 = """درجات ≔ ⟨90, 85, 95, 88, 92⟩
مجموع ≔ مجموع_قائمة(درجات)
عدد ≔ أحص(درجات)
متوسط ≔ مجموع ÷ عدد
أقصى ≔ 0
∀ س ∈ درجات : ﴿ م ≔ س > أقصى ⋄ أقصى ≔ م ؟ س : أقصى ﴾
ملف ≔ فتح("report.txt")
اكتب_ملف(ملف، "SQL Report")
اكتب_ملف(ملف، " COUNT: ")
اكتب_ملف(ملف، نص(عدد))
اكتب_ملف(ملف، " SUM: ")
اكتب_ملف(ملف، نص(مجموع))
اكتب_ملف(ملف، " AVG: ")
اكتب_ملف(ملف، نص(متوسط))
اكتب_ملف(ملف، " MAX: ")
اكتب_ملف(ملف، نص(أقصى))
اختم(ملف)
ملف ≔ فتح("report.txt")
محتوى ≔ اقرأ_ملف(ملف، 4096)
اختم(ملف)
⎕ محتوى
"""

ر = حلل_رموز(برنامج_6)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('sql6.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'sql6.asm', '-o', 'sql6.o'], check=True)
subprocess.run(['ld', 'sql6.o', '-o', 'sql6'], check=True)
result = subprocess.run(['./sql6'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "COUNT: 5" in out and "SUM: 450" in out and "AVG: 90" in out and "MAX: 95" in out:
    print("  ✅ تقرير SQL محفوظ يعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ═══════════════════════════════════════════════════════════
# الملخص
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("📖 الدستور القرآني المطبق:")
print("   ﴿فاسأل به خبيراً﴾ — الاستعلام")
print("   ﴿أحاط بما لديهم﴾ — الإحصاء الشامل")
print("   ﴿وكل صغير وكبير مستطر﴾ — التقرير المحفوظ")
print("   ﴿وكنتم أزواجاً ثلاثة﴾ — GROUP BY")
print("   ﴿وكذلك جعلناكم أمة وسطاً﴾ — AVG")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 29 نجحت!")
    print(f"   لغتنا العربية تدعم SQL كامل:")
    print(f"   - SELECT COUNT WHERE")
    print(f"   - SELECT MAX / MIN")
    print(f"   - SELECT AVG")
    print(f"   - SELECT SUM GROUP BY")
    print(f"   - تقرير SQL محفوظ في ملف")
    print(f"\n   الخطوة التالية: المرحلة 30 — AI الرمزي (علم آدم)")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)