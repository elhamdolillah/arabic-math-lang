# عقد امتدادات MAL v0.2

**الحالة:** `RESEARCH_WITH_IMPLEMENTABLE_SUBSET`
**العلاقة:** لا تعدّل Grammar v0.1؛ هذه مواصفة امتداد منفصلة.
**القاعدة:** لا تُرفع أي ميزة إلى `PROVEN` لمجرد وجودها في لغة أخرى. يلزم parser، type checker، canonical IR، corpus، stdout، SHA-256، وسلسلة تحقق مستقلة.

## 1. بوابة القبول المشتركة

كل امتداد يجب أن يحدد المجال والأنواع وترتيب العمليات وحدود السعة وحالات الفشل والتمثيل القانوني. لا وقت حقيقي ولا شبكة ولا `source_ref` ولا `eval` ولا `exec` ولا raw pointers في المسار الحتمي.

المعادلة العامة للقبول:

```text
ACCEPT(extension) = DOMAIN_DEFINED
                    ∧ TYPES_DEFINED
                    ∧ CANONICAL_ORDER
                    ∧ FAILURE_BOUNDS
                    ∧ CORPUS_PASS
                    ∧ SHA256_CHAIN=0
```

إذا فشل شرط واحد، فالقرار `ABSTAIN_UNTIL_EVIDENCE`، باستثناء المؤشرات الخام والتنفيذ الديناميكي غير المصرح به فهما `DENY`.

## 2. امتدادات Grammar المقترحة

الصياغة التالية **اقتراح نحوي فقط** إلى أن ينفذ parser وtype checker:

```ebnf
نوع_امتداد ::= نوع_أساسي
             | "مصفوفة" "<" نوع_امتداد "," رتبة ">"
             | "متجه_دائم" "<" نوع_امتداد ">"
             | "نوع_مُمَثَّل" معرف
             | "بتات" "<" عدد_صحيح ">" ;

رتبة       ::= عدد_صحيح ;

نوع_مُمَثَّل ::= "نوع_مُمَثَّل" معرف "<" معاملات_نوع ">" ;

تعبير_رمزي ::= ثابت_رمزي
             | معرف
             | "جمع_رمزي" "(" تعبير_رمزي "," تعبير_رمزي ")"
             | "ضرب_رمزي" "(" تعبير_رمزي "," تعبير_رمزي ")" ;

تسلسل_بايت ::= "بايتات" "(" تعبير "," نهاية_بايت ")" ;
نهاية_بايت ::= "كبير" | "صغير" ;

قناة_حتمية ::= "قناة" "<" نوع_امتداد "," سعة ">" ;
سعة        ::= عدد_صحيح ;
```

هذه القواعد لا تدخل Grammar v0.1 تلقائياً؛ يجب إصدار parser versioned منفصل.

## 3. مصفوفة القرار

| المعرف | الامتداد | نطاق الاعتماد الأول | القرار | سبب القرار |
|---|---|---|---|---|
| `gadt-bounded` | GADT | أنواع مُمثلة محدودة، بلا فحص وقت التشغيل | `RESEARCH` | يحتاج type checker وبراهين حفظ النوع |
| `array-shape` | المصفوفات | مصفوفات ثابتة الرتبة والأبعاد، دون broadcasting | `EXTENSION_SCOPED_PROVEN` بعد corpus | الحدود والأبعاد قابلة للفحص الحتمي |
| `rank-static` | rank-polymorphism | رتب ثابتة مع قيود compile-time | `RESEARCH` | لا يوجد بعد نظام أنواع رتب في MAL |
| `symbolic-total` | الحساب الرمزي العام | AST رمزي محدود، canonical rewrite، fuel | `EXTENSION_SCOPED_PROVEN` بعد corpus | يمكن إثبات ترتيب إعادة الكتابة ونفاد الوقود |
| `endian-fixed` | endianness | ترميز/فك ترميز bytes بعرض ثابت | `EXTENSION_SCOPED_PROVEN` بعد corpus | الترتيب صريح ولا يعتمد على العتاد |
| `pvec-immutable` | persistent vectors | بنية immutable بمؤشرات منطقية/NodeID فقط | `RESEARCH` | يحتاج IR وقياس بنيوي دون عناوين |
| `csp-step` | التزامن | محاكاة قنوات bounded بخطوات منطقية | `RESEARCH` | التزامن الفعلي والجدولة لم يُثبتا |
| `gc-trace` | GC | tracer تجريبي خارج Tier-0 | `RESEARCH` | زمن GC غير ثابت؛ لا اعتماد زمني حتمي |
| `dispatch-closed` | dynamic dispatch | dispatch على جدول مغلق مرتب بالمعرف | `RESEARCH` | يحتاج ABI وcanonical vtable |
| `ieee754-guarded` | الحساب العائم | تحليل/تحقق فقط، لا تنفيذ Tier-0 | `ABSTAIN` | IEEE-754 يتطلب عقد rounding/exceptions/NaN/ABI |
| `raw-pointer` | مؤشرات خام | لا نطاق مسموح | `DENY` | تخالف الملكية والعناوين المستقلة |

## 4. العقود التنفيذية المختصرة

### 4.1 المصفوفات

كل قيمة تحمل الشكل `(rank, shape, data)`، ويُمنع broadcasting الضمني:

```text
shape_a = shape_b ∨ القرار = ABSTAIN / SHAPE_MISMATCH
0 ≤ index_k < shape_k
```

### 4.2 الحساب الرمزي

يجب ترتيب العقد بـ `NodeID`، وتطبيق قواعد rewrite مرتبة، وإجبار كل عملية على fuel محدود:

```text
fuel_remaining = fuel_initial - rewrite_count
fuel_remaining < 0 ⇒ ABSTAIN / FUEL_EXHAUSTED
```

لا تعني مساواة الشكل الرمزي إثباتاً رياضياً عاماً.

### 4.3 endianness

الترميز مستقل عن host ABI:

```text
byte[k] = (value >> (8 * k)) & 255
```

مع عرض ثابت وفحص overflow قبل التحويل. أي عرض أو ترتيب غير محدد يسبب `ABSTAIN`.

### 4.4 persistent vectors

يُسمح فقط بعقد immutable تستخدم `NodeID` ونسخاً بنيوية محددة. لا تستخدم عناوين ذاكرة أو hash غير مزروع. يبقى الامتداد `RESEARCH` حتى يثبت allocation trace canonical.

### 4.5 التزامن

المسموح حالياً هو نموذج محاكاة أحادي المنفذ بخطوات منطقية:

```text
step_n → queue_order_n → transition_n → state_{n+1}
```

أما threads وOS scheduling وlock timing فليست جزءاً من Tier-0.

### 4.6 GC

GC يبقى خارج المسار الحتمي. يمكن اختبار tracer كبحث، لكن لا يُسمح أن يغير ترتيب النتائج أو حد الزمن. نفاد الوقود أو عدم اكتمال graph يؤدي إلى `ABSTAIN`.

### 4.7 dynamic dispatch

لا يُقبل إلا جدول مغلق canonical مرتب بـ `(trait_id, method_id)`، مع رفض أي symbol lookup أو تحميل runtime. يحتاج ذلك عقد ABI منفصلاً.

### 4.8 الحساب العائم

وجود token `عدد_حقيقي` في Grammar لا يمنح صلاحية التنفيذ. إلى حين عقد مستقل، النتيجة:

```text
REAL_ARITHMETIC_CONTRACT_MISSING ⇒ ABSTAIN
NaN ∨ Infinity ∨ implicit_cast ⇒ DENY أو ABSTAIN حسب الحالة
```

### 4.9 المؤشرات الخام

لا توجد صيغة MAL مسموحة لها. البديل هو `NodeID` أو `Handle(index, generation)` والتحقق من الملكية والعمر والحدود.

## 5. معيار رفع الامتداد

لا ينتقل الامتداد من `RESEARCH` إلى `EXTENSION_SCOPED_PROVEN` إلا بعد تنفيذ مستقل يثبت parser وchecker وIR، واختبار حالات الحد، ومخرجاً خاماً وبصمة وسلسلة تحقق ناجحة. لا يثبت ذلك سلامة kernel أو WASM أو كل العتاد.

```text
SOURCE_EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
BASELINE_MODIFIED=NO
```
