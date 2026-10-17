# مراجعة دستورية للآليات 81–85

## النطاق والمرجع

تراجع هذه الوثيقة الآليات الخمس المرفقة مستقلاً عن خط الأساس المجمد `MAL_GRAMMAR_SPEC_v0.1_AR.md`. وجود آلية في لغة أخرى لا يثبت قابليتها للترجمة أو التنفيذ الحتمي في MAL/UORI. لم تُنفّذ أي شيفرة بحثية أو مصدر خارجي، ولم تُقبل أي ميزة في وقت التشغيل.

## جدول القرار

| الرقم | الآلية | القرار | سبب القرار المختصر |
|---:|---|---|---|
| 81 | Bash `set -e` | `RESEARCH` | سياسة للتحكم في خروج shell، لكنها لا تغطي استثناءات السياق ولا التراجع عن الآثار الجانبية. |
| 82 | TypeScript `as const` | `RESEARCH` | تضييق نوعي وقت الترجمة، وليس ضماناً عاماً لعدم التغيير وقت التشغيل أو عبر المراجع الخارجية. |
| 83 | Rust `#[repr(align(N))]` | `ABSTAIN_UNTIL_EVIDENCE` | محاذاة نوعية مرتبطة بالهدف؛ لا تثبت العنوان أو ABI أو المخصّص، ومثال المؤشر الخام مرفوض دستورياً. |
| 84 | C `restrict` | `ABSTAIN_UNTIL_EVIDENCE` | عقد aliasing قد يؤدي خرقه إلى undefined behavior، ولا يملك مسار رفض آمن، كما يعتمد على مؤشرات خام. |
| 85 | SQL `UNIQUE` | `RESEARCH` | يثبت قيد uniqueness عند حد قاعدة بيانات محدد فقط؛ يلزم تثبيت المحرك والدلالة الخاصة بـNULL والتجميع والعزل وترتيب النتائج. |

## تطبيق بوابة MAL/UORI

تم تثبيت التصنيف في registry مستقل، وسُجلت الحالات في corpus مستقل. القرار الابتدائي لكل الآليات هو عدم الإدخال إلى runtime. لا يُسمح برفع أي آلية إلى `PROVEN` أو `EXTENSION_SCOPED_PROVEN` قبل وجود عقد نطاقي، دلالة canonical، حالات فشل معلنة، اختبارات خام، بصمة، وسلسلة تحقق ناجحة.

تعارض الآليتان 83 و84 مباشرةً مع سياسة `raw_pointers: DENY` بصيغتهما المقترحة. أما 81 و82 و85 فليست مرفوضة بذاتها، لكنها لا تملك عقد MAL/UORI ولا أدلة تنفيذية تجعلها أكثر من `RESEARCH`.

## متطلبات الانتقال اللاحق

يجب أن يحدد أي امتداد لاحق الإصدار والهدف والأنواع وترتيب العمليات وحدود الموارد، وأن يضيف corpus إيجابياً وسلبياً، وstdout خاماً، وبصمة SHA-256، والتحقق من السلسلة. يجب أن تكون المخالفات structured rejection أو `ABSTAIN`، لا undefined behavior ولا قبولاً ضمنياً. لا يجوز تنفيذ shell أو source_ref أو eval أو exec أو شبكة أثناء المراجعة.

## حالة الأدلة

```text
CONSTITUTION_REVIEW=PASS_WITH_GUARDS
RULES_EXECUTIVELY_ADOPTED=0
RUNTIME_FEATURES_ADMITTED=0
SOURCE_EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
BASELINE_MODIFIED=NO
```

## الملفات

- `protocol/MAL_ATTACHED_MECHANISMS_81_85_REGISTRY_AR.json`
- `tests/MAL_ATTACHED_MECHANISMS_81_85_CORPUS_AR.json`
- `evidence/MAL_ATTACHED_MECHANISMS_81_85_REVIEW_AR.stdout`
- `evidence/MAL_ATTACHED_MECHANISMS_81_85_REVIEW_AR.sha256`
