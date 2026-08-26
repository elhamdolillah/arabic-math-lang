# تقرير دفعة 777 مرحلة: Sidecar AST→IR→ABI

**المشروع:** UORI/MAL  
**التاريخ:** 2026-08-25  
**النطاق:** توليد sidecar canonical حتمي وربطه بجسر AST→IR وبوابة ABI.

## الحكم التنفيذي

أُنجز عقد sidecar، ووحدة MAL لمولد sidecar، ونموذج artifact canonical، وسجل تحقق تكراري. يثبت النموذج ترتيب الحقول، ويرفض البصمات المفقودة، والعدد الخارج عن حدود Arena، والحالات غير المصرح بها.

النموذج الناتج **غير معتمد تنفيذيًا**؛ إذ إن حقول البصمات فيه placeholders إلى حين تشغيل المصدر عبر مشغل MAL موثوق. لذلك بقي التصنيف `RESEARCH / POLICY`، ولم يحدث ترفيع أو تعديل للـbaseline.

## الملفات المنجزة

| الملف | الغرض |
|---|---|
| `protocol/MAL_AST_IR_BRIDGE_CONTRACT_v0.1_AR.md` | عقد الجسر السابق |
| `extensions/mal_sidecar_generator.ar` | مولد sidecar بلغة MAL فقط |
| `artifacts/MAL_AST_IR_ABI_SIDECAR_v0.1_AR.json` | نموذج sidecar canonical |
| `evidence/MAL_777_SIDECAR_BASE.stdout` | مرجع المدخلات والحالة |
| `evidence/MAL_777_SIDECAR_VERIFY_RUN1.stdout` | تشغيل التحقق الأول |
| `evidence/MAL_777_SIDECAR_VERIFY_RUN2.stdout` | تشغيل التحقق الثاني |

## النتائج

| الفئة | النتيجة |
|---|---|
| فحص JSON | `PASS` |
| المسح الأمني | `PASS` |
| ترتيب sidecar | `PASS_WITH_ABSTAIN` |
| البصمات المفقودة | `ABSTAIN` مقصود |
| قابلية التنفيذ المصدرية | `NOT_PERFORMED` |
| التكرارية | `PASS` |

تطابقت بصمة سجلي التحقق، إذ كانت بصمة التشغيلين معًا:

```text
77bed6b4c9e1a5c8e301d45926a41e58ce5f80a331fe36b65d1d21a79bfe0f8e
```

## البصمات

| العنصر | SHA-256 |
|---|---|
| سجل المرجع | `a58063be4371f23b53ae200e71aa09b1707c86f6512b3cfb5c5631ca64e2098b` |
| وحدة مولد sidecar | تُثبت عند حزم الدفعة |
| نموذج sidecar | يُثبت عند حزم الدفعة |
| تحقق التشغيلين | `77bed6b4c9e1a5c8e301d45926a41e58ce5f80a331fe36b65d1d21a79bfe0f8e` |

## الوضع الدستوري

```text
RAW_POINTERS=DENY
DYNAMIC_ALLOCATION=DENY
EVAL_EXEC=DENY
NON_DETERMINISTIC_SCHEDULING=DENY
SIDECAR_CANONICAL_ORDER=PASS_WITH_ABSTAIN
MISSING_FINGERPRINTS=ABSTAIN
MAL_AR_RUNTIME=UNAVAILABLE
SOURCE_EXECUTION=NOT_PERFORMED
BASELINE_MODIFIED=NO
AUTO_PROMOTION=DENY
```

## القياس

لم تُشغّل أداة قياس النسبة الرسمية في هذه الدفعة، ولذلك لم تُنشأ نسبة تقديرية. آخر قيمة رسمية موثقة لمؤشر `MAL / (MAL + Python)` هي **1.25278784%**.

## القرار التالي

بعد توفر مشغل MAL، يجب استبدال placeholders ببصمات ناتجة عن تشغيل موثق، ثم إعادة بناء sidecar مرتين، ومقارنة AST وIR وABI والسجل النهائي. قبل ذلك لا يجوز استخدام artifact للاعتماد أو تحديث baseline.
