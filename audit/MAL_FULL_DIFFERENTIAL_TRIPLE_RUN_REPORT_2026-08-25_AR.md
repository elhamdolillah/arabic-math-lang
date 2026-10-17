# تقرير التدقيق التفاضلي المرجعي الثلاثي

## الملخص التنفيذي

نُفذت جولة مقارنة تفاضلية كاملة على 27 ملفًا من Corpus المحلي، بعد ربط حزام الفحص بنموذج Python مرجعي مستقل للنحو المحدود المثبت. أُجريت ثلاث تشغيلات متتالية، فكانت المخرجات النصية متطابقة بتًا ببت، كما طابقت مخرجات `mal_runner` مخرجات النموذج المرجعي في جميع الحالات السبع والعشرين.

لا يساوي هذا الإثبات وجود مشغل MAL سيادي كامل؛ فهو محصور في النحو التجريبي المثبت وصيغة تعريف عقدة عددية محدودة، ولا يثبت الترجمة إلى Assembly أو الاستضافة الذاتية أو تغطية اللغة الكاملة.

## النتائج المقاسة

| المؤشر | النتيجة |
|---|---:|
| ملفات Corpus | 27 |
| الحالات المحللة محدوديًا | 24 |
| حالات `ABSTAIN` | 3 |
| حالات `FAIL` | 0 |
| التطابق المرجعي canonical | 27 من 27 |
| الاختلافات | 0 |
| التشغيلات المتتالية | 3 |
| تطابق stdout بين التشغيلات | 3 من 3 |
| SHA-256 الموحد للـ stdout | `3c58974b1dcae63b18bd1e1c1d3766b0818e7401420259d258f6b3c8327bed58` |

## مخرجات التشغيل

```text
DIFFERENTIAL_STATUS=MATCHED_CANONICAL FILES=27 PARSED=24 ABSTAIN=3 FAIL=0 MATCHES=27 MISMATCHES=0 MISSING_DIRS=0
```

ظهرت السلسلة نفسها في التشغيلات الثلاثة، وكانت رموز الخروج الثلاثة مساوية للصفر لأن المقارنة الكاملة نجحت ضمن النطاق المحدود.

## حدود الإثبات

يثبت التقرير أن النموذج المرجعي Python وحساس Rust الحالي يعيدان الحالة والمخرج النصي نفسه لكل ملفات Corpus الحالية. ولا يثبت أن النموذجين مستقلان دلاليًا على مستوى اللغة العامة، ولا يثبت توفر Parser شامل أو Interpreter أو Codegen أو Sidecar تنفيذي عام. كما أن حالات الامتناع الثلاث طابقت المرجع، لكنها لا تمنح اعتمادًا تلقائيًا لأي بناء لغوي خارج النحو المحدد.

وعليه، تُقبل الحالة التالية فقط:

```text
MAL_RUNNER_BUILD=PASSED
CORPUS_FILES=27
TRIPLE_RUN_REPRODUCIBILITY=PASSED
REFERENCE_COMPARISON=MATCHED_CANONICAL_SCOPED
DIFFERENTIAL_EXECUTION=PERFORMED_TRIPLE_RUN_SCOPED
PARSED_EXTENSION_SCOPED=24
ABSTAIN=3
FAIL=0
MAL_AR_RUNTIME=AVAILABLE_FOR_PROVEN_GRAMMAR_ONLY
SOURCE_EXECUTION=VERIFIED_ON_SCOPED_CORPUS
AUTO_PROMOTION=DENY
BASELINE_FREEZE=ACTIVE
BASELINE_MODIFIED=NO
STATUS=PASSED_SCOPED_ONLY
```

لا يجوز تحويل `MAL_AR_RUNTIME` إلى توفر عام، ولا رفع أي وحدة إلى `PROVEN` خارج هذا النطاق، ولا فك تجميد baseline استنادًا إلى هذا التقرير وحده.

## الأدلة

```text
evidence/MAL_DIFFERENTIAL_FULL_RUN1.stdout
evidence/MAL_DIFFERENTIAL_FULL_RUN2.stdout
evidence/MAL_DIFFERENTIAL_FULL_RUN3.stdout
evidence/MAL_FULL_TRIPLE_RUN_AUDIT_2026-08-25.sha256
evidence/MAL_DIFFERENTIAL_EXECUTION_2026-08-25.json
scripts/mal_reference_model.py
scripts/mal_differential_runner.py
```

## القرار

النتيجة `MATCHED_CANONICAL` صحيحة ومثبتة **ضمن Corpus والنحو المحدودين فقط**. أما حالة المشغل السيادي الكامل، والتكافؤ العام، والترقية الآلية، فتبقى محكومة بالامتناع والتجميد.
