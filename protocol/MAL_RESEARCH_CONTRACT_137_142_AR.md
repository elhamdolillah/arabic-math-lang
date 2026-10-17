# عقد البحث العربي للآليات 137–142

## المرجع والنطاق

هذا العقد امتداد بحثي مستقل فوق `MAL_GRAMMAR_SPEC_v0.1_AR.md`. لا يضيف ميزات تنفيذية إلى النواة، ولا يغيّر baseline المجمد، ولا يجيز المؤشرات الخام أو `eval` أو `exec` أو تنفيذ `source_ref`.

```text
CONTRACT=MAL_RESEARCH_CONTRACT_137_142_AR_v0.1
SOURCE_EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
RAW_POINTERS=DENY
RUNTIME_FEATURES_ADMITTED=0
AUTO_PROMOTION=DENY
BASELINE_KERNEL=UNCHANGED
```

## العقود المرشحة للتطوير

| الآلية | الاسم العربي المقترح | الحالة | الحد الأدنى للعقد |
|---|---|---|---|
| 137 | `اسم_رمز_ساكن` | RESEARCH | لا ينتج نصًا إلا من رمز موجود في جدول رموز ثابت؛ الاسم canonical ومحدد بترميز MAL، ويُرفض الرمز المفقود. |
| 139 | `خطأ_ساكن` | RESEARCH | شرط ثابت محدود بلا IO أو شبكة؛ إذا تحقق الشرط يفشل البناء ولا ينتج executable، مع رسالة خطأ canonical. |
| 141 | `فرع_ساكن` | RESEARCH | الشرط ثابت وقابل للتقييم قبل التنفيذ؛ الفرع المختار فقط يدخل التنفيذ، والفرع الآخر يبقى صحيح الصياغة ولا يعتمد على runtime. |
| 142 | `حساب_متحقق` | RESEARCH | عرض صحيح وإشارة وحدود overflow والقسمة على صفر معلنة؛ الفشل قيمة structured وليس سلوكًا غير معرف. |

## العقود الممتنعة حاليًا

### 138 — تفرع سياق التقييم

يصنّف `ABSTAIN_UNTIL_EVIDENCE` لأن وجود مسارين مختلفين للوظيفة نفسها، أحدهما في الترجمة والآخر في التنفيذ، قد يخرق وحدة الدلالة الحتمية. لا يُفتح قبل وجود نموذج تقييم ثابت يحدد الحدود والنتائج دون الاعتماد على خصائص backend غير مثبتة.

### 140 — التخطيط العابر لـ ABI

يصنّف `ABSTAIN_UNTIL_EVIDENCE` لأن `repr(C)` يتطلب عقدًا للعرض والمحاذاة والحشو وendianness وهدف ABI، ولأن إدخال FFI قد يفتح حدودًا تخالف سياسة no raw pointers. البديل الآمن هو عقد سجل مسطح مفهرس داخل MAL لا يدّعي التطابق مع C.

## بوابات الإثبات

لا يجوز ترقية أي آلية إلى `PROVEN` أو `EXTENSION_SCOPED_PROVEN` إلا بعد توفير تمثيل canonical، حالات موجبة وسالبة، تنفيذ عربي مستقل، مخرج خام، بصمة SHA-256، وتحقق سلسلة ناجح. لا يكفي تشابه الآلية مع ميزة في لغة أخرى لإثبات تنفيذ MAL.

## قرار هذه الدورة

```text
RULES_REVIEWED=6
RULES_RUNTIME_ADOPTED=0
RESEARCH=4
ABSTAIN_UNTIL_EVIDENCE=2
SOURCE_EXECUTION=NOT_PERFORMED
BASELINE_MODIFIED=NO
```
