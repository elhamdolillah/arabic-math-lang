# تقرير بوابة المشغل التنفيذي لـ MAL — 2026-08-25

## النطاق

يفحص هذا التقرير ما إذا كانت مكونات المستودع المقدمة تمثل مشغلًا موثوقًا قادرًا على قراءة ملفات `.ar` وتشغيلها، أم أنها تقتصر على اختبار طبقة Arena. لا يغيّر التقرير baseline ولا يرفع أي تصنيف تلقائيًا.

## النتائج

| العنصر | النتيجة | التصنيف |
|---|---|---|
| `rust/mal_ownership_arena/src/lib.rs` | موجود، ويحتوي `#![forbid(unsafe_code)]` واختبارات Arena | مثبت محليًا |
| اختبارات Rust Arena | 5 اختبارات ناجحة، 0 فاشلة، و0 اختبارات توثيقية | PASS للنواة فقط |
| مشغل MAL قابل للاستدعاء | لم تُكتشف أوامر `mal` أو `mal-runtime` أو `mal_ar_runtime` أو `uori-mal-runtime` أو `uori-mediator` | ABSTAIN |
| `MAL_AR_RUNTIME` | غير مضبوط | ABSTAIN |
| `uori-mediator-kit/protocol/MANIFEST_AR.json` | غير موجود في المسار المذكور | ABSTAIN |
| `uori_arabic_math-0.1.0` | غير موجود في المسار المذكور | ABSTAIN |
| تشغيل ملفات `.ar` | لم يُنفذ | `NOT_PERFORMED` |
| التكافؤ الثنائي MAL مقابل Python | غير قابل للتنفيذ قبل توفر المشغل | `ABSTAIN` |

## الحكم الدستوري

يثبت نجاح Rust Arena سلامة اختبارات نموذج الذاكرة والفهارس والعمر والنوع والسعة في المكتبة المحلية، لكنه لا يثبت وجود مشغل MAL، ولا يثبت قدرة قراءة أو تفسير أو تنفيذ ملفات `.ar`. لذلك لا يجوز تغيير `SOURCE_EXECUTION` إلى `PERFORMED` ولا `AUTO_PROMOTION` إلى `ALLOW` بناءً على هذه النتيجة.

تبقى الحالة الحاكمة كما يلي:

```text
ARENA_LOCAL_TESTS=PASS
MAL_AR_RUNTIME=UNAVAILABLE
SOURCE_EXECUTION=NOT_PERFORMED
RAW_POINTERS=DENY
DYNAMIC_ALLOCATION=DENY
EVAL_EXEC=DENY
BASELINE_FREEZE=ACTIVE
AUTO_PROMOTION=DENY
```

## الخطوة اللازمة لفتح الإثبات التنفيذي

يلزم تقديم مشغل قابل للاستدعاء أو crate/ثنائي موثق يقرأ ملف `.ar` محددًا ويعيد نتيجة حتمية قابلة للتسجيل. بعد التحقق من بصمته وعزله، يُشغّل Corpus المقرر، ثم تُقارن مخرجات MAL بمخرجات Python وتُنشأ sidecar ببصمات فعلية. إلى ذلك الحين، كل ادعاء عن التنفيذ المباشر أو الترفيع إلى `PROVEN` ممتنع.

## الأدلة

- `evidence/MAL_RUNTIME_PATH_INVENTORY_2026-08-25.stdout`
- `evidence/MAL_RUNTIME_CAPABILITY_2026-08-25.stdout`
- `evidence/MAL_RUST_ARENA_CARGO_TEST_2026-08-25.stdout`
- `evidence/MAL_RUNTIME_CAPABILITY_2026-08-25.sha256`
- `evidence/MAL_RUST_ARENA_CARGO_TEST_2026-08-25.sha256`

**الخلاصة:** نجاح محلي لنواة Arena، مع بقاء فجوة المشغل التنفيذي لملفات MAL مفتوحة وحالة baseline مجمدة.
