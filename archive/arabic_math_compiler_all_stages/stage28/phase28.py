#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 28: الجداول (لوح)
الدستور: ﴿في لوح محفوظ﴾
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 28: الجداول (لوح)")
print("الدستور: ﴿في لوح محفوظ﴾")
print("=" * 70)

failed = 0

# ─────────────────────────────────────────────────────────
# اختبار 1: إنشاء جدول + عمليات أساسية
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 1: إنشاء جدول (﴿في لوح محفوظ﴾)")
برنامج_جدول = """أسماء ≔ ⟨"أحمد", "فاطمة", "علي", "مريم", "يوسف"⟩
أعمار ≔ ⟨30, 25, 35, 28, 32⟩
درجات ≔ ⟨90, 85, 95, 88, 92⟩
⎕ "عدد الطلاب: " ⊕ نص(أحص(أسماء))
⎕ "مجموع الأعمار: " ⊕ نص(مجموع_قائمة(أعمار))
⎕ "مجموع الدرجات: " ⊕ نص(مجموع_قائمة(درجات))
"""

ر = حلل_رموز(برنامج_جدول)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('table1.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'table1.asm', '-o', 'table1.o'], check=True)
subprocess.run(['ld', 'table1.o', '-o', 'table1'], check=True)
result = subprocess.run(['./table1'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "عدد الطلاب: 5" in out and "مجموع الأعمار: 150" in out and "مجموع الدرجات: 450" in out:
    print("  ✅ إنشاء جدول يعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 2: WHERE — تصفية بشرط
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 2: WHERE (﴿فاختار موسى سبعين رجلاً﴾)")
برنامج_where = """درجات ≔ ⟨90, 85, 95, 88, 92⟩
ممتاز ≔ 0
∀ س ∈ درجات : ﴿ م ≔ س > 89 ⋄ ممتاز ≔ م ؟ ممتاز + 1 : ممتاز ﴾
⎕ "عدد الممتازين (> 89): " ⊕ نص(ممتاز)
"""

ر = حلل_رموز(برنامج_where)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('table2.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'table2.asm', '-o', 'table2.o'], check=True)
subprocess.run(['ld', 'table2.o', '-o', 'table2'], check=True)
result = subprocess.run(['./table2'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "عدد الممتازين (> 89): 3" in out:
    print("  ✅ WHERE تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 3: ORDER BY — أعلى درجة
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 3: ORDER BY (﴿والسماء رفعها﴾)")
برنامج_order = """درجات ≔ ⟨90, 85, 95, 88, 92⟩
أعلى ≔ 0
∀ س ∈ درجات : ﴿ م ≔ س > أعلى ⋄ أعلى ≔ م ؟ س : أعلى ﴾
أدنى ≔ 999
∀ س ∈ درجات : ﴿ م ≔ س < أدنى ⋄ أدنى ≔ م ؟ س : أدنى ﴾
⎕ "أعلى درجة: " ⊕ نص(أعلى)
⎕ "أدنى درجة: " ⊕ نص(أدنى)
"""

ر = حلل_رموز(برنامج_order)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('table3.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'table3.asm', '-o', 'table3.o'], check=True)
subprocess.run(['ld', 'table3.o', '-o', 'table3'], check=True)
result = subprocess.run(['./table3'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "أعلى درجة: 95" in out and "أدنى درجة: 85" in out:
    print("  ✅ ORDER BY تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 4: GROUP BY — تصنيف حسب شرط
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 4: GROUP BY (﴿وكنتم أزواجاً ثلاثة﴾)")
برنامج_group = """درجات ≔ ⟨90, 85, 95, 88, 92⟩
ممتاز ≔ 0
جيد ≔ 0
متوسط ≔ 0
∀ س ∈ درجات : ﴿
    م ≔ س > 89 ⋄ ممتاز ≔ م ؟ ممتاز + 1 : ممتاز ⋄
    م ≔ س > 84 ⋄ جيد ≔ م ؟ جيد + 1 : جيد ⋄
    م ≔ س < 85 ⋄ متوسط ≔ م ؟ متوسط + 1 : متوسط
﴾
⎕ "ممتاز (> 89): " ⊕ نص(ممتاز)
⎕ "جيد (> 84): " ⊕ نص(جيد)
⎕ "متوسط (< 85): " ⊕ نص(متوسط)
"""

ر = حلل_رموز(برنامج_group)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('table4.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'table4.asm', '-o', 'table4.o'], check=True)
subprocess.run(['ld', 'table4.o', '-o', 'table4'], check=True)
result = subprocess.run(['./table4'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "ممتاز (> 89): 3" in out and "جيد (> 84): 5" in out and "متوسط (< 85): 0" in out:
    print("  ✅ GROUP BY تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 5: AVG — المتوسط
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 5: AVG (﴿وكذلك جعلناكم أمة وسطاً﴾)")
برنامج_avg = """درجات ≔ ⟨90, 85, 95, 88, 92⟩
مجموع ≔ مجموع_قائمة(درجات)
عدد ≔ أحص(درجات)
متوسط ≔ مجموع ÷ عدد
⎕ "المتوسط: " ⊕ نص(متوسط)
"""

ر = حلل_رموز(برنامج_avg)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('table5.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'table5.asm', '-o', 'table5.o'], check=True)
subprocess.run(['ld', 'table5.o', '-o', 'table5'], check=True)
result = subprocess.run(['./table5'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "المتوسط: 90" in out:
    print("  ✅ AVG تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 6: حفظ الجدول في ملف (﴿في لوح محفوظ﴾)
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 6: حفظ الجدول في ملف (﴿في لوح محفوظ﴾)")
برنامج_حفظ = """ملف ≔ فتح("students.txt")
اكتب_ملف(ملف، "أحمد,30,90")
اكتب_ملف(ملف، " ")
اكتب_ملف(ملف، "فاطمة,25,85")
اكتب_ملف(ملف، " ")
اكتب_ملف(ملف، "علي,35,95")
اختم(ملف)
ملف ≔ فتح("students.txt")
محتوى ≔ اقرأ_ملف(ملف، 4096)
اختم(ملف)
⎕ محتوى
"""

ر = حلل_رموز(برنامج_حفظ)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('table6.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'table6.asm', '-o', 'table6.o'], check=True)
subprocess.run(['ld', 'table6.o', '-o', 'table6'], check=True)
result = subprocess.run(['./table6'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "أحمد,30,90" in out and "فاطمة,25,85" in out and "علي,35,95" in out:
    print("  ✅ حفظ الجدول في ملف يعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ═══════════════════════════════════════════════════════════
# الملخص
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("📖 الدستور القرآني المطبق:")
print("   ﴿في لوح محفوظ﴾ — الجدول المحفوظ")
print("   ﴿وكل شيء أحصيناه كتاباً﴾ — كل صف مُحصَى")
print("   ﴿فاختار موسى سبعين رجلاً﴾ — WHERE")
print("   ﴿والسماء رفعها﴾ — ORDER BY")
print("   ﴿وكنتم أزواجاً ثلاثة﴾ — GROUP BY")
print("   ﴿وكذلك جعلناكم أمة وسطاً﴾ — AVG")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 28 نجحت!")
    print(f"   لغتنا العربية تدعم الجداول (لوح):")
    print(f"   - إنشاء جدول (قوائم متوازية)")
    print(f"   - WHERE: تصفية بشرط")
    print(f"   - ORDER BY: أعلى/أدنى")
    print(f"   - GROUP BY: تصنيف")
    print(f"   - AVG: المتوسط")
    print(f"   - حفظ في ملف")
    print(f"\n   الخطوة التالية: المرحلة 29 — SQL كامل (اسأل)")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)