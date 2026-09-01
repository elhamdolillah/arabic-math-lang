# تقرير بوابة الفحص التفاضلي

**التاريخ:** 2026-08-25  
**المشغل:** `rust/mal_ownership_arena/target/release/mal_runner`  
**النطاق:** تشغيل CLI المحدود على Corpus الموجود فعليًا

## الحكم التنفيذي

أُنشئ حزام تفاضلي مصحح يرفض إعلان التكافؤ عند غياب Corpus أو النموذج المرجعي. شُغّل الحزام بنجاح تقنيًا، لكنه أعاد `ABSTAIN` لأن المسارين المتوقعين غير موجودين في الشجرة الحالية:

```text
corpus/stage0_18_files
corpus/stage1_9_files
```

لذلك لم تُشغّل أي ملفات `.ar` في هذه الدورة، ولم تُنفذ مقارنة مع Python، ولم تُستخرج بصمات AST أو Sidecar تنفيذية.

## النتيجة الفعلية

| المؤشر | النتيجة |
|---|---:|
| ملفات Corpus المكتشفة | 0 |
| مجلدات Corpus المفقودة | 2 |
| حالات Parser | 0 |
| حالات ABSTAIN من Runner | 0 |
| حالات فشل | 0 |
| المقارنة المرجعية | `NOT_PERFORMED` |
| حالة الحزام | `ABSTAIN` |
| رمز خروج السكريبت | 0 |

السجل الخام محفوظ في:

```text
evidence/MAL_DIFFERENTIAL_EXECUTION_2026-08-25.stdout
```

والتقرير canonical محفوظ في:

```text
evidence/MAL_DIFFERENTIAL_EXECUTION_2026-08-25.json
```

أما البصمات فمحفوظة في:

```text
evidence/MAL_DIFFERENTIAL_EXECUTION_2026-08-25.sha256
```

## تصحيح المقترح المرفق

المقترح الأصلي كان سيعلن `differential_status=COMPLETED` حتى عندما لا توجد ملفات، وكان يعدّ كل مخرج لا يحتوي `STATUS=PASS` حالة `ABSTAIN` رغم أن `mal_runner` الحالي يصدر `STATUS=PARSED`. كما أن عداد `failed` لم يكن يزداد، وكان `git_commit` مثبتًا نصيًا دون إثبات HEAD، ولم يكن هناك نظير Python فعلي للمقارنة.

عولجت هذه النقاط في:

```text
scripts/mal_differential_runner.py
```

فأصبح الحزام يسجل المجلدات المفقودة، ويفصل بين `PARSED_EXTENSION_SCOPED` و`ABSTAIN` و`FAIL`، ويستخدم JSON canonical، ولا يعلن المقارنة المرجعية إلا بعد تنفيذها فعلًا.

## الموقف الدستوري

```text
STAGE0_FIXED_ARENA=PASSED
STAGE1_LEXER_PARSER=EXTENSION_SCOPED_PROVEN
DIFFERENTIAL_HARNESS=IMPLEMENTED
DIFFERENTIAL_EXECUTION=NOT_PERFORMED
REFERENCE_COMPARISON=NOT_PERFORMED
MAL_AR_RUNTIME=UNAVAILABLE
SOURCE_EXECUTION=NOT_PERFORMED
AUTO_PROMOTION=DENY
BASELINE_FREEZE=ACTIVE
BASELINE_MODIFIED=NO
STATUS=ABSTAIN
```

لا يجوز بناءً على هذه الدورة إعلان `MAL_AR_RUNTIME=AVAILABLE_FOR_PARSER_EXTENSIONS` أو `SOURCE_EXECUTION=VERIFIED_ON_PROVEN_GRAMMAR`؛ فغياب Corpus منع الاختبار الفعلي، كما أن Runner الحالي محدود النحو ولا يثبت لغة MAL الكاملة.

## شرط المتابعة

قبل أي ادعاء بالمطابقة الثنائية، يجب توفير Corpus فعلي موثق، وربط كل حالة بنتيجتها المتوقعة، وتوفير نموذج Python مرجعي مستقل، ثم تشغيل كل حالة ثلاث مرات مع تطابق المخرجات canonical وبصماتها.
