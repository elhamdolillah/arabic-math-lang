# التقرير النهائي لإصلاح دالة أُس في C40

## النتيجة

أُصلحت دالة **أُس** في C40 باستخدام حساب داخلي Q64.64 مع حاصل ضرب وسيط بعرض 128 بت، مع إبقاء خرج الواجهة بصيغة Q32.32. لم تُقبل النتيجة اعتماداً على تقريب `math.exp` الثنائي؛ بل استُخدم مرجع C مستقل مبني على `long double` للمقارنة المباشرة، مع حد صارم `حد_الخطأ = 16` وحدة Q32.32.

> معيار القبول: `abs(فعلي_Q32 - مرجع_Q32) <= 16` لكل حالة، مع نجاح البناء والتنفيذ على x86_64/NASM.

## الأدلة العددية

| الاختبار | الحالات | النتيجة | أقصى فرق مطلق |
|---|---:|---:|---:|
| إعادة إنتاج C40 | 8 | 8/8 | 1 |
| إجهاد Q32.32 بمرجع C مستقل | 21 | 21/21 | 4 |
| مرجع C Q64.64 الداخلي | 12 حدّاً | 0 إخفاق | 3 |

في حالة الحد الموجب `x_Q32 = 91912300134`، كان المرجع `8450098549233815825` والخرج الفعلي `8450098549233815821`، أي فرق `-4` فقط. أما الحد السالب المقابل فأعطى الفرق `0`.

## التحقق العتادي

أُعيد البناء والتنفيذ على VPS Ubuntu 24.04 x86_64 باستخدام Python 3.12.3 وNASM 2.16.01 وGNU ld 2.42. سجل بوابة VPS رقم `20260820T172944Z` أثبت:

```text
RC_c40_reproduction=0
RC_c40_q32_stress=0
النتيجة: ناجح=21 فاشل=0 المجموع=21
STATUS=مقبول-للمراجعة-فقط
```

كما نجح GitHub Actions في الالتزام `5e437104a40c0cf1bc91c529c758de2b38780367` بعد تثبيت NASM داخل بيئة CI. نجحت جميع مراحل workflow: فحص Python، بناء مرجع C، تشغيل مرجع Q64.64، وتشغيل بوابة إجهاد Q32.32.

## سلسلة المصدر

الفرع: `fix/c40-q64-exp`

الالتزام الذي يحتوي إصلاح مسار الاختبار النهائي: `e7595db20b37b168133e18f338c4250f30c352f7`

الالتزام الذي يثبت بيئة GitHub Assembly: `5e437104a40c0cf1bc91c529c758de2b38780367`

حالة العمل المحلية نظيفة بعد النشر، ولم تُنفذ عملية merge تلقائية داخل بوابة VPS؛ الدمج النهائي يتم فقط عبر GitHub بعد مراجعة هذا التقرير.

## ملاحظة منهجية

أظهر الاختبار الأولي فرقاً كبيراً ظاهرياً عند استخدام `math.exp`، لكن التحقيق أثبت أن مصدر الفرق هو دقة المرجع الثنائي عند تحويل القيم الكبيرة إلى Q32.32، لا خطأ في النواة. لذلك أضيف وضع argv إلى مرجع C المستقل، واستُخدم هذا المرجع في اختبار الإجهاد المنشور. هذا يمنع قبول إصلاح أو رفضه بسبب oracle غير كافٍ.

## الحكم

الإصلاح **مُثبت عددياً وعتادياً ضمن العتبة المحددة**: 21/21 محلياً، 21/21 على VPS، ونجاح GitHub CI. لا يتضمن هذا التقرير ادعاء إثبات Coq أو Lean؛ الإثبات المتاح هنا هو نموذج الحساب الصحيح، oracle مستقل، تحقق Assembly فعلي، وتكامل CI قابل لإعادة التشغيل.

**القرار المقترح:** السماح بفتح Pull Request ودمج الفرع بعد مراجعة بشرية أخيرة للتقرير.

## المراجع

1. [UORI Arabic Math Language repository](https://github.com/elhamdolillah/arabic-math-lang)
2. [GitHub Actions run 32398053487](https://github.com/elhamdolillah/arabic-math-lang/actions/runs/32398053487)
3. [Repair branch fix/c40-q64-exp](https://github.com/elhamdolillah/arabic-math-lang/tree/fix/c40-q64-exp)
4. [Q64.64 reference source](https://github.com/elhamdolillah/arabic-math-lang/blob/fix/c40-q64-exp/tests/c40_q32_verification/ref_exp_q64.c)
5. [Q32.32 stress gate](https://github.com/elhamdolillah/arabic-math-lang/blob/fix/c40-q64-exp/tests/c40_q32_verification/test_c40_q32_stress.py)

_المؤلف: Manus AI_
_التاريخ: 20 أغسطس 2026_
تمام_بحمد_الله

---

# Final C40 Exponent Repair Report

The C40 exponent implementation now uses Q64.64 internal arithmetic with 128-bit intermediate products while preserving a Q32.32 public result. Acceptance uses an independent C oracle and the strict threshold `abs(actual - reference) <= 16`.

The final evidence is 8/8 reproduction cases, 21/21 Q32.32 stress cases on the VPS, and a successful GitHub Actions run for commit `5e437104a40c0cf1bc91c529c758de2b38780367`. The maximum absolute stress error was 4 ULPs. No Coq or Lean proof was performed; the available evidence consists of the arithmetic model, independent oracle, x86_64 Assembly execution, VPS gate, and reproducible CI workflow.
