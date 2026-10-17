# تقرير دفعة 777 مرحلة: جسر AST إلى IR وSidecar

**المشروع:** UORI/MAL  
**التاريخ:** 2026-08-25  
**النطاق:** بناء جسر فهرسي بين AST وسجل IR وبوابة ABI، مع تعريف sidecar canonical.

## الحكم التنفيذي

أُنجز عقد عربي لجسر AST→IR→ABI، ووحدة MAL مفهرسة، وcorpus حاكم من تسع حالات. يحافظ الجسر على ترتيب `NodeID → IR Ordinal → ABI Symbol`، ويرفض التكرار، والرتب غير الصالحة، والأرقام الخارجة عن حدود Arena، والعمليات غير المصرح بها.

أُدرج ترتيب sidecar canonical وحقول البصمات في corpus، لكن لم يُنشأ sidecar اعتماد تنفيذي؛ لأن مشغل MAL الموثوق غير متاح. لذلك يبقى التصنيف `POLICY / RESEARCH`، وتبقى `SOURCE_EXECUTION=NOT_PERFORMED` و`AUTO_PROMOTION=DENY`.

## الملفات

| الملف | الغرض |
|---|---|
| `protocol/MAL_AST_IR_BRIDGE_CONTRACT_v0.1_AR.md` | عقد الجسر والـsidecar |
| `extensions/mal_ast_ir_bridge.ar` | تنفيذ الجسر بلغة MAL فقط |
| `tests/MAL_AST_IR_BRIDGE_CORPUS_v0.1_AR.json` | حالات القبول والامتناع |
| `evidence/MAL_777_BRIDGE_VERIFY.stdout` | سجل التحقق الثابت |
| `evidence/MAL_777_BRIDGE_BASE.stdout` | مرجع ما قبل التنفيذ |

## نتائج corpus

| الفئة | العدد |
|---|---:|
| حالات قبول | 5 |
| حالات امتناع | 4 |
| الإجمالي | 9 |

تشمل حالات الامتناع عدم تطابق ABI، وإعادة NodeID، والرتبة الصفرية، وتجاوز حدود Arena. هذه النتائج متوقعة دستوريًا وليست مسار فشل مفتوح.

## التحقق والبصمات

اجتاز corpus فحص البنية، واجتازت الوحدة المسح الثابت للمؤشرات الخام والتخصيص الديناميكي و`eval/exec` ومسارات التزامن غير الحتمي. سجل التحقق:

```text
33391464f59548b4b9d22512dce7ab2be2bf0f30990b4e14f3dc31a5a17823d8
```

| العنصر | SHA-256 |
|---|---|
| عقد الجسر | `d8017a8e67ec8cfaf1cf9d3554e675fbdc73863980db46785544324436a73107` |
| وحدة الجسر | `d8e0ac2575137c2900f4aa3a69cb60de7e9eaf60f9a4d1669c075ed738d0a684` |
| corpus الجسر | `ad329301063968612b3e82fd85cd8836fda18c5595dafff1ffd75c42a1333a21` |
| مرجع الدفعة | `1499dee9979b87ace3728cf50560a7df148b215b03cda9ac76ffd8aa28c5ba3c` |

## القيود الدستورية

```text
RAW_POINTERS=DENY
DYNAMIC_ALLOCATION=DENY
EVAL_EXEC=DENY
NON_DETERMINISTIC_SCHEDULING=DENY
SIDECAR_ORDER=PASS_WITH_ABSTAIN
ABI_GATE=PASS_WITH_ABSTAIN
MAL_AR_RUNTIME=UNAVAILABLE
SOURCE_EXECUTION=NOT_PERFORMED
BASELINE_MODIFIED=NO
AUTO_PROMOTION=DENY
```

## نسبة الهجرة

لم تُشغّل أداة قياس النسبة الرسمية في هذه الدفعة، ولذلك لم تُنشأ نسبة تقديرية. تبقى آخر قيمة رسمية موثقة لمؤشر `MAL / (MAL + Python)` هي **1.25278784%**.

## القرار التالي

الخطوة التالية الآمنة هي إنشاء سجل sidecar فعلي من مدخلات ثابتة بعد توفر مشغل MAL، ثم إجراء مقارنة ثنائية بين ناتج الجسر وناتج Python المرجعي. ولا يجوز تحديث baseline أو اعتماد `PROVEN` قبل اكتمال هذا الإثبات.
