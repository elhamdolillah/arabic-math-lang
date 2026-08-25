# سجل المراحل الموحّد — MAL/UORI

**تاريخ التحديث:** 2026-08-25  
**الفرع:** `integration/mal-deterministic-audit-2026-08-25`  
**baseline المحمي:** `uori-wave77-freeze-2026-08-24` / `f56b8bd`  
**قاعدة الحالة:** لا تُرفع مرحلة إلى `PROVEN` إلا بدليل قابل لإعادة الإنتاج؛ عند التعارض أو غياب الدليل تُستخدم `ABSTAIN` أو `RESEARCH`.

## 1. تعريف الحالات

| الحالة | المعنى |
|---|---|
| `PROVEN` | مثبتة باختبار أو عقد مستقل قابل لإعادة التشغيل ضمن النطاق المحدد. |
| `PROVEN_FOR_SCOPE` | مثبتة، لكن الإثبات لا يغطي المشروع الكامل أو كل backends والبيئات. |
| `INTEGRATED_PENDING_CI` | مدمجة في فرع التبني، لكن شرط CI الحتمي لم يكتمل. |
| `RESEARCH` | تصميم أو قدرة مستقبلية تحتاج تنفيذًا ودليلًا مستقلًا. |
| `ABSTAIN` | يوجد تعارض أو نقص دليل يمنع قرار اعتماد آمن. |

## 2. السجل الموحد

| المعرّف | المجال | الحالة الحالية | الدليل/الحد |
|---|---|---|---|
| MAL-01 | Grammar وParser v0.1 | `PROVEN_FOR_SCOPE` | corpus من 12 حالة؛ لا يثبت كل اللغة. |
| MAL-02 | MAL-DIR v0.1 | `PROVEN_FOR_SCOPE` | validator وبنية 58 عقدة؛ لا يثبت v0.2. |
| UORI-03 | Admission Gate الثلاثي | `PROVEN_FOR_SCOPE` | ALLOW/DENY/ABSTAIN وpolicy comparator؛ لا يثبت تنفيذًا خامًا. |
| UORI-04 | DENY policy | `PROVEN_FOR_SCOPE` | رفض `eval` و`exec` و`source_ref` غير الموثق؛ fail-closed. |
| BUILD-05 | Ubuntu cross-environment audit | `PROVEN_FOR_SCOPE` | مسار CI موجود؛ المقارنة النهائية تتطلب تطابق كل evidence. |
| BUILD-06 | Alpine/musl audit | `PROVEN_FOR_SCOPE` | صورة `python:3.12-alpine3.20` مع network disabled؛ يحتاج نجاح المقارنة المشتركة. |
| BUILD-07 | SHA-256 comparison required check | `INTEGRATED_PENDING_CI` | وظيفة CI موجودة، لكن `MAL_GRAMMAR_CORPUS_PARSER.stdout` ما زال مختلفًا بين البيئات. |
| RUST-08 | Ownership/Arena بالمقابض المفهرسة | `PROVEN_FOR_SCOPE` | خمسة اختبارات، `unsafe` وraw pointers ممنوعان؛ prototype فقط. |
| RUST-09 | دمج Arena في MAL-DIR الرسمي | `RESEARCH` | يحتاج MAL-DIR v0.2، AST pass، ABI، وcross-toolchain proof. |
| LINEAGE-10 | سجل تاريخ لغات البرمجة | `PROVEN_FOR_SCOPE` | JSON قانوني مرتب زمنيًا واختبار registry؛ لا يعني دمج كل اللغات. |
| LINEAGE-11 | السمات الموروثة من Rust/ML/Ada/ALGOL وغيرها | `EXTENSION_SCOPED_PROVEN` أو `RESEARCH` | تُدمج سمةً بسمة؛ raw pointers وGC غير الحتمي والتنفيذ الديناميكي ليست معتمدة. |
| MAL-12 | إعادة بناء compiler ذاتيًا | `RESEARCH` | لا يوجد دليل self-hosting كامل داخل مسار MAL الحالي. |
| UORI-13 | UORI كنظام تشغيل كامل/boot/QEMU فعلي | `ABSTAIN` | الحزمة الحالية وسيط/مكتبة فوق OS، ولا تثبت kernel أو boot حقيقيًا. |
| APK-14 | تطبيق Android/APK | `ABSTAIN` | لا توجد شجرة Android أو APK داخل المستودع المفحوص؛ المستودع المرافق غير داخل هذا PR. |
| ROAD-15 | Result/Option كمرحلة roadmap | `ABSTAIN` | الوثائق متعارضة: `PHASES_SUMMARY.md` يضعها قادمة، بينما README يعلنها مكتملة. |
| ROAD-16 | Async/Await | `ABSTAIN` | التعارض نفسه؛ لا يعتمد السجل الموحّد على ادعاء README دون دليل مستقل. |
| ROAD-17 | Macros | `RESEARCH` | بند مستقبلي في خارطة الطريق. |
| ROAD-18 | Dependent Types | `RESEARCH` | بند بحثي؛ لا يُدخل إلى Tier-0 دون عقد إثبات. |
| ROAD-19 | Self-hosting الكامل | `RESEARCH` | أولوية لاحقة بعد تثبيت backend وbootstrap الحتمي. |

## 3. الأولويات القصوى المعلقة

### P0 — إغلاق reproducible build قبل أي دمج

إصلاح اختلاف `evidence/MAL_GRAMMAR_CORPUS_PARSER.stdout` بين Ubuntu وAlpine دون حذفه من allowlist أو تطبيع المقارنة بصورة تخفي الفرق. يجب أن تنتج البيئات الثلاث نفس البايتات والبصمة، ثم ينجح check:

```text
Compare cross-environment SHA-256 manifests
```

إلى أن يحدث ذلك، حالة الدمج `ABSTAIN/DENY`.

### P0 — تثبيت سجل مراحل واحد

يجب اعتبار هذا الملف المرجع الموحد، وإما تحديث `PHASES_SUMMARY.md` و`ROADMAP.md` في PR مستقل، أو إعلان أحدهما غير مرجعي. لا يجوز في CI استخدام رقم 47/50 أو 45/50 دون ربط كل مرحلة بدليل.

### P1 — إكمال إثبات Arena قبل الترقية الرسمية

ينبغي إضافة Arena إلى MAL-DIR v0.2 مع تمريرة AST، واختبارات ABI، واختبارات Rust toolchain عبر Ubuntu وAlpine، وسلسلة SHA-256 مستقلة. الحالة الحالية تثبت prototype فقط.

### P1 — إغلاق واجهة MAL الحتمية قبل self-hosting

يجب تثبيت grammar وIR وownership وcode generation وbootstrap ثلاثي المراحل قبل اعتبار self-hosting الكامل هدفًا منفذًا. أي ادعاء self-hosting يبقى `RESEARCH` ما لم يُرفق بإثبات مستقل.

### P2 — Result/Option ثم Macros ثم Dependent Types

هذه الميزات لا تُنفذ دفعة واحدة. الأولوية المنطقية هي Result/Option بعقد فشل مغلق، ثم Macros مقيدة وقابلة للتوسيم، ثم Dependent Types كنطاق بحثي. Async/Await لا يُعتمد حتى يُثبت ترتيب الجدولة والحالة الزمنية الحتمية.

### P2 — فصل APK عن نواة MAL/UORI

لا يُضاف Android/APK إلى حالة المشروع قبل توفر مستودع Android قابل للفحص، manifest، build recipe، واختبار reproducible مستقل. غياب الملف لا يعني أن APK فاشل؛ يعني أن القرار الحالي `ABSTAIN`.

## 4. قاعدة الترقية

لا تنتقل أي مرحلة من `RESEARCH` أو `ABSTAIN` إلى `PROVEN` إلا بعد وجود: مواصفة عربية، تنفيذ مصدر، corpus مستقل، اختبار نجاح وفشل، stdout مختصر، SHA-256، تحقق cross-environment، وتسجيل في هذا الملف. baseline المجمد لا يُعدّل؛ كل ترقية تتم في فرع تبنٍ منفصل.
