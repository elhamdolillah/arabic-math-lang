# تقرير ABI الآمن للمقاطع العددية الثابتة — Stage 6

## الحكم التنفيذي

أُضيفت وحدة `rust/mal_ownership_arena/src/wasm_safe_abi.rs` لتقديم عقد عددي ثابت مسبقاً دون مؤشرات أو أطوال أو تخصيص ديناميكي أو كتل `unsafe`. لم يبدأ Stage 7، ولم يتغير Baseline أو Corpus.

الحالة الدستورية:

```text
SAFE_ABI_IMPLEMENTATION=COMPLETED
UNSAFE_CODE=NOT_ADDED
MAL_ALLOC=NOT_ADDED
RAW_POINTERS=NOT_ADDED
STAGE7=NOT_STARTED
BASELINE_MODIFIED=NO
AUTO_PROMOTION=DENY
```

## العقد المتاح

تعتمد الواجهة على أربعة مقاطع ثابتة، لكل منها ثماني قيم عددية، وعلى عمليات الجمع والعدّ والمجموع الموزون وفحص السعة. يُرجع التقييم بنية `AbiResult` موسومة بـ `repr(C)`، وتُرفض المقاطع أو العمليات غير المعروفة بحالات صريحة.

| العنصر | القيمة |
|---|---:|
| إصدار ABI | 1 |
| عدد المقاطع | 4 |
| الحد الأقصى لعناصر المقطع | 8 |
| حالات الرفض | مقطع مجهول، عملية مجهولة، فيض، رفض سعة |

## التحقق

نجحت اختبارات Rust الخاصة بالنواة وABI: **8 اختبارات في الحزمة المستهدفة، و0 فشل**. نجح بناء Native للهدف `x86_64-unknown-linux-gnu` وبناء WASM للهدف `wasm32-unknown-unknown`.

وحدة WASM الناتجة صحيحة بنيوياً، لكن أدوات فحص exports الثنائية غير مثبتة في البيئة (`WASM_EXPORT_INSPECTOR=UNAVAILABLE`). كما أن استخدام `#[no_mangle]` أو `#[unsafe(no_mangle)]` ممنوع فعلياً تحت `#![forbid(unsafe_code)]`. لذلك فإن الدوال الحالية تمثل عقداً منطقياً آمناً داخل المكتبة، ولا يُعلن أنها exports بأسماء عامة قابلة للاستدعاء من المتصفح قبل إضافة آلية تصدير توافق الدستور.

> الحكم الحتمي: تم قبول ABI الآمن الداخلي، مع الامتناع عن إعلان تصدير WASM خارجي غير مثبت.

## البصمات

```text
a62f71e13d270fec856e7c6ef0addada06caa5f0dee211292e17f9a0a97a4c01  build_artifacts/stage6/mal_runner_x86_64
cdcee2bcdc12d29dcf419324e2329dcab4f0d12fe28daa36e680d5b28f65a1ad  build_artifacts/stage6/mal_engine_stage6_safe_abi.wasm
```

## الخلاصة

المسار الأكثر اتساقاً مع الدستور هو إبقاء `forbid(unsafe_code)` فعالاً، وعدم إضافة `mal_alloc` أو واجهة مؤشرات. ولتحويل العقد المنطقي إلى exports فعلية في المتصفح، يلزم اعتماد آلية تصدير آمنة ومثبتة لا تتطلب سمات unsafe؛ ولا تُفتح هذه الخطوة تلقائياً.

```text
STATUS=SAFE_ABI_ACCEPTED_EXTERNAL_WASM_EXPORT=ABSTAIN_PENDING_SAFE_EXPORT_MECHANISM
```

