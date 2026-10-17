# الفصل 5: نظام الأنواع (Type System)

## مقدمة

نظام الأنواع هو **الحارس** الذي يتحقق من صحة البرنامج قبل تنفيذه.

```text
AST خام → [Type Checker] → AST مُتحقق منه
    أو              🔍
              خطأ في وقت التجميع
```

---

## الأنواع الأساسية

```text
┌─────────────────────────────────────────┐
│ الأنواع البدائية (Primitive Types)     │
├─────────────────────────────────────────┤
│ عدد   ← Integer (64-bit signed)        │
│ نص    ← String (UTF-8, length-prefixed)│
│ منطقي ← Boolean (0 أو 1)                │
│ وحدة  ← Unit (لا قيمة)                  │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ الأنواع المركبة (Compound Types)       │
├─────────────────────────────────────────┤
│ قائمة<T>   ← List of T                  │
│ دالة(A)→B  ← Function                  │
│ ملف        ← File descriptor            │
│ مقبض       ← Socket handle              │
└─────────────────────────────────────────┘
```

---

## الاستنتاج التلقائي (Type Inference)

المُجمّع يستنتج الأنواع تلقائياً دون الحاجة لتصريح صريح.

### مثال
```arabic
س ≔ 42              # يُستنتج: عدد
ص ≔ "مرحبا"         # يُستنتج: نص
ق ≔ ⟨1, 2, 3⟩       # يُستنتج: قائمة<عدد>
د ≡ λس. س + 1       # يُستنتج: دالة(عدد)→عدد
```

### الخوارزمية (Algorithm W مبسط)

```python
def infer_type(expr, env):
    if isinstance(expr, NumNode):
        return Type("عدد")
    
    if isinstance(expr, StrNode):
        return Type("نص")
    
    if isinstance(expr, VarNode):
        if expr.name not in env:
            raise Exception(f"متغير غير معرف: {expr.name}")
        return env[expr.name]
    
    if isinstance(expr, BinOpNode):
        left_type = infer_type(expr.left, env)
        right_type = infer_type(expr.right, env)
        
        # العمليات الحسابية
        if expr.op in ('+', '-', '·', '÷'):
            if left_type != Type("عدد") or right_type != Type("عدد"):
                raise Exception(f"العملية {expr.op} تتطلب عددين")
            return Type("عدد")
        
        # الدمج النصي
        if expr.op == '⊕':
            if left_type != Type("نص") or right_type != Type("نص"):
                raise Exception("⊕ يتطلب نصين")
            return Type("نص")
        
        # المقارنات
        if expr.op in ('=', '≠', '<', '>', '<=', '>='):
            if left_type != right_type:
                raise Exception("المقارنة تتطلب نوعين متطابقين")
            return Type("منطقي")
    
    if isinstance(expr, ListNode):
        if not expr.elements:
            return Type("قائمة<فارغ>")
        element_types = [infer_type(e, env) for e in expr.elements]
        if not all(t == element_types[0] for t in element_types):
            raise Exception("عناصر القائمة يجب أن تكون من نفس النوع")
        return Type(f"قائمة<{element_types[0].name}>")
    
    if isinstance(expr, LambdaNode):
        new_env = env.copy()
        for param in expr.params:
            new_env[param] = Type("غير_معروف")  # سيُستنتج لاحقاً
        body_type = infer_type(expr.body, new_env)
        return Type(f"دالة({', '.join(expr.params)})→{body_type.name}")
```

---

## قواعد التحقق

### 1. التوافق في العمليات الحسابية

```arabic
✅ س ≔ 5 + 3          # عدد + عدد = عدد
❌ س ≔ 5 + "نص"       # عدد + نص → خطأ
❌ س ≔ "أ" + "ب"      # نص + نص → خطأ (استخدم ⊕)
```

### 2. التوافق في المقارنات

```arabic
✅ م ≔ 5 > 3          # عدد > عدد = منطقي
✅ م ≔ "أ" = "ب"      # نص = نص = منطقي
❌ م ≔ 5 > "نص"       # أنواع مختلفة → خطأ
```

### 3. التوافق في الإسناد

```arabic
س ≔ 42
س ≔ 100               # ✅ عدد ← عدد

س ≔ "نص"              # ❌ لا يمكن تغيير النوع
```

### 4. استدعاء الدوال

```arabic
مربع ≡ λس. س · س
⎕ مربع(5)             # ✅ عدد → عدد
⎕ مربع("نص")          # ❌ خطأ نوع
```

---

## الملكية الخطية (Linear Ownership)

### المفهوم
```text
∀ مورد M:
    ∃! مالك O: يملك(O, M)
    
"كل مورد له مالك واحد فقط في أي لحظة"
```

### القواعد

```arabic
# ✅ الأعداد قابلة للنسخ (Copyable)
س ≔ 42
ص ≔ س                 # نسخ
⎕ س                   # 42 ✅
⎕ ص                   # 42 ✅

# ❌ القوائم غير قابلة للنسخ (Linear)
ق ≔ ⟨1, 2, 3⟩
ص ≔ ق                 # خطأ! استخدم ⊸
ص ≔ ق ⊸               # ✅ نقل ملكية
⎕ ص                   # ⟨1, 2, 3⟩ ✅
⎕ ق                   # ❌ خطأ: ق منقول
```

### التحقق في وقت التجميع

```python
def check_ownership(stmt, env):
    if isinstance(stmt, AssignNode):
        if isinstance(stmt.value, MoveNode):
            source = stmt.value.source
            if source in env.moved:
                raise Exception(
                    f"❌ المتغير '{source}' منقول مسبقاً!\n"
                    f"   ﴿أدوا الأمانات إلى أهلها﴾"
                )
            env.moved.add(source)
```

---

## رسائل الخطأ الواضحة

### مثال 1: نوع غير متوافق
```arabic
س ≔ 42
ص ≔ "نص"
م ≔ س + ص
```

```text
❌ خطأ نوع في السطر 3:
   العملية '+' تتطلب عددين
   
   س: عدد ✅
   ص: نص ❌
   
   الدستور: ﴿وضع الميزان﴾
  Hint: استخدم ⊕ لدمج النصوص
```

### مثال 2: متغير منقول
```arabic
ق ≔ ⟨1, 2, 3⟩
ص ≔ ق ⊸
⎕ ق
```

```text
❌ خطأ ملكية في السطر 3:
   المتغير 'ق' منقول مسبقاً في السطر 2
   
   الدستور: ﴿أدوا الأمانات إلى أهلها﴾
   Hint: استخدم نسخة أو أعد إنشاء القائمة
```

---

## تمارين الفصل الخامس

1. **تمرين 1:** أضف دعم الأنواع القابلة للخيار (Option/Nullable)
2. **تمرين 2:** نفّذ استنتاج أنواع الدوال العودية
3. **تمرين 3:** أضف دعم الأنواع المعممة (Generics)
4. **تمرين 4:** حسّن رسائل الخطأ مع اقتراحات الإصلاح

---

## الخلاصة

نظام الأنواع هو **خط الدفاع الأول**:
- يكتشف الأخطاء قبل التشغيل
- يضمن أمان الذاكرة
- يوفر توثيقاً ذاتياً للكود

بهذا نكون قد أكملنا **الجزء الأول من الكتاب** (الأساسيات). في الجزء التالي، سندرس **توليد الكود** وتنفيذه.

**﴿وقل رب زدني علماً﴾**