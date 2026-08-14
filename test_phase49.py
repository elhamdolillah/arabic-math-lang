#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 49: Dependent Types — Static Assertions + Bounded Types
===============================================================
يضيف المحرك فحص التأكيدات الثابتة قبل التجميع، ويوفر وحدة
phase49_types: تأكيد ثابت، أنواع محدودة المدى، واستنتاج نوع تابع AST.
"""
import sys
sys.path.insert(0, '.')

import phase49_types as pt
from math_complete import حلل_رموز, حلل_برنامج, compile_program
import subprocess, os

ناجح = 0
إجمالي = 0

def check(اسم, شرط, متوقع=""):
    global ناجح, إجمالي
    إجمالي += 1
    try:
        ok = شرط()
        if ok == متوقع or متوقع == "" or (isinstance(ok, str) and متوقع in ok):
            print(f"  ✅ {اسم}")
            ناجح += 1
        else:
            print(f"  ❌ {اسم}: expected {متوقع}, got {ok!r}")
    except Exception as e:
        print(f"  ❌ {اسم}: {e}")

print("═"*55)
print("  اختبارات المرحلة 49: Dependent Types")
print("═"*55)

# 1. تأكيد ثابت ناجح
pt.إعادة_تعيين()
pt.أضف_تأكيد("1 == 1", "ok")
check("t49_assert_pass", lambda: pt.فحص_التأكيدات())

# 2. تأكيد ثابت فاشل يرفع استثناء
pt.أضف_تأكيد("1 == 2", "bad")
def fail_check():
    try:
        pt.فحص_التأكيدات()
        return "no error"
    except Exception as e:
        return str(e)
check("t49_assert_fail", fail_check, "bad")

# 3. إعادة تعيين تمسح التأكيدات
pt.إعادة_تعيين()
check("t49_reset", lambda: pt.فحص_التأكيدات())

# 4. نوع محدود المدى — داخل المدى
pt.عرّف_نوع_محدود("بايت", 0, 255)
check("t49_bounded_ok", lambda: pt.تحقق_من_المدى("بايت", 42))

# 5. نوع محدود المدى — خارج المدى
def out_of_range():
    try:
        pt.تحقق_من_المدى("بايت", 300)
        return "no error"
    except Exception as e:
        return str(e)
check("t49_bounded_fail", out_of_range, "خارج مدى")

# 6. نوع غير معرف
def unknown_type():
    try:
        pt.تحقق_من_المدى("غير_موجود", 1)
        return "no error"
    except Exception as e:
        return str(e)
check("t49_unknown_type", unknown_type, "غير معرف")

# 7. استنتاج النوع التابع من AST
check("t49_infer_nat", lambda: pt.استنتج_نوع_تابع(("عدد", 5)), "عدد_طبيعي")
check("t49_infer_int", lambda: pt.استنتج_نوع_تابع(("عدد", -3)), "عدد_صحيح")
check("t49_infer_option", lambda: pt.استنتج_نوع_تابع(("استدعاء", "بعض", [("عدد", 5)])), "Option")

# 8. التأكيدات الثابتة لا تفسد التجميع العادي (توافق عكسي)
src = "⎕ نص(42 + 8)"
def compile_clean():
    pt.إعادة_تعيين()
    ر = حلل_رموز(src)
    ب = حلل_برنامج(ر)
    asm = compile_program(ب)
    with open('_p49t.asm', 'w') as f: f.write(asm)
    subprocess.run(['nasm', '-f', 'elf64', '_p49t.asm', '-o', '_p49t.o'], check=True)
    subprocess.run(['ld', '_p49t.o', '-o', '_p49t'], check=True)
    r = subprocess.run(['./_p49t'], capture_output=True, text=True)
    return r.stdout.strip()
check("t49_compat_compile", compile_clean, "50")

print("═"*55)
print(f"  النتيجة: {ناجح}/{إجمالي} {'✅' if ناجح==إجمالي else '❌'}")
print("═"*55)

for p in ['_p49t', '_p49t.o', '_p49t.asm']:
    if os.path.exists(p):
        os.remove(p)

sys.exit(0 if ناجح == إجمالي else 1)
