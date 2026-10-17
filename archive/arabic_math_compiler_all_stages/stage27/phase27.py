#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 27: عمليات القوائم (اختر، رتب، صنف)
الدستور: ﴿فاختار موسى سبعين رجلاً﴾
"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 27: عمليات القوائم (اختر، رتب، صنف)")
print("الدستور: ﴿فاختار موسى سبعين رجلاً﴾")
print("=" * 70)

failed = 0

# ─────────────────────────────────────────────────────────
# اختبار 1: اختر — تصفية بشرط
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 1: اختر (﴿فاختار موسى سبعين رجلاً﴾)")
برنامج_اختر = """أعداد ≔ ⟨10, 25, 30, 15, 40, 5, 50⟩
كبار ≔ 0
∀ س ∈ أعداد : ﴿ م ≔ س > 20 ⋄ كبار ≔ م ؟ كبار + 1 : كبار ﴾
⎕ "عدد العناصر > 20: " ⊕ نص(كبار)
"""

ر = حلل_رموز(برنامج_اختر)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('list1.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'list1.asm', '-o', 'list1.o'], check=True)
subprocess.run(['ld', 'list1.o', '-o', 'list1'], check=True)
result = subprocess.run(['./list1'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "عدد العناصر > 20: 4" in out:
    print("  ✅ اختر تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 2: رتب — إيجاد أكبر عنصر
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 2: رتب — أكبر عنصر (﴿والسماء رفعها﴾)")
برنامج_أكبر = """أعداد ≔ ⟨10, 25, 30, 15, 40, 5, 50⟩
أكبر ≔ 0
∀ س ∈ أعداد : ﴿ م ≔ س > أكبر ⋄ أكبر ≔ م ؟ س : أكبر ﴾
⎕ "أكبر عنصر: " ⊕ نص(أكبر)
"""

ر = حلل_رموز(برنامج_أكبر)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('list2.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'list2.asm', '-o', 'list2.o'], check=True)
subprocess.run(['ld', 'list2.o', '-o', 'list2'], check=True)
result = subprocess.run(['./list2'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "أكبر عنصر: 50" in out:
    print("  ✅ رتب (أكبر) تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 3: رتب — إيجاد أصغر عنصر
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 3: رتب — أصغر عنصر (﴿أدنى الأرض﴾)")
برنامج_أصغر = """أعداد ≔ ⟨10, 25, 30, 15, 40, 5, 50⟩
أصغر ≔ 999
∀ س ∈ أعداد : ﴿ م ≔ س < أصغر ⋄ أصغر ≔ م ؟ س : أصغر ﴾
⎕ "أصغر عنصر: " ⊕ نص(أصغر)
"""

ر = حلل_رموز(برنامج_أصغر)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('list3.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'list3.asm', '-o', 'list3.o'], check=True)
subprocess.run(['ld', 'list3.o', '-o', 'list3'], check=True)
result = subprocess.run(['./list3'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "أصغر عنصر: 5" in out:
    print("  ✅ رتب (أصغر) تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 4: صنف — تجميع حسب شرط
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 4: صنف (﴿وكنتم أزواجاً ثلاثة﴾)")
برنامج_صنف = """أعداد ≔ ⟨10, 25, 30, 15, 40, 5, 50⟩
كبار ≔ 0
صغار ≔ 0
∀ س ∈ أعداد : ﴿ م ≔ س > 25 ⋄ كبار ≔ م ؟ كبار + 1 : كبار ⋄ صغار ≔ م ؟ صغار : صغار + 1 ﴾
⎕ "كبار (> 25): " ⊕ نص(كبار)
⎕ "صغار (≤ 25): " ⊕ نص(صغار)
"""

ر = حلل_رموز(برنامج_صنف)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('list4.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'list4.asm', '-o', 'list4.o'], check=True)
subprocess.run(['ld', 'list4.o', '-o', 'list4'], check=True)
result = subprocess.run(['./list4'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "كبار (> 25): 3" in out and "صغار (≤ 25): 4" in out:
    print("  ✅ صنف تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 5: أحص + مجموع_قائمة
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 5: أحص + مجموع_قائمة (﴿وأحصاهم عدداً﴾)")
برنامج_إحصاء = """أعداد ≔ ⟨10, 25, 30, 15, 40, 5, 50⟩
⎕ "العدد: " ⊕ نص(أحص(أعداد))
⎕ "المجموع: " ⊕ نص(مجموع_قائمة(أعداد))
"""

ر = حلل_رموز(برنامج_إحصاء)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('list5.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'list5.asm', '-o', 'list5.o'], check=True)
subprocess.run(['ld', 'list5.o', '-o', 'list5'], check=True)
result = subprocess.run(['./list5'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "العدد: 7" in out and "المجموع: 175" in out:
    print("  ✅ أحص + مجموع_قائمة تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 6: عمليات مركبة (اختر + رتب + صنف)
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 6: عمليات مركبة (﴿وكل شيء أحصيناه كتاباً﴾)")
برنامج_مركب = """أعداد ≔ ⟨10, 25, 30, 15, 40, 5, 50⟩
مجموع ≔ مجموع_قائمة(أعداد)
عدد ≔ أحص(أعداد)
متوسط ≔ مجموع ÷ عدد
أكبر ≔ 0
∀ س ∈ أعداد : ﴿ م ≔ س > أكبر ⋄ أكبر ≔ م ؟ س : أكبر ﴾
⎕ "العدد: " ⊕ نص(عدد)
⎕ "المجموع: " ⊕ نص(مجموع)
⎕ "المتوسط: " ⊕ نص(متوسط)
⎕ "الأكبر: " ⊕ نص(أكبر)
"""

ر = حلل_رموز(برنامج_مركب)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('list6.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'list6.asm', '-o', 'list6.o'], check=True)
subprocess.run(['ld', 'list6.o', '-o', 'list6'], check=True)
result = subprocess.run(['./list6'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "العدد: 7" in out and "المجموع: 175" in out and "المتوسط: 25" in out and "الأكبر: 50" in out:
    print("  ✅ العمليات المركبة تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ═══════════════════════════════════════════════════════════
# الملخص
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("📖 الدستور القرآني المطبق:")
print("   ﴿فاختار موسى سبعين رجلاً﴾ — اختر (SELECT)")
print("   ﴿والسماء رفعها﴾ — رتب (ORDER)")
print("   ﴿وكنتم أزواجاً ثلاثة﴾ — صنف (GROUP)")
print("   ﴿وأحصاهم عدداً﴾ — أحص (COUNT)")
print("   ﴿وكل شيء أحصيناه كتاباً﴾ — العمليات المركبة")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 27 نجحت!")
    print(f"   لغتنا العربية تدعم عمليات القوائم:")
    print(f"   - اختر (SELECT): تصفية بشرط")
    print(f"   - رتب (ORDER): أكبر/أصغر عنصر")
    print(f"   - صنف (GROUP): تجميع حسب شرط")
    print(f"   - أحص (COUNT): عدد العناصر")
    print(f"   - مجموع_قائمة (SUM): مجموع العناصر")
    print(f"   - عمليات مركبة: متوسط + أكبر + عدد")
    print(f"\n   الخطوة التالية: المرحلة 28 — الجداول (لوح)")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)