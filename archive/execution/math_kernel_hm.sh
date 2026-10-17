#!/bin/sh
set -e
cat > math_kernel_full.py <<'PY'
import sys

أرقام_القيم = {
    "0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,
    "٠":0,"١":1,"٢":2,"٣":3,"٤":4,"٥":5,"٦":6,"٧":7,"٨":8,"٩":9
}
رموز_العمليات = {
    "≔":"≔","≡":"≡","∀":"∀","∈":"∈","⊕":"⊕","·":"·","*":"·","×":"·",
    "⟨":"⟨","⟩":"⟩","(":"(",")":")",",":",","،":",",":":":",".":".",
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
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_المقارنة:
        ع=رموز[i][1]; i+=1; م,i=حلل_جمع(رموز,i); ي=("ثنائية",ع,ي,م)
    return ي,i
def حلل_جمع(رموز,i):
    ي,i=حلل_ضرب(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_الجمع:
        ع=رموز[i][1]; i+=1; م,i=حلل_ضرب(رموز,i); ي=("ثنائية",ع,ي,م)
    return ي,i
def حلل_ضرب(رموز,i):
    ي,i=حلل_عامل(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_الضرب:
        i+=1; م,i=حلل_عامل(رموز,i); ي=("ثنائية","·",ي,م)
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

# --- Type Checker (Hindley-Milner Style Unification) ---

class TypeVar:
    _counter = 0
    def __init__(self):
        TypeVar._counter += 1
        self.id = TypeVar._counter
        self.bound = None

    def resolve(self):
        if self.bound is None: return self
        self.bound = self.bound.resolve()
        return self.bound

    def bind(self, type):
        if self == type: return
        self.bound = type

    def __eq__(self, other):
        return isinstance(other, TypeVar) and self.id == other.id

def occurs_check(v, type):
    type = type.resolve()
    if isinstance(type, TypeVar): return v == type
    if hasattr(type, 'args'):
        return any(occurs_check(v, arg) for arg in type.args)
    return False

def unify(t1, t2):
    t1 = t1.resolve()
    t2 = t2.resolve()
    if t1 == t2: return
    if isinstance(t1, TypeVar):
        if occurs_check(t1, t2): raise Exception("فشل فحص التكرار (Occurs check)")
        t1.bind(t2)
        return
    if isinstance(t2, TypeVar):
        if occurs_check(t2, t1): raise Exception("فشل فحص التكرار (Occurs check)")
        t2.bind(t1)
        return
    if t1.name != t2.name or len(t1.args) != len(t2.args):
        raise Exception(f"خطأ في النوع: لا يمكن توحيد {t1} مع {t2}")
    for a1, a2 in zip(t1.args, t2.args):
        unify(a1, a2)

class Type:
    def __init__(self, name, args=None):
        self.name = name
        self.args = args or []
    def resolve(self):
        return self
    def __eq__(self, other):
        return type(self) == type(other) and self.name == other.name and self.args == other.args
    def __repr__(self):
        if not self.args: return self.name
        return f"{self.name}({', '.join(map(str, self.args))})"

T_INT = Type("صحيح")
T_STR = Type("نص")
T_BOOL = Type("منطقي")
def T_LIST(t): return Type("قائمة", [t])
def T_FUNC(t1, t2): return Type("دالة", [t1, t2])

def get_builtin_type(name):
    if name == "طول":
        return T_FUNC(T_LIST(TypeVar()), T_INT)
    return None

def دقق_نوع(ت, γ):
    ن = ت[0]
    if ن == "عدد": return T_INT
    if ن == "نص": return T_STR
    if ن == "قائمة":
        if not ت[1]: return T_LIST(TypeVar())
        t_elem = دقق_نوع(ت[1][0], γ)
        for elem in ت[1][1:]: unify(t_elem, دقق_نوع(elem, γ))
        return T_LIST(t_elem.resolve())
    if ن == "متغير":
        if ت[1] not in γ: raise Exception(f"متغير غير معرف: {ت[1]}")
        return γ[ت[1]]
    if ن == "دالة":
        tv = TypeVar()
        γ_new = dict(γ)
        γ_new[ت[1]] = tv
        t_body = دقق_نوع(ت[2], γ_new)
        return T_FUNC(tv.resolve(), t_body.resolve())
    if ن == "استدعاء":
        t_func = γ.get(ت[1]) or get_builtin_type(ت[1])
        if t_func is None: raise Exception(f"دالة غير معرفة: {ت[1]}")
        if len(ت[2]) != 1: raise Exception(f"الدالة {ت[1]} تأخذ وسيطاً واحداً، لكن تم تمرير {len(ت[2])}")
        t_arg = دقق_نوع(ت[2][0], γ)
        t_ret = TypeVar()
        unify(t_func, T_FUNC(t_arg, t_ret))
        return t_ret.resolve()
    if ن == "ثنائية":
        op = ت[1]
        t_left = دقق_نوع(ت[2], γ)
        t_right = دقق_نوع(ت[3], γ)
        if op in ["+", "-", "·"]:
            unify(t_left, T_INT); unify(t_right, T_INT); return T_INT
        if op == "⊕":
            unify(t_left, T_STR); unify(t_right, T_STR); return T_STR
        if op in ["<", ">", "=", "≠"]:
            unify(t_left, t_right); return T_BOOL
    raise Exception(f"تعبير غير معروف: {ن}")

def دقق_بيان(ب, γ):
    ن = ب[0]
    if ن == "أسند":
        t_expr = دقق_نوع(ب[2], γ)
        if ب[1] in γ: unify(γ[ب[1]], t_expr)
        else: γ[ب[1]] = t_expr
        return γ
    if ن == "اطبع":
        دقق_نوع(ب[1], γ); return γ
    if ن == "لكل":
        t_list = دقق_نوع(ب[2], γ)
        t_elem = TypeVar()
        unify(t_list, T_LIST(t_elem))
        γ_new = dict(γ)
        γ_new[ب[1]] = t_elem.resolve()
        return دقق_بيان(ب[3], γ_new)
    if ن == "طالما":
        t_cond = دقق_نوع(ب[1], γ)
        unify(t_cond, T_BOOL)
        return دقق_بيان(ب[2], γ)
    raise Exception(f"بيان غير معروف: {ن}")

def دقق_برنامج(برنامج):
    γ_global = {"طول": T_FUNC(T_LIST(TypeVar()), T_INT)}
    γ = dict(γ_global)
    for بيان in برنامج: γ = دقق_بيان(بيان, γ)
    return γ

def شغل_و_دقق(نص):
    ر = حلل_رموز(نص)
    ب = حلل_برنامج(ر)
    try:
        دقق_برنامج(ب)
        return "نجاح"
    except Exception as خ:
        return "خطأ: " + str(خ)

اختبارات = [
    ("حساب", "س ≔ ٢ + ٣\nص ≔ ١٠ - ٤\nض ≔ س · ص\n⎕ ض", True),
    ("دالة", "تربيع ≡ λس. س · س\nن ≔ تربيع(٥)\n⎕ ن", True),
    ("نص", 'رحب ≡ λاسم. "مرحباً " ⊕ اسم\nج ≔ رحب("بالعربية")\n⎕ ج', True),
    ("لكل", "أ ≔ ⟨١,٢,٣⟩\nم ≔ ٠\n∀ س ∈ أ : م ≔ م + س\n⎕ م", True),
    ("طالما", "ع ≔ ٠\nμ ع < ٣ : ع ≔ ع + ١\n⎕ ع", True),
    ("طول_مدمجة", "أ ≔ ⟨١,٢,٣⟩\nط ≔ طول(أ)\n⎕ ط", True),
    
    ("رفض_جمع_نص", 'س ≔ ٢ + "نص"', False),
    ("رفض_استدعاء_خاطئ", 'تربيع ≡ λس. س · س\nن ≔ تربيع("نص")', False),
    ("رفض_شرط_غير_منطقي", 'ع ≔ ٠\nμ ١ + ٢ : ع ≔ ع + ١', False),
    ("رفض_تكرار_على_عدد", '∀ س ∈ ٥ : ⎕ س', False),
]

فشل = False
for اسم, مصدر, متوقع_نجاح in اختبارات:
    نتيجة = شغل_و_دقق(مصدر)
    نجاح = نتيجة == "نجاح"
    if نجاح == متوقع_نجاح: sys.stdout.write(f"✅ {اسم}\n")
    else:
        sys.stdout.write(f"❌ {اسم} | متوقع: {'نجاح' if متوقع_نجاح else 'رفض'} | فعلي: {نتيجة}\n")
        فشل = True

if فشل: sys.exit(1)
sys.stdout.write("اختبارات النواة الرياضية والمُدقق النوعي: ١٠ من ١٠ نجحت\n")
PY
python3 math_kernel_full.py