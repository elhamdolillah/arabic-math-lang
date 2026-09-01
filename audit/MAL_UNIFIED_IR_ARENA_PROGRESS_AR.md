# تقرير دمج Arena الموحدة لسجل IR

**التاريخ:** 2026-08-25  
**النطاق:** دمج AST/IR وبوابة ABI في Arena مسطحة، واختبار الترتيب المعياري، وتجميد baseline.

## الحكم

أُنجز عقد Arena الموحدة، ووحدة MAL لسجل AST/IR/ABI الموحد، وcorpus حاكم من **8 حالات**: **5 PASS** و**3 ABSTAIN**. يرفض السجل العملية غير المعيارية، والترتيب غير المتزايد، وتجاوز السعة، دون إعادة ترتيب ضمنية أو إصلاح صامت.

## اختبار الترتيب والتكرارية

اجتاز corpus التحقق البنيوي والمسح الأمني. تطابقت بصمتا سجلي التحقق في التشغيلين:

```text
492d8623613180d3a25a3364a465b6ef5aab10ccc9a9845ed76467a2cac0880c
```

وهذا يثبت تكرارية **سجل التحقق نفسه**. أما تنفيذ مصدر MAL، فلم يُجرَ لأن المشغل الموثوق غير متاح؛ لذلك يبقى اختبار التكافؤ التنفيذي `ABSTAIN`.

## sidecar المؤجل

أُعدّت مدخلات sidecar في `artifacts/MAL_AST_IR_ABI_SIDECAR_v0.1_AR.json` باستخدام ترتيب ثابت، لكن بصمات AST وIR وABI التنفيذية لا تزال غير قابلة للإصدار. ستُملأ مباشرة من التشغيل الموثوق عند توفره، ثم يُعاد الاختبار الثنائي مقابل Python المرجعي.

## حالة baseline

| البند | الحالة |
|---|---|
| تجميد baseline | `ACTIVE` |
| تعديل الشجرة | `NO` |
| commit أو tag | `NOT_PERFORMED` |
| تشغيل MAL المصدري | `NOT_PERFORMED` |
| الترفيع الآلي | `DENY` |

## الحواجز

```text
RAW_POINTERS=DENY
DYNAMIC_ALLOCATION=DENY
EVAL_EXEC=DENY
NON_DETERMINISTIC_SCHEDULING=DENY
CANONICAL_ORDERING=PASS_WITH_ABSTAIN
REPRO_PASS=PASS_FOR_AUDIT_RECORD
SOURCE_EXECUTION=NOT_PERFORMED
BASELINE_FREEZE=ACTIVE
AUTO_PROMOTION=DENY
```

## نسبة الهجرة

لم تُشغّل أداة القياس الرسمية في هذه الدورة؛ لذلك لم تُنشأ نسبة تقديرية. آخر نسبة رسمية موثقة هي **1.25278784%** لمؤشر `MAL / (MAL + Python)`.

## القرار

تُعتمد النتيجة كإنجاز بنيوي وسياساتي فقط. لا يجوز إعلان `PROVEN` أو تحديث baseline قبل توفر مشغل MAL، وإصدار sidecar ببصمات فعلية، وإتمام المقارنة الثنائية مع Python.
