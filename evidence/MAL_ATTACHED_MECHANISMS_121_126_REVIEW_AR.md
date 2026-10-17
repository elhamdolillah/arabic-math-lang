# مراجعة الآليات 121–126 وفق دستور MAL وUORI

## النتيجة العامة

هذه الحزمة مراجعة حاكمة مستقلة، وليست اعتماداً تنفيذياً. لم تُنفّذ مصادر اللغات المستهدفة، ولم تُضف أي ميزة إلى وقت التشغيل. طُبقت الحتمية القابلة للإثبات، والامتناع الآمن عند الغموض، ومنع المؤشرات الخام، وفصل البحث عن التنفيذ.

| الرقم | الآلية | القرار | حالة التشغيل |
|---:|---|---|---|
| 121 | Kotlin `value class` | `RESEARCH` | `NOT_ADMITTED` |
| 122 | C# `Span<T>` | `ABSTAIN_UNTIL_EVIDENCE` | `NOT_ADMITTED` |
| 123 | MongoDB `hint()` | `ABSTAIN_UNTIL_EVIDENCE` | `NOT_ADMITTED` |
| 124 | Ruby `String#-@` | `ABSTAIN_UNTIL_EVIDENCE` | `NOT_ADMITTED` |
| 125 | Prolog `once/1` | `RESEARCH` | `NOT_ADMITTED` |
| 126 | JavaScript `Object.seal` | `RESEARCH` | `NOT_ADMITTED` |

## التحليل الحاكم

**121 — Kotlin `value class`.** تفصل فئة القيمة بين أنواع ذات أساس واحد وقد تقلل التغليف في مسارات محددة، إلا أن boxing وnullability وpolymorphism وbackend تؤثر في التمثيل. لذلك لا يثبت الادعاء حجماً مستقلاً عن JVM، وبقي التصنيف `RESEARCH`.

**122 — C# `Span<T>`.** يفرض `ref struct` قيوداً على التخزين والالتقاط، وتوجد حماية حدود للفهرسة، لكنه ليس دائماً ذاكرة مكدس؛ فقد يشير إلى مصفوفة أو ذاكرة غير مُدارة. كما أن المثال يقترب من مناطق lifetime وstackalloc التي تحتاج عقداً صريحاً، ولذلك صُنّف `ABSTAIN_UNTIL_EVIDENCE`.

**123 — MongoDB `hint()`.** يقيّد اختيار فهرس معين، لكنه لا يثبت خطة التنفيذ الكاملة أو ترتيب النتائج أو الاستقلال عن إصدار الخادم وإحصاءات الفهرس وحالة البيانات. يلزم `sort` صريح وبيئة وsnapshot مثبتان، ولذلك صُنّف `ABSTAIN_UNTIL_EVIDENCE`.

**124 — Ruby `String#-@`.** قد ينتج سلسلة مجمدة معاد استخدامها داخل مفسر معين، لكن هوية الكائن وجدول deduplication وlifetime ليست عقداً محمولاً عبر الإصدارات والبيئات. لا يجوز تحويل `equal?` إلى برهان على هوية ذاكرة حتمية، ولذلك صُنّف `ABSTAIN_UNTIL_EVIDENCE`.

**125 — Prolog `once/1`.** يلتزم بأول حل يقدمه الهدف، لكن معنى الأول يتبع ترتيب البنود والتوحيد والمحرك. كما أن الآثار الجانبية قد تجعل الالتزام غير آمـن دلالياً. يحتاج إلى ترتيب بحث canonical ونموذج آثار محدد، ولذلك بقي `RESEARCH`.

**126 — JavaScript `Object.seal`.** يثبت مجموعة الخصائص وبعض أوصافها، لكنه يسمح بتعديل القيم ولا يمنع التعديل العميق. كما أن proxy وstrict mode وسياسة ترتيب المفاتيح تحتاج إلى عقد MAL، ولذلك بقي `RESEARCH`.

## القيود الحاكمة

```text
CONSTITUTION_REVIEW=PASS_WITH_GUARDS
MECHANISMS_REVIEWED=6
RULES_EXECUTIVELY_ADOPTED=0
RUNTIME_FEATURES_ADMITTED=0
SOURCE_EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
RAW_POINTERS=DENY
BASELINE_MODIFIED=NO
```

لا يجوز رفع أي آلية إلى `PROVEN` قبل عقد MAL محدد، وcorpus موجب وسلبي، ومخرج خام، وبصمة SHA-256، وإثبات إعادة إنتاج عبر البيئات. ولا يجوز إدخال ادعاءات التخطيط الحتمي لقواعد البيانات، أو هوية الذاكرة، أو العناوين الخام، أو سلوك JVM/GC غير المثبت في Tier-0.
