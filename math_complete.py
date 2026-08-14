from lexicon_quranic_support import توليد_أسماء_بديلة_آمنة
# -*- coding: utf-8 -*-
"""
اللغة الرياضية العربية - الملف المتكامل النهائي
المُجمّع + الاختبارات + الآلة الحاسبة
جميع الحلول وفق الدستور الرياضي
"""
import sys, subprocess
# ═══════════════════════════════════════════════════════════
# القاموس الموحد — المرحلة 47 (دمج من lexicon/)
# ═══════════════════════════════════════════════════════════
import importlib.util
_lex = importlib.util.spec_from_file_location("lexicon", __import__("os").path.join(__import__("os").path.dirname(__file__) or ".", "lexicon", "lexicon.py"))
_lexm = importlib.util.module_from_spec(_lex)
_lex.loader.exec_module(_lexm)
_lexicon = _lexm.القاموس
def بحث_رمز_في_القاموس(نص):
    """دالة مساعدة: بحث ضبابي في القاموس الموحد"""
    import importlib.util as _iu, os as _os
    _sup = _iu.spec_from_file_location("lexicon_support", _os.path.join(_os.path.dirname(__file__) or ".", "lexicon", "lexicon_support.py"))
    _supm = _iu.module_from_spec(_sup)
    _sup.loader.exec_module(_supm)
    نتيجة = _supm.بحث_رمز(نص)
    return نتيجة['رمز'] if نتيجة else None
# ═══════════════════════════════════════════════════════════

# ═══════════════════════════════════════════════════════════
# Lexer
# ═══════════════════════════════════════════════════════════
أرقام_القيم = {"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9}
رموز_العمليات = {
    "+":"+",    "-":"-",    "·":"·",    "*":"*",    "×":"×",
    "÷":"÷",    "⊕":"⊕",    "⊖":"⊖",    "⊗":"⊗",    "≔":"≔",
    "≡":"≡",    "=":"=",    "≠":"≠",    "<":"<",    ">":">",
    "≤":"≤",    "≥":"≥",    "λ":"λ",    "μ":"μ",    "∀":"∀",
    "∃":"∃",    "∈":"∈",    "⊸":"⊸",    "﴿":"﴿",    "﴾":"﴾",
    "⟨":"⟨",    "⟩":"⟩",    "(":"(",    ")":")",    "[":"[",
    "]":"]",    "⎕":"⎕",    "⊙":"⊙",    "؟":"؟",    "∧":"∧",
    "∨":"∨",    "¬":"¬",    "⇒":"⇒",    "⇔":"⇔",    "،":",",
    ",":",",    ":":":",    ".":".",    "⋄":"⋄",    "|":"|",
    "…":"…",    'نوع':'نوع',    'سمة':'سمة',    'تطبيق':'تطبيق',    'على':'على',
    "↻":"↻",    'بانتظار':'بانتظار',    'بدء':'بدء',    'طول':'طول',    'رأس':'رأس',
    'ذيل':'ذيل',    'ألحق':'ألحق',    'نص':'نص',    'عدد':'عدد',    'مجموع_قائمة':'مجموع_قائمة',
    'جذر':'جذر',    'قوة':'قوة',    'مطلق':'مطلق',    'توازي':'توازي',    'قناة':'قناة',
    'أرسل':'أرسل',    'استقبل':'استقبل',    'فتح':'فتح',    'اكتب_ملف':'اكتب_ملف',    'اقرأ_ملف':'اقرأ_ملف',
    'اختم':'اختم'
}
رموز_يونانية = {"λ":"λ","μ":"μ"}
أسماء_بديلة = {
    "دالة":"λ",    "λ":"λ",    "اطبع":"⎕",    "⎕":"⎕",
    "طالما":"μ",    "μ":"μ",    "لكل":"∀",    "∀":"∀",
    "في":"∈",    "∈":"∈",    "انقل":"⊸",    "⊸":"⊸",
    "اقرأ":"⊙",    "⊙":"⊙",    "طابق":"طابق",    "حيث":"حيث",    "ماكرو":"ماكرو",
    "شامل":"_",    "_":"_",    "نوع":"نوع",    "سمة":"سمة",
    "تطبيق":"تطبيق",    "على":"على",    "بانتظار":"بانتظار",    "بدء":"بدء"
}

# دمج المصطلحات القرآنية الآمنة (دفعة Qwen 2 — لا يتجاوز الأصل ولا أسماء البنائات)
for كلمة, رمز in توليد_أسماء_بديلة_آمنة().items():
    if كلمة not in أسماء_بديلة:
        أسماء_بديلة[كلمة] = رمز
عمليات_الجمع = {"+":"+","-":"-","⊕":"⊕"}
عمليات_الضرب = {"·":"·","÷":"÷"}
عمليات_المقارنة = {"<":"<",">":">","=":"=","≠":"≠","≤":"≤","≥":"≥"}

def pos_msg(رموز, i):
    """إرجاع رسالة موقع السطر والعمود لموضع في قائمة الرموز"""
    if i < len(رموز) and len(رموز[i]) >= 4:
        return f"السطر {رموز[i][2]} العمود {رموز[i][3]}"
    return "نهاية الملف"

def حلل_رموز(نص):
    رموز=[]; i=0; n=len(نص); سطر=1; بداية_السطر=0
    while i<n:
        ح=نص[i]
        if ح=='\n':
            سطر+=1; بداية_السطر=i+1; i+=1; continue
        if ح.isspace(): i+=1; continue
        عمود=i-بداية_السطر+1
        ر=أرقام_القيم.get(ح)
        if ر is not None:
            ق=0
            while i<n:
                د=أرقام_القيم.get(نص[i])
                if د is None: break
                ق=ق*10+د; i+=1
            رموز.append(("عدد",ق,سطر,عمود)); continue
        if ح=='"':
            i+=1; أ=[]
            while i<n and نص[i]!='"': أ.append(نص[i]); i+=1
            if i>=n: raise Exception(f"نص غير مغلق عند السطر {سطر} العمود {عمود}")
            i+=1; رموز.append(("نص","".join(أ),سطر,عمود)); continue
        ي=رموز_يونانية.get(ح)
        if ي is not None: رموز.append(("عملية",ي,سطر,عمود)); i+=1; continue
        if ح.isalpha() or ح=="_":
            ب=i; i+=1
            while i<n and (نص[i].isalpha() or نص[i].isdigit() or نص[i]=="_" or ("\u064B"<=نص[i]<="\u0652") or نص[i]=="\u0670"): i+=1
            ك="".join([ح for ح in نص[ب:i] if not ("\u064B"<=ح<="\u0652") and ح!="\u0670"])
            بد=أسماء_بديلة.get(ك)
            if بد is not None: رموز.append(("عملية",بد,سطر,عمود))
            else: رموز.append(("معرف",ك,سطر,عمود))
            continue
        ع=رموز_العمليات.get(ح)
        if ع is not None: رموز.append(("عملية",ع,سطر,عمود)); i+=1; continue
        raise Exception(f"رمز غير معروف '{ح}' عند السطر {سطر} العمود {عمود}")
    return رموز

# ═══════════════════════════════════════════════════════════
# Parser
# ═══════════════════════════════════════════════════════════
def حلل_برنامج(رموز):
    ب=[]; i=0
    while i<len(رموز):
        بيان,i=حلل_بيان(رموز,i); ب.append(بيان)
    return ب

def حلل_بيان(رموز,i):
    if i>=len(رموز): raise Exception(f"بيان مفقود عند {pos_msg(رموز, i)}")
    ن,ق=رموز[i][0],رموز[i][1]
    if ن=="عملية" and ق=="⎕":
        i+=1; ت,i=حلل_تعبير(رموز,i); return ("اطبع",ت),i
    if ن=="عملية" and ق=="﴿":
        i+=1; بيانات=[]; إخراج=None
        while True:
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="﴾": i+=1; break
            بيان,i=حلل_بيان(رموز,i); بيانات.append(بيان)
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="⋄":
                i+=1
                if i<len(رموز) and رموز[i][1]=="﴾": continue
                if (i<len(رموز) and رموز[i][0]=="معرف" and
                    (i+1>=len(رموز) or (رموز[i+1][0]=="عملية" and رموز[i+1][1] not in ("≔","≡","⊸","(")))):
                    إخراج,i=حلل_تعبير(رموز,i)
                elif i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in ("μ","∀","⎕","طابق","ماكرو"):
                    continue
                    if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
                    if رموز[i][1]=="﴾": i+=1; break
                    if رموز[i][1]=="⋄": continue
                    raise Exception("⋄ أو ﴾ مطلوبة بعد التعبير")
                continue
            if رموز[i][1]=="﴾": i+=1; break
            raise Exception(f"⋄ أو ﴾ مطلوبة عند {pos_msg(رموز, i)}")
        return ("كتلة",بيانات,إخراج),i
    if ن=="معرف":
        اسم=ق
        if i+1<len(رموز) and رموز[i+1][0]=="عملية" and رموز[i+1][1]=="⊸":
            i+=2
            if i>=len(رموز) or رموز[i][0]!="معرف":
                raise Exception("اسم المصدر مطلوب بعد ⊸")
            مصدر=رموز[i][1]; i+=1
            return ("نقل",اسم,مصدر),i
        if i+1<len(رموز) and رموز[i+1][0]=="عملية" and (رموز[i+1][1]=="≔" or رموز[i+1][1]=="≡"):
            رمز=رموز[i+1][1]; i+=2; ت,i=حلل_تعبير(رموز,i)
            return ("عرف" if رمز=="≡" else "أسند",اسم,ت),i
        if i+1<len(رموز) and رموز[i+1][0]=="عملية" and رموز[i+1][1]=="(":
            ت,i=حلل_تعبير(رموز,i)
            return ("استدعاء_جملة",ت),i
    if ن=="عملية" and ق=="μ":
        i+=1; شرط,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة عند {pos_msg(رموز, i)}")
        i+=1; جسم,i=حلل_بيان(رموز,i)
        return ("طالما",شرط,جسم),i
    if ن=="عملية" and ق=="∀":
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم مطلوب بعد ∀ عند {pos_msg(رموز, i)}")
        اسم=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!="∈": raise Exception(f"∈ مطلوبة عند {pos_msg(رموز, i)}")
        i+=1; قائمة,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة عند {pos_msg(رموز, i)}")
        i+=1; جسم,i=حلل_بيان(رموز,i)
        return ("لكل",اسم,قائمة,جسم),i
    if ن=="عملية" and ق=="ماكرو":
        # المرحلة 48: تعريف ماكرو — ماكرو اسم(معاملات) : ﴿ تعبير ﴾
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم الماكرو مطلوب عند {pos_msg(رموز, i)}")
        اسم=رموز[i][1]; i+=1
        # معاملات اختيارية
        معاملات=[]
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1
            while True:
                if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                if رموز[i][1]==")": i+=1; break
                if رموز[i][0]!="معرف": raise Exception(f"اسم معامل مطلوب عند {pos_msg(رموز, i)}")
                معاملات.append(رموز[i][1]); i+=1
                if i<len(رموز) and رموز[i][1]==",": i+=1
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة عند {pos_msg(رموز, i)}")
        i+=1
        if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception(f"﴿ مطلوبة عند {pos_msg(رموز, i)}")
        i+=1
        # حلل الجسم: كتلة ﴿...﴾ متداخلة أو تعبير واحد
        if i<len(رموز) and رموز[i][1]=="﴿":
            جسم,i=حلل_بيان(رموز,i)
        else:
            جسم,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!="﴾": raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
        i+=1
        # استيراد وتسجيل في registry
        try:
            from phase48_macros import سجل_ماكرو
            سجل_ماكرو(اسم, [{"معاملات": معاملات, "جسم": جسم}])
        except ImportError:
            pass
        return ("تعريف_ماكرو", اسم, [{"معاملات": معاملات, "جسم": جسم}]),i
    if ق=="نوع":
        # المرحلة 44: تعريف نوع جبري — نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم النوع مطلوب عند {pos_msg(رموز, i)}")
        اسم=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة بعد اسم النوع عند {pos_msg(رموز, i)}")
        i+=1
        if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception(f"﴿ مطلوبة بعد : عند {pos_msg(رموز, i)}")
        i+=1; بناة=[]
        while True:
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="﴾": i+=1; break
            if رموز[i][0]!="معرف": raise Exception(f"اسم باني مطلوب عند {pos_msg(رموز, i)}")
            اسم_باني=رموز[i][1]; i+=1
            معاملات=[]
            if i<len(رموز) and رموز[i][1]=="(":
                i+=1
                while True:
                    if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                    if رموز[i][1]==")": i+=1; break
                    if رموز[i][0]!="معرف": raise Exception(f"اسم معامل مطلوب عند {pos_msg(رموز, i)}")
                    معاملات.append(رموز[i][1]); i+=1
                    if i<len(رموز) and رموز[i][1]==",": i+=1
            بناة.append((اسم_باني, len(معاملات)))
            if i<len(رموز) and رموز[i][1]=="⋄": i+=1
        # المرحلة 44: سجّل النوع أثناء التحليل حتى يتعرف حلل_نمط على البناة
        globals()['_type_registry'][اسم]=بناة
        return ("تعريف_نوع", اسم, بناة),i
    if ق=="سمة":
        # المرحلة 45: تعريف سمة — سمة اسم(وسائط) : ﴿ دوال ⟩
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم السمة مطلوب عند {pos_msg(رموز, i)}")
        اسم=رموز[i][1]; i+=1
        معاملات=[]
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1
            while True:
                if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                if رموز[i][1]==")": i+=1; break
                if رموز[i][0]!="معرف": raise Exception(f"اسم معامل مطلوب عند {pos_msg(رموز, i)}")
                معاملات.append(رموز[i][1]); i+=1
                if i<len(رموز) and رموز[i][1]==",": i+=1
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة بعد اسم السمة عند {pos_msg(رموز, i)}")
        i+=1
        if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception(f"﴿ مطلوبة بعد : عند {pos_msg(رموز, i)}")
        i+=1; دوال=[]
        while True:
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="﴾": i+=1; break
            if رموز[i][0]!="معرف": raise Exception(f"اسم دالة مطلوب عند {pos_msg(رموز, i)}")
            اسم_دالة=رموز[i][1]; i+=1
            if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة بعد اسم الدالة عند {pos_msg(رموز, i)}")
            i+=1
            # تخطَّ توقيع الدالة (ن → نص) — استهلك حتى ⋄ أو ﴾
            عمق=0
            while i<len(رموز):
                if رموز[i][1]=="﴿": عمق+=1
                elif رموز[i][1]=="﴾":
                    if عمق==0: break
                    عمق-=1
                elif عمق==0 and رموز[i][1]=="⋄": break
                i+=1
            دوال.append((اسم_دالة, 1))
            if i<len(رموز) and رموز[i][1]=="⋄": i+=1
        globals()['_trait_registry'][اسم]=دوال
        return ("تعريف_سمة", اسم, معاملات, دوال),i
        globals()['_type_registry'][اسم]=بناة
        return ("تعريف_نوع", اسم, بناة),i
    if ق=="تطبيق":
        # المرحلة 45: تطبيق سمة على نوع — تطبيق سمة على نوع : ﴿ دالة(وسائط) ≔ تعبير ⟩
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم السمة مطلوب عند {pos_msg(رموز, i)}")
        اسم_سمة=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!="على": raise Exception(f"'على' مطلوبة بعد اسم السمة عند {pos_msg(رموز, i)}")
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم النوع مطلوب عند {pos_msg(رموز, i)}")
        اسم_نوع=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة بعد اسم النوع عند {pos_msg(رموز, i)}")
        i+=1
        if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception(f"﴿ مطلوبة بعد : عند {pos_msg(رموز, i)}")
        i+=1; تطبيقات=[]
        while True:
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="﴾": i+=1; break
            if رموز[i][0]!="معرف": raise Exception(f"اسم دالة مطلوب عند {pos_msg(رموز, i)}")
            اسم_دالة=رموز[i][1]; i+=1
            وسائط=[]
            if i<len(رموز) and رموز[i][1]=="(":
                i+=1
                while True:
                    if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                    if رموز[i][1]==")": i+=1; break
                    if رموز[i][0]!="معرف": raise Exception(f"اسم معامل مطلوب عند {pos_msg(رموز, i)}")
                    وسائط.append(رموز[i][1]); i+=1
                    if i<len(رموز) and رموز[i][1]==",": i+=1
            if i>=len(رموز) or رموز[i][1]!="≔": raise Exception(f"≔ مطلوبة بعد معاملات الدالة عند {pos_msg(رموز, i)}")
            i+=1
            تعبير,i=حلل_تعبير(رموز,i)
            تطبيقات.append((اسم_دالة, وسائط, تعبير))
            if i<len(رموز) and رموز[i][1]=="⋄": i+=1
        globals()['_impl_registry'][(اسم_سمة, اسم_نوع)]={fn: (ar, bd) for fn, ar, bd in تطبيقات}
        return ("تطبيق_سمة", اسم_سمة, اسم_نوع, تطبيقات),i
    if ق=="طابق":
        i+=1; قيمة,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(": مطلوبة بعد طابق")
        i+=1
        if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception("﴿ مطلوبة بعد طابق :")
        i+=1; فروع=[]
        while True:
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="﴾": i+=1; break
            نمط,i=حلل_نمط(رموز,i)
            if i>=len(رموز) or رموز[i][1]!="⇒": raise Exception(f"⇒ مطلوبة بعد النمط عند {pos_msg(رموز, i)}")
            i+=1
            if i<len(رموز) and رموز[i][1]=="﴿": جسم,i=حلل_بيان(رموز,i); تعبير=جسم
            else: تعبير,i=حلل_تعبير(رموز,i)
            فروع.append((نمط,تعبير))
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="⋄": i+=1; continue
            if رموز[i][1]=="﴾": i+=1; break
            raise Exception(f"⋄ أو ﴾ مطلوبة عند {pos_msg(رموز, i)}")
        return ("طابق",قيمة,فروع),i
    if ن=="عملية" and ق=="⟨":
        ت,i=حلل_تعبير(رموز,i); return ("تعبير",ت),i
    raise Exception(f"بيان غير معروف عند {pos_msg(رموز, i)}")

def حلل_تعبير(رموز,i):
    تعبير,i=حلل_شرطي(رموز,i)
    # المرحلة 46: ؟ — استخراج مشروط: إن نجح استخرج القيمة، وإلا عد القيمة الفاشلة كما هي
    if i<len(رموز) and رموز[i][1]=="؟":
        i+=1
        return ("عامل_نتيجة",تعبير),i
    return تعبير,i

def حلل_شرطي(رموز,i):
    شرط,i=حلل_مقارنة(رموز,i)
    if i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1]=="؟":
        i+=1; صح,i=حلل_شرطي(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة عند {pos_msg(رموز, i)}")
        i+=1; خطأ,i=حلل_شرطي(رموز,i)
        return ("شرطي",شرط,صح,خطأ),i
    return شرط,i

def حلل_مقارنة(رموز,i):
    ي,i=حلل_جمع(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_المقارنة:
        ع=رموز[i][1]; i+=1; م,i=حلل_جمع(رموز,i); ي=("مقارنة",ع,ي,م)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1]=="∧":
        i+=1
        م,i=حلل_جمع(رموز,i)
        while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_المقارنة:
            ع=رموز[i][1]; i+=1; ر,i=حلل_جمع(رموز,i); م=("مقارنة",ع,م,ر)
        ي=("مقارنة","∧",ي,م)
    if i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1]=="∨":
        i+=1; م,i=حلل_مقارنة(رموز,i); ي=("مقارنة","∨",ي,م)
    return ي,i

def حلل_جمع(رموز,i):
    ي,i=حلل_ضرب(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_الجمع:
        ع=رموز[i][1]; i+=1; م,i=حلل_ضرب(رموز,i); ي=("ثنائية",ع,ي,م)
    return ي,i

def حلل_ضرب(رموز,i):
    ي,i=حلل_عامل(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_الضرب:
        ع=رموز[i][1]; i+=1; م,i=حلل_عامل(رموز,i); ي=("ثنائية",ع,ي,م)
    return ي,i

def حلل_نمط(رموز,i):
    if i>=len(رموز): raise Exception(f"نمط مطلوب عند {pos_msg(رموز, i)}")
    ن,ق=رموز[i][0],رموز[i][1]
    if ق=="_":
        return ("نمط_شامل",),i+1
    if ن=="عملية" and ق=="⟨":
        i+=1
        if i<len(رموز) and رموز[i][1]=="⟩": return ("نمط_قائمة",None,None),i+1
        عناصر=[]; ذيل=None
        while True:
            if i>=len(رموز): raise Exception(f"⟩ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="⟩": break
            if رموز[i][1]=="…" or (رموز[i][1]=="." and i+2<len(رموز) and رموز[i+1][1]=="." and رموز[i+2][1]=="."):
                i += (3 if رموز[i][1]=="." else 1)
                if i>=len(رموز): raise Exception("اسم مطلوب بعد …")
                if رموز[i][0]=="معرف":
                    ذيل=رموز[i][1]; i+=1
                elif رموز[i][0]=="عملية" and رموز[i][1]=="_":
                    ذيل="_"; i+=1
                else:
                    raise Exception("اسم مطلوب بعد …")
                if i>=len(رموز): raise Exception("⟩ مطلوبة بعد …ذيل")
                if رموز[i][1]!="⟩": raise Exception("⟩ مطلوبة بعد …ذيل")
                continue  # العودة للحلقة لتستهلك ⟩ وتخرج
            if رموز[i][0]=="عدد": عناصر.append(("نمط_حرفي",رموز[i][1])); i+=1
            elif رموز[i][0]=="نص": عناصر.append(("نمط_حرفي",رموز[i][1])); i+=1
            elif رموز[i][0]=="معرف": عناصر.append(("نمط_متغير",رموز[i][1])); i+=1
            elif رموز[i][0]=="عملية" and رموز[i][1]=="_": عناصر.append(("نمط_متغير","_")); i+=1
            else: raise Exception("عنصر نمط غير صالح")
            if i<len(رموز) and رموز[i][1]==",": i+=1
        if i>=len(رموز) or رموز[i][1]!="⟩": raise Exception(f"⟩ مطلوبة عند {pos_msg(رموز, i)}")
        return ("نمط_قائمة",عناصر,ذيل),i+1
    if ن=="عدد":
        if i+1<len(رموز) and رموز[i+1][1]=="|":
            قيم=[ق]; i+=2  # تجاوز '|' الأولى
            while True:
                if i>=len(رموز): raise Exception("قيمة مطلوبة بعد |")
                if رموز[i][0]=="عدد": قيم.append(رموز[i][1]); i+=1
                elif رموز[i][0]=="نص": قيم.append(رموز[i][1]); i+=1
                else: raise Exception("قيمة مطلوبة بعد |")
                if i<len(رموز) and رموز[i][1]=="|": i+=1
                else: break
            return ("نمط_بديل",قيم),i
        return ("نمط_حرفي",ق),i+1
    if ن=="نص": return ("نمط_حرفي",ق),i+1
    if ن=="معرف":
        اسم=ق; i+=1
        # المرحلة 44: نمط باني — دائرة(ن) أو مستطيل(ع، ا) أو باني بلا معاملات (أزرق)
        _pb_tag=-1
        if اسم in ["نجاح","فشل","بعض","لاشيء"]:
            _pb_tag=0  # مقبول كباني؛ التمييز الفعلي عند التوليد
        else:
            for _tn, _bs in _type_registry.items():
                for _bi, (_bn, _ba) in enumerate(_bs):
                    if _bn == اسم: _pb_tag=_bi; break
                if _pb_tag>=0: break
        if _pb_tag>=0:
            أنماط_فرعية=[]
            if i<len(رموز) and رموز[i][1]=="(":
                i+=1
                while True:
                    if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                    if رموز[i][1]==")": i+=1; break
                    نمط_فرعي,i=حلل_نمط(رموز,i)
                    أنماط_فرعية.append(نمط_فرعي)
                    if i<len(رموز) and رموز[i][1]==",": i+=1
            return ("نمط_باني", اسم, أنماط_فرعية),i
        if i<len(رموز) and رموز[i][1]=="|":
            قيم=[اسم]; i+=1
            while i<len(رموز) and (رموز[i][0]=="عدد" or رموز[i][0]=="نص"):
                قيم.append(رموز[i][1]); i+=1
                if i<len(رموز) and رموز[i][1]=="|": i+=1
                else: break
            return ("نمط_بديل",قيم),i
        if i<len(رموز) and رموز[i][1]=="حيث":
            i+=1; شرط,i=حلل_تعبير(رموز,i)
            return ("نمط_شرطي",("نمط_متغير",اسم),شرط),i
        return ("نمط_متغير",اسم),i
    if ن=="عملية" and ق=="|":
        # بديل يبدأ بقيم حرفية: 0 | 1 | 2
        قيم=[]; i+=1
        while True:
            if i>=len(رموز): raise Exception("قيمة مطلوبة بعد |")
            if رموز[i][0]=="عدد": قيم.append(رموز[i][1]); i+=1
            elif رموز[i][0]=="نص": قيم.append(رموز[i][1]); i+=1
            else: raise Exception("قيمة مطلوبة بعد |")
            if i<len(رموز) and رموز[i][1]=="|": i+=1
            else: break
        return ("نمط_بديل",قيم),i
    raise Exception("نمط غير معروف: "+str(ق))

def حلل_عامل(رموز,i):
    if i>=len(رموز): raise Exception(f"عامل مفقود عند {pos_msg(رموز, i)}")
    ن,ق=رموز[i][0],رموز[i][1]
    if ن=="عدد": return ("عدد",ق),i+1
    if ن=="عملية" and ق=="-":
        # سالب أحادي: -5 أو -ن
        i+=1
        ع,i=حلل_عامل(رموز,i)
        return ("سالب",ع),i
    if ن=="نص": return ("نص",ق),i+1
    if ن=="عملية" and ق=="⊙":
        i+=1
        return ("اقرأ",),i
    if ن=="عملية" and ق=="↻":
        # المرحلة 47: دالة غير متزامنة — ↻ اسم(معاملات) : ﴿ ... ﴾
        i+=1
        if i<len(رموز) and رموز[i][0]=="معرف":
            اسم_دالة=رموز[i][1]; i+=1
            return ("تعريف_دالة_غير_متزامنة", اسم_دالة), i
        return ("علامة_غير_متزامن",), i
    if ن=="عملية" and ق=="λ":
        i+=1; معلمون=[]
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1
            # دعم لامدا بلا معاملات: λ(). ﴿...﴾
            if i<len(رموز) and رموز[i][1]==")":
                i+=1
            else:
                while True:
                    if i>=len(رموز) or رموز[i][0]!="معرف":
                        raise Exception(f"اسم معامل مطلوب عند {pos_msg(رموز, i)}")
                    معلمون.append(رموز[i][1]); i+=1
                    if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                    if رموز[i][1]==",": i+=1; continue
                    if رموز[i][1]==")": i+=1; break
        else:
            if i>=len(رموز) or رموز[i][0]!="معرف":
                raise Exception(f"معامل مطلوب بعد λ عند {pos_msg(رموز, i)}")
            معلمون.append(رموز[i][1]); i+=1
        if i>=len(رموز) or رموز[i][1]!=".": raise Exception(f". مطلوبة عند {pos_msg(رموز, i)}")
        i+=1
        if i<len(رموز) and رموز[i][1]=="﴿":
            جسم,i=حلل_بيان(رموز,i)
        else:
            جسم,i=حلل_تعبير(رموز,i)
        return ("دالة",معلمون,جسم),i
    if ن=="عملية" and ق=="⟨":
        i+=1; ع=[]
        if i<len(رموز) and رموز[i][1]=="⟩": return ("قائمة",ع),i+1
        while True:
            عنصر,i=حلل_تعبير(رموز,i); ع.append(عنصر)
            if i>=len(رموز): raise Exception(f"⟩ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]==",": i+=1; continue
            if رموز[i][1]=="⟩": i+=1; break
            raise Exception(f"فاصلة أو ⟩ مطلوبة عند {pos_msg(رموز, i)}")
        return ("قائمة",ع),i
    if ن=="عملية" and ق=="(":
        i+=1; ت,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=")": raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
        return ت,i+1
    if ن=="معرف":
        اسم=ق; i+=1; نتيجة_استدعاء=None
        # المرحلة 44: باني بلا معاملات يُستخدم كتعبير — أزرق ⇨ استدعاء(أزرق, [])
        # (لا نتدخل إن كانت '(' تلي الاسم — المسار الأصلي يحللها)
        _p44_ctor = False
        for _tn, _bs in _type_registry.items():
            for _bi, (_bn, _ba) in enumerate(_bs):
                if _bn == اسم: _p44_ctor = True; break
            if _p44_ctor: break
        if _p44_ctor and (i >= len(رموز) or رموز[i][1] != "("):
            return ("استدعاء", اسم, []), i
        while True:
            if i<len(رموز) and رموز[i][1]=="(":
                i+=1; وس=[]
                if i<len(رموز) and رموز[i][1]==")": اسم=("استدعاء",اسم,وس); i+=1; continue
                while True:
                    و,i=حلل_تعبير(رموز,i); وس.append(و)
                    if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                    if رموز[i][1]==",": i+=1; continue
                    if رموز[i][1]==")": اسم=("استدعاء",اسم,وس); i+=1; break
            elif i<len(رموز) and رموز[i][1]=="[":
                i+=1; فهرس,i=حلل_تعبير(رموز,i)
                if i>=len(رموز) or رموز[i][1]!="]": raise Exception(f"] مطلوبة عند {pos_msg(رموز, i)}")
                i+=1; اسم=("فهرسة",اسم,فهرس)
            else:
                break
        if isinstance(اسم, tuple) and اسم[0]=="استدعاء": return اسم,i
        # المرحلة 47: بانتظار و بدء كـ expressions
        if اسم=="بانتظار":
            i+=1
            تعبير,i=حلل_تعبير(رموز,i)
            return ("بانتظار", تعبير), i
        if اسم=="بدء":
            i+=1
            تعبير,i=حلل_تعبير(رموز,i)
            return ("بدء", تعبير), i
        if اسم=="طابق":
            قيمة,i=حلل_تعبير(رموز,i)
            if i>=len(رموز) or رموز[i][1]!=":": raise Exception(": مطلوبة بعد طابق (تعبير)")
            i+=1
            if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception("﴿ مطلوبة بعد طابق :")
            i+=1; فروع=[]
            while True:
                if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
                if رموز[i][1]=="﴾": i+=1; break
                نمط,i=حلل_نمط(رموز,i)
                if i>=len(رموز) or رموز[i][1]!="⇒": raise Exception(f"⇒ مطلوبة بعد النمط عند {pos_msg(رموز, i)}")
                i+=1
                if i<len(رموز) and رموز[i][1]=="﴿": جسم,i=حلل_بيان(رموز,i); تعبير=جسم
                else: تعبير,i=حلل_تعبير(رموز,i)
                فروع.append((نمط,تعبير))
                if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
                if رموز[i][1]=="⋄": i+=1; continue
                if رموز[i][1]=="﴾": i+=1; break
                raise Exception(f"⋄ أو ﴾ مطلوبة عند {pos_msg(رموز, i)}")
            return ("طابق",قيمة,فروع),i
        return ("متغير",اسم),i
    if ق=="طابق":
        # طابق يُصدره المحلل المعجمي كعملية — يدعم طابق كتعبير أولي
        i+=1; قيمة,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(": مطلوبة بعد طابق (تعبير)")
        i+=1
        if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception("﴿ مطلوبة بعد طابق :")
        i+=1; فروع=[]
        while True:
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="﴾": i+=1; break
            نمط,i=حلل_نمط(رموز,i)
            if i>=len(رموز) or رموز[i][1]!="⇒": raise Exception(f"⇒ مطلوبة بعد النمط عند {pos_msg(رموز, i)}")
            i+=1
            if i<len(رموز) and رموز[i][1]=="﴿": جسم,i=حلل_بيان(رموز,i); تعبير=جسم
            else: تعبير,i=حلل_تعبير(رموز,i)
            فروع.append((نمط,تعبير))
            if i>=len(رموز): raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
            if رموز[i][1]=="⋄": i+=1; continue
            if رموز[i][1]=="﴾": i+=1; break
            raise Exception(f"⋄ أو ﴾ مطلوبة عند {pos_msg(رموز, i)}")
        return ("طابق",قيمة,فروع),i
    if ن=="عملية" and ق=="[":

        raise Exception("قوس الفهرسة '[' يجب أن يتبع قائمة أو متغيراً")
    raise Exception(f"عامل غير متوقع عند {pos_msg(رموز, i)}")

# ═══════════════════════════════════════════════════════════
# Ownership Checker (Linear Logic ⊸)
# ═══════════════════════════════════════════════════════════
def get_used_vars(expr):
    ن=expr[0]
    if ن=="متغير":
        س=expr[1]
        if isinstance(س, tuple):
            if س[0]=="فهرسة": return get_used_vars(("متغير",س[1]))|get_used_vars(س[2])
            if س[0]=="استدعاء":
                res=set()
                for arg in س[2]: res|=get_used_vars(arg)
                return res|(get_used_vars(("متغير",س[1])) if isinstance(س[1],str) else get_used_vars(س[1]))
            return set()
        return {س}
    if ن in ["ثنائية","مقارنة"]:
        return get_used_vars(expr[2])|get_used_vars(expr[3])
    if ن=="شرطي":
        return get_used_vars(expr[1])|get_used_vars(expr[2])|get_used_vars(expr[3])
    if ن=="استدعاء":
        res=set()
        for arg in expr[2]: res|=get_used_vars(arg)
        return res
    if ن=="عامل_نتيجة":
        # المرحلة 46: ؟ — استخراج مشروط (extract-or-propagate)
        # إن tag([ptr+8])==0 (نجاح): استخرج القيمة من +16؛ وإلا: عد القيمة الفاشلة كما هي
        code=compile_expr(expr[1], env, funcs, env_layout)
        _counters["empty"]+=1; _qk=_counters["empty"]
        code+=["    mov rbx, [rax + 8]", "    test rbx, rbx", f"    jnz .rq_fail_{_qk}",
               "    mov rax, [rax + 16]", f".rq_fail_{_qk}:"]
        return code
    if ن=="بانتظار":
        # المرحلة 47: بانتظار(تعبير) — انتظار اكتمال Future
        code=compile_expr(expr[1], env, funcs, env_layout)
        code.append("    mov rdi, rax              ; future ptr")
        code.append("    call await_future")
        return code
    if ن=="بدء":
        # المرحلة 47: بدء(تعبير) — بدء مهمة في الخلفية
        code=compile_expr(expr[1], env, funcs, env_layout)
        return code
    if ن=="قائمة":
        res=set()
        for e in expr[1]: res|=get_used_vars(e)
        return res
    if ن=="دالة": return get_stmt_used_vars(expr[2]) if expr[2][0]=="كتلة" else get_used_vars(expr[2])-set(expr[1])
    if ن=="اقرأ": return set()
    return set()

def get_stmt_free_vars(stmt, bound):
    ن=stmt[0]
    if ن=="كتلة":
        res=set(); b=bound
        for s in stmt[1]:
            res|=get_stmt_free_vars(s,b)
            if s[0] in ("أسند","لكل","نقل"): b=b|{s[1]}
            elif s[0]=="عرف": b=b|{s[1]}
        if stmt[2] is not None: res|=get_free_vars(stmt[2], b)
        return res
    if ن=="أسند": return get_free_vars(stmt[2],bound)
    if ن=="طالما": return get_free_vars(stmt[1],bound)|get_stmt_free_vars(stmt[2],bound)
    if ن=="لكل": return get_free_vars(stmt[2],bound)|get_stmt_free_vars(stmt[3],bound)
    if ن=="اطبع": return get_free_vars(stmt[1],bound)
    if ن=="استدعاء_جملة": return get_free_vars(stmt[1],bound)
    if ن=="عرف":
        if stmt[2][0]=="دالة":
            return set(stmt[2][1])
        return get_free_vars(stmt[2],bound)
    if ن=="نقل": return set()
    if ن=="تعبير": return get_free_vars(stmt[1], bound)
    return set()

def استنتاج_نوع_كتلة(stmt, type_env):
    for s in reversed(stmt[1]):
        if s[0]=="أسند": continue
        if s[0]=="اطبع": return "نص"
        return استنتاج_نوع_جملة(s, type_env) if s[0]=="استدعاء_جملة" else "مجهول"
    return "مجهول"

def get_stmt_used_vars(stmt):
    ن=stmt[0]
    if ن in ["أسند","عرف"]: return get_used_vars(stmt[2])
    if ن=="اطبع": return get_used_vars(stmt[1])
    if ن=="استدعاء_جملة": return get_used_vars(stmt[1])
    if ن=="نقل": return {stmt[2]}
    if ن=="طالما": return get_used_vars(stmt[1])|get_stmt_used_vars(stmt[2])
    if ن=="لكل": return get_used_vars(stmt[2])|get_stmt_used_vars(stmt[3])
    if ن=="كتلة":
        res=set()
        for s in stmt[1]: res|=get_stmt_used_vars(s)
        if stmt[2] is not None: res|=get_used_vars(stmt[2])
        return res
    if ن=="تعبير": return get_used_vars(stmt[1])
    if ن=="تعبير": return get_free_vars(stmt[1], bound)
    return set()

def check_ownership(برنامج):
    consumed=set()
    def check_stmt(stmt):
        ن=stmt[0]
        if ن=="كتلة":
            for s in stmt[1]: check_stmt(s)
            return
        if ن=="طالما":
            used=get_used_vars(stmt[1])
            for v in used:
                if v in consumed:
                    raise Exception(f"خطأ ملكية ⊸: '{v}' مستهلك — نُقلت ملكيته ولا يمكن استخدامه")
            check_stmt(stmt[2])
            return
        if ن=="لكل":
            used=get_used_vars(stmt[2])
            for v in used:
                if v in consumed:
                    raise Exception(f"خطأ ملكية ⊸: '{v}' مستهلك — نُقلت ملكيته ولا يمكن استخدامه")
            check_stmt(stmt[3])
            return
        if ن=="نقل":
            هدف=stmt[1]; مصدر=stmt[2]
            if مصدر in consumed:
                raise Exception(f"خطأ ملكية ⊸: '{مصدر}' مستهلك بالفعل — لا يمكن نقله مرتين")
            consumed.add(مصدر)
            return
        if ن in ["أسند","عرف"]:
            اسم=stmt[1]
            consumed.discard(اسم)
            used=get_used_vars(stmt[2])
            for v in used:
                if v in consumed:
                    raise Exception(f"خطأ ملكية ⊸: '{v}' مستهلك — نُقلت ملكيته ولا يمكن استخدامه")
            return
        if ن=="اطبع":
            used=get_used_vars(stmt[1])
            for v in used:
                if v in consumed:
                    raise Exception(f"خطأ ملكية ⊸: '{v}' مستهلك — نُقلت ملكيته ولا يمكن استخدامه")
            return
        if ن=="استدعاء_جملة":
            used=get_used_vars(stmt[1])
            for v in used:
                if v in consumed:
                    raise Exception(f"خطأ ملكية ⊸: '{v}' مستهلك — نُقلت ملكيته ولا يمكن استخدامه")
            return
        used=get_stmt_used_vars(stmt)
        for v in used:
            if v in consumed:
                raise Exception(f"خطأ ملكية ⊸: '{v}' مستهلك — نُقلت ملكيته ولا يمكن استخدامه")
    for بيان in برنامج:
        check_stmt(بيان)
    return True

# ═══════════════════════════════════════════════════════════
# Helpers
# ═══════════════════════════════════════════════════════════
def get_free_vars(expr, bound):
    ن=expr[0]
    if ن=="متغير": return {expr[1]} if expr[1] not in bound else set()
    if ن in ["ثنائية","مقارنة"]:
        return get_free_vars(expr[2],bound)|get_free_vars(expr[3],bound)
    if ن=="دالة": return get_stmt_free_vars(expr[2], bound|set(expr[1])) if expr[2][0]=="كتلة" else get_free_vars(expr[2], bound|set(expr[1]))
    if ن=="استدعاء":
        res=set()
        اسم=expr[1]
        if not isinstance(اسم, str):
            res|=get_free_vars(اسم, bound)
        for arg in expr[2]: res|=get_free_vars(arg,bound)
        return res
    if ن=="شرطي":
        return get_free_vars(expr[1],bound)|get_free_vars(expr[2],bound)|get_free_vars(expr[3],bound)
    if ن=="قائمة":
        res=set()
        for e in expr[1]: res|=get_free_vars(e,bound)
        return res
    if ن=="نمط_باني":
        res=set()
        for _sp in expr[2]: res|=get_free_vars(_sp, bound)
        return res
    if ن=="فهرسة":
        res=get_free_vars(expr[2],bound)
        if isinstance(expr[1],str):
            if expr[1] not in bound: res.add(expr[1])
        else:
            res|=get_free_vars(expr[1],bound)
        return res
    if ن=="كتلة": return get_stmt_free_vars(expr, bound) - bound
    if ن=="تعبير": return get_free_vars(expr[1], bound)
    return set()

def استنتاج_نوع(expr, type_env):
    ن=expr[0]
    if ن=="نص": return "نص"
    if ن=="عدد": return "عدد"
    if ن=="قائمة": return "قائمة"
    if ن=="اقرأ": return "نص"
    if ن=="ثنائية":
        if expr[1]=="⊕": return "نص"
        if expr[1] in ["+","-","·","÷"]: return "عدد"
        return "مجهول"
    if ن=="مقارنة": return "منطقي"
    if ن=="شرطي":
        t1=استنتاج_نوع(expr[2], type_env)
        if t1!="مجهول": return t1
        return استنتاج_نوع(expr[3], type_env)
    if ن=="متغير":
        س=expr[1]
        if isinstance(س, tuple):
            if س[0]=="فهرسة": return "عدد"
            if س[0]=="استدعاء":
                return "مجهول"
            return "مجهول"
        return type_env.get(س, "مجهول")
    if ن=="استدعاء":
        اسم=expr[1]
        # المرحلة 46: Result/Option
        if اسم=="نجاح" or اسم=="بعض":
            if expr[2]: return استنتاج_نوع(expr[2][0], type_env)
            return "مجهول"
        if اسم in ["فشل","لاشيء"]: return "مجهول"
        if اسم=="أس" or اسم=="أُس": return "عدد"
        if اسم in ["طول","حجم","أحص"]: return "عدد"
        if اسم in ["جذر","أرضية","قوة","مطلق","مجموع_قائمة"]: return "عدد"
        if اسم=="ذيل": return "قائمة"
        if اسم=="رمز": return "عدد"
        if اسم=="نص": return "نص"
        if اسم=="عدد": return "عدد"
        if اسم=="نص_رمز": return "نص"
        if اسم=="فتح": return "عدد"
        if اسم=="عروة": return "عدد"
        if اسم=="توازي": return "عدد"
        if اسم=="اقرأ_ملف": return "نص"
        if اسم=="اكتب_ملف": return "عدد"
        if اسم=="اختم": return "عدد"
        if اسم in type_env and type_env[اسم] != "مجهول": return type_env[اسم]
        # المرحلة 45 P8: استدعاء دالة سمة — استنتج النوع من جسم التطبيق (قبل التخمين العام)
        if اسم in [fn for _d in _trait_registry.values() for fn, _ in _d]:
            for (_sn,_tn),_im in _impl_registry.items():
                if اسم in _im:
                    _bd = _im[اسم][1]
                    _bt = استنتاج_نوع(_bd, type_env)
                    if _bt != "مجهول": return _bt
            return "مجهول"
        if expr[2]: return استنتاج_نوع(expr[2][0], type_env)  # المراحل 40-42: نوع نتيجة استدعاء دالة غير معروفة = نوع وسيطها الأول
        return "مجهول"
    if ن=="دالة":
        if expr[2][0]=="كتلة": return استنتاج_نوع_كتلة(expr[2], type_env)
        return استنتاج_نوع(expr[2], type_env)
    if ن=="طابق":
        if expr[2]: return استنتاج_نوع(expr[2][0][1], type_env)
        return "مجهول"
    return "مجهول"

def استنتاج_نوع_جملة(stmt, type_env):
    ن=stmt[0]
    if ن=="أسند": return استنتاج_نوع(stmt[2],type_env)
    if ن=="اطبع":
        نوع=استنتاج_نوع(stmt[1],type_env)
        return "نص" if نوع=="نص" else "عدد"
    if ن=="كتلة": return استنتاج_نوع_كتلة(stmt, type_env)
    return "مجهول"

ARG_REGS = ["rdi","rsi","rdx","rcx","r8","r9"]
_counters = {"cond":0,"empty":0,"copy":0,"loop":0,"scmp":0,"tq":0,"index":0,"bmatch":0,"scand":0,"scor":0}

# المرحلة 44: الأنواع الجبرية — سجل الأنواع
_trait_registry = {}   # اسم_السمة → [(اسم_الدالة, عدد_المعاملات), ...]
_impl_registry = {}  # (اسم_السمة, اسم_النوع) → {اسم_الدالة: (وسائط, جسم)}
_type_registry = {}  # اسم_النوع → [(اسم_الباني, عدد_المعاملات), ...]

# ═══════════════════════════════════════════════════════════
# Code Generator
# ═══════════════════════════════════════════════════════════
def compile_expr(expr, env, funcs, env_layout=None):
    ن=expr[0]
    if ن=="عدد":
        ق=expr[1]
        return [f"    mov rax, {'qword ' if ق>2**31-1 else ''}{ق}"]
    if ن=="سالب":
        code=compile_expr(expr[1], env, funcs, env_layout)
        code += ["    neg rax"]
        return code
    if ن=="نص":
        byts=expr[1].encode('utf-8'); ln=len(byts)
        code=[f"    mov rdi, {8+ln}", "    call arena_alloc"]
        code.append(f"    mov qword [rax], {ln}")
        for k, b in enumerate(byts):
            code.append(f"    mov byte [rax + {8+k}], {b}")
        return code
    if ن=="استدعاء" and expr[1]=="نص_رمز":
        if len(expr[2]) != 1: raise Exception("نص_رمز تأخذ وسيطاً واحداً")
        code = compile_expr(expr[2][0], env, funcs, env_layout)
        code += [
            "    push rax",
            "    mov rdi, 9",
            "    call arena_alloc",
            "    mov qword [rax], 1",
            "    pop rbx",
            "    mov [rax + 8], bl",
        ]
        return code
    if ن=="اقرأ":
        _counters["copy"]+=1; k=_counters["copy"]
        return [
            "    xor rcx, rcx",
            f".rd_loop_{k}:",
            f"    lea rsi, [read_buf + rcx]",
            "    xor rdi, rdi",
            "    mov rdx, 1",
            "    xor rax, rax",
            "    push rcx",
            "    syscall",
            "    pop rcx",
            "    test rax, rax",
            f"    jz .rd_end_{k}",
            f"    mov al, [read_buf + rcx]",
            "    cmp al, 10",
            f"    je .rd_end_{k}",
            "    inc rcx",
            f"    jmp .rd_loop_{k}",
            f".rd_end_{k}:",
            "    mov rax, rcx",
            "    add rax, 8",
            "    mov rdi, rax",
            "    call arena_alloc",
            "    mov [rax], rcx",
            "    push rax",
            "    push rcx",
            "    lea rsi, [read_buf]",
            "    lea rdi, [rax + 8]",
            f".rd_copy_{k}:",
            "    test rcx, rcx",
            f"    jz .rd_cdone_{k}",
            "    mov al, [rsi]",
            "    mov [rdi], al",
            "    inc rsi",
            "    inc rdi",
            "    dec rcx",
            f"    jmp .rd_copy_{k}",
            f".rd_cdone_{k}:",
            "    pop rcx",
            "    pop rax",
        ]
    if ن=="متغير":
        س=expr[1]
        if isinstance(س, tuple):
            # متغير مركب: سلسة استدعاءات وفهرسات، مثل: د(1)[0] أو ق[ع]
            كود=[]
            م=س
            # اجمع سلسلة الفهرسة (قد تتضمن استدعاءات متداخلة)
            سلسلة=[]
            while isinstance(م, tuple) and م[0]=="فهرسة":
                سلسلة.append(م[2]); م=م[1]
            سلسلة.reverse()
            code=compile_expr(("متغير",م),env,funcs,env_layout) if isinstance(م,str) else compile_expr(م,env,funcs,env_layout)
            for فهرس in سلسلة:
                _counters["index"]+=1; ك=_counters["index"]
                code+=["    push rax"]
                code.extend(compile_expr(فهرس,env,funcs,env_layout))
                code+=["    mov r10, rax","    pop r11"]
                code+=[
                    "    mov rbx, [r11]",            # طول القائمة
                    f"    cmp r10, rbx",f"    jae .indx_err_{ك}",
                    "    mov rax, [r11 + r10*8 + 16]",  # العنصر
                    f"    jmp .indx_ok_{ك}",
                    f".indx_err_{ك}:",
                    "    mov rax, 60","    mov rdi, 7","    syscall",
                    f".indx_ok_{ك}:",
                ]
            return code
        if env_layout and س in env_layout:
            return [f"    mov rax, [r15 + {env_layout[س]}]"]
        if env.get("match_locals") and س in env["match_locals"]:
            return [f"    mov rax, [rbp - {env['match_locals'][س]}]"]
        if س in env["locals"]:
            return [f"    mov rax, [rbp - {env['locals'][س]}]"]
        if س in env["globals"]:
            return [f"    mov rax, [vars + {env['globals'][س]*8}]"]
        raise Exception(f"متغير غير معرف: {س}")

    if ن=="قائمة":
        elems=expr[1]; ln=len(elems)
        code=[f"    mov rdi, {16+ln*8}", "    call arena_alloc"]
        code.append("    push rax")
        code.append(f"    mov qword [rax], {ln}")
        code.append("    mov qword [rax + 8], 0")   # فتحة وسم موحدة (قوائم: 0)
        for idx,el in enumerate(elems):
            code.extend(compile_expr(el,env,funcs,env_layout))
            code.append("    mov rcx, rax")
            code.append("    mov rbx, [rsp]")
            code.append(f"    mov [rbx + {16+idx*8}], rcx")
        code.append("    pop rax")
        return code
    if ن=="كتلة":
        # كتلة كتعبير: نفّذ البيانات ثم عبّر عن الذيل
        بيانات=expr[1]; ذيل=expr[2] if len(expr)>2 else None
        code=[]
        for s in بيانات:
            code.extend(compile_stmt(s,env,funcs,env_layout))
        if ذيل is not None:
            code.extend(compile_expr(ذيل,env,funcs,env_layout))
        else:
            code.append("    xor rax, rax")
        return code
    if ن=="طابق":
        قيمة=expr[1]; فروع=expr[2]
        _counters["empty"]+=1; k=_counters["empty"]
        code=compile_expr(قيمة,env,funcs,env_layout)
        code.append("    mov [match_val], rax")
        # — المرحلة 43: فحوصات الأنماط —
        def _match_slot(اسم_م):
            # تخصيص فتحة عامة للمتغير المربوط بالنمط
            if اسم_م not in env.get("match_locals", {}):
                # المرحلة 43: في أجسام الدوال، نربط متغيرات النمط بفتحات محلية
                # على المكدس (rbp نسبي) تفاديًا للفساد عند الاستدعاءات العودية
                if اسم_م not in env["globals"]:
                    env["globals"][اسم_م]=len(env["globals"])
                return ("globals", env["globals"][اسم_م])
            return ("local", env["match_locals"][اسم_م])
        def _emit_bind(اسم_م):
            نوع,slot=_match_slot(اسم_م)
            if نوع=="local": return f"    mov [rbp - {slot}], rax"
            return f"    mov [vars + {slot}*8], rax"
        def _emit_load(اسم_م):
            نوع,slot=_match_slot(اسم_م)
            if نوع=="local": return f"    mov rax, [rbp - {slot}]"
            return f"    mov rax, [vars + {slot}*8]"
        for idx,(نمط,تعبير) in enumerate(فروع):
            mk=f".m{k}_{idx}"
            if نمط[0]=="نمط_شامل":
                code.append(f"    jmp {mk}")
            elif نمط[0]=="نمط_حرفي":
                val=نمط[1]
                code.append(f"    mov rax, [match_val]")
                if isinstance(val,str) and len(val)>8: pass
                if isinstance(val,int) and (val>2**31-1 or val<-2**31):
                    code+=[f"    mov r10, {val}",f"    cmp rax, r10",f"    je {mk}"]
                elif isinstance(val,str):
                    # نمط نصي: قارن نصًا بنص — مقارنة بسيطة بالطول والمحتوى عبر strncmp مضمن
                    _counters["scmp"]+=1; ks=_counters["scmp"]
                    code.append(f"    push rax")
                    code.extend(compile_expr(("نص",val),env,funcs,env_layout))
                    code+=[f"    mov r10, rax","    pop rax",
                           f"    mov r11, [rax]","    mov r12, [r10]",
                           f"    cmp r11, r12",f"    jne .mskip{k}_{idx}",
                           f"    mov r13, {len(val.encode('utf-8'))}",f"    xor rbx, rbx",
                           f".msloop{k}_{idx}:",f"    test r13, r13",f"    jz .mmatch{k}_{idx}",
                           f"    mov cl, [rax + rbx + 8]","    mov dl, [r10 + rbx + 8]",
                           f"    cmp cl, dl",f"    jne .mskip{k}_{idx}",
                           f"    inc rbx","    dec r13",f"    jmp .msloop{k}_{idx}",
                           f".mmatch{k}_{idx}:",f"    jmp {mk}",
                           f".mskip{k}_{idx}:"]
                else:
                    code+=[f"    cmp rax, {val}",f"    je {mk}"]
            elif نمط[0]=="نمط_متغير":
                اسم_م=نمط[1]
                code.append(f"    mov rax, [match_val]")
                code+=[_emit_bind(اسم_م),f"    jmp {mk}"]
            elif نمط[0]=="نمط_قائمة":
                عناصر=نمط[1]; ذيل=نمط[2]
                code.append(f"    mov rax, [match_val]")
                if عناصر is None:  # قائمة فارغة ⟨⟩
                    code+=[f"    cmp qword [rax], 0",f"    je {mk}",f"    jmp .mskip{k}_{idx}",f".mskip{k}_{idx}:"]
                else:  # نمط cons: ربط رأس + ذيل اختياري
                    for ei,عنصر in enumerate(عناصر):
                        if عنصر[0]=="نمط_متغير":
                            اسم_م=عنصر[1]
                            code+=[f"    mov rbx, [rax + {(ei+2)*8}]",
                                   f"    mov [rbp - {_match_slot(اسم_م)[1]}], rbx" if _match_slot(اسم_م)[0]=="local" else f"    mov [vars + {_match_slot(اسم_م)[1]*8}], rbx"]
                    if ذيل:
                        t=_match_slot(ذيل)
                        code+=[f"    lea rcx, [rax + {(len(عناصر)+2)*8}]",
                               f"    mov [rbp - {t[1]}], rcx" if t[0]=="local" else f"    mov [vars + {t[1]*8}], rcx"]
                    code.append(f"    jmp {mk}")
            elif نمط[0]=="نمط_شرطي":
                نمط_داخلي=نمط[1]; شرط=نمط[2]
                if نمط_داخلي[0]=="نمط_متغير":
                    اسم_م=نمط_داخلي[1]
                    code+=[f"    mov rax, [match_val]",
                           _emit_bind(اسم_م)]
                code.extend(compile_expr(شرط,env,funcs,env_layout))
                code+=[f"    test rax, rax",f"    jnz {mk}",f"    jmp .mskip{k}_{idx}",f".mskip{k}_{idx}:"]
            elif نمط[0]=="نمط_باني":
                # المرحلة 44: نمط باني — افحص tag ثم اربط المعاملات
                _pb_name=نمط[1]; _pb_subs=نمط[2]
                _pb_tag=-1
                # المرحلة 46: بناة Result/Option — وسم موحَّد: نجاح=0، فشل=1، بعض=2، لاشيء=3
                if _pb_name=="نجاح": _pb_tag=0
                elif _pb_name=="فشل": _pb_tag=1
                elif _pb_name=="بعض": _pb_tag=2
                elif _pb_name=="لاشيء": _pb_tag=3
                else:
                    for _tname, _builders in _type_registry.items():
                        for _bi, (_bn, _ba) in enumerate(_builders):
                            if _bn == _pb_name:
                                _pb_tag=_bi
                                break
                        if _pb_tag>=0: break
                if _pb_tag<0: raise Exception(f"باني غير معرف: {_pb_name}")
                code.append(f"    mov rax, [match_val]")
                # تحقق: مؤشر heap صالح — يجب أن يكون داخل نطاق arena_mem
                _counters["bmatch"]+=1; _kb=_counters["bmatch"]
                code+=[f"    lea r10, [arena_mem]",
                       f"    cmp rax, r10", f"    jb .mskip{k}_{idx}",
                       f"    lea r10, [arena_mem + 262144]",
                       f"    cmp rax, r10", f"    jae .mskip{k}_{idx}",
                       f"    mov rbx, [rax + 8]"]
                code.append(f"    cmp rbx, {_pb_tag}")
                code.append(f"    jne .mskip{k}_{idx}")
                for _fi, _sp in enumerate(_pb_subs):
                    if _sp[0]=="نمط_متغير":
                        code.append("    push rax")  # حفظ مؤشر ADT
                        code.append(f"    mov rbx, [rax + {(_fi + 2) * 8}]")
                        code.append("    mov rax, rbx")
                        code.append(_emit_bind(_sp[1]))
                        code.append("    pop rax")   # استعادة مؤشر ADT
                    elif _sp[0]=="نمط_شامل":
                        pass
                code.append(f"    jmp {mk}")
                code.append(f".mskip{k}_{idx}:")
            elif نمط[0]=="نمط_بديل":
                قيم=نمط[1]
                code.append(f"    mov rax, [match_val]")
                for v in قيم:
                    if isinstance(v,int) and (v>2**31-1 or v<-2**31):
                        code+=[f"    mov r10, {v}",f"    cmp rax, r10",f"    je {mk}"]
                    else:
                        code+=[f"    cmp rax, {v}",f"    je {mk}"]
            else:
                raise Exception("نمط غير مدعوم في التوليد: "+نمط[0])
        # لا يوجد تطابق → اطبع القيمة المطابقة نفسها ثم أنهِ (القيمة الافتراضية)
        code.append("    mov rax, [match_val]")
        code.append("    call print_int")
        code += ["    mov rax, 60","    mov rdi, 0","    syscall"]
        mend=f".mend{k}"
        # — أجسام الفروع —
        for idx,(نمط,تعبير) in enumerate(فروع):
            mk=f".m{k}_{idx}"
            code.append(f"{mk}:")
            code.extend(compile_expr(تعبير,env,funcs,env_layout))
            code.append(f"    jmp {mend}")
        code.append(f"{mend}:")
        return code
    if ن=="ثنائية":
        op=expr[1]
        left=compile_expr(expr[2],env,funcs,env_layout)
        right=compile_expr(expr[3],env,funcs,env_layout)
        if op=="⊕":
            _counters["copy"]+=1; k=_counters["copy"]
            code=left+["    push rax"]+right+["    mov r11, rax","    pop r10"]
            code += [
                "    push r10","    push r11",
                "    mov rax, [r10]","    add rax, [r11]","    add rax, 8",
                "    mov rdi, rax","    call arena_alloc","    mov r12, rax",
                "    mov rax, [r10]","    add rax, [r11]","    mov [r12], rax",
                "    mov rax, [r10]","    lea rsi, [r10 + 8]","    lea rdi, [r12 + 8]",
                f".cpy1_{k}:","    test rax, rax",f"    jz .c1d_{k}",
                "    mov cl, [rsi]","    mov [rdi], cl",
                "    inc rsi","    inc rdi","    dec rax",
                f"    jmp .cpy1_{k}",f".c1d_{k}:",
                "    mov rax, [r11]","    lea rsi, [r11 + 8]",
                f".cpy2_{k}:","    test rax, rax",f"    jz .c2d_{k}",
                "    mov cl, [rsi]","    mov [rdi], cl",
                "    inc rsi","    inc rdi","    dec rax",
                f"    jmp .cpy2_{k}",f".c2d_{k}:",
                "    pop r11","    pop r10","    mov rax, r12"]
            return code
        code=left+["    push rax"]+right+["    pop rbx"]
        if op=="+": code.append("    add rax, rbx")
        elif op=="-": code.append("    sub rbx, rax"); code.append("    mov rax, rbx")
        elif op=="·": code.append("    imul rax, rbx")
        elif op=="÷": code += ["    mov rdx, 0","    mov rcx, rax","    mov rax, rbx","    div rcx"]
        return code
    if ن=="مقارنة":
        op=expr[1]
        ل=expr[2]; ي=expr[3]
        def is_textish(e):
            if e[0]=="نص": return True
            if e[0]=="ثنائية" and e[1]=="⊕": return True
            return False
        str_cmp = (op in ("=","≠")) and (is_textish(ل) or is_textish(ي))
        if op in ("∧","∨"):
            # Lazy (short-circuit) evaluation: the right operand is compiled ONLY
            # on the branch where the left operand demands it. This is required
            # because right-side expressions like رمز(نص،م) contain partial
            # index checks that must NOT execute when the loop guard م&lt;len is false.
            if op=="∧":
                _counters["scand"]+=1; k=_counters["scand"]
                left=compile_expr(ل,env,funcs,env_layout)
                code=left+["    cmp rax, 0",f"    je .sa0_{k}"]
                code.extend(compile_expr(ي,env,funcs,env_layout))
                code+=["    cmp rax, 0","    setne al",f"    jmp .sa1_{k}",
                       f".sa0_{k}:","    mov rax, 0",f".sa1_{k}:"]
                return code
            else:
                _counters["scor"]+=1; k=_counters["scor"]
                left=compile_expr(ل,env,funcs,env_layout)
                code=left+["    cmp rax, 0",f"    jne .so1_{k}"]
                code.extend(compile_expr(ي,env,funcs,env_layout))
                code+=["    cmp rax, 0","    setne al",f"    jmp .so0_{k}",
                       f".so1_{k}:","    mov rax, 1",f".so0_{k}:"]
                return code
        left=compile_expr(ل,env,funcs,env_layout)
        right=compile_expr(ي,env,funcs,env_layout)
        if str_cmp:
            _counters["scmp"]+=1; k=_counters["scmp"]
            code=left+["    push rax"]+right+["    pop rbx"]
            code += ["    mov r10, rbx","    mov r11, rax",
                     f"    cmp r10, r11",f"    je .seq_eq_{k}",
                     "    mov rdi, r10","    mov rsi, r11",
                     "    call str_eq","    test rax, rax",
                     f"    jnz .seq_eq_{k}",
                     "    mov rax, 0"]
            if op=="=":
                code += [f"    jmp .seq_end_{k}",
                         f".seq_eq_{k}:","    mov rax, 1",
                         f".seq_end_{k}:"]
            else:
                code += [f"    jmp .seq_ne_{k}",
                         f".seq_eq_{k}:","    mov rax, 0",
                         f".seq_ne_{k}:","    mov rax, 1",
                         f".seq_end_{k}:"]
            return code
        code=left+["    push rax"]+right+["    pop rbx"]
        if op=="<":
            code.append("    cmp rbx, rax")
            code.append("    mov rax, 0")
            code.append("    setl al")
        elif op==">":
            code.append("    cmp rbx, rax")
            code.append("    mov rax, 0")
            code.append("    setg al")
        elif op=="=":
            code.append("    cmp rbx, rax")
            code.append("    mov rax, 0")
            code.append("    sete al")
        elif op=="≠":
            code.append("    cmp rbx, rax")
            code.append("    mov rax, 0")
            code.append("    setne al")
        elif op=="≥":
            code.append("    cmp rbx, rax")
            code.append("    mov rax, 0")
            code.append("    setge al")
        elif op=="≤":
            code.append("    cmp rbx, rax")
            code.append("    mov rax, 0")
            code.append("    setle al")
        elif op=="∧":
            # Lazy ∧: right already compiled eagerly (non-condition usage).
            code.append("    cmp rax, 0")
            code.append(f"    je .sa0_{k}")
            code.append("    cmp rbx, 0")
            code.append("    setne al")
            code.append(f"    jmp .sa1_{k}")
            code.append(f".sa0_{k}:")
            code.append("    mov rax, 0")
            code.append(f".sa1_{k}:")
        elif op=="∨":
            # Lazy ∨: right already compiled eagerly (non-condition usage).
            code.append("    cmp rax, 0")
            code.append(f"    jne .so1_{k}")
            code.append("    cmp rbx, 0")
            code.append("    setne al")
            code.append(f"    jmp .so0_{k}")
            code.append(f".so1_{k}:")
            code.append("    mov rax, 1")
            code.append(f".so0_{k}:")
            # NOTE: these branches are only reached when the comparison path
            # pre-compiled both operands (e.g. nested ∧ inside text-equal etc.).
        return code
    if ن=="شرطي":
        _counters["cond"]+=1; k=_counters["cond"]
        code=compile_expr(expr[1],env,funcs,env_layout)
        code.append("    cmp rax, 0"); code.append(f"    je .else_{k}")
        code.extend(compile_expr(expr[2],env,funcs,env_layout))
        code.append(f"    jmp .end_{k}"); code.append(f".else_{k}:")
        code.extend(compile_expr(expr[3],env,funcs,env_layout))
        code.append(f".end_{k}:")
        return code
    if ن=="دالة":
        params=expr[1]; body=expr[2]
        bound=set(env["globals"].keys())|set(params)
        free_vars=list(get_free_vars(body,bound))
        inner_label=f"func_{funcs['idx']}"; funcs['idx']+=1
        inner_fc=[f"{inner_label}:","    push rbp","    mov rbp, rsp"]
        inner_env={"globals":env["globals"],"locals":{},"match_locals":{}}
        inner_env_layout={}
        local_counter=[len(params)]
        # المرحلة 43: حجز فتحات محلية على المكدس لمتغيرات الأنماط المرتبطة
        def collect_match_locals(node):
            if node is None or not isinstance(node, tuple): return
            ن=node[0]
            if ن=="طابق":
                for نمط,تعبير in node[2]:
                    collect_pattern_vars(نمط)
                    collect_match_locals(تعبير)
            elif ن=="دالة":
                collect_match_locals(node[2])
            elif ن=="كتلة":
                for s in node[1]: collect_match_locals(s)
                if len(node)>2: collect_match_locals(node[2])
            elif ن=="استدعاء":
                for a in node[2]: collect_match_locals(a)
            elif ن=="ثنائية":
                collect_match_locals(node[2]); collect_match_locals(node[3])
            elif ن in ("مقارنة","شرطي"):
                for a in node[2:]: collect_match_locals(a)
            elif ن=="نص":
                pass
        def collect_pattern_vars(نمط):
            if نمط is None: return
            if نمط[0]=="نمط_متغير":
                اسم=نمط[1]
                if اسم not in inner_env["locals"] and اسم not in inner_env["match_locals"]:
                    n=local_counter[0]; local_counter[0]+=1
                    inner_env["match_locals"][اسم]=(n+1)*8
            elif نمط[0]=="نمط_شرطي":
                collect_pattern_vars(نمط[1])
            elif نمط[0]=="نمط_قائمة":
                if نمط[1]:
                    for ع in نمط[1]: collect_pattern_vars(ع)
                if نمط[2]:
                    collect_pattern_vars(("نمط_متغير",نمط[2]))
            elif نمط[0]=="نمط_باني":
                for _sp in نمط[2]: collect_pattern_vars(_sp)
            elif نمط[0]=="نمط_بديل":
                pass
        for j,p in enumerate(params):
            inner_env["locals"][p]=(j+1)*8
        for ix,v in enumerate(free_vars): inner_env_layout[v]=8+ix*8
        _param_movs=[f"    mov [rbp - {(j+1)*8}], {ARG_REGS[j]}" for j,p in enumerate(params) if j<len(ARG_REGS)]
        def inner_local_layout(var):
            n=local_counter[0]; local_counter[0]+=1
            off=(n+1)*8
            inner_env["locals"][var]=off
            return off
        if body[0]=="كتلة":
            def allocate_locals(stmt):
                ن=stmt[0]
                if ن in ("أسند","نقل","عرف") and stmt[1] not in inner_env["locals"]:
                    inner_local_layout(stmt[1])
                elif ن=="لكل" and stmt[1] not in inner_env["locals"]:
                    inner_local_layout(stmt[1])
                elif ن=="كتلة":
                    for s in stmt[1]: allocate_locals(s)
                    if len(stmt)>2 and stmt[2] is not None: allocate_locals(stmt[2])
                elif ن=="طالما":
                    allocate_locals(stmt[2])
            # المرحلة 43: جمع متغيرات الأنماط المرتبطة
            collect_match_locals(body)
            for s in body[1]:
                allocate_locals(s)
            stack_size=local_counter[0]*8
            if stack_size%16!=0: stack_size+=8
            if stack_size==0: stack_size=16
            inner_fc.append(f"    sub rsp, {stack_size}")
            inner_fc.extend(_param_movs)
            tail=body[2] if len(body)>2 else None
            body_stmts=list(body[1])
            if tail is None and body_stmts and body_stmts[-1][0]=="تعبير":
                tail=body_stmts[-1][1]; body_stmts=body_stmts[:-1]
            for s in body_stmts:
                inner_fc.extend(compile_stmt_local(s,inner_env,funcs,inner_env_layout,None,False))
            if tail is not None:
                inner_fc.extend(compile_expr(tail,inner_env,funcs,inner_env_layout))
            else:
                inner_fc.append("    xor rax, rax")
        else:
            # المرحلة 43: حجز فتحات محلية لمتغيرات الأنماط في أجسام التعبيرات المباشرة
            collect_match_locals(body)
            nml=len(inner_env["match_locals"])
            stack_size=max(len(params)+nml,0)*8
            if stack_size%16!=0: stack_size+=8
            if stack_size==0: stack_size=16
            inner_fc.append(f"    sub rsp, {stack_size}")
            inner_fc.extend(_param_movs)
            inner_fc.extend(compile_expr(body,inner_env,funcs,inner_env_layout))
        inner_fc+=["    leave","    ret"]
        funcs['bodies'].extend(inner_fc)
        code=[]
        env_size=8+len(free_vars)*8
        code.append(f"    mov rdi, {env_size}")
        code.append("    call arena_alloc"); code.append("    push rax")
        code.append(f"    mov rcx, {inner_label}"); code.append("    mov [rax], rcx")
        for ix,v in enumerate(free_vars):
            offset=8+ix*8
            if env_layout and v in env_layout:
                code.append(f"    mov rcx, [r15 + {env_layout[v]}]")
            elif v in env["locals"]:
                code.append(f"    mov rcx, [rbp - {env['locals'][v]}]")
            elif v in env["globals"]:
                code.append(f"    mov rcx, [vars + {env['globals'][v]*8}]")
            code.append(f"    mov [rax + {offset}], rcx")
        code.append("    pop rax")
        return code
    if ن=="استدعاء" and expr[1] in ["نجاح","فشل","بعض","لاشيء"]:
        # المرحلة 46: Result/Option مدمجة — وسم موحَّد: نجاح=0، فشل=1، بعض=2، لاشيء=3
        _rn=expr[1]; _ra=expr[2]; _nbn=len(_ra)
        _rtag={"نجاح":0,"فشل":1,"بعض":2,"لاشيء":3}[_rn]
        code=[]
        code.append(f"    mov rdi, {16 + _nbn * 8}")
        code.append("    call arena_alloc")
        code.append("    mov r11, rax")
        code.append(f"    mov qword [r11], {_nbn}")
        code.append(f"    mov qword [r11 + 8], {_rtag}")
        for _idx, _arg in enumerate(_ra):
            code.extend(compile_expr(_arg, env, funcs, env_layout))
            code.append(f"    mov qword [r11 + {(_idx + 2) * 8}], rax")
        code.append("    mov rax, r11")
        return code
    if ن=="استدعاء":
        # المرحلة 44: استدعاء باني نوع جبري (قبل مسار الاستدعاء العادي)
        _nb_name=expr[1]; _nb_args=expr[2]
        _nb_found=False; _nb_tag=-1
        for _tname, _builders in _type_registry.items():
            for _bi, (_bn, _ba) in enumerate(_builders):
                if _bn == _nb_name:
                    _nb_found=True; _nb_tag=_bi
                    break
            if _nb_found: break
        if _nb_found:
            _nbn=len(_nb_args); code=[]
            code.append(f"    mov rdi, {16 + _nbn * 8}")
            code.append("    call arena_alloc")
            code.append("    mov r11, rax")
            code.append(f"    mov qword [r11], {_nbn}")
            code.append(f"    mov qword [r11 + 8], {_nb_tag}")
            for _idx, _arg in enumerate(_nb_args):
                code.extend(compile_expr(_arg, env, funcs, env_layout))
                code.append(f"    mov qword [r11 + {(_idx + 2) * 8}], rax")
            code.append("    mov rax, r11")
            return code
    if ن=="استدعاء":
        اسم=expr[1]; args=expr[2]
        if isinstance(اسم, tuple) and len(اسم)==3 and اسم[0]=="استدعاء":
            # المرحلة 50: تطبيق متسلسل f(a)(b) — اسم ليس نصًا بل استدعاء آخر
            code=[]
            for arg in args:
                code.extend(compile_expr(arg,env,funcs,env_layout))
                code.append("    push rax")
            _inner_fn = اسم[1]
            code.extend(compile_expr(اسم,env,funcs,env_layout))
            for j in range(len(args)-1,-1,-1):
                if j<len(ARG_REGS): code.append(f"    pop {ARG_REGS[j]}")
            code.append("    push rbx")
            code.append("    mov rbx, rax")   # rbx = closure الناتجة من f(a)
            code+=["    mov r15, rbx","    mov r10, [rbx]","    call r10","    pop rbx"]
            return code
        # المرحلة 45: استدعاء دالة سمة — dispatch حسب نوع الوسيط الأول
        _tr_fn = اسم in [fn for _d in _trait_registry.values() for fn, _ in _d]
        if _tr_fn and args:
            _tr_type = None
            if args[0][0]=="استدعاء":
                for _tn, _bs in _type_registry.items():
                    for _bn, _ba in _bs:
                        if _bn == args[0][1]:
                            _tr_type = _tn; break
                    if _tr_type: break
            if _tr_type is None:
                # وسيط متغير: إن وُجد تطبيق واحد فقط لهذه الدالة — استخدمه
                _hits=[(sn,tn) for (sn,tn),im in _impl_registry.items() if اسم in im]
                if len(_hits)==1: _tr_type=_hits[0][1]
            if _tr_type is None:
                # المرحلة 45 P9: دالة عامة λس.احصل(س)… — س نوعه مجهول وقت الترجمة
                # استخدم أول impl مرشَّح closure له مبنية فعلاً في globals هذا التجميع
                for (_sn,_tn),_im in _impl_registry.items():
                    if اسم in _im:
                        _d = f"__trait__{_sn}__{_tn}__{اسم}"
                        if _d in env['globals']:
                            _tr_type = _tn; break
            if _tr_type:
                _key=None
                for (sn,tn),im in _impl_registry.items():
                    if tn==_tr_type and اسم in im: _key=(sn,tn); break
                if _key:
                    داخلي = f"__trait__{_key[0]}__{_key[1]}__{اسم}"
                    code=[]
                    for _idx, _arg in enumerate(args):
                        code.extend(compile_expr(_arg, env, funcs, env_layout))
                        if _idx < len(ARG_REGS):
                            code.append(f"    mov {ARG_REGS[_idx]}, rax")
                    code.append(f"    mov r10, [vars + {env['globals'][داخلي]*8}]")
                    code.append("    push r15")
                    code.append("    mov r15, r10")
                    code.append("    mov r10, [r10]")
                    code.append("    call r10")
                    code.append("    pop r15")
                    return code
        if اسم=="أس" or اسم=="أُس":        اسم=expr[1]; args=expr[2]
        if اسم=="أس" or اسم=="أُس":
            # المرحلة 44: أُس حتمي — exp() بالفاصلة الثابتة Q32.32
            # خوارزمية: k=round(x·INVLN2/2^64)، r=x−k·LN2، Horner درجة 12، ثم إزاحة 2^k
            if len(args)!=1: raise Exception("أُس تأخذ وسيطاً واحداً")
            _counters["empty"]+=1; k=_counters["empty"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code += ["    push rdi", "    push r8"]
            code += [
                "    mov rbx, rax",                       # rbx = x (Q32.32)
                "    mov rax, rbx",
                "    mov rdx, 6196328019",                 # INVLN2_Q32 (mov r64, imm64)
                "    imul rdx",                            # rdx:rax = x·INVLN2 (Q64.64)
                "    mov r8, 2147483648",                  # 2^31 — تقريب لأقرب (يلزم r8 لأن add r64,imm لا يقبل 2^31)
                "    add rax, r8",
                "    adc rdx, 0",
                "    mov rdi, rdx",                        # rdi = k
                "    mov rax, rdi",
                "    mov rdx, 2977044472",                 # LN2_Q32
                "    imul rdx",                            # rdx:rax = k·LN2 (rdx صغير — تجاهله)
                "    sub rbx, rax",                        # rbx = r = x−k·LN2 (Q32.32)
                "    mov rax, 9",                          # c12
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, 108",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, 1184",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, 11836",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, 106522",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, 852176",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, 5965232",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, 35791394",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, 178956971",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, 715827883",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    add rax, r8",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    mov r8, 4294967296", "    add rax, r8",
                "    mov rdx, rbx", "    imul rdx", "    mov rcx, rax", "    shr rcx, 32", "    shl rdx, 32", "    or rdx, rcx", "    mov rax, rdx", "    mov r8, 4294967296", "    add rax, r8",
                f"    mov rcx, rdi",                        # rcx = k (محفوظة في rdi)
                f"    test rcx, rcx", f"    jns .uexp_pos_{k}",
                f"    neg rcx", f"    sar rax, cl", f"    jmp .uexp_done_{k}",
                f".uexp_pos_{k}:", f"    shl rax, cl",
                f".uexp_done_{k}:",
            ]
            code.append("    pop r8")
            code.append("    pop rdi")
            return code
        if اسم=="قوة":
            # المرحلة 40 (FFI): قوة(أ، ب) — أس صحيح: ب ضربات
            if len(args)!=2: raise Exception("قوة تأخذ وسيطين")
            _counters["empty"]+=1; k=_counters["empty"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs,env_layout))
            code += [
                "    mov rcx, rax",      # rcx = الأس ب
                "    pop rax",            # rax = الأساس أ
                "    mov r8, 1",          # result = 1
                "    test rcx, rcx",f"    jz .pow_done_{k}",
                f".pow_loop_{k}:","    imul r8, rax",
                "    dec rcx",f"    jnz .pow_loop_{k}",
                f".pow_done_{k}:","    mov rax, r8",
            ]
            return code
        if اسم=="جذر" or اسم=="أرضية" or اسم=="مطلق":
            # المرحلة 40 (FFI): جذر/أرضية/مطلق — تنفيذ أصيل بدون libc
            if len(args)!=1: raise Exception(f"{اسم} تأخذ وسيطاً واحداً")
            _counters["empty"]+=1; k=_counters["empty"]
            code=compile_expr(args[0],env,funcs,env_layout)
            if اسم=="مطلق":
                code += ["    test rax, rax",f"    jns .abs_pos_{k}","    neg rax",f".abs_pos_{k}:"]
            elif اسم=="أرضية":
                code += ["    nop"]  # الأعداد الصحيحة: أرضية(x)=x بالفعل
            else:  # جذر: جذر صحيح bit-by-bit (أصلي بدون libc): result|=step إذا result²≤x
                code += [
                    "    test rax, rax",f"    jns .sqrt_pos_{k}","    mov rax, 60","    mov rdi, 1","    syscall",
                    f".sqrt_pos_{k}:",                    "    push r11","    mov r11, rax",  # r11 = x (محفوظ لأن syscall يتلفه)
                    "    mov r10, 0",                     # result في r10 (imul الأحادي يتلف rax)
                    "    mov r8, 1", "    shl r8, 30",     # step = 2^30 (أكبر بت جذر لعدد 62-بت)
                    f".sq_loop_{k}:",
                    "    mov r9, r10", "    or r9, r8",     # r9 = المرشّح result | step
                    "    mov rax, r9", "    imul rax",         # rdx:rax = المرشّح² (الصيغة الأحادية تعطي حاصل الضرب الكامل 128-بت)
                    "    test rdx, rdx", f"    jnz .sq_skip_{k}",  # التربيع تجاوز 64-بت → تخطَّ
                    "    cmp rax, r11", f"    ja .sq_skip_{k}",
                    "    mov r10, r9",                     # result = المرشّح
                    f".sq_skip_{k}:","    shr r8, 1", "    test r8, r8", f"    jnz .sq_loop_{k}",
                    "    mov rax, r10",                    # أعِد result في rax
                    "    pop r11",                         # استعد r11
                ]
            return code
        if اسم=="رأس":
            if len(args)!=1: raise Exception("رأس تأخذ وسيطاً واحداً")
            _counters["empty"]+=1; k=_counters["empty"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code += ["    mov rbx, [rax]","    test rbx, rbx",f"    jz .hemp_{k}",
                     "    mov rax, [rax + 16]",f"    jmp .hdne_{k}",
                     f".hemp_{k}:","    mov rax, 60","    mov rdi, 1","    syscall",
                     f".hdne_{k}:"]
            return code
        if اسم=="ذيل":
            if len(args)!=1: raise Exception("ذيل تأخذ وسيطاً واحداً")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code += ["    mov rcx, [rax]","    test rcx, rcx",f"    jz .taihemp_{k}",
                "    push rax","    dec rcx","    mov rdi, rcx",
                "    shl rdi, 3","    add rdi, 16",
                "    call arena_alloc","    mov r12, rax","    mov [rax], rcx",
                "    mov qword [rax + 8], 0",
                "    pop rsi","    add rsi, 24","    lea rdi, [r12 + 16]",
                f".tcopy_{k}:","    test rcx, rcx",f"    jz .tcd_{k}",
                "    mov rdx, [rsi]","    mov [rdi], rdx",
                "    add rsi, 8","    add rdi, 8","    dec rcx",
                f"    jmp .tcopy_{k}",f".tcd_{k}:",
                "    mov rax, r12",f"    jmp .taine_{k}",
                f".taihemp_{k}:","    mov rax, 60","    mov rdi, 1","    syscall",
                f".taine_{k}:"]
            return code
        if اسم=="طول":
            if len(args)!=1: raise Exception("طول تأخذ وسيطاً واحداً")
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    mov rax, [rax]")
            return code
        if اسم=="حجم":
            if len(args)!=1: raise Exception("حجم تأخذ وسيطاً واحداً")
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    mov rax, [rax]")
            return code
        if اسم=="أحص":
            if len(args)!=1: raise Exception("أحص تأخذ وسيطاً واحداً")
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    mov rax, [rax]")
            return code
        if اسم=="مجموع_قائمة":
            if len(args)!=1: raise Exception("مجموع_قائمة تأخذ وسيطاً واحداً")
            _counters["loop"]+=1; k=_counters["loop"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code += [
                "    mov rcx, [rax]",
                "    xor rbx, rbx",
                f".sl_loop_{k}:",
                "    test rcx, rcx",
                f"    jz .sl_done_{k}",
                "    mov rdx, rcx","    dec rdx",
                "    add rbx, [rax + rdx * 8 + 16]",
                "    dec rcx",
                f"    jmp .sl_loop_{k}",
                f".sl_done_{k}:",
                "    mov rax, rbx",
            ]
            return code
        if اسم=="ألحق":
            if len(args)!=2: raise Exception("ألحق تأخذ وسيطين")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs,env_layout))
            code += ["    mov r11, rax","    pop r10","    push r10","    push r11",
                "    mov rax, [r10]","    add rax, 1",
                "    mov rdi, rax","    shl rdi, 3","    add rdi, 16",
                "    call arena_alloc","    mov r12, rax",
                "    mov rax, [r10]","    add rax, 1","    mov [r12], rax",
                "    mov qword [r12 + 8], 0",
                "    mov rax, [r10]","    lea rsi, [r10 + 16]","    lea rdi, [r12 + 16]",
                f".lcpy_{k}:","    test rax, rax",f"    jz .lcd_{k}",
                "    mov rcx, [rsi]","    mov [rdi], rcx",
                "    add rsi, 8","    add rdi, 8","    dec rax",
                f"    jmp .lcpy_{k}",f".lcd_{k}:","    mov [rdi], r11",
                "    pop r11","    pop r10","    mov rax, r12"]
            return code
        if اسم=="رمز":
            if len(args)!=2: raise Exception("رمز تأخذ وسيطين")
            _counters["empty"]+=1; k=_counters["empty"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs,env_layout))
            code += ["    pop rbx","    mov rcx, rax",
                     f"    test rcx, rcx",f"    jns .rc_pos_{k}",
                     "    mov rdx, [rbx]","    add rcx, rdx",
                     f".rc_pos_{k}:",
                     "    mov rax, [rbx]","    test rcx, rcx",f"    jl .ch_err_idx_{k}",f"    cmp rcx, rax",f"    jge .ch_err_{k}",
                     "    movzx rax, byte [rbx + rcx + 8]",
                     "    test al, 0x80",f"    jz .ch_ok_{k}",
                     "    movzx rsi, al","    and esi, 0xE0",
                     "    cmp esi, 0xC0",f"    jl .ch_invalid_{k}",
                     "    cmp esi, 0xE0",f"    je .ch_two_{k}",
                     "    cmp esi, 0xF0",f"    jb .ch_three_{k}",
                     "    movzx rax, byte [rbx + rcx + 8]",
                     "    and al, 0x07","    shl eax, 12",
                     "    movzx rsi, byte [rbx + rcx + 9]",
                     "    and esi, 0x3F","    shl esi, 6",
                     "    or eax, esi",
                     "    movzx rsi, byte [rbx + rcx + 10]",
                     "    and esi, 0x3F","    shl esi, 6",
                     "    or eax, esi",
                     "    movzx rsi, byte [rbx + rcx + 11]",
                     "    and esi, 0x3F",
                     "    or eax, esi",f"    jmp .ch_ok_{k}",
                     f".ch_three_{k}:",
                     "    movzx rax, al","    and al, 0x0F","    shl eax, 6",
                     "    movzx rsi, byte [rbx + rcx + 9]",
                     "    and esi, 0x3F","    shl esi, 6",
                     "    or eax, esi",
                     "    movzx rsi, byte [rbx + rcx + 10]",
                     "    and esi, 0x3F",
                     "    or eax, esi",f"    jmp .ch_ok_{k}",
                     f".ch_two_{k}:",
                     "    movzx rax, al","    and al, 0x1F","    shl eax, 6",
                     "    movzx rsi, byte [rbx + rcx + 9]",
                     "    and esi, 0x3F",
                     "    or eax, esi",f"    jmp .ch_ok_{k}",
                     f".ch_invalid_{k}:","    mov rax, 0xFFFD",f"    jmp .ch_ok_{k}",
                     f".ch_err_idx_{k}:",f".ch_err_{k}:","    mov rax, 60","    mov rdi, 1","    syscall",
                     f".ch_ok_{k}:"]
            return code
        if اسم=="نص":
            if len(args)!=1: raise Exception("نص تأخذ وسيطاً واحداً")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code += [
                "    push r12",
                "    test rax, rax",f"    jns .npos_{k}",
                "    neg rax","    mov r12, 1",f"    jmp .psign_{k}",
                f".npos_{k}:",
                "    mov r12, 0",
                f".psign_{k}:",
                "    mov rbx, 10","    mov rcx, 0",
                "    lea rdi, [num_buf + 31]",
                f".nts_{k}:",
                "    xor rdx, rdx","    div rbx",
                "    add dl, '0'","    dec rdi","    mov [rdi], dl",
                "    inc rcx","    test rax, rax",
                f"    jnz .nts_{k}",
                "    test r12, r12",f"    jz .nskip2_{k}",
                "    dec rdi","    mov byte [rdi], 45","    inc rcx",
                f".nskip2_{k}:",
                "    push rdi","    push rcx",
                "    mov rax, rcx","    add rax, 8",
                "    mov rdi, rax","    call arena_alloc",
                "    pop rcx","    mov [rax], rcx",
                "    pop rsi","    push rax",
                "    lea rdi, [rax + 8]",
                f".ntc_{k}:",
                "    test rcx, rcx",f"    jz .ntd_{k}",
                "    mov al, [rsi]","    mov [rdi], al",
                "    inc rsi","    inc rdi","    dec rcx",
                f"    jmp .ntc_{k}",f".ntd_{k}:",
                "    pop rax",
                "    pop r12",
            ]
            return code
        if اسم=="عدد":
            if len(args)!=1: raise Exception("عدد تأخذ وسيطاً واحداً")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code += [
                "    mov rcx, [rax]","    lea rsi, [rax + 8]",
                "    mov rax, 0","    mov rbx, 10",
                f".std_{k}:",
                "    test rcx, rcx",f"    jz .sdd_{k}",
                "    movzx rdx, byte [rsi]",
                "    cmp dl, '0'",f"    jl .std_skip_{k}",
                "    cmp dl, '9'",f"    jg .std_skip_{k}",
                "    sub dl, '0'",
                "    imul rax, rbx","    add rax, rdx",
                f".std_skip_{k}:",
                "    inc rsi","    dec rcx",
                f"    jmp .std_{k}",f".sdd_{k}:",
            ]
            return code
        code=[]
        for arg in args:
            code.extend(compile_expr(arg,env,funcs,env_layout))
            code.append("    push rax")
        if اسم=="فتح":
            if len(args)!=1: raise Exception("فتح تأخذ وسيطاً واحداً")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code += [
                "    mov rcx, [rax]",
                "    lea rsi, [rax + 8]",
                "    lea rdi, [file_path_buf]",
                f".fp_c_{k}:",
                "    test rcx, rcx",
                f"    jz .fp_d_{k}",
                "    mov al, [rsi]",
                "    mov [rdi], al",
                "    inc rsi",
                "    inc rdi",
                "    dec rcx",
                f"    jmp .fp_c_{k}",
                f".fp_d_{k}:",
                "    mov byte [rdi], 0",
                "    lea rdi, [file_path_buf]",
                "    mov rsi, 66",
                "    mov rdx, 420",
                "    mov rax, 2",
                "    push rcx",
                "    syscall",
                "    pop rcx",
            ]
            return code
        if اسم=="عروة":
            code = [
                "    mov rdi, 2",
                "    mov rsi, 1",
                "    mov rdx, 0",
                "    mov rax, 41",
                "    syscall",
            ]
            return code
        if اسم=="اكتب_ملف":
            if len(args)!=2: raise Exception("اكتب_ملف تأخذ وسيطين")
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs,env_layout))
            code += [
                "    mov rdx, [rax]",
                "    lea rsi, [rax + 8]",
                "    pop rdi",
                "    push rcx",
                "    mov rax, 1",
                "    syscall",
                "    pop rcx",
                "    mov rax, rdx",
            ]
            return code
        if اسم=="اقرأ_ملف":
            if len(args)!=2: raise Exception("اقرأ_ملف تأخذ وسيطين")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs,env_layout))
            code += [
                "    mov rdx, rax",
                "    pop rdi",
                "    lea rsi, [file_buf]",
                "    push rcx",
                "    mov rax, 0",
                "    syscall",
                "    pop rcx",
                "    mov rcx, rax",
                "    mov rdi, rax",
                "    add rdi, 8",
                "    call arena_alloc",
                "    mov [rax], rcx",
                "    push rax",
                "    lea rsi, [file_buf]",
                "    lea rdi, [rax + 8]",
                "    mov rdx, rcx",
                f".fr_c_{k}:",
                "    test rdx, rdx",
                f"    jz .fr_d_{k}",
                "    mov cl, [rsi]",
                "    mov [rdi], cl",
                "    inc rsi",
                "    inc rdi",
                "    dec rdx",
                f"    jmp .fr_c_{k}",
                f".fr_d_{k}:",
                "    pop rax",
            ]
            return code
        if اسم=="اختم":
            if len(args)!=1: raise Exception("اختم تأخذ وسيطاً واحداً")
            code=compile_expr(args[0],env,funcs,env_layout)
            code += [
                "    push rcx",
                "    mov rax, 3",
                "    syscall",
                "    pop rcx",
            ]
            return code
        if اسم=="توازي":
            if len(args)!=2: raise Exception("توازي تأخذ وسيطين: دالة وقيمة")
            _counters["tq"]+=1; k=_counters["tq"]
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs,env_layout))
            code += [
                "    push rax",
                f"    lea rsi, [rel t_task_{k}]",
                "    pop rax",
                "    mov [rsi + 8], rax",
                "    pop rax",
                "    mov [rsi], rax",
                "    xor rdi, rdi",
                "    mov rsi, 65536",
                "    mov rdx, 3",
                "    mov r10, 34",
                "    xor r8, r8",
                "    xor r9, r9",
                "    mov rax, 9",
                "    syscall",
                "    test rax, rax",
                "    js mmfail",
                f"    mov [t_task_{k} + 24], rax",
                "    add rax, 65536",
                "    sub rax, 16",
                "    mov rsi, rax",
                f"    lea r14, [rel t_task_{k}]",
                "    mov rdi, 1809",
                "    xor rdx, rdx",
                "    xor r10, r10",
                "    xor r8, r8",
                "    xor r9, r9",
                "    mov rax, 56",
                "    syscall",
                "    test rax, rax",
                f"    jnz t_parent_{k}",
                f"    lea r12, [rel t_after_{k}]",
                "    push r12",
                f"    mov r15, [r14]",
                f"    mov r10, [r15]",
                f"    mov rdi, [r14 + 8]",
                f"    call r10",
                f"t_after_{k}:",
                f"    mov [r14 + 16], rax",
                f"    mov rdi, [r14 + 24]",
                "    mov rsi, 0",
                "    xor rdx, rdx",
                "    xor r10, r10",
                "    mov rax, 231",
                "    syscall",
                f"t_parent_{k}:",
                f"    mov [t_task_{k} + 24], rax",
                f"    mov edi, [t_task_{k} + 24]",
                f"    lea rsi, [rel t_status_{k}]",
                "    xor rdx, rdx",
                "    xor r10, r10",
                "    mov rax, 61",
                "    syscall",
                f"    mov rax, [t_task_{k} + 16]",
            ]
            return code
        if اسم=="قناة":
            # المرحلة 41: قناة() — pipe2 (syscall 293) بدون libc
            # أنشئ كتلة arena من 16 بايت: [0]=read_fd, [8]=write_fd
            if len(args)!=0: raise Exception("قناة بلا وسائط")
            _counters["empty"]+=1; k=_counters["empty"]
            code = [
                "    mov rdi, 16",
                "    call arena_alloc",        # rax = ptr to {rd_fd, wr_fd}
                "    push rbx",                # احفظ rbx (callee-saved)
                "    mov rbx, rax",            # rbx = ptr
                "    lea rdi, [rel fds_tmp]",  # buffer ثابتة للـ fd
                "    xor rsi, rsi",            # flags = 0
                "    push rcx",
                "    mov rax, 293",            # pipe2
                "    syscall",
                "    pop rcx",
                "    movsxd rax, dword [rel fds_tmp]",     # rd_fd (قراءة int32 → int64)
                "    movsxd rcx, dword [rel fds_tmp + 4]", # wr_fd
                "    mov [rbx], rax",          # [+0] = read fd
                "    mov [rbx + 8], rcx",      # [+8] = write fd
                "    mov rax, rbx",
                "    pop rbx",
            ]
            return code
        if اسم=="أرسل":
            # المرحلة 41: أرسل(ق، قيمة) — write(wr_fd, &value, 8)
            if len(args)!=2: raise Exception("أرسل تأخذ وسيطين: قناة وقيمة")
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rbx")        # احفظ rbx
            code.append("    mov rbx, rax")    # rbx = ptr قناة
            code.extend(compile_expr(args[1],env,funcs,env_layout))
            code += [
                "    mov [rel chan_tmp], rax", # خزّن القيمة في buffer ثابتة
                "    mov edi, [rbx + 8]",      # wr_fd من قناة [+8]
                "    lea rsi, [rel chan_tmp]", # buf = القيمة
                "    mov rdx, 8",
                "    push rcx",
                "    mov rax, 1",              # sys_write
                "    syscall",
                "    pop rcx",
                "    mov rax, 8",              # أعِد عدد البايتات المكتوبة
                "    pop rbx",
            ]
            return code
        if اسم=="استقبل":
            # المرحلة 41: استقبل(ق) — read(rd_fd, &buf, 8)
            if len(args)!=1: raise Exception("استقبل تأخذ وسيطاً واحداً")
            code=compile_expr(args[0],env,funcs,env_layout)
            code += [
                "    push rbx",                # احفظ rbx
                "    mov rbx, rax",            # rbx = ptr قناة
                "    mov edi, [rbx]",          # rd_fd من قناة [+0]
                "    lea rsi, [rel chan_tmp]", # buf ثابتة
                "    mov rdx, 8",
                "    push rcx",
                "    xor rax, rax",            # sys_read
                "    syscall",
                "    pop rcx",
                "    mov rax, [rel chan_tmp]", # أعِد القيمة المستقبَلة
                "    pop rbx",
            ]
            return code
        for j in range(len(args)-1,-1,-1):
            if j<len(ARG_REGS): code.append(f"    pop {ARG_REGS[j]}")
        if اسم in env["locals"]:
            code.append(f"    mov r10, [rbp - {env['locals'][اسم]}]")
        elif اسم in env["globals"]:
            code.append(f"    mov r10, [vars + {env['globals'][اسم]*8}]")
        else: raise Exception(f"دالة غير معرفة: {اسم}")
        code.append("    push r15")
        code.append("    mov r15, r10")
        code.append("    mov r10, [r10]")
        code.append("    call r10")
        code.append("    pop r15")
        return code
    raise Exception(f"تعبير غير مدعوم: {ن}")

# ═══════════════════════════════════════════════════════════
# Statement Compiler
# ═══════════════════════════════════════════════════════════
def stmt_writes_local(stmt, env):
    ن=stmt[0]
    if ن in ("أسند","نقل","عرف","لكل"):
        if ن=="لكل": return stmt[1] in env["locals"]
        return stmt[1] in env["locals"]
    return False

def compile_stmt(stmt, env, funcs, type_env, is_last=False):
    return compile_stmt_local(stmt, env, funcs, {}, type_env, is_last)

def compile_stmt_local(stmt, env, funcs, locals_layout, type_env, is_last):
    ن=stmt[0]
    if ن in ["أسند","عرف"]:
        اسم=stmt[1]
        if اسم not in env["locals"] and اسم not in env["globals"]: env["globals"][اسم]=len(env["globals"])
        code=compile_expr(stmt[2],env,funcs,locals_layout)
        if اسم in env["locals"]:
            code.append(f"    mov [rbp - {env['locals'][اسم]}], rax")
        else:
            if اسم not in env["globals"]: env["globals"][اسم]=len(env["globals"])
            code.append(f"    mov [vars + {env['globals'][اسم]*8}], rax")
        return code
    if ن=="نقل":
        هدف=stmt[1]; مصدر=stmt[2]
        if هدف not in env["globals"]: env["globals"][هدف]=len(env["globals"])
        if مصدر not in env["globals"]: raise Exception(f"متغير غير معرف: {مصدر}")
        code=[]
        code.append(f"    mov rax, [vars + {env['globals'][مصدر]*8}]")
        code.append(f"    mov [vars + {env['globals'][هدف]*8}], rax")
        code.append(f"    mov qword [vars + {env['globals'][مصدر]*8}], 0")
        return code
    if ن=="اطبع":
        e=stmt[1]
        code=compile_expr(e,env,funcs,locals_layout)
        نوع=استنتاج_نوع(e, type_env)
        code.append("    call print_str" if نوع=="نص" else "    call print_int")
        return code
    if ن=="استدعاء_جملة":
        return compile_expr(stmt[1], env, funcs, locals_layout)
    if ن=="تعبير":
        return compile_expr(stmt[2], env, funcs, locals_layout)
    if ن=="كتلة":
        code=[]
        body_stmts=list(stmt[1])
        tail=stmt[2] if len(stmt)>2 else None
        if tail is None and body_stmts and body_stmts[-1][0]=="تعبير":
            tail=body_stmts[-1][2]; body_stmts=body_stmts[:-1]
        for i,s in enumerate(body_stmts):
            _is_last=(i==len(body_stmts)-1) and (tail is None)
            code.extend(compile_stmt_local(s,env,funcs,locals_layout,type_env,_is_last))
        if tail is not None:
            code.extend(compile_expr(tail,env,funcs,locals_layout))
        else:
            code.append("    xor rax, rax")
        return code
    if ن=="طالما":
        _counters["loop"]+=1; k=_counters["loop"]
        code=[f".while_{k}:"]
        code.extend(compile_expr(stmt[1],env,funcs,locals_layout))
        code.append("    cmp rax, 0")
        code.append(f"    je .wend_{k}")
        code.extend(compile_stmt_local(stmt[2],env,funcs,locals_layout,type_env,False))
        code.append(f"    jmp .while_{k}")
        code.append(f".wend_{k}:")
        return code
    if ن=="لكل":
        _counters["loop"]+=1; k=_counters["loop"]
        متغير=stmt[1]; قائمة=stmt[2]; جسم=stmt[3]
        if متغير not in env["locals"] and متغير not in env["globals"]: env["globals"][متغير]=len(env["globals"])
        code=[]
        code.extend(compile_expr(قائمة,env,funcs,locals_layout))
        code += ["    mov r14, [rax]","    lea rbx, [rax + 16]",
                 f".fe_{k}:","    test r14, r14",f"    jz .feend_{k}",
                 "    mov rax, [rbx]"]
        if متغير in env["locals"]:
            code.append(f"    mov [rbp - {env['locals'][متغير]}], rax")
        else:
            code.append(f"    mov [vars + {env['globals'][متغير]*8}], rax")
        code += ["    push rbx","    push r14"]
        code.extend(compile_stmt_local(جسم,env,funcs,locals_layout,type_env,False))
        code += ["    pop r14","    pop rbx","    add rbx, 8","    dec r14",
                 f"    jmp .fe_{k}",f".feend_{k}:"]
        return code
    if ن=="تعريف_سمة":
        # المرحلة 45: السمة مسجّلة في _trait_registry أثناء التحليل — لا كود
        return []
    if ن=="تطبيق_سمة":
        # المرحلة 45: الدوال الداخلية تُولَّد في compile_program — لا كود هنا
        return []
    if ن=="تعريف_نوع":
        # المرحلة 44: تسجيل النوع الجبري
        اسم=stmt[1]; بناة=stmt[2]
        _type_registry[اسم]=بناة
        # اسجل كل باني كمتغير عام (للاستدعاء لاحقًا)
        for اسم_باني, عدد in بناة:
            if اسم_باني not in env["globals"]:
                env["globals"][اسم_باني]=len(env["globals"])
        return []
    if ن=="طابق":
        return compile_expr(stmt, env, funcs, locals_layout)
    raise Exception(f"بيان غير مدعوم: {ن}")

# ═══════════════════════════════════════════════════════════
# Program Compiler
# ═══════════════════════════════════════════════════════════
def compile_program(برنامج):
    # المرحلة 48: توسيع الماكروزات قبل التحقق من الملكية
    try:
        from phase48_macros import وسّع_برنامج, إعادة_عداد_التوسعات
        إعادة_عداد_التوسعات()
        برنامج = وسّع_برنامج(برنامج)
    except ImportError:
        pass
    check_ownership(برنامج)
    asm=["global _start","section .bss",
         "    vars resq 256","    num_buf resb 32","    negflag resb 1","    read_buf resb 256",
         "    match_val resq 1","    match_tmp resq 1",   # المرحلة 43: pattern matching
         "    file_path_buf resb 256",
         "    file_buf resb 4096",
         "    arena_ptr resq 1","    arena_mem resb 262144",
         "    fds_tmp resq 2",        # مؤقت للقنوات: [0]=read_fd [1]=write_fd
         "    chan_tmp resq 1",       # مؤقت للقيمة المرسلة/المستقبلة (8 بايت)
        "    future_registry resq 1",    # المرحلة 47: جدول Futures
        "    epoll_events_buf resq 1",   # المرحلة 47: buffer أحداث epoll
        "    future_wake_buf resq 1"]    # المرحلة 47: buffer إيقاظ eventfd
    for k in range(1, 17):
        asm.append(f"    t_task_{k} resq 4")
        asm.append(f"    t_status_{k} resq 1")
    asm.append("")
    asm.append("section .text")
    asm += ["_start_init:",
            "    lea rax, [arena_mem]",
            "    add rax, 7",
            "    and rax, -8",
            "    mov [arena_ptr], rax",
            "    jmp _start",
            "mmfail:","    mov rax, 60","    mov rdi, 2","    syscall", ""]
    asm += ["arena_alloc:","    mov rax, [arena_ptr]",
            "    add rdi, 15","    and rdi, -16",
            "    add [arena_ptr], rdi","    ret",""]
    # المرحلة 43: علم السالب محلي على المكدس (آمن مع الخيوط المتوازية)
    asm += ["print_int:",
        "    sub rsp, 8",
        "    mov byte [rsp], 0",
        "    push rax","    push rbx","    push rcx",
        "    push rdx","    push rsi","    push rdi",
        "    test rax, rax","    jns .pi_pos",
        "    neg rax","    mov byte [rsp + 48], 1",
        ".pi_pos:",
        "    mov rbx, 10","    mov rcx, 0",
        "    lea rdi, [num_buf + 31]",
        ".piloop:",
        "    xor rdx, rdx","    div rbx","    add dl, '0'",
        "    dec rdi","    mov [rdi], dl",
        "    inc rcx","    test rax, rax","    jnz .piloop",
        "    cmp byte [rsp + 48], 1","    jne .pi_skip_neg",
        "    dec rdi","    mov byte [rdi], 45","    inc rcx",
        ".pi_skip_neg:",
        "    mov rsi, rdi","    mov byte [rsi + rcx], 10","    inc rcx",
        "    mov rdi, 1","    mov rax, 1","    mov rdx, rcx","    syscall",
        "    pop rdi","    pop rsi","    pop rdx",
        "    pop rcx","    pop rbx","    pop rax",
        "    add rsp, 8","    ret",""]
    asm += ["str_eq:",
        "    mov rcx, [rdi]","    mov rdx, [rsi]",
        "    cmp rcx, rdx","    jne str_eq_ne",
        "    add rdi, 8","    add rsi, 8",
        "str_eq_loop:",
        "    test rcx, rcx","    jz str_eq_eq",
        "    mov al, [rdi]","    cmp al, [rsi]",
        "    jne str_eq_ne",
        "    inc rdi","    inc rsi","    dec rcx",
        "    jmp str_eq_loop",
        "str_eq_eq:",
        "    mov rax, 1","    ret",
        "str_eq_ne:",
        "    mov rax, 0","    ret",""]
    asm += ["print_str:",
        "    push rax","    push rdx","    push rsi","    push rdi",
        "    mov rsi, rax","    add rsi, 8","    mov rdx, [rax]",
        "    mov rdi, 1","    mov rax, 1","    syscall",
        "    mov rsi, nl_ptr","    mov rdx, 1",
        "    mov rdi, 1","    mov rax, 1","    syscall",
        "    pop rdi","    pop rsi","    pop rdx","    pop rax","    ret",""]
    asm += ["section .data","nl_ptr: db 10","section .text",""]
    asm += ["_start:","    lea rax, [arena_mem]","    add rax, 7","    and rax, -8","    mov [arena_ptr], rax",""]
    type_env={}
    # المرحلة 46: أنواع Result و Option مدمجة — لا تحتاج تعريف_نوع
    globals()['_type_registry']['نتيجة']=[('نجاح', 1), ('فشل', 1)]
    globals()['_type_registry']['خيار']=[('بعض', 1), ('لاشيء', 0)]
    for بيان in برنامج:
        if بيان[0] in ["عرف","أسند"]:
            type_env[بيان[1]]=استنتاج_نوع(بيان[2], type_env)
        elif بيان[0]=="نقل":
            type_env[بيان[1]] = type_env.get(بيان[2], "مجهول")
    var_map={}; funcs={"idx":0,"bodies":[]}; global_code=[]
    env={"globals":var_map,"locals":{}}
    var_map={}; funcs={"idx":0,"bodies":[]}; global_code=[]
    env={"globals":var_map,"locals":{}}
    # المرحلة 45: ولّد دوال داخلية لأجسام تطبيقات السمات
    for بيان in برنامج:
        if بيان[0]=="تطبيق_سمة":
            اسم_سمة=بيان[1]; اسم_نوع=بيان[2]; تطبيقات=بيان[3]
            for اسم_دالة, وسائط, تعبير in تطبيقات:
                داخلي = f"__trait__{اسم_سمة}__{اسم_نوع}__{اسم_دالة}"
                if داخلي not in env["globals"]:
                    env["globals"][داخلي]=len(env["globals"])
                params=وسائط
                bound=set(env["globals"].keys())|set(params)
                free_vars=[]
                for _fv in get_free_vars(تعبير,bound):
                    _n= _fv[1] if isinstance(_fv, tuple) else _fv
                    _name= _n if isinstance(_n, str) else (_n[1] if isinstance(_n, tuple) else None)
                    if _name is not None and _name not in bound and _name not in free_vars: free_vars.append(_name)
                inner_label=f"trait_{funcs['idx']}"; funcs['idx']+=1
                inner_env={"globals":env["globals"],"locals":{},"match_locals":{}}
                inner_env_layout={}
                local_counter=[len(params)]
                def inner_collect_match_locals(node, _ie=inner_env, _lc=local_counter):
                    if node is None or not isinstance(node, tuple): return
                    ن=node[0]
                    if ن=="طابق":
                        for نمط,تعبير in node[2]:
                            collect_pattern_vars(نمط, _ie, _lc)
                            inner_collect_match_locals(تعبير, _ie, _lc)
                    elif ن=="دالة": inner_collect_match_locals(node[2], _ie, _lc)
                    elif ن=="كتلة":
                        for s in node[1]: inner_collect_match_locals(s, _ie, _lc)
                        if len(node)>2: inner_collect_match_locals(node[2], _ie, _lc)
                    elif ن=="استدعاء":
                        for a in node[2]: inner_collect_match_locals(a, _ie, _lc)
                    elif ن=="ثنائية":
                        inner_collect_match_locals(node[2], _ie, _lc); inner_collect_match_locals(node[3], _ie, _lc)
                    elif ن in ("مقارنة","شرطي"):
                        for a in node[2:]: inner_collect_match_locals(a, _ie, _lc)
                def collect_pattern_vars(نمط, _e, _lc, _b=bound):
                    if نمط is None: return
                    if نمط[0]=="نمط_متغير":
                        اسم=نمط[1]
                        if اسم not in _e["locals"] and اسم not in _e["match_locals"]:
                            n=_lc[0]; _lc[0]+=1
                            _e["match_locals"][اسم]=(n+1)*8
                    elif نمط[0]=="نمط_شرطي": collect_pattern_vars(نمط[1], _e, _lc)
                    elif نمط[0]=="نمط_قائمة":
                        if نمط[1]:
                            for ع in نمط[1]: collect_pattern_vars(ع, _e, _lc)
                        if نمط[2]: collect_pattern_vars(("نمط_متغير",نمط[2]), _e, _lc)
                    elif نمط[0]=="نمط_باني":
                        for _sp in نمط[2]: collect_pattern_vars(_sp, _e, _lc)
                inner_collect_match_locals(تعبير)
                inner_fc=[f"{inner_label}:","    push rbp","    mov rbp, rsp"]
                for j,p in enumerate(params):
                    inner_env["locals"][p]=(j+1)*8
                for ix,v in enumerate(free_vars): inner_env_layout[v]=8+ix*8
                stack_size=local_counter[0]*8
                if stack_size%16!=0: stack_size+=8
                if stack_size==0: stack_size=16
                inner_fc.append(f"    sub rsp, {stack_size}")
                for j,p in enumerate(params):
                    if j<len(ARG_REGS):
                        inner_fc.append(f"    mov [rbp - {inner_env['locals'][p]}], {ARG_REGS[j]}")
                inner_fc.extend(compile_expr(تعبير,inner_env,funcs,inner_env_layout))
                inner_fc+=["    leave","    ret"]
                funcs['bodies'].extend(inner_fc)
                # خزّن closure في متغير عام
                global_code.append(f"    mov rdi, {8+len(free_vars)*8}")
                global_code.append("    call arena_alloc")
                global_code.append("    push rax")
                global_code.append(f"    mov rcx, {inner_label}")
                global_code.append("    mov [rax], rcx")
                for ix,v in enumerate(free_vars):
                    offset=8+ix*8
                    if v in env["globals"]:
                        global_code.append(f"    mov rcx, [vars + {env['globals'][v]*8}]")
                        global_code.append(f"    mov [rax + {offset}], rcx")
                    else:
                        global_code.append(f"    mov [rax + {offset}], rax")  # unreachable safety
                global_code.append("    pop rax")
                global_code.append(f"    mov [vars + {env['globals'][داخلي]*8}], rax")
    for بيان in برنامج:
        global_code.extend(compile_stmt(بيان,env,funcs,type_env))
    asm += global_code+["","    mov rax, 60","    xor rdi, rdi","    syscall",""]
    asm += funcs["bodies"]
    asm += [""]
    asm += """; ═══════════════════════════════════════════════════════════
; Event Loop Runtime — المرحلة 47
; ═══════════════════════════════════════════════════════════

; إنشاء epoll instance
create_event_loop:
    push rbx
    push r12
    xor rdi, rdi                ; flags = 0
    mov rax, 291
    syscall
    test rax, rax
    js .epoll_fail
    mov r12, rax                ; حفظ epfd

; تخصيص Future registry (8 futures كحد أقصى)
    mov rdi, 512                ; 8 * 64 bytes
    call arena_alloc
    mov [future_registry], rax

; تخصيص epoll_events buffer
    mov rdi, 256                ; 16 events * 16 bytes
    call arena_alloc
    mov [epoll_events_buf], rax

    mov rax, r12
    pop r12
    pop rbx
    ret

.epoll_fail:
    mov rax, 60
    mov rdi, 9
    syscall

; إنشاء Future جديد — يُرجع مؤشر Future
; Future layout: [state:8][value:8][eventfd:8][callback:8][padding:32]
create_future:
    push rbx
    push r12
    mov rdi, 64
    call arena_alloc
    mov r12, rax                ; future ptr

; إنشاء eventfd للـ future
    xor rdi, rdi                ; initval = 0
    xor rsi, rsi                ; flags = 0
    mov rax, 290
    syscall
    test rax, rax
    js .future_fd_fail

; تهيئة Future
    mov qword [r12 + 0], 0   ; state
    mov qword [r12 + 8], 0              ; value
    mov [r12 + 16], rax               ; eventfd
    mov qword [r12 + 24], 0           ; callback

    mov rax, r12
    pop r12
    pop rbx
    ret

.future_fd_fail:
    mov rax, 60
    mov rdi, 10
    syscall

; حل Future بقيمة — resolve_future(future, value)
resolve_future:
    push rbx
    mov rbx, rdi                ; future ptr
    mov qword [rbx + 0], 1
    mov [rbx + 8], rsi            ; value

; كتابة إلى eventfd لإيقاظ الـ event loop
    lea rsi, [rel future_wake_buf]
    mov qword [rsi], 1
    mov rdi, [rbx + 16]           ; eventfd
    mov rdx, 8
    mov rax, 1
    syscall
    pop rbx
    ret

; انتظار Future — await_future(future) → value
await_future:
    push rbx
    push r12
    mov rbx, rdi                ; future ptr

.await_loop:
    cmp qword [rbx + 0], 0
    jne .await_done

; قراءة من eventfd (blocking)
    mov rdi, [rbx + 16]           ; eventfd
    lea rsi, [rel future_wake_buf]
    mov rdx, 8
    mov rax, 0
    syscall
    jmp .await_loop

.await_done:
    cmp qword [rbx + 0], 2
    je .await_failed
    mov rax, [rbx + 8]            ; value
    pop r12
    pop rbx
    ret

.await_failed:
    mov rax, 60
    mov rdi, 11
    syscall

; تشغيل Event Loop — run_event_loop(epfd, timeout_ms)
run_event_loop:
    push rbx
    push r12
    push r13
    mov r12, rdi                ; epfd
    mov r13d, esi               ; timeout_ms

.loop:
    mov rdi, r12
    mov rsi, [epoll_events_buf]
    mov rdx, 16                 ; max events
    mov r10d, r13d
    mov rax, 232
    syscall
    test rax, rax
    jle .loop_end

; معالجة الأحداث
    mov rcx, rax
    mov rbx, [epoll_events_buf]
.process_events:
    ; TODO: dispatch to callbacks
    add rbx, 16
    dec rcx
    jnz .process_events
    jmp .loop

.loop_end:
    pop r13
    pop r12
    pop rbx
    ret""".split("\n")
    return "\n".join(asm)

# ═══════════════════════════════════════════════════════════
# Test Helpers
# ═══════════════════════════════════════════════════════════
def build_and_run(name, source, expected, stdin_input=None):
    try:
        ر=حلل_رموز(source); ب=حلل_برنامج(ر); asm=compile_program(ب)
        with open(f"{name}.asm","w") as f: f.write(asm)
        subprocess.run(["nasm","-f","elf64",f"{name}.asm","-o",f"{name}.o"],
                       check=True,capture_output=True)
        subprocess.run(["ld",f"{name}.o","-o",name],check=True,capture_output=True)
        result=subprocess.run([f"./{name}"],capture_output=True,text=True,
                              timeout=5,input=stdin_input)
        out=result.stdout.strip()
        if out==expected: print(f"✅ ({name}): {out}")
        else:
            print(f"❌ ({name}): Expected '{expected}', Got '{out}'")
            sys.exit(1)
    except Exception as e:
        print(f"❌ ({name}): Error: {e}"); sys.exit(1)

def build_and_expect_error(name, source, expected_err_contains):
    try:
        ر=حلل_رموز(source); ب=حلل_برنامج(ر); asm=compile_program(ب)
        print(f"❌ ({name}): Expected compile error but succeeded!")
        sys.exit(1)
    except Exception as e:
        if expected_err_contains in str(e):
            print(f"✅ ({name}): رفض صحيح — {e}")
        else:
            print(f"❌ ({name}): Wrong error: {e}")
            sys.exit(1)

# ═══════════════════════════════════════════════════════════
# Phase 2: Calculator
# ═══════════════════════════════════════════════════════════
def run_calculator():
    برنامج_حاسبة = '⎕ "أدخل عدداً:"\nأ ≔ عدد(⊙)\n⎕ "أدخل عدداً ثانياً:"\nب ≔ عدد(⊙)\n⎕ "المجموع:"\n⎕ نص(أ + ب)'

    print("\n🔧 تجميع الآلة الحاسبة...")
    ر = حلل_رموز(برنامج_حاسبة)
    ب = حلل_برنامج(ر)
    asm = compile_program(ب)
    with open('calc.asm', 'w') as f:
        f.write(asm)
    subprocess.run(['nasm', '-f', 'elf64', 'calc.asm', '-o', 'calc.o'], check=True)
    subprocess.run(['ld', 'calc.o', '-o', 'calc'], check=True)
    print("✅ تم التجميع")

    print("\n🔢 التشغيل (5 + 3):")
    result = subprocess.run(['./calc'], capture_output=True, text=True, input="5\n3\n")
    print(result.stdout)

    expected = "أدخل عدداً:\nأدخل عدداً ثانياً:\nالمجموع:\n8"
    if result.stdout.strip() == expected:
        print("✅ الآلة الحاسبة تعمل!")
    else:
        print(f"❌ متوقع: {expected}")
        print(f"   فعلي: {result.stdout.strip()}")
        sys.exit(1)

# ═══════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════
if __name__ == '__main__':
    # وضع CLI: python3 math_complete.py <ملف.ar> → تجميع + تشغيل فوري
    if len(sys.argv) > 1:
        مسار=sys.argv[1]
        with open(مسار, encoding='utf-8') as ف:
            source=ف.read()
        اسم=مسار.rsplit('.',1)[0].rsplit('/')[-1]
        try:
            ر=حلل_رموز(source); ب=حلل_برنامج(ر); asm=compile_program(ب)
            with open(f"{اسم}.asm","w") as ف: ف.write(asm)
            subprocess.run(["nasm","-f","elf64",f"{اسم}.asm","-o",f"{اسم}.o"],check=True,capture_output=True)
            subprocess.run(["ld",f"{اسم}.o","-o",اسم],check=True,capture_output=True)
            print(f"✅ تم تجميع {مسار} → {اسم}")
        except Exception as e:
            print(f"❌ فشل التجميع: {e}"); sys.exit(1)
        raise SystemExit(0)
    print("=" * 50)
    print("المرحلة 1: اختبارات المُجمّع")
    print("=" * 50)

    build_and_run("t_fact",
        "مضروب ≡ λن. (ن = 1) ؟ 1 : ن · مضروب(ن - 1)\n⎕ مضروب(5)", "120")
    build_and_run("t_foreach",
        "م ≔ 0\n∀ س ∈ ⟨1,2,3,4⟩ : م ≔ م + س\n⎕ م", "10")
    build_and_run("t_block",
        "ع ≔ 0\nن ≔ 1\nμ ع < 5 : ﴿ ن ≔ ن · 2 ⋄ ع ≔ ع + 1 ﴾\n⎕ ن", "32")
    build_and_run("t_move_valid",
        "أ ≔ ⟨1,2,3⟩\nب ⊸ أ\n⎕ طول(ب)", "3")
    build_and_run("t_move_str",
        'ن ≔ "مرحبا"\nم ⊸ ن\n⎕ م', "مرحبا")
    build_and_run("t_reassign_after_move",
        "أ ≔ ⟨1,2,3⟩\nب ⊸ أ\nأ ≔ ⟨4,5⟩\n⎕ طول(أ)", "2")
    build_and_expect_error("t_use_after_move",
        "أ ≔ ⟨1,2,3⟩\nب ⊸ أ\n⎕ طول(أ)", "مستهلك")
    build_and_expect_error("t_double_move",
        "أ ≔ ⟨1,2,3⟩\nب ⊸ أ\nج ⊸ أ", "مستهلك")
    build_and_expect_error("t_move_in_block",
        "أ ≔ ⟨1,2,3⟩\n﴿ ب ⊸ أ ⋄ ⎕ طول(أ) ﴾", "مستهلك")
    build_and_run("t_read_echo",
        "س ≔ ⊙\n⎕ س", "مرحبا", stdin_input="مرحبا")
    build_and_run("t_read_size",
        "س ≔ ⊙\n⎕ حجم(س)", "10", stdin_input="مرحبا")
    build_and_run("t_char",
        'س ≔ "abc"\n⎕ رمز(س, 0)', "97")
    build_and_run("t_char2",
        'س ≔ "مرحبا"\n⎕ رمز(س, 0)', "217")
    build_and_run("t_num2str",
        "⎕ نص(42)", "42")
    build_and_run("t_str2num",
        '⎕ عدد("123")', "123")
    build_and_run("t_roundtrip",
        "⎕ عدد(نص(99))", "99")

    print("\n🎉 المرحلة 1: جميع الاختبارات نجحت!")

    print("\n" + "=" * 50)
    print("المرحلة 2: الآلة الحاسبة التفاعلية")
    print("=" * 50)
    run_calculator()

    print("\n" + "=" * 50)
    print("🏆 جميع المراحل نجحت!")
    print("=" * 50)
