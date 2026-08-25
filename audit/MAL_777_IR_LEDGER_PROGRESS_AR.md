# تقرير دفعة 777 مرحلة: سجل تعليمات IR الموحد

**المشروع:** UORI/MAL  
**التاريخ:** 2026-08-25  
**النطاق:** توحيد سجل تعليمات IR داخل Arena وربطه بحواجز ABI.

## الحكم التنفيذي

أُنجز عقد عربي مستقل لسجل تعليمات IR، ووحدة MAL مفهرسة، وcorpus حاكم من تسع حالات. يحفظ السجل العلاقة `(رقم_التعليمة، عملية_IR، مصدر_NodeID، الرتبة)`، ويقبل العمليات الخمس المعيارية فقط. تُرفض العمليات المجهولة، والأرقام الخارجة عن السعة، وإعادة استخدام NodeID، والرتب غير الصالحة.

هذا إثبات بنيوي وسياسة تصميمية فقط. لم يُنفذ مصدر MAL بسبب غياب المشغل الموثوق؛ ولذلك بقي التصنيف `RESEARCH / POLICY`، ولم يحدث ترفيع أو تعديل baseline.

## الملفات

| الملف | الغرض |
|---|---|
| `protocol/MAL_IR_INSTRUCTION_LEDGER_CONTRACT_v0.1_AR.md` | عقد السجل وقواعد ABI والحتمية |
| `extensions/mal_ir_instruction_ledger.ar` | سجل IR بلغة MAL فقط |
| `tests/MAL_IR_INSTRUCTION_LEDGER_CORPUS_v0.1_AR.json` | corpus موجب وسالب |
| `evidence/MAL_777_IR_LEDGER_VERIFY.stdout` | سجل التحقق الثابت |

## نتائج corpus

| الفئة | العدد |
|---|---:|
| حالات قبول | 5 |
| حالات امتناع | 4 |
| الإجمالي | 9 |

اجتاز corpus فحص البنية، واجتازت الوحدة مسحًا ثابتًا للمؤشرات الخام والتخصيص الديناميكي و`eval/exec` والتزامن غير الحتمي. وتبقى حالات الامتناع جزءًا مقصودًا من العقد وليست إخفاقات.

## البصمات

| العنصر | SHA-256 |
|---|---|
| عقد سجل التعليمات | يُستخرج من الملف عند تثبيت الحزمة |
| وحدة سجل IR | `09c75dcf01a5f91cb06a5b598cbf2f0f246ee97f6e6292bee6656566d67237f6` |
| corpus | `752130c1215344b299c25c4a5f156ebf7ede677617f0b58e00c2d763463b7c75` |
| سجل التحقق | `bf8e79c54ccf73061f4c67aefa7fc6863022ebe7711586db7df3f21ee9b20573` |
| مرجع الجرد السابق | `0a3b4b287308ef9b2d04bdf7ad25c831fce94cd49799953f8b03b39754cdbca2` |

## الوضع الدستوري

```text
RAW_POINTERS=DENY
DYNAMIC_ALLOCATION=DENY
EVAL_EXEC=DENY
NON_DETERMINISTIC_SCHEDULING=DENY
IR_LEDGER_ORDER=PASS_WITH_ABSTAIN
ABI_GATE=PASS_WITH_ABSTAIN
MAL_AR_RUNTIME=UNAVAILABLE
SOURCE_EXECUTION=NOT_PERFORMED
BASELINE_MODIFIED=NO
AUTO_PROMOTION=DENY
```

## القياس

لم تُشغّل أداة قياس النسبة الرسمية في هذه الدفعة، لذلك لم تُنشأ قيمة تقديرية. تبقى آخر قيمة رسمية موثقة لمؤشر `MAL / (MAL + Python)` هي **1.25278784%**.

## القرار التالي

الخطوة الآمنة التالية هي إنشاء جسر تحقق يطابق سجل AST→IR مع سجل التعليمات الموحد، ثم إضافة sidecar canonical يربط البصمة بالـ ABI. ولا يجوز إعلان التكافؤ التنفيذي أو تحديث baseline قبل توفر المشغل وتشغيل corpus فعليًا.
