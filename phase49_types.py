# -*- coding: utf-8 -*-
# المرحلة 49: Dependent Types — Static Assertions + Bounded Types
_static_assertions = []
_bounded_types = {}
_type_annotations = {}

def أضف_تأكيد(شرط, رسالة):
    _static_assertions.append({"شرط": شرط, "رسالة": رسالة})

def فحص_التأكيدات():
    أخطاء = []
    for ت in _static_assertions:
        try:
            if not eval(ت["شرط"], {"__builtins__": {}}):
                أخطاء.append(ت["رسالة"])
        except Exception:
            أخطاء.append(f"تعذر تقييم: {ت['شرط']}")
    if أخطاء:
        raise Exception("فشل التأكيد الثابت:\n" + "\n".join(أخطاء))
    return True

def عرّف_نوع_محدود(اسم, أدنى, أعلى):
    _bounded_types[اسم] = (أدنى, أعلى)

def تحقق_من_المدى(اسم_النوع, قيمة):
    if اسم_النوع not in _bounded_types:
        raise Exception(f"نوع غير معرف: {اسم_النوع}")
    أدنى, أعلى = _bounded_types[اسم_النوع]
    if not (أدنى <= قيمة <= أعلى):
        raise Exception(f"القيمة {قيمة} خارج مدى {اسم_النوع} [{أدنى}، {أعلى}]")
    return True

def استنتج_نوع_تابع(expr):
    if not isinstance(expr, tuple): return "مجهول"
    ن = expr[0]
    if ن == "عدد": return "عدد_طبيعي" if expr[1] >= 0 else "عدد_صحيح"
    if ن == "قائمة": return f"قائمة({len(expr[1])})"
    if ن == "استدعاء":
        اسم = expr[1]
        if اسم == "نجاح": return "Result(نجاح)"
        if اسم == "فشل": return "Result(فشل)"
        if اسم == "بعض": return "Option(بعض)"
        if اسم == "لاشيء": return "Option(لاشيء)"
    return "مجهول"

def إعادة_تعيين():
    global _static_assertions, _bounded_types, _type_annotations
    _static_assertions = []; _bounded_types = {}; _type_annotations = {}

def عدد_التأكيدات(): return len(_static_assertions)
def عدد_الأنواع_المحدودة(): return len(_bounded_types)
