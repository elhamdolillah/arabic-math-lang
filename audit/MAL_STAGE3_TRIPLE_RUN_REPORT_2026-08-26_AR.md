# تقرير التدقيق التفاضلي الثلاثي للمرحلة الثالثة

**التاريخ الحتمي:** 1970-01-01T00:00:00Z وفق `SOURCE_DATE_EPOCH=0`.

## نطاق التنفيذ

تم ربط Parser وRunner بالتقييم المتسلسل للتصريحات المفصولة بأسطر، وإضافة عقدة `Sequence`، وجدول الرموز ثابت السعة، والمقيّم الحسابي الحتمي. يظل التنفيذ مقيدًا بالنحو المثبت ولا يمثل استضافة ذاتية كاملة للغة MAL.

## النتائج المقاسة

| المعيار | النتيجة |
|---|---:|
| ملفات Stage 0 | 18 |
| ملفات Stage 1 | 9 |
| ملفات Stage 2 | 12 |
| ملفات Stage 3 | 15 |
| إجمالي الملفات | 54 |
| التحليل المحدود | 42 |
| الامتناع | 12 |
| الفشل غير المتوقع | 0 |
| التطابق canonical | 54/54 |
| الاختلافات | 0 |
| حالة المقارنة المرجعية | `MATCHED_CANONICAL` |

أُجريت ثلاثة تشغيلات متتالية للحزام التفاضلي. أنتجت التشغيلات الثلاثة السطر نفسه:

```text
DIFFERENTIAL_STATUS=MATCHED_CANONICAL FILES=54 PARSED=42 ABSTAIN=12 FAIL=0 MATCHES=54 MISMATCHES=0 MISSING_DIRS=0
```

وكانت بصمة سجلات التشغيل الثلاثة موحدة:

```text
576128ce00e26f8511b23c9399c22f07416bf6c5bf63eec8bf8954f83bf196f8
```

## قياس نسبة الهجرة

وفق أداة القياس الرسمية على الشجرة الحالية:

| المؤشر | القيمة |
|---|---:|
| إجمالي SLOC | 1,426,002 |
| SLOC للمصدر العربي الرياضي | 1,262 |
| SLOC لبايثون | 56,898 |
| العربية / الكل | 0.09% |
| العربية / (العربية + بايثون) | 2.17% |
| بايثون / الكل | 3.99% |
| عقد الامتناع | 23 |
| بصمة سجل القياس | `b732012aa005dd6b8a936ee067a7c87e8a9420bf2ad89ee63f46b491113c2ea9` |

هذه النسبة قياس وصفي حتمي للشجرة الحالية، ولا تُعد دليلًا على اكتمال الهجرة أو الاستضافة الذاتية.

## الحكم الدستوري

```text
BASELINE_FREEZE=ACTIVE
BASELINE_COMMIT=f44f2f0
BASELINE_COMMIT_UNCHANGED=YES
LOCAL_STAGE3_COMMIT=PENDING_FINAL_REVIEW
STAGE3_CORPUS=15_FILES_PRESENT
CORPUS_FILES=54
STAGE3_UNIT_TESTS=PASSED
REFERENCE_COMPARISON=MATCHED_CANONICAL
DIFFERENTIAL_EXECUTION=PERFORMED_TRIPLE_RUN_SCOPED
PARSED_EXTENSION_SCOPED=42
ABSTAIN=12
FAIL=0
MAL_AR_RUNTIME=AVAILABLE_FOR_SCOPED_MULTI_STATEMENT_EVALUATION_ONLY
AUTO_PROMOTION=DENY
STATUS=PASSED_STAGE3_SCOPED_ONLY
```

## حدود الاعتماد

يثبت هذا التقرير التكافؤ المرجعي للنطاق الذي تغطيه حزمة Corpus الحالية فقط. ولا يثبت اكتمال قواعد اللغة العامة، ولا يثبت غياب جميع مسارات التخصيص خارج المسار المنفذ، ولا يبرر تغيير `BASELINE_FREEZE` أو تفعيل `AUTO_PROMOTION`.

تم حفظ التقرير البنيوي canonical وسجلات التشغيل الثلاثة وملف بصماتها وسجل قياس النسبة في مجلد `evidence/`.

**المؤلف:** Manus AI
