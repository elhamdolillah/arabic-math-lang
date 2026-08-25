# حزمة الإحاطة — 2026-08-25

## 1. الهوية (من المانيفست)

المشروع يتكوّن من مسارين مرتبطين لكن منفصلين: **اللغة العربية الرياضية MAL** ومترجمها/اختباراتها، و**وسيط UORI** المبني على خط أساس مجمّد. المانيفست المرجعي هو `uori-mediator-kit/protocol/MANIFEST_AR.json`.

| العنصر | القيمة |
|---|---|
| حزمة UORI | `uori-mediator-kit` |
| اللغة | `ar` |
| الدور | `ai-mediator-reviewer` |
| baseline | `uori-wave77-freeze-2026-08-24` |
| baseline commit | `f56b8bd` |
| سياسة baseline | `do-not-modify-baseline` |
| فرع MAL/UORI الحالي | `integration/mal-deterministic-audit-2026-08-25` |
| runtime UORI | Python `>=3.11` وwheel `uori_arabic_math-0.1.0` |
| حالات القرار | `DETERMINISTIC`, `ABSTAIN`, `INFORMATIONAL` |
| التنفيذ الساكن | `NOT_PERFORMED` |
| الشبكة | `disabled-by-contract` |
| قبول UORI المعلن في المانيفست | `PASS` |

لا توجد حزمة APK أو شجرة Android محلية ضمن المستودع المفحوص. يوجد مستودع مرافق مذكور في دليل المشروع باسم `arabic-math-android`، لكنه ليس جزءاً من هذه الشجرة ولم تُضمّن منه ملفات تنفيذية أو ثنائية.

## 2. القواعد الحاكمة (ملخص 5 أسطر + رابط للملف الكامل عند الحاجة)

1. **الإحكام:** لكل رمز ودلالة تفسير محدد، ولا تُقبل ambiguity أو التحويلات الضمنية غير المصرّح بها.
2. **التيسير والعدل:** تُفضّل نواة صغيرة واضحة، وكل ميزة جديدة تحتاج مبرراً قابلاً للفحص مقابل كلفتها.
3. **الأمانة والحفظ:** لكل مورد مالك واحد، مع ملكية خطية وفحص حدود، ومنع `null` و`use-after-free` و`double-free` وraw pointers.
4. **البيان والتفكر:** كل قرار قابل للتوثيق، والأخطاء القابلة للتجنب تُكتشف مبكراً، مع اختبارات وبصمات قابلة لإعادة الإنتاج.
5. **الشمولية المنضبطة:** تُستعار السمات النافعة من اللغات الأخرى بعد فحصها؛ التنفيذ الخارجي أو الغموض أو المصدر غير الموثوق ينتهي بـ`DENY` أو `ABSTAIN`.

المرجع الكامل المختار: `docs/CONSTITUTION.md`، الإصدار 8.0. وتوجد نسخ/تقارير دستورية أخرى؛ أُدرجت هنا كمرجع إضافي فقط عند الحاجة، لا كمصادر متوازية.

## 3. المراحل: مغلقة / معلّقة

المرجع الموحد الحالي هو `STAGE_REGISTRY_AR.md`، وقد فُصلت فيه الحالة المثبتة عن الادعاءات التاريخية المتعارضة في `ROADMAP.md` و`docs/PHASES_SUMMARY.md`.

| النطاق | الحالة الموحدة | الأولوية/الملخص |
|---|---|---|
| MAL Grammar/Parser v0.1 | `PROVEN_FOR_SCOPE` | corpus من 12 حالة؛ لا يثبت كل اللغة. |
| MAL-DIR v0.1 | `PROVEN_FOR_SCOPE` | validator و58 عقدة؛ v0.2 ما زال مطلوباً. |
| Admission Gate وDENY policy | `PROVEN_FOR_SCOPE` | ALLOW/DENY/ABSTAIN دون تنفيذ مصدر خام. |
| Rust Ownership/Arena | `PROVEN_FOR_SCOPE` | خمسة اختبارات ومقابض generations؛ prototype فقط. |
| Language lineage registry | `PROVEN_FOR_SCOPE` | سجل عربي زمني واختبار حتمي. |
| Ubuntu/Alpine cross-environment | `INTEGRATED_PENDING_CI` | اختلاف parser evidence يمنع إغلاق المقارنة. |
| Required SHA-256 check | `INTEGRATED_PENDING_CI` | لا دمج في `main` حتى ينجح check عبر كل البيئات. |
| MAL-DIR v0.2 + Arena integration | `RESEARCH` | يحتاج AST pass وABI وcross-toolchain proof. |
| Result/Option وAsync/Await | `ABSTAIN` | تعارض بين roadmap وphase summary؛ يلزم دليل مستقل. |
| Macros | `RESEARCH` | بند لاحق يحتاج عقد حتمية. |
| Dependent Types | `RESEARCH` | بند بحثي خارج Tier-0 الحالي. |
| Self-hosting الكامل | `RESEARCH` | لا يوجد إثبات مستقل كامل بعد. |
| APK/Android | `ABSTAIN` | لا توجد شجرة Android أو APK محلية قابلة للفحص. |

### الأولويات القصوى المعلقة

1. **P0 — reproducible build:** تفسير وإصلاح اختلاف `MAL_GRAMMAR_CORPUS_PARSER.stdout` بين Ubuntu وAlpine، مع إبقاء الملف ضمن allowlist؛ الفشل الحالي يمنع الدمج.
2. **P0 — سجل مراحل واحد:** اعتماد `STAGE_REGISTRY_AR.md` وتصفية تعارض أرقام 45/50 و47/50 من الوثائق غير المرجعية.
3. **P1 — Arena رسمية:** نقل prototype إلى MAL-DIR v0.2 مع AST وABI واختبارات Rust cross-environment.
4. **P1 — حدود المترجم:** تثبيت grammar وIR وownership وcodegen وbootstrap الحتمي قبل إعلان self-hosting كاملاً.
5. **P2 — الميزات اللاحقة:** Result/Option ثم Macros؛ Dependent Types بحثي، وAsync/Await لا يعتمد قبل إثبات جدولة حتمية.
6. **P2 — APK منفصل:** لا قرار اعتماد قبل مستودع Android وmanifest وbuild reproducibility مستقل.

المرجع التفصيلي للحالات والأدلة وقاعدة الترقية: `STAGE_REGISTRY_AR.md`.

## 4. آخر دليل قبول (RC/PASS فقط، بلا stdout كامل)

آخر تقرير قبول نصي هو `evidence/MAL_OWNERSHIP_ARENA_RUST_REPORT_AR.md`، وهو أحدث من تقارير Arena السابقة. السطور المختصرة:

```text
MAL_OWNERSHIP_ARENA_RUST=PASS
TESTS=5
RAW_POINTERS=FORBIDDEN
UNSAFE_CODE=FORBIDDEN
GENERATION_CHECK=PASS
BORROW_RULES=PASS
SCOPE_ISOLATION=PASS
CAPACITY_RULE=PASS
EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
STATUS=0
```

حدود الدليل: يثبت Rust Arena ضمن نطاق النموذج الأولي فقط، ولا يثبت بعد تكامل grammar أو MAL-DIR أو ABI أو backend أو WASM أو نظام تشغيل كامل. كما أن فحص `Compare cross-environment SHA-256 manifests` في Pull Request ما زال مانعاً للدمج حتى يُفسّر اختلاف `MAL_GRAMMAR_CORPUS_PARSER.stdout` ويُثبت التطابق بتاً-بت.

## 5. حالة Git الحالية

الناتج المختصر المطلوب:

```text
git status --short: clean
HEAD: 58ffedd
BRANCH: integration/mal-deterministic-audit-2026-08-25
```

آخر خمسة commits:

```text
58ffedd feat(mal): add governed language lineage registry
2245f46 chore(mal): ignore Rust build artifacts
e731a4c feat(mal): add deterministic Rust ownership arena
cca59f0 fix(ci): exclude comparison output from manifest inputs
ba68923 fix(ci): collect cross-environment artifacts explicitly
```

## 6. الملفات المصدر الفعلية للرجوع عند الحاجة

المرجع الأحدث لحالة المراحل: `STAGE_REGISTRY_AR.md`.


| الدور | الملف المختار الوحيد |
|---|---|
| الهوية | `uori-mediator-kit/protocol/MANIFEST_AR.json` |
| الدستور | `docs/CONSTITUTION.md` |
| سجل المراحل | `docs/PHASES_SUMMARY.md` |
| خارطة الطريق | `ROADMAP.md` |
| جرد الكود الوظيفي | `README.md` |
| نظرة UORI العربية | `uori-mediator-kit/README_AR.md` |
| آخر تقرير قبول | `evidence/MAL_OWNERSHIP_ARENA_RUST_REPORT_AR.md` |
| عقد MAL/UORI الحالي | `protocol/MAL_LANGUAGE_LINEAGE_INTEGRATION_AR.md` |
| سجل السمات التاريخية | `protocol/MAL_LANGUAGE_LINEAGE_REGISTRY_AR.json` |
| عقد حماية الفرع | `protocol/MAL_BRANCH_PROTECTION_AR.md` |
| عقد MAL Grammar | `protocol/MAL_GRAMMAR_SPEC_v0.1_AR.md` |
| عقد MAL-DIR | `protocol/MAL_DIR_SPEC_v0.1_AR.md` |
| عقد سياسة DENY | `protocol/MAL_DENY_POLICY_v0.1_AR.md` |
| تنفيذ Rust Arena | `rust/mal_ownership_arena/src/lib.rs` |
| مسار CI | `.github/workflows/mal-deterministic-audit.yml` |
| Pull Request | `https://github.com/elhamdolillah/arabic-math-lang/pull/2` |

الملفات المستبعدة بسبب التكرار أو قدمها: `CONSTITUTION.md` الجذرية، `README_old.md`، تقارير Arena القديمة، تقارير Grammar/MAL-DIR القديمة، وملفات الأرشيف المرحلية. لم تُرفق أي ملفات `.stdout` أو `.asm` أو `.o` أو `.wasm` أو `.apk` أو غيرها من المخرجات الخام والثنائيات.

## 7. نطاق الحزمة

هذه الوثيقة هي **حزمة الإحاطة الوحيدة** المقصودة للفهم الأولي. عند الحاجة إلى إثبات بند محدد فقط، يُرجع إلى الملف المصدر المقابل في الجدول، ثم إلى evidence الخام المرتبط بذلك البند؛ ولا تُستخدم هذه الحزمة بديلاً عن التحقق التنفيذي أو عن عقد baseline المجمّد.
