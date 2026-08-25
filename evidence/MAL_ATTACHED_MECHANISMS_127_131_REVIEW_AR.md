# مراجعة الآليات 127–131 وفق دستور MAL وUORI

## النتيجة العامة

هذه الحزمة مراجعة حاكمة مستقلة وليست اعتماداً تنفيذياً. لم تُنفَّذ مصادر اللغات المستهدفة، ولم تُضَف أي ميزة إلى وقت التشغيل. بقيت القرارات محافظة، وطُبقت سياسة الامتناع عند الغموض، مع منع المؤشرات الخام وفصل البحث عن التنفيذ.

| الرقم | الآلية | القرار | حالة التشغيل |
|---:|---|---|---|
| 127 | Rust `NonZeroU32` | `RESEARCH` | `NOT_ADMITTED` |
| 128 | Go `-trimpath` | `RESEARCH` | `NOT_ADMITTED` |
| 129 | C `fesetround` | `ABSTAIN_UNTIL_EVIDENCE` | `NOT_ADMITTED` |
| 130 | C++ `std::atomic_ref` مع `seq_cst` | `ABSTAIN_UNTIL_EVIDENCE` | `NOT_ADMITTED` |
| 131 | JavaScript `Object.preventExtensions` | `RESEARCH` | `NOT_ADMITTED` |

## التحليل الحاكم

**127 — Rust `NonZeroU32`.** يفرض النوع، عبر واجهته الآمنة، عدم إنشاء قيمة صفرية ويتيح تمرير هذا القيد إلى الدوال. غير أن نظام MAL لا يتضمن بعد أنواعاً غير صفرية أو refinement types، ولا يثبت تمثيل niche أو ABI مستقلاً عن المترجم. لذلك بقيت الآلية `RESEARCH`.

**128 — Go `-trimpath`.** يقلل المسارات المطلقة داخل ميتاداتا البناء، لكنه لا يضمن وحده التطابق الثنائي؛ إذ قد تبقى آثار لإصدار المترجم، وbuild id، والخيارات، والتبعيات، ووقت البناء. لذلك بقيت `RESEARCH` إلى حين عقد hermetic كامل.

**129 — C `fesetround`.** يحدد وضع تقريب الفاصلة العائمة، لكنه يقع ضمن الحساب العائم الذي لم يُعتمد في MAL. كما قد تؤثر FENV_ACCESS وتحسينات المترجم والدقة الزائدة والعتاد والاستثناءات في النتيجة. صُنّفت الآلية `ABSTAIN_UNTIL_EVIDENCE`.

**130 — C++ `std::atomic_ref`.** يتيح الوصول الذري إلى كائن غير ذري مع ترتيب `seq_cst`، لكن الترتيب الكلي للعمليات لا يثبت جدولة حتمية أو نتيجة واحدة عامة لكل تشغيل. كما يلزم التحقق من lifetime والمحاذاة ومنع الوصول غير الذري. صُنّفت `ABSTAIN_UNTIL_EVIDENCE`.

**131 — JavaScript `Object.preventExtensions`.** يمنع إضافة خصائص جديدة، لكنه يسمح بحذف الخصائص وتعديل القيم، فلا يثبت مجموعة مفاتيح ثابتة ولا immutability عميقة. وتحتاج proxy وstrict mode وترتيب المفاتيح إلى عقد MAL صريح. لذلك بقيت `RESEARCH`.

## القيود الحاكمة

```text
CONSTITUTION_REVIEW=PASS_WITH_GUARDS
MECHANISMS_REVIEWED=5
RULES_EXECUTIVELY_ADOPTED=0
RUNTIME_FEATURES_ADMITTED=0
SOURCE_EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
RAW_POINTERS=DENY
BASELINE_MODIFIED=NO
```

لا يجوز رفع أي آلية إلى `PROVEN` قبل عقد MAL محدد، وcorpus موجب وسلبي، ومخرج خام، وبصمة SHA-256، وإثبات إعادة إنتاج عبر البيئات. وبخاصة لا يُستعمل `fesetround` لإثبات حتمية الحساب العائم، ولا تُستعمل `seq_cst` لإثبات حتمية الجدولة، ولا تُستعمل `-trimpath` وحدها لإثبات reproducible binary.
