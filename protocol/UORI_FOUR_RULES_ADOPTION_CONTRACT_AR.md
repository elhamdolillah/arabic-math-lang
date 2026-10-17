# عقد اعتماد امتداد القواعد الأربع

**المعرّف:** `uori-four-rules-extension-v1`  
**الفرع:** `adoption/uori-four-rules-2026-08-25`  
**المرجع المجمد خارج هذا الفرع:** `uori-wave77-freeze-2026-08-24` / `f56b8bd`  
**النطاق:** امتداد Python `extensions/uori_validated_math.py` فقط.

## القواعد الداخلة

1. الحساب النسبي والفاصل: `Interval.add`, `sub`, `mul`, `div` باستخدام `Fraction`.
2. شروط الشكل: `require_same_shape` مع رفض الأطوال المختلفة.
3. التجميع الحتمي: `interval_sum` بترتيب الإدخال الثابت داخل نموذج أحادي العملية.
4. حارس التقارب: `convergence_guard` مع tolerance وfuel، ولا يمنح قبولاً إلا عند تحقق الخطأ.

## شروط القبول

تُقبل النتيجة فقط إذا كان التمثيل canonical، والأنواع معلنة، والترتيب ثابتاً، وحالات الفشل صريحة، وتطابقت مخرجات التشغيلات مع fixture المرجعية، ونجحت سلسلة SHA-256.

## حالات الرفض/الامتناع

`DIVISOR_CONTAINS_ZERO`, `SHAPE_MISMATCH`, `INTERVAL_ORDER_INVALID`, `NON_CANONICAL_NUMBER`, `FUEL_INVALID`، وأي نتيجة تقريبية لم تحقق `error <= tolerance` تعاد كامتناع أو خطأ نطاقي، ولا تستبدل بقيمة تخمينية.

## حدود السلطة

لا يثبت هذا العقد دمج القواعد في wheel المجمد أو kernel أو WASM أو العتاد أو التوازي الفعلي. لا ينفذ `source_ref` أو نصاً بحثياً أو شبكة أو ساعة. لا يعتمد بيانات المرفق المرفق كدليل رياضي؛ استُخدم كمرجع وصفي فقط.

## قرار العقد

```text
ADOPTION_SCOPE=EXTENSION_ONLY
KERNEL_ADOPTION=NO
WASM_ADOPTION=NO
UNTRUSTED_SOURCE_EXECUTION=NO
BASELINE_MODIFIED=NO
```
