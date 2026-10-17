# -*- coding: utf-8 -*-
# المسار: phase48_macros.py
"""
نظام الماكروز للغة العربية الرياضية
Hygienic AST-level expansion

البنية:
  _macro_registry = {
      "اسم_الماكرو": {
          "أنماط": [
              {"معاملات": ["س"، "ص"], "جسم": AST}
          ]
      }
  }

Hygiene: المتغيرات المولدة داخل الماكرو تحصل على بادئة فريدة
  __macro_{call_id}_{varname}

حد التوسع: 64 توسعًا متداخلًا (يمنع اللانهائية)
"""

# ═══════════════════════════════════════════════════════════
# Registry
# ═══════════════════════════════════════════════════════════
_macro_registry = {}
_macro_call_counter = [0]  # counter للتوسعات (hygiene IDs)

_MAX_EXPANSION_DEPTH = 64


def د_عدد(عقدة):
    """يفك ('عدد', ن) إلى ن، وإلا None"""
    if isinstance(عقدة, tuple) and len(عقدة) == 2 and عقدة[0] == "عدد":
        return عقدة[1] if isinstance(عقدة[1], (int, float)) else None
    if isinstance(عقدة, (int, float)):
        return عقدة
    return None

def بسّط_رقمي(عقدة):
    """طي ثوابت بسيطة: (ع op ع) حين تكون قيمة عددية، و(ع - 1) متداخل."""
    if not isinstance(عقدة, tuple):
        return عقدة
    نوع = عقدة[0]
    if نوع == "ثنائية":
        op, ي, ز = عقدة[1], عقدة[2], عقدة[3]
        ي, ز = بسّط_رقمي(ي), بسّط_رقمي(ز)
        # فك ('عدد', ن) إلى قيمة مجردة
        د = د_عدد(ي)
        و = د_عدد(ز)
        # (ع - 1) حيث ع عدد → عدد مبسّط (يتقلص عمق الطرح المتداخل)
        if op == "-" and isinstance(ي, tuple) and len(ي) == 3 and ي[0] == "ثنائية" and ي[1] == "-" and د_عدد(ي[2]) is not None and و is not None:
            return ("عدد", د_عدد(ي[2]) - د_عدد(ي[3]) - و)
        if د is not None and و is not None:
            if op == "+": return ("عدد", د + و)
            if op == "-": return ("عدد", د - و)
            if op == "·": return ("عدد", د * و)
            if op == "÷" and و != 0: return ("عدد", int(د / و))
        return ("ثنائية", op, ي, ز)
        if isinstance(ي, (int, float)) and isinstance(ز, (int, float)):
            if op == "+": return ("عدد", ي + ز)
            if op == "-": return ("عدد", ي - ز)
            if op == "·": return ("عدد", ي * ز)
            if op == "÷" and ز != 0: return ("عدد", int(ي / ز))
        return ("ثنائية", op, ي, ز)
    if نوع == "عدد":
        return عقدة
    if نوع == "متغير":
        return عقدة
    # للباقي: لا نغيّر
    return عقدة


def يحتوي_تعبير(عقدة, اسم_ماكرو):
    """هل يحتوي التعبير استدعاءً للماكرو المحدد؟ (لإيقاف التوسع الذاتي)"""
    if not isinstance(عقدة, tuple):
        return False
    if عقدة[0] == "استدعاء" and عقدة[1] == اسم_ماكرو:
        return True
    return any(يحتوي_تعبير(x, اسم_ماكرو) for x in عقدة[1:])
def سجل_ماكرو(اسم, أنماط):
    """تسجيل ماكرو جديد"""
    _macro_registry[اسم] = {"أنماط": أنماط}

def هل_ماكرو(اسم):
    """التحقق مما إذا كان اسمًا لماكرو"""
    if not isinstance(اسم, str):
        return False
    return اسم in _macro_registry

def جلب_ماكرو(اسم):
    """جلب تعريف ماكرو"""
    return _macro_registry.get(اسم)

# ═══════════════════════════════════════════════════════════
# Hygiene: تسمية المتغيرات المولدة
# ═══════════════════════════════════════════════════════════
def اسم_نظيف(اسم, call_id):
    """توليد اسم نظيف للمتغير داخل الماكرو"""
    if اسم.startswith("__macro_"):
        return اسم  # بالفعل مولّد
    return f"__macro_{call_id}_{اسم}"

def وسّع_المتغيرات(عقدة, call_id, معاملات, match_bindings=None):
    if match_bindings is None:
        match_bindings = {}
    """
    توسيع المتغيرات داخل جسم الماكرو:
    - المتغيرات التي هي معاملات → تستبدل بقيمها
    - المتغيرات المحلية → تُسمى باسم نظيف
    """
    if not isinstance(عقدة, tuple):
        return عقدة
    
    نوع = عقدة[0]
    
    if نوع == "متغير":
        اسم = عقدة[1]
        if اسم in معاملات:
            return معاملات[اسم]  # استبدل بالقيمة
        if اسم in match_bindings:
            return match_bindings[اسم]  # متغير نمط مرتبط بقيمة أثناء التوسع
        # متغير محلي — اجعله نظيفًا
        return ("متغير", اسم_نظيف(اسم, call_id))
    
    if نوع == "أسند":
        return ("أسند", اسم_نظيف(عقدة[1], call_id), وسّع_المتغيرات(عقدة[2], call_id, معاملات))
    
    if نوع == "اطبع":
        return ("اطبع", وسّع_المتغيرات(عقدة[1], call_id, معاملات))
    
    if نوع in ["ثنائية", "مقارنة"]:
        return (نوع, عقدة[1],
                وسّع_المتغيرات(عقدة[2], call_id, معاملات, match_bindings),
                وسّع_المتغيرات(عقدة[3], call_id, معاملات, match_bindings))
    
    if نوع == "شرطي":
        return ("شرطي",
                وسّع_المتغيرات(عقدة[1], call_id, معاملات, match_bindings),
                وسّع_المتغيرات(عقدة[2], call_id, معاملات, match_bindings),
                وسّع_المتغيرات(عقدة[3], call_id, معاملات, match_bindings))
    
    if نوع == "استدعاء":
        args_جديدة = [وسّع_المتغيرات(a, call_id, معاملات, match_bindings) for a in عقدة[2]]
        return ("استدعاء", عقدة[1], args_جديدة)
    
    if نوع == "دالة":
        # معاملات الدالة الداخلية تبقى كما هي (shadowing)
        return ("دالة", عقدة[1], وسّع_المتغيرات(عقدة[2], call_id, معاملات, match_bindings))
    
    if نوع == "طابق":
        قيمة = وسّع_المتغيرات(عقدة[1], call_id, معاملات)
        فروع = []
        for نمط, تعبير in عقدة[2]:
            ربط = dict(match_bindings)
            if isinstance(نمط, tuple) and len(نمط) == 2 and نمط[0] == "نمط_متغير":
                ربط[نمط[1]] = قيمة  # متغير النمط مرتبط بقيمة المطابقة
            فروع.append((نمط, وسّع_المتغيرات(تعبير, call_id, معاملات, ربط)))
        return ("طابق", قيمة, فروع)
    
    if نوع == "كتلة":
        بيانات = [وسّع_المتغيرات(s, call_id, معاملات, match_bindings) for s in عقدة[1]]
        tail = وسّع_المتغيرات(عقدة[2], call_id, معاملات, match_bindings) if len(عقدة) > 2 and عقدة[2] else None
        return ("كتلة", بيانات, tail)
    
    return عقدة

# ═══════════════════════════════════════════════════════════
# Expansion Engine
# ═══════════════════════════════════════════════════════════
def وسّع_ماكرو(اسم, args, depth=0):
    """
    توسيع استدعاء ماكرو إلى AST عادي
    """
    if depth > _MAX_EXPANSION_DEPTH:
        raise Exception(f"ماكرو '{اسم}': تجاوز حد التوسع ({_MAX_EXPANSION_DEPTH})")

    
    ماكرو = جلب_ماكرو(اسم)
    if ماكرو is None:
        raise Exception(f"ماكرو غير معرف: {اسم}")
    
    # اختصار القيمة الثابتة: جسم طابق + مطابقة حرفية لفرع نمط_حرفي
    for نمط in ماكرو["أنماط"]:
        if len(نمط["معاملات"]) == len(args):
            جسم = نمط["جسم"]
            if isinstance(جسم, tuple) and len(جسم) == 3 and جسم[0] == "طابق":
                قيمة_مطابقة = args[0]
                د = د_عدد(قيمة_مطابقة)
                if د is not None:
                    for نمط_فرع, تعبير_فرع in جسم[2]:
                        if isinstance(نمط_فرع, tuple) and len(نمط_فرع) == 2 and نمط_فرع[0] == "نمط_حرفي" and نمط_فرع[1] == د:
                            if not يحتوي_تعبير(تعبير_فرع, اسم):
                                _macro_call_counter[0] += 1
                                return وسّع_المتغيرات(تعبير_فرع, _macro_call_counter[0], {نمط["معاملات"][0]: ("عدد", د)})
    # جرب كل نمط حتى ينجح أحدها
    for نمط in ماكرو["أنماط"]:
        if len(نمط["معاملات"]) == len(args):
            # طابق: ابنِ قاموس المعاملات
            معاملات = {}
            for i, اسم_معامل in enumerate(نمط["معاملات"]):
                معاملات[اسم_معامل] = بسّط_رقمي(args[i])
            
            # احصل على call_id فريد
            _macro_call_counter[0] += 1
            call_id = _macro_call_counter[0]
            
            # وسّع جسم الماكرو
            جسم_موسع = وسّع_المتغيرات(نمط["جسم"], call_id, معاملات)
            
            # توسيع عودي للماكروزات المتداخلة
            return وسّع_تعبير_بالكامل(جسم_موسع, depth + 1)
    
    raise Exception(f"ماكرو '{اسم}': لا يوجد نمط يطابق {len(args)} معاملات")

def وسّع_تعبير_بالكامل(عقدة, depth=0, match_bindings=None):
    if match_bindings is None:
        match_bindings = {}
    # المرحلة 48: توسيع كل الماكروزات داخل تعبير (recursively)
    if not isinstance(عقدة, tuple):
        return عقدة
    
    نوع = عقدة[0]
    
    # استدعاء قد يكون ماكرو
    if نوع == "استدعاء":
        اسم = عقدة[1]
        args = [وسّع_تعبير_بالكامل(a, depth, match_bindings) for a in عقدة[2]]
        if isinstance(اسم, (tuple, list)):
            اسم = وسّع_تعبير_بالكامل(اسم, depth, match_bindings)
        if هل_ماكرو(اسم):
            return وسّع_ماكرو(اسم, args, depth)
        return ("استدعاء", اسم, args)
    if نوع == "أسند":
        return ("أسند", عقدة[1], وسّع_تعبير_بالكامل(عقدة[2], depth, match_bindings))
    if نوع == "اطبع":
        return ("اطبع", وسّع_تعبير_بالكامل(عقدة[1], depth, match_bindings))
    
    # باقٍ الأنواع — توسّع عادي
    if نوع in ["ثنائية", "مقارنة"]:
        ع = (نوع, عقدة[1],
                وسّع_تعبير_بالكامل(عقدة[2], depth, match_bindings),
                وسّع_تعبير_بالكامل(عقدة[3], depth, match_bindings))
        return بسّط_رقمي(ع) if نوع == "ثنائية" else ع
    
    if نوع == "شرطي":
        return ("شرطي",
                وسّع_تعبير_بالكامل(عقدة[1], depth, match_bindings),
                وسّع_تعبير_بالكامل(عقدة[2], depth, match_bindings),
                وسّع_تعبير_بالكامل(عقدة[3], depth, match_bindings))
    
    if نوع == "دالة":
        return ("دالة", عقدة[1], وسّع_تعبير_بالكامل(عقدة[2], depth, match_bindings))
    
    if نوع == "طابق":
        قيمة = وسّع_تعبير_بالكامل(عقدة[1], depth, match_bindings)
        فروع = []
        for نمط, تعبير in عقدة[2]:
            ربط = dict(match_bindings)
            if isinstance(نمط, tuple) and len(نمط) == 2 and نمط[0] == "نمط_متغير":
                ربط[نمط[1]] = قيمة
            فروع.append((نمط, وسّع_تعبير_بالكامل(تعبير, depth, ربط)))
        return ("طابق", قيمة, فروع)
    
    if نوع == "كتلة":
        بيانات = [وسّع_تعبير_بالكامل(s, depth, match_bindings) for s in عقدة[1]]
        tail = وسّع_تعبير_بالكامل(عقدة[2], depth, match_bindings) if len(عقدة) > 2 and عقدة[2] else None
        return ("كتلة", بيانات, tail)

    if نوع == "قائمة":
        return ("قائمة", [وسّع_تعبير_بالكامل(e, depth, match_bindings) for e in عقدة[1]])
    
    if نوع == "سالب":
        return ("سالب", وسّع_تعبير_بالكامل(عقدة[1], depth, match_bindings))
    
    return عقدة

def وسّع_بيان_بالكامل(بيان, depth=0):
    """توسيع الماكروزات داخل بيان"""
    if not isinstance(بيان, tuple):
        return بيان
    
    نوع = بيان[0]
    
    if نوع == "تعريف_ماكرو":
        # لا توسّع التعريف — فقط سجله
        سجل_ماكرو(بيان[1], بيان[2])
        return None  # احذف البيان من البرنامج
    
    if نوع == "أسند":
        return ("أسند", بيان[1], وسّع_تعبير_بالكامل(بيان[2], depth))
    
    if نوع == "عرف":
        return ("عرف", بيان[1], وسّع_تعبير_بالكامل(بيان[2], depth))
    
    if نوع == "اطبع":
        return ("اطبع", وسّع_تعبير_بالكامل(بيان[1], depth))
    
    if نوع == "كتلة":
        بيانات = []
        for s in بيان[1]:
            موسع = وسّع_بيان_بالكامل(s, depth)
            if موسع is not None:
                بيانات.append(موسع)
        tail = وسّع_تعبير_بالكامل(بيان[2], depth) if len(بيان) > 2 and بيان[2] else None
        return ("كتلة", بيانات, tail)
    
    if نوع == "طالما":
        return ("طالما",
                وسّع_تعبير_بالكامل(بيان[1], depth),
                وسّع_بيان_بالكامل(بيان[2], depth))
    
    if نوع == "لكل":
        return ("لكل", بيان[1],
                وسّع_تعبير_بالكامل(بيان[2], depth),
                وسّع_بيان_بالكامل(بيان[3], depth))
    if نوع == "استدعاء_جملة":
        return ("استدعاء_جملة", وسّع_تعبير_بالكامل(بيان[1], depth))
    if نوع == "طابق":
        قيمة = وسّع_تعبير_بالكامل(بيان[1], depth)
        فروع = []
        for نمط, تعبير in بيان[2]:
            ربط = {}
            if isinstance(نمط, tuple) and len(نمط) == 2 and نمط[0] == "نمط_متغير":
                ربط[نمط[1]] = قيمة
            فروع.append((نمط, وسّع_تعبير_بالكامل(تعبير, depth, ربط)))
        return ("طابق", قيمة, فروع)
    return بيان

def وسّع_برنامج(برنامج):
    """توسيع كل الماكروزات في برنامج كامل"""
    نتيجة = []
    for بيان in برنامج:
        موسع = وسّع_بيان_بالكامل(بيان, 0)
        if موسع is not None:
            نتيجة.append(موسع)
    return نتيجة

# ═══════════════════════════════════════════════════════════
# إحصائيات
# ═══════════════════════════════════════════════════════════
def عدد_الماكروز():
    return len(_macro_registry)

def إعادة_عداد_التوسعات():
    _macro_call_counter[0] = 0

def حد_التوسع():
    return _MAX_EXPANSION_DEPTH
