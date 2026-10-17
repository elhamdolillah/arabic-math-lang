# تقرير المراجعة — الآليات 154–158 ومطابقة MAL-DIR v0.2

## نطاق المراجعة

احتوى المرفق على خمس آليات بحثية جديدة، مرقمة من 154 إلى 158، ولم يحتوِ على دليل MAL-DIR أو نتائج تنفيذ مزدوج أو بصمات `MATCHES`/`FAILURES`. لذلك عولج في مسار مراجعة دستورية مستقل، مع إجراء مطابقة منفصل لسجل MAL-DIR v0.2 الموجود في المستودع.

## التصنيف الدستوري

| الرقم | المفهوم الموحد | التصنيف | سبب الحماية |
|---:|---|---|---|
| 154 | نطاق تحرير مؤجل | `ABSTAIN_UNTIL_EVIDENCE` | يعتمد على runtime خارجي وعمر كائنات غير ممثل في عقد MAL الحالية. |
| 155 | فرع شرطي وقت الترجمة | `RESEARCH_DUPLICATE` | مكرر دلاليًا للآلية 141؛ يلزم عقد موحد بدل إضافة Grammar ثانية. |
| 156 | قاموس مرتب حسب الإدراج | `RESEARCH` | يحتاج arena قاموسية ومساواة وحذفًا وإعادة إدراج canonical. |
| 157 | منع أثر جامع القمامة | `RESEARCH` | يحتاج تحليل أثر تخصيص ساكنًا على كامل سلسلة الاستدعاء. |
| 158 | تقييد قيمة المعلمة بمجموعة | `RESEARCH` | يحتاج مجموعة ثابتة ورسالة رفض canonical قبل دخول جسم الدالة. |

لم تُنفذ أي مصادر أجنبية، ولم تُقبل أي ميزة runtime: `runtime_features_admitted=0`، و`SOURCE_EXECUTION=NOT_PERFORMED`، و`AUTO_PROMOTION=DENY`.

## إعادة بناء corpus الموحد

```text
UNIFIED_CORPUS=PASS
REGISTERED_ENTRIES=90
ATTACHED_MECHANISMS=31-50,78-85,94-105,116-120,121-126,127-131,137-142,154-158
SOURCE_EXECUTION=NOT_PERFORMED
RAW_POINTERS=DENY
BASELINE_MODIFIED=NO
STATUS=0
```

تمت إضافة registry وcorpus 154–158 إلى مولد corpus الموحد، وأعيد بناء `tests/MAL_UNIFIED_GOVERNED_CORPUS_AR.json` حتميًا. تحقق JSON للregistry والcorpus والملف الموحد بنجاح بعد تصحيح مسار فحص registry إلى مجلد `protocol` الصحيح.

## مطابقة MAL-DIR v0.2

لم يغيّر المرفق دليل MAL-DIR ولم يضف حالات جديدة إليه. بقي السجل التنفيذي السابق كما هو، وبصمته:

```text
f6126297611b5bef343d702728b7fdd1af6a8040c06069d1824542aa72392f9e
```

وتظل نتيجته المعتمدة:

```text
MAL_DIR_DIFFERENTIAL_V02=PASS
CASES=11
MATCHES=11
FAILURES=0
AUTO_PROMOTION=DENY
```

## حالة baseline

لم يُنشأ commit جديد، ولم يُحدّث tag، ولم يُعدّل baseline النواة. التغييرات الحالية محصورة في سجل الآليات الجديدة، corpus الموحد، التقرير، وحزمة الأدلة. الحالة الدستورية هي `CONSTITUTION_REVIEW=PASS_WITH_GUARDS`، مع `RULES_EXECUTIVELY_ADOPTED=0`.
