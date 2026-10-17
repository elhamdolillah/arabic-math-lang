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

# -----------------------------
# Lexer
# -----------------------------

def حلل_رموز(نص):
    رموز=[]; i=0; n=len(نص)
    while i<n:
        ح=نص[i]
        if ح.isspace():
            i+=1; continue

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
            while i<n and نص[i]!='"':
                أ.append(نص[i]); i+=1
            if i>=n: raise Exception("نص غير مغلق")
            i+=1
            رموز.append(("نص","".join(أ))); continue

        ي=رموز_يونانية.get(ح)
        if ي is not None:
            رموز.append(("عملية",ي)); i+=1; continue

        if ح.isalpha() or ح=="_":
            ب=i; i+=1
            while i<n and (نص[i].isalpha() or نص[i].isdigit() or نص[i]=="_"):
                i+=1
            ك=نص[ب:i]
            بد=أسماء_بديلة.get(ك)
            if بد is not None:
                رموز.append(("عملية",بد))
            else:
                رموز.append(("معرف",ك))
            continue

        ع=رموز_العمليات.get(ح)
        if ع is not None:
            رموز.append(("عملية",ع)); i+=1; continue

        raise Exception("رمز غير معروف: "+ح)

    return رموز

# -----------------------------
# Parser
# -----------------------------

def حلل_برنامج(رموز):
    ب=[]; i=0
    while i<len(رموز):
        بيان,i=حلل_بيان(رموز,i)
        ب.append(بيان)
    return ب

def حلل_بيان(رموز,i):
    if i>=len(رموز):
        raise Exception("بيان مفقود")

    ن,ق=رموز[i]

    if ن=="عملية" and ق=="⎕":
        i+=1
        ت,i=حلل_تعبير(رموز,i)
        return ("اطبع",ت),i

    if ن=="عملية" and ق=="∀":
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف":
            raise Exception("اسم مطلوب بعد ∀")
        اسم=رموز[i][1]; i+=1
        if i>=len(رموز) or رموز[i][1]!="∈":
            raise Exception("∈ مطلوبة")
        i+=1
        قائمة,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":":
            raise Exception(": مطلوبة")
        i+=1
        جسم,i=حلل_بيان(رموز,i)
        return ("لكل",اسم,قائمة,جسم),i

    if ن=="عملية" and ق=="μ":
        i+=1
        شرط,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=":":
            raise Exception(": مطلوبة")
        i+=1
        جسم,i=حلل_بيان(رموز,i)
        return ("طالما",شرط,جسم),i

    if ن=="معرف":
        اسم=ق
        if (i+1<len(رموز) and رموز[i+1][0]=="عملية"
                and (رموز[i+1][1]=="≔" or رموز[i+1][1]=="≡")):
            رمز=رموز[i+1][1]
            i+=2
            ت,i=حلل_تعبير(رموز,i)
            if رمز=="≔":
                return ("أسند",اسم,ت),i
            return ("عرف",اسم,ت),i
        raise Exception("بيان غير معروف: "+اسم)

    raise Exception("بيان غير معروف")

def حلل_تعبير(رموز,i):
    return حلل_مقارنة(رموز,i)

def حلل_مقارنة(رموز,i):
    ي,i=حلل_جمع(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_المقارنة:
        ع=رموز[i][1]; i+=1
        م,i=حلل_جمع(رموز,i)
        ي=("ثنائية",ع,ي,م)
    return ي,i

def حلل_جمع(رموز,i):
    ي,i=حلل_ضرب(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_الجمع:
        ع=رموز[i][1]; i+=1
        م,i=حلل_ضرب(رموز,i)
        ي=("ثنائية",ع,ي,م)
    return ي,i

def حلل_ضرب(رموز,i):
    ي,i=حلل_عامل(رموز,i)
    while i<len(رموز) and رموز[i][0]=="عملية" and رموز[i][1] in عمليات_الضرب:
        i+=1
        م,i=حلل_عامل(رموز,i)
        ي=("ثنائية","·",ي,م)
    return ي,i

def حلل_عامل(رموز,i):
    if i>=len(رموز):
        raise Exception("عامل مفقود")

    ن,ق=رموز[i]

    if ن=="عدد":
        return ("عدد",ق),i+1

    if ن=="نص":
        return ("نص",ق),i+1

    if ن=="عملية" and ق=="λ":
        i+=1
        معلمون=[]

        if i<len(رموز) and رموز[i][1]=="(":
            i+=1
            if i>=len(رموز) or رموز[i][0]!="معرف":
                raise Exception("معامل مطلوب بعد λ(")
            while True:
                if رموز[i][0]!="معرف":
                    raise Exception("اسم معامل مطلوب")
                معلمون.append(رموز[i][1]); i+=1
                if i>=len(رموز):
                    raise Exception(") مطلوبة")
                if رموز[i][1]==",":
                    i+=1; continue
                if رموز[i][1]==")":
                    i+=1; break
                raise Exception("فاصلة أو ) مطلوبة")
        else:
            if i>=len(رموز) or رموز[i][0]!="معرف":
                raise Exception("معامل مطلوب بعد λ")
            معلمون.append(رموز[i][1]); i+=1

        if i>=len(رموز) or رموز[i][1]!=".":
            raise Exception(". مطلوبة بعد معاملات λ")

        i+=1
        جسم,i=حلل_تعبير(رموز,i)
        return ("دالة",معلمون,جسم),i

    if ن=="عملية" and ق=="⟨":
        i+=1
        ع=[]
        if i<len(رموز) and رموز[i][1]=="⟩":
            return ("قائمة",ع),i+1
        while True:
            عنصر,i=حلل_تعبير(رموز,i)
            ع.append(عنصر)
            if i>=len(رموز):
                raise Exception("⟩ مطلوبة")
            if رموز[i][1]==",":
                i+=1; continue
            if رموز[i][1]=="⟩":
                i+=1; break
            raise Exception("فاصلة أو ⟩ مطلوبة")
        return ("قائمة",ع),i

    if ن=="عملية" and ق=="(":
        i+=1
        ت,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!=")":
            raise Exception(") مطلوبة")
        return ت,i+1

    if ن=="معرف":
        اسم=ق; i+=1
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1
            وس=[]
            if i<len(رموز) and رموز[i][1]==")":
                return ("استدعاء",اسم,وس),i+1
            while True:
                و,i=حلل_تعبير(رموز,i)
                وس.append(و)
                if i>=len(رموز):
                    raise Exception(") مطلوبة")
                if رموز[i][1]==",":
                    i+=1; continue
                if رموز[i][1]==")":
                    i+=1; break
                raise Exception("فاصلة أو ) مطلوبة")
            return ("استدعاء",اسم,وس),i
        return ("متغير",اسم),i

    raise Exception("عامل غير متوقع")

# -----------------------------
# Runtime environment
# -----------------------------

def ابحث(ب,اسم):
    م=ب[0]
    أب=ب[1]
    ق=م.get(اسم)
    if ق is not None:
        return ق
    if أب is None:
        raise Exception("غير معرف: "+اسم)
    return ابحث(أب,اسم)

def أسند(ب,اسم,ق):
    م=ب[0]
    أب=ب[1]
    if م.get(اسم) is not None:
        م[اسم]=ق
        return
    if أب is not None:
        أسند(أب,اسم,ق)
        return
    م[اسم]=ق

# -----------------------------
# Built-in functions
# -----------------------------

def طول(وس):
    if len(وس)!=1:
        raise Exception("طول تأخذ وسيطاً واحداً")
    if type(وس[0]) is not list:
        raise Exception("طول تتطلب قائمة")
    return len(وس[0])

def رأس(وس):
    if len(وس)!=1:
        raise Exception("رأس تأخذ وسيطاً واحداً")
    ق=وس[0]
    if type(ق) is not list:
        raise Exception("رأس تتطلب قائمة")
    if len(ق)==0:
        raise Exception("رأس تتطلب قائمة غير فارغة")
    return ق[0]

def ذيل(وس):
    if len(وس)!=1:
        raise Exception("ذيل تأخذ وسيطاً واحداً")
    ق=وس[0]
    if type(ق) is not list:
        raise Exception("ذيل تتطلب قائمة")
    if len(ق)==0:
        raise Exception("ذيل تتطلب قائمة غير فارغة")
    return ق[1:]

def ألحق(وس):
    if len(وس)==1:
        ق=وس[0]
        if type(ق) is not list:
            raise Exception("ألحق تتطلب قائمة")
        def لاحق(وس2):
            if len(وس2)!=1:
                raise Exception("ألحق تأخذ عنصراً بعد القائمة")
            return ق + [وس2[0]]
        return لاحق

    if len(وس)==2:
        ق=وس[0]
        ع=وس[1]
        if type(ق) is not list:
            raise Exception("ألحق تتطلب قائمة")
        return ق + [ع]

    raise Exception("ألحق تأخذ قائمة وعنصراً")

def بيئة_جديدة():
    return ({
        "طول": طول,
        "رأس": رأس,
        "ذيل": ذيل,
        "ألحق": ألحق
    }, None)

# -----------------------------
# Evaluator
# -----------------------------

def طبق(د,وس):
    if len(وس)==0:
        return د

    if callable(د):
        return د(وس)

    نتيجة=د
    i=0
    while i<len(وس):
        if type(نتيجة) is tuple and len(نتيجة)==5 and نتيجة[0]=="إغلاق":
            _, معلمون, جسم, ب_إ, سابق = نتيجة
            جديد = سابق + [وس[i]]

            if len(جديد) < len(معلمون):
                نتيجة = ("إغلاق", معلمون, جسم, ب_إ, جديد)
            else:
                محلي = ({}, ب_إ)
                ج=0
                while ج < len(معلمون):
                    محلي[0][معلمون[ج]] = جديد[ج]
                    ج += 1
                نتيجة = قيم(جسم, محلي)

        elif callable(نتيجة):
            return نتيجة(وس[i:])

        else:
            raise Exception("غير قابلة للاستدعاء")

        i += 1

    return نتيجة

def قيم(ت,ب):
    ن=ت[0]

    if ن=="عدد":
        return ت[1]

    if ن=="نص":
        return ت[1]

    if ن=="قائمة":
        ع=[]
        i=0
        while i<len(ت[1]):
            ع.append(قيم(ت[1][i],ب))
            i+=1
        return ع

    if ن=="متغير":
        return ابحث(ب,ت[1])

    if ن=="دالة":
        return ("إغلاق", ت[1], ت[2], ب, [])

    if ن=="استدعاء":
        د=ابحث(ب,ت[1])
        وس=[]
        i=0
        while i<len(ت[2]):
            وس.append(قيم(ت[2][i],ب))
            i+=1
        if len(وس)==0:
            raise Exception("استدعاء بدون وسائط")
        return طبق(د,وس)

    if ن=="ثنائية":
        ي=قيم(ت[2],ب)
        م=قيم(ت[3],ب)
        ع=ت[1]

        if ع=="+":
            if type(ي) is int and type(م) is int:
                return ي+م
            raise Exception("+ تتطلب عددين")

        if ع=="-":
            if type(ي) is int and type(م) is int:
                return ي-م
            raise Exception("- تتطلب عددين")

        if ع=="·":
            if type(ي) is int and type(م) is int:
                return ي*م
            raise Exception("· تتطلب عددين")

        if ع=="⊕":
            if type(ي) is str and type(م) is str:
                return ي+م
            raise Exception("⊕ تتطلب نصين")

        if ع=="<":
            return ي<م
        if ع==">":
            return ي>م
        if ع=="=":
            return ي==م
        if ع=="≠":
            return ي!=م

    raise Exception("تعبير غير معروف")

def نفذ(ب,بيئة,خرج):
    ن=ب[0]

    if ن=="أسند" or ن=="عرف":
        أسند(بيئة, ب[1], قيم(ب[2], بيئة))
        return

    if ن=="اطبع":
        خرج.append(str(قيم(ب[1],بيئة)))
        return

    if ن=="لكل":
        ع=قيم(ب[2],بيئة)
        if type(ع) is not list:
            raise Exception("∀ تتطلب قائمة")
        i=0
        while i<len(ع):
            أسند(بيئة, ب[1], ع[i])
            نفذ(ب[3], بيئة, خرج)
            i+=1
        return

    if ن=="طالما":
        while قيم(ب[1],بيئة):
            نفذ(ب[2],بيئة,خرج)
        return

    raise Exception("بيان غير معروف")

def شغل(نص):
    ر=حلل_رموز(نص)
    ب=حلل_برنامج(ر)
    بيئة=بيئة_جديدة()
    خرج=[]
    i=0
    while i<len(ب):
        نفذ(ب[i],بيئة,خرج)
        i+=1
    return "\n".join(خرج)

# -----------------------------
# Type system
# -----------------------------

class TypeVar:
    _counter = 0

    def __init__(self):
        TypeVar._counter += 1
        self.id = TypeVar._counter
        self.bound = None

    def resolve(self):
        if self.bound is None:
            return self
        self.bound = self.bound.resolve()
        return self.bound

    def bind(self, type):
        if self == type:
            return
        self.bound = type

    def __eq__(self, other):
        return isinstance(other, TypeVar) and self.id == other.id

    def __repr__(self):
        return "τ" + str(self.id)

class Type:
    def __init__(self, name, args=None):
        self.name = name
        self.args = args or []

    def resolve(self):
        return self

    def __eq__(self, other):
        return isinstance(other, Type) and self.name == other.name and self.args == other.args

    def __repr__(self):
        if self.name == "دالة" and len(self.args) == 2:
            left = repr(self.args[0])
            right = repr(self.args[1])
            if isinstance(self.args[0], Type) and self.args[0].name == "دالة":
                left = "(" + left + ")"
            return left + " → " + right

        if not self.args:
            return self.name

        return self.name + "(" + ", ".join(map(repr, self.args)) + ")"

T_INT = Type("صحيح")
T_STR = Type("نص")
T_BOOL = Type("منطقي")

def T_LIST(t):
    return Type("قائمة", [t])

def T_FUNC(a,b):
    return Type("دالة", [a,b])

def get_builtin_type(name):
    if name == "طول":
        return T_FUNC(T_LIST(TypeVar()), T_INT)

    if name == "رأس":
        tv = TypeVar()
        return T_FUNC(T_LIST(tv), tv)

    if name == "ذيل":
        tv = TypeVar()
        return T_FUNC(T_LIST(tv), T_LIST(tv))

    if name == "ألحق":
        tv = TypeVar()
        return T_FUNC(T_LIST(tv), T_FUNC(tv, T_LIST(tv)))

    return None

def occurs_check(v, type):
    type = type.resolve()
    if isinstance(type, TypeVar):
        return v == type
    if hasattr(type, "args"):
        for arg in type.args:
            if occurs_check(v, arg):
                return True
    return False

def unify(t1, t2):
    t1 = t1.resolve()
    t2 = t2.resolve()

    if t1 == t2:
        return

    if isinstance(t1, TypeVar):
        if occurs_check(t1, t2):
            raise Exception("فشل فحص التكرار (Occurs check)")
        t1.bind(t2)
        return

    if isinstance(t2, TypeVar):
        if occurs_check(t2, t1):
            raise Exception("فشل فحص التكرار (Occurs check)")
        t2.bind(t1)
        return

    if t1.name != t2.name or len(t1.args) != len(t2.args):
        raise Exception("خطأ في النوع: لا يمكن توحيد " + repr(t1) + " مع " + repr(t2))

    j=0
    while j < len(t1.args):
        unify(t1.args[j], t2.args[j])
        j += 1

def دقق_نوع(ت, γ):
    ن=ت[0]

    if ن=="عدد":
        return T_INT

    if ن=="نص":
        return T_STR

    if ن=="قائمة":
        if len(ت[1]) == 0:
            return T_LIST(TypeVar())
        t_elem = دقق_نوع(ت[1][0], γ)
        i=1
        while i < len(ت[1]):
            unify(t_elem, دقق_نوع(ت[1][i], γ))
            i += 1
        return T_LIST(t_elem.resolve())

    if ن=="متغير":
        if ت[1] not in γ:
            raise Exception("متغير غير معرف: " + ت[1])
        return γ[ت[1]]

    if ن=="دالة":
        γ_new = dict(γ)
        tvs = []
        for اسم in ت[1]:
            tv = TypeVar()
            tvs.append(tv)
            γ_new[اسم] = tv

        t_body = دقق_نوع(ت[2], γ_new)
        t = t_body.resolve()

        idx = len(tvs)-1
        while idx >= 0:
            t = T_FUNC(tvs[idx].resolve(), t)
            idx -= 1

        return t

    if ن=="استدعاء":
        if len(ت[2]) == 0:
            raise Exception("استدعاء بدون وسائط")

        if ت[1] in γ:
            t_func = γ[ت[1]]
        else:
            t_func = get_builtin_type(ت[1])
            if t_func is None:
                raise Exception("دالة غير معرفة: " + ت[1])

        t_ret = TypeVar()
        expected = t_ret

        idx = len(ت[2]) - 1
        while idx >= 0:
            t_arg = دقق_نوع(ت[2][idx], γ)
            expected = T_FUNC(t_arg.resolve(), expected)
            idx -= 1

        unify(t_func, expected)
        return t_ret.resolve()

    if ن=="ثنائية":
        op = ت[1]
        t_left = دقق_نوع(ت[2], γ)
        t_right = دقق_نوع(ت[3], γ)

        if op == "+" or op == "-" or op == "·":
            unify(t_left, T_INT)
            unify(t_right, T_INT)
            return T_INT

        if op == "⊕":
            unify(t_left, T_STR)
            unify(t_right, T_STR)
            return T_STR

        if op == "<" or op == ">":
            unify(t_left, T_INT)
            unify(t_right, T_INT)
            return T_BOOL

        if op == "=" or op == "≠":
            unify(t_left, t_right)
            return T_BOOL

    raise Exception("تعبير غير معروف")

def دقق_بيان(ب, γ):
    ن=ب[0]

    if ن=="أسند" or ن=="عرف":
        اسم=ب[1]
        if اسم in γ:
            موجود=γ[اسم]
        else:
            موجود=TypeVar()
            γ[اسم]=موجود

        t_expr = دقق_نوع(ب[2], γ)
        unify(موجود, t_expr)
        γ[اسم] = موجود.resolve()
        return γ

    if ن=="اطبع":
        دقق_نوع(ب[1], γ)
        return γ

    if ن=="لكل":
        t_list = دقق_نوع(ب[2], γ)
        t_elem = TypeVar()
        unify(t_list, T_LIST(t_elem))
        γ[ب[1]] = t_elem.resolve()
        return دقق_بيان(ب[3], γ)

    if ن=="طالما":
        t_cond = دقق_نوع(ب[1], γ)
        unify(t_cond, T_BOOL)
        return دقق_بيان(ب[2], γ)

    raise Exception("بيان غير معروف")

def دقق_برنامج(برنامج):
    γ = {}
    i=0
    while i < len(برنامج):
        γ = دقق_بيان(برنامج[i], γ)
        i += 1
    return γ

def دقق_فقط(نص):
    try:
        ر = حلل_رموز(نص)
        ب = حلل_برنامج(ر)
        دقق_برنامج(ب)
        return "نجاح"
    except Exception as خ:
        return "خطأ: " + str(خ)

# -----------------------------
# Mathematical disassembler helpers
# -----------------------------

def إلى_عربية(ن):
    if ن == 0:
        return "٠"
    س = ""
    م = ن
    if م < 0:
        م = -م
    while م > 0:
        س = "٠١٢٣٤٥٦٧٨٩"[م % 10] + س
        م //= 10
    if ن < 0:
        return "-" + س
    return س

def expr_to_math(ت):
    ن=ت[0]

    if ن=="عدد":
        return إلى_عربية(ت[1])

    if ن=="نص":
        return '"' + ت[1] + '"'

    if ن=="قائمة":
        return "⟨" + ", ".join(expr_to_math(ع) for ع in ت[1]) + "⟩"

    if ن=="متغير":
        return ت[1]

    if ن=="دالة":
        معلمون = ت[1]
        if len(معلمون) == 1:
            head = "λ" + معلمون[0]
        else:
            head = "λ(" + ", ".join(معلمون) + ")"
        return head + ". " + expr_to_math(ت[2])

    if ن=="استدعاء":
        return ت[1] + "(" + ", ".join(expr_to_math(و) for و in ت[2]) + ")"

    if ن=="ثنائية":
        return "(" + expr_to_math(ت[2]) + " " + ت[1] + " " + expr_to_math(ت[3]) + ")"

    raise Exception("تعبير غير معروف")

def فكك_بيان(ب, γ, فهرس=None, مع_النوع=True):
    بادئة = ""
    if فهرس is not None:
        بادئة = "[" + إلى_عربية(فهرس) + "] "

    ن=ب[0]

    if ن=="أسند" or ن=="عرف":
        اسم=ب[1]
        if اسم in γ:
            موجود=γ[اسم]
        else:
            موجود=TypeVar()
            γ[اسم]=موجود

        t_expr = دقق_نوع(ب[2], γ)
        unify(موجود, t_expr)
        γ[اسم] = موجود.resolve()

        رمز = "≔" if ن=="أسند" else "≡"
        نص_البيان = اسم + " " + رمز + " " + expr_to_math(ب[2])
        if مع_النوع:
            نص_البيان += " : " + repr(γ[اسم])
        return بادئة + نص_البيان

    if ن=="اطبع":
        t_expr = دقق_نوع(ب[1], γ)
        نص_البيان = "⎕ " + expr_to_math(ب[1])
        if مع_النوع:
            نص_البيان += " : " + repr(t_expr.resolve())
        return بادئة + نص_البيان

    if ن=="لكل":
        t_list = دقق_نوع(ب[2], γ)
        t_elem = TypeVar()
        unify(t_list, T_LIST(t_elem))
        γ[ب[1]] = t_elem.resolve()

        جسم = فكك_بيان(ب[3], γ, None, False)
        return بادئة + "∀ " + ب[1] + " ∈ " + expr_to_math(ب[2]) + " : " + جسم

    if ن=="طالما":
        t_cond = دقق_نوع(ب[1], γ)
        unify(t_cond, T_BOOL)

        جسم = فكك_بيان(ب[2], γ, None, False)
        return بادئة + "μ " + expr_to_math(ب[1]) + " : " + جسم

    raise Exception("بيان غير معروف")

def فكك_برنامج(نص):
    ر = حلل_رموز(نص)
    ب = حلل_برنامج(ر)
    γ = {}
    أسطر = []
    i=0
    while i < len(ب):
        أسطر.append(فكك_بيان(ب[i], γ, i, True))
        i += 1
    return "\n".join(أسطر)

# -----------------------------
# Tests
# -----------------------------

if __name__ == "__main__":
    فشل = False

    اختبارات_تشغيل = [
        ("حساب", "س ≔ ٢ + ٣\nص ≔ ١٠ - ٤\nض ≔ س · ص\n⎕ ض", "30"),

        ("دالة_ثنائية", "جمع ≡ λ(س, ص). س + ص\nن ≔ جمع(٢, ٣)\n⎕ ن", "5"),

        ("جزئية_التطبيق", "جمع ≡ λ(س, ص). س + ص\nج ≔ جمع(٢)\nن ≔ ج(٣)\n⎕ ن", "5"),

        ("ثلاثة_معاملات", "جمع_ثلاثة ≡ λ(س, ص, ع). س + ص + ع\nن ≔ جمع_ثلاثة(١, ٢, ٣)\n⎕ ن", "6"),

        ("طول_قائمة", "أ ≔ ⟨١,٢,٣⟩\n⎕ طول(أ)", "3"),

        ("ألحق_و_طول", "أ ≔ ⟨١,٢⟩\nب ≔ ألحق(أ, ٣)\n⎕ طول(ب)", "3"),

        ("رأس_قائمة", "أ ≔ ⟨٤,٥,٦⟩\n⎕ رأس(أ)", "4"),
    ]

    i=0
    while i < len(اختبارات_تشغيل):
        اسم, مصدر, متوقع = اختبارات_تشغيل[i]
        try:
            فعلي = شغل(مصدر)
        except Exception as خ:
            فعلي = "خطأ: " + str(خ)

        if فعلي == متوقع:
            sys.stdout.write("✅ تشغيل: " + اسم + "\n")
        else:
            sys.stdout.write("❌ تشغيل: " + اسم + " متوقع:" + متوقع + " فعلي:" + فعلي + "\n")
            فشل = True

        i += 1

    اختبارات_نوع = [
        ("حساب", "س ≔ ٢ + ٣\n⎕ س", True),

        ("دالة_ثنائية", "جمع ≡ λ(س, ص). س + ص\nن ≔ جمع(١, ٢)", True),

        ("جزئية_التطبيق", "جمع ≡ λ(س, ص). س + ص\nج ≔ جمع(١)\nن ≔ ج(٢)", True),

        ("طول_قائمة", "أ ≔ ⟨١,٢,٣⟩\nط ≔ طول(أ)", True),

        ("ألحق_كامل", "أ ≔ ⟨١,٢⟩\nب ≔ ألحق(أ, ٣)", True),

        ("رفض_جمع_نص", "س ≔ ٢ + \"نص\"", False),

        ("رفض_معامل_نص", "جمع ≡ λ(س, ص). س + ص\nن ≔ جمع(\"نص\", ٢)", False),

        ("رفض_عدد_وسائط", "جمع ≡ λ(س, ص). س + ص\nن ≔ جمع(١, ٢, ٣)", False),

        ("رفض_طول_عدد", "س ≔ طول(٥)", False),

        ("رفض_ألحق_نص", "أ ≔ ⟨١,٢⟩\nب ≔ ألحق(أ, \"نص\")", False),
    ]

    i=0
    while i < len(اختبارات_نوع):
        اسم, مصدر, متوقع_نجاح = اختبارات_نوع[i]
        نتيجة = دقق_فقط(مصدر)
        نجاح = (نتيجة == "نجاح")

        if نجاح == متوقع_نجاح:
            sys.stdout.write("✅ نوع: " + اسم + "\n")
        else:
            sys.stdout.write("❌ نوع: " + اسم + " | متوقع: " + ("نجاح" if متوقع_نجاح else "رفض") + " | فعلي: " + نتيجة + "\n")
            فشل = True

        i += 1

    if فشل:
        sys.exit(1)

    sys.stdout.write("اختبارات الدوال متعددة الوسائط: " + إلى_عربية(len(اختبارات_تشغيل)) + " تشغيل و " + إلى_عربية(len(اختبارات_نوع)) + " نوع نجحت\n")
