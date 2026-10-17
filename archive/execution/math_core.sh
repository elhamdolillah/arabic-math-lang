#!/bin/sh
set -e
cat > math_core.py <<'PY'
import sys

أرقام_القيم = {
    "0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,
    "٠":0,"١":1,"٢":2,"٣":3,"٤":4,"٥":5,"٦":6,"٧":7,"٨":8,"٩":9
}
رموز_العمليات = {
    "≔":"≔","≡":"≡","∀":"∀","∈":"∈","⊕":"⊕","·":"·","*":"·","×":"·",
    "⟨":"⟨","⟩":"⟩","(":"(",")":")",",",",","،":",",":":":",".":".",
    "+":"+","-":"-","<":"<",">":">","=":"=","≠":"≠","⎕":"⎕"
}
رموز_يونانية = {"λ":"λ","μ":"μ"}
أسماء_بديلة = {
    "دالة":"λ","λ":"λ","طالما":"μ","μ":"μ",
    "لكل":"∀","∀":"∀","في":"∈","∈":"∈","اطبع":"⎕","⎕":"⎕"
}
عمليات_المقارنة = {"<":"<",">":">","=":"=","≠":"≠"}
عمليات_الجمع = {"+":"+","-":"-","⊕":"⊕"}
عمليات_الضرب = {"·":"·"}

def حلل_رموز(نص):
    رموز=[]; i=0; n=len(نص)
    while i<n:
        ح=نص[i]
        if ح.isspace(): i+=1; continue
        ر=أرقام_القيم.get(ح)
        if ر is not None:
            ق=0
            while i<n:
                د=أرقام_القيم.get(نص[i])
                if د is None: break
                ق=ق*10+د; i+=1
            رموز.append(("عدد",ق)); continue
        if ح=='"':
            i+=1; أ=[]
            while i<n and نص[i]!='"': أ.append(نص[i]); i+=1
            if i>=n: raise Exception("نص غير مغلق")
            i+=1; رموز.append(("نص","".join(أ))); continue
        ي=رموز_يونانية.get(ح)
        if ي is not None: رموز.append(("عملية",ي)); i+=1; continue
        if ح.isalpha() or ح=="_":
            ب=i; i+=1
            while i<n and (نص[i].isalpha() or نص[i].isdigit() or نص[i]=="_"): i+=1
            ك=نص[ب:i]; بد=أسماء_بديلة.get(ك)
            if بد is not None: رموز.append(("عملية",بد))
            else: رموز.append(("معرف",ك))
            continue
        ع=رموز_العمليات.get(ح)
        if ع is not None: رموز.append(("عملية",ع)); i+=1; continue
        raise Exception("رمز غير معروف: "+ح)
    return رموز

def حلل_برنامج(رموز):
    ب=[]; i=0
    while i<len(رموز):
        بيان,i=حلل_بيان(رموز,i); ب.append(بيان)
    return ب

def حلل_بيان(رموز,i):
    if i>=len(رموز): raise Exception("بيان مفقود")
    ن,ق=رموز[i]
    if ن=="عملية" and ق=="⎕":
        i+=1; ت,i=حلل_تعبير(رموز,i); return ("اطبع",ت),i
    if ن=="عملية" and ق=="∀":
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception("اسم مطلوب بعد ∀")
        اسم=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!="∈": raise Exception("∈ مطلوبة")
        i+=1; قائمة,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(": مطلوبة")
        i+=1; جسم,i=حلل_بيان(رموز,i)
        return ("لكل",اسم,قائمة,جسم),i
    if ن=="عملية" and ق=="μ":
        i+=1; شرط,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(": مطلوبة")
        i+=1; جسم,i=حلل_بيان(رموز,i)
        return ("طالما",شرط,جسم),i
    if ن=="معرف":
        اسم=ق
        if i+1<len(رموز) and رموز[i+1][0]=="عملية" and (رموز[i+1][1]=="≔" or رموز[i+1][1]=="≡"):
            i+=2; ت,i=حلل_تعبير(رموز,i); return ("أسند",اسم,ت),i
        raise Exception("بيان غير معروف: "+اسم)
    raise Exception("بيان غير معروف")

def حلل_تعبير(رموز,i): return حلل_مقارنة(رموز,i)
def حلل_مقارنة(رموز,i):
    ي,i=حلل_جمع(رموز,i)
    while i<len(رموز):
        ن,ق=رموز[i]; ع=عمليات_المقارنة.get(ق) if ن=="عملية" else None
        if ع is None: break
        i+=1; م,i=حلل_جمع(رموز,i); ي=("ثنائية",ع,ي,م)
    return ي,i
def حلل_جمع(رموز,i):
    ي,i=حلل_ضرب(رموز,i)
    while i<len(رموز):
        ن,ق=رموز[i]; ع=عمليات_الجمع.get(ق) if ن=="عملية" else None
        if ع is None: break
        i+=1; م,i=حلل_ضرب(رموز,i); ي=("ثنائية",ع,ي,م)
    return ي,i
def حلل_ضرب(رموز,i):
    ي,i=حلل_عامل(رموز,i)
    while i<len(رموز):
        ن,ق=رموز[i]; ع=عمليات_الضرب.get(ق) if ن=="عملية" else None
        if ع is None: break
        i+=1; م,i=حلل_عامل(رموز,i); ي=("ثنائية",ع,ي,م)
    return ي,i
def حلل_عامل(رموز,i):
    if i>=len(رموز): raise Exception("عامل مفقود")
    ن,ق=رموز[i]
    if ن=="عدد": return ("عدد",ق),i+1
    if ن=="نص": return ("نص",ق),i+1
    if ن=="عملية" and ق=="λ":
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception("معامل مطلوب بعد λ")
        مع=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!=".": raise Exception(". مطلوبة")
        i+=1; جسم,i=حلل_تعبير(رموز,i)
        return ("دالة",مع,جسم),i
    if ن=="عملية" and ق=="⟨":
        i+=1; ع=[]
        if i<len(رموز) and رموز[i][1]=="⟩": return ("قائمة",ع),i+1
        while True:
            عنصر,i=حلل_تعبير(رموز,i); ع.append(عنصر)
            if i>=len(رموز): raise Exception("⟩ مطلوبة")
            if رموز[i][1]==",": i+=1; continue
            if رموز[i][1]=="⟩": i+=1; break
            raise Exception("فاصلة أو ⟩ مطلوبة")
        return ("قائمة",ع),i
    if ن=="عملية" and ق=="(":
        i+=1; ت,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=")": raise Exception(") مطلوبة")
        return ت,i+1
    if ن=="معرف":
        اسم=ق; i+=1
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1; وس=[]
            if i<len(رموز) and رموز[i][1]==")": return ("استدعاء",اسم,وس),i+1
            while True:
                و,i=حلل_تعبير(رموز,i); وس.append(و)
                if i>=len(رموز): raise Exception(") مطلوبة")
                if رموز[i][1]==",": i+=1; continue
                if رموز[i][1]==")": i+=1; break
                raise Exception("فاصلة أو ) مطلوبة")
            return ("استدعاء",اسم,وس),i
        return ("متغير",اسم),i
    raise Exception("عامل غير متوقع")

def ابحث(ب,اسم):
    م=ب[0]; أب=ب[1]; ق=م.get(اسم)
    if ق is not None: return ق
    if أب is None: raise Exception("غير معرف: "+اسم)
    return ابحث(أب,اسم)
def أسند(ب,اسم,ق):
    م=ب[0]; أب=ب[1]
    if م.get(اسم) is not None: م[اسم]=ق; return
    if أب is not None: أسند(أب,اسم,ق); return
    م[اسم]=ق

def قيم(ت,ب):
    ن=ت[0]
    if ن=="عدد": return ت[1]
    if ن=="نص": return ت[1]
    if ن=="قائمة":
        ع=[]; i=0
        while i<len(ت[1]): ع.append(قيم(ت[1][i],ب)); i+=1
        return ع
    if ن=="متغير": return ابحث(ب,ت[1])
    if ن=="دالة": return ("إغلاق",ت[1],ت[2],ب)
    if ن=="استدعاء":
        د=ابحث(ب,ت[1]); وس=[]; i=0
        while i<len(ت[2]): وس.append(قيم(ت[2][i],ب)); i+=1
        if type(د) is tuple and len(د)==4 and د[0]=="إغلاق":
            if len(وس)==0: raise Exception("استدعاء بدون وسائط")
            نتيجة=د; i=0
            while i<len(وس):
                if not(type(نتيجة) is tuple and len(نتيجة)==4 and نتيجة[0]=="إغلاق"):
                    raise Exception("غير قابلة للاستدعاء")
                _,مع,جسم,ب_إ=نتيجة
                نتيجة=قيم(جسم,({مع:وس[i]},ب_إ)); i+=1
            return نتيجة
        if callable(د): return د(وس)
        raise Exception("غير قابلة للاستدعاء")
    if ن=="ثنائية":
        ي=قيم(ت[2],ب); م=قيم(ت[3],ب)
        ع=ت[1]
        if ع=="+":
            if type(ي) is int and type(م) is int: return ي+م
            raise Exception("+ تتطلب عددين")
        if ع=="-":
            if type(ي) is int and type(م) is int: return ي-م
            raise Exception("- تتطلب عددين")
        if ع=="·":
            if type(ي) is int and type(م) is int: return ي*م
            raise Exception("· تتطلب عددين")
        if ع=="⊕":
            if type(ي) is str and type(م) is str: return ي+م
            raise Exception("⊕ تتطلب نصين")
        if ع=="<": return ي<م
        if ع==">": return ي>م
        if ع=="=": return ي==م
        if ع=="≠": return ي!=م
    raise Exception("تعبير غير معروف")

def نفذ(بيان,ب,خرج):
    ن=بيان[0]
    if ن=="أسند": أسند(ب,بيان[1],قيم(بيان[2],ب)); return
    if ن=="اطبع": خرج.append(str(قيم(بيان[1],ب))); return
    if ن=="لكل":
        ع=قيم(بيان[2],ب)
        if type(ع) is not list: raise Exception("∀ تتطلب قائمة")
        i=0
        while i<len(ع):
            أسند(ب,بيان[1],ع[i]); نفذ(بيان[3],ب,خرج); i+=1
        return
    if ن=="طالما":
        while قيم(بيان[1],ب): نفذ(بيان[2],ب,خرج)
        return
    raise Exception("بيان غير معروف")

def شغل(نص):
    ر=حلل_رموز(نص); ب=حلل_برنامج(ر)
    بيئة=({},None); خرج=[]; i=0
    while i<len(ب): نفذ(ب[i],بيئة,خرج); i+=1
    return "\n".join(خرج)

اختبارات=[
    ("حساب","س ≔ ٢ + ٣\nص ≔ ١٠ - ٤\nض ≔ س · ص\n⎕ ض","30"),
    ("دالة","تربيع ≡ λس. س · س\nن ≔ تربيع(٥)\n⎕ ن","25"),
    ("نص",'رحب ≡ λاسم. "مرحباً " ⊕ اسم\nج ≔ رحب("بالعربية")\n⎕ ج',"مرحباً بالعربية"),
    ("لكل","أ ≔ ⟨١,٢,٣⟩\nم ≔ ٠\n∀ س ∈ أ : م ≔ م + س\n⎕ م","6"),
    ("طالما","ع ≔ ٠\nμ ع < ٣ : ع ≔ ع + ١\n⎕ ع","3"),
]
فشل=False; i=0
while i<len(اختبارات):
    اسم,مصدر,متوقع=اختبارات[i]
    try: فعلي=شغل(مصدر)
    except Exception as خ: فعلي="خطأ: "+str(خ)
    if فعلي==متوقع: sys.stdout.write("✅ "+اسم+"\n")
    else:
        sys.stdout.write("❌ "+اسم+" متوقع:"+متوقع+" فعلي:"+فعلي+"\n"); فشل=True
    i+=1
if فشل: sys.exit(1)
sys.stdout.write("اختبارات النواة الرياضية: ٥ من ٥ نجحت\n")
PY
python3 math_core.py