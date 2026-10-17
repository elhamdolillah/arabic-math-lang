# تقرير التحقق المتقاطع للبصمات الرقمية عبر بيئات البناء

## الحالة

- **المرحلة:** Cross-Environment SHA-256 Audit v0.1
- **المستودع:** `uori-mediator-kit-adoption-2026-08-25`
- **الفرع:** `implementation/reproducible-build-2026-08-25`
- **آخر commit:** `dbd2e5d`
- **حالة worktree:** نظيف
- **التصنيف:** `RESEARCH / CI IMPLEMENTED`

## ما تم تنفيذه

أضيف مولد manifest حتمي هو `scripts/run_mal_cross_env_manifest.py`. يشغل runner التدقيق الموجود، ثم يحسب SHA-256 لمجموعة allowlist ثابتة من المواصفات ومخرجات الأدلة. لا تدخل تسمية البيئة أو إصدار Python أو `GITHUB_SHA` في البصمة القابلة للمقارنة؛ تحفظ هذه المعلومات وصفياً فقط. وبذلك لا يؤدي اختلاف اسم المضيف إلى إخفاء اختلاف حقيقي في artifacts.

أضيف comparator هو `scripts/compare_mal_cross_env_manifests.py`. يتحقق أولاً من schema والبصمة الذاتية لكل manifest، ثم يعيد حساب البصمة من الحقول القابلة للمقارنة، وبعدها يقارن جميع البصمات. عند نقص بيئة أو فساد manifest أو اختلاف البصمات لا يعيد `ALLOW`؛ بل يفشل المسار أو يعيد `ABSTAIN` عند نقص الدليل.

## نتيجة التشغيل المحلي

تم تشغيل مولد manifest بتسميتين تمثلان بيئتي Ubuntu 22.04 وUbuntu 24.04، ثم تمت المقارنة من شجرة Git نظيفة:

```text
CROSS_ENV_AUDIT=PASS
LABEL=ubuntu-22.04
COMPARABLE_SHA256=0cd2dac84446a33e1a91c556c9a22127e7b3afeac9cbbdb380bea816a0ffb893

CROSS_ENV_AUDIT=PASS
LABEL=ubuntu-24.04
COMPARABLE_SHA256=0cd2dac84446a33e1a91c556c9a22127e7b3afeac9cbbdb380bea816a0ffb893

CROSS_ENV_COMPARE=PASS
ENVIRONMENTS=2
UNIQUE_DIGESTS=1
EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
```

تطابقت البصمتان القابلتان للمقارنة بتاً ببت. كما نجح `sha256sum -c` لملفات manifests وcomparison الناتجة.

## اختبار الفشل الآمن

بعد تعديل manifest واحد في نسخة مؤقتة، يجب أن يفشل comparator بسبب `SELF_HASH_MISMATCH` أو بسبب اختلاف `comparable_sha256`. هذا الاختبار لا يغير ملفات المشروع ولا يسمح بتمرير نتيجة غير متطابقة. أما غياب manifest ثانٍ فيؤدي إلى `ABSTAIN / INSUFFICIENT_ENVIRONMENTS`.

## مسار GitHub Actions

يحتوي `.github/workflows/mal-deterministic-audit.yml` على مصفوفة بيئتين فعليتين:

```text
ubuntu-22.04
ubuntu-24.04
```

كل job يشغل التدقيق الحتمي ويرفع manifest وstdout وSHA-256 كـartifact. بعد اكتمال المصفوفة يشغل job مستقل comparator على جميع manifests. لا ينجح job النهائي إلا عند تحقق:

```text
ENVIRONMENTS >= 2
UNIQUE_DIGESTS = 1
CROSS_ENV_COMPARE = PASS
```

## الحدود

التشغيل المحلي الحالي يحاكي تسميتي البيئتين على نفس المضيف؛ لذلك يثبت صحة المنطق والتكرارية، لكنه لا يثبت اختلاف نظام التشغيل فعلياً. الإثبات المتقاطع الحقيقي يتطلب دفع الفرع إلى GitHub وتشغيل المصفوفة على runners `ubuntu-22.04` و`ubuntu-24.04`، ثم حفظ artifact المقارنة. كما أن تطابق SHA-256 لمخرجات audit لا يثبت وحده تطابق machine code أو سلوك microarchitecture؛ تلك مراحل منفصلة وتبقى `RESEARCH`.

## الضمانات

لا ينفذ المسار مصدر MAL أو `source_ref`، ولا يستخدم شبكة، ولا يعتمد على وقت النظام أو عشوائية أو عناوين ذاكرة. يعتمد فقط على ملفات allowlist، وcanonical JSON، وSHA-256، وقرارات fail-closed.
