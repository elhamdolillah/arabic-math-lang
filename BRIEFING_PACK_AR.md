# حزمة الإحاطة — 2026-08-26

> **الغرض:** حزمة نصية دنيا للفهم الأولي لمشروع MAL/UORI مع الإشارة إلى وضع APK، دون إرفاق مخرجات تنفيذ خام أو ملفات ثنائية.

## 1. الهوية (من المانيفست)

| العنصر | القيمة |
|---|---|
| اسم الحزمة | `uori-mediator-kit` |
| اللغة | `ar` — اللغة الرياضية العربية MAL |
| الدور | `ai-mediator-reviewer` |
| المانيفست المرجعي | `/home/ubuntu/uori-mediator-kit/protocol/MANIFEST_AR.json` |
| baseline المعلن في المانيفست | `uori-wave77-freeze-2026-08-24` / `f56b8bd` |
| سياسة baseline | `do-not-modify-baseline` |
| runtime | Python `>=3.11`، wheel `uori_arabic_math-0.1.0-py3-none-any.whl` |
| فئات القرار | `DETERMINISTIC`، `ABSTAIN`، `INFORMATIONAL` |
| التنفيذ الساكن | `NOT_PERFORMED` |
| الشبكة | `disabled-by-contract` |
| قبول المانيفست | `PASS`، المثال الحتمي `٧×٦ → ٤٢` |
| APK/Android | لا توجد شجرة Android أو APK داخل المستودع المفحوص؛ لا يجوز استنتاج حالة APK من غيابها |

> **تنبيه نطاقي:** المانيفست خارجي عن شجرة `/home/ubuntu/uori-mal-pr`. لذلك تُعرض قيمته كمرجع هوية، بينما تُعرض حالة Git الآنية من المستودع المحلي نفسه.

## 2. القواعد الحاكمة (ملخص 5 أسطر + رابط للملف الكامل عند الحاجة)

1. **الإحكام:** لكل رمز ودلالة معنى محدد، ولا تُقبل الغموض أو التحويلات الضمنية غير المصرح بها.
2. **التيسير والعدل:** تُفضّل النواة الصغيرة، وكل ميزة تحتاج مبرراً قابلاً للفحص مقابل كلفتها.
3. **الأمانة والحفظ:** ملكية الموارد خطية، وفحص الحدود إلزامي، وتُمنع مؤشرات raw و`use-after-free` و`double-free`.
4. **البيان والتفكر:** القرارات والأخطاء قابلة للتوثيق والفحص وإعادة الإنتاج، مع الامتناع عند النقص.
5. **الشمولية المنضبطة:** لا يُسمح بالتنفيذ الديناميكي أو المصدر غير الموثوق؛ النتيجة عند الخطر `DENY` أو `ABSTAIN`.

المرجع الدستوري المختار: `docs/CONSTITUTION.md`، الإصدار 8.0. ويظل `STAGE_REGISTRY_AR.md` المرجع الموحد لحالات المراحل، لا README أو خارطة الطريق عند التعارض.

## 3. المراحل: مغلقة / معلّقة

| النطاق | الحالة المرجعية | الدليل أو القيد |
|---|---|---|
| MAL Grammar/Parser v0.1 | `PROVEN_FOR_SCOPE` | corpus من 12 حالة؛ لا يثبت كل اللغة |
| MAL-DIR v0.1 | `PROVEN_FOR_SCOPE` | validator وبنية 58 عقدة؛ v0.2 غير مثبت |
| Admission Gate وDENY policy | `PROVEN_FOR_SCOPE` | حالات ALLOW/DENY/ABSTAIN ضمن النطاق الاختباري |
| Rust Ownership/Arena | `PROVEN_FOR_SCOPE` | prototype بخمسة اختبارات؛ لا يثبت التكامل الكامل |
| Ubuntu/Alpine cross-environment | `INTEGRATED_PENDING_CI` | اختلاف parser evidence ما زال مانعاً للإغلاق |
| SHA-256 required check | `INTEGRATED_PENDING_CI` | يلزم تطابق الأدلة عبر البيئات قبل الدمج |
| MAL-DIR v0.2 + Arena integration | `RESEARCH` | يحتاج AST pass وABI وcross-toolchain proof |
| Result/Option وAsync/Await | `ABSTAIN` | تعارض وثائقي يحتاج دليلاً مستقلاً |
| Macros | `RESEARCH` | بند مستقبلي يحتاج عقد حتمية |
| Dependent Types | `RESEARCH` | بند بحثي خارج Tier-0 الحالي |
| Self-hosting الكامل | `RESEARCH` | لا يوجد إثبات مستقل كامل |
| APK/Android | `ABSTAIN` | لا توجد شجرة Android أو APK محلية قابلة للفحص |
| Stage 7 corrective branch | `TECHNICAL_GATES_PASSED / PROMOTION_NOT_PERFORMED` | 179 حالة، 0 اختلافات؛ التغييرات غير ملتزمة حالياً وفق Git |

**الأولويات المعلقة:** إصلاح اختلاف المقارنة عبر البيئات، توحيد سجل المراحل، إكمال Arena داخل MAL-DIR v0.2، تثبيت حدود المترجم قبل self-hosting، ثم فصل APK في مستودع قابل للفحص وإعادة البناء.

## 4. آخر دليل قبول (RC/PASS فقط، بلا stdout كامل)

المصدر المختار: `evidence/STAGE7_CORRECTIVE_EXECUTION_REPORT_AR.md`.

```text
CORRECTIVE_CORPUS=64_FILES
TOTAL_CORPUS_CASES=179
DIFFERENTIAL_STATUS=MATCHED_CANONICAL
DIFFERENTIAL_FILES=179
DIFFERENTIAL_MATCHES=179
DIFFERENTIAL_MISMATCHES=0
CARGO_TEST_EXIT=0
UNSAFE_SCAN=PASS_NO_UNSAFE_ITEMS
TRIPLE_JSON_MATCH=PASS
TRIPLE_STDOUT_MATCH=PASS
CORRECTIVE_EVIDENCE=SHA256_EXIT_0
ARABIC_VS_PYTHON_EXACT=2.583114087539%
RATIO_GATE=PASS
AUTO_PROMOTION=DENY
STAGE7_PROMOTION=NOT_PERFORMED
NEXT_STAGES=BLOCKED_PENDING_EXPLICIT_APPROVAL
```

**حدود الدليل:** التقرير يثبت البوابات التصحيحية ضمن نطاق Stage 7 المعلن، ولا يثبت تلقائياً الدمج أو الترقية أو صحة Stage 8 أو خلو النظام الكامل من جميع العيوب.

## 5. حالة Git الحالية (مختصر)

```text
git status --short --branch: ## stage7-execution-2026-08-26
working_tree: NOT_CLEAN
tracked_modified: 7 files
untracked_files: present, including Stage 7 corpus/evidence
HEAD: 7e1301a
branch: stage7-execution-2026-08-26
```

آخر خمسة commits:

```text
7e1301a Record safe ABI build verification
de9e234 Add safe fixed-segment ABI for Stage 6
dbcc030 Correct final WebAssembly artifact report
1c10ed Record WebAssembly target provisioning attempts
e9dac8a Complete Stage 6 WebAssembly artifact
```

> **فرق مهم:** `STAGE_REGISTRY_AR.md` يحمل فرعاً أقدم (`integration/mal-deterministic-audit-2026-08-25`) وbaseline مختلفاً عن Git الآني؛ لذلك لا يُوصف المستودع الحالي بأنه نظيف أو على ذلك الفرع.

## 6. الملفات المصدر الفعلية للرجوع عند الحاجة (أسماء فقط)

| الدور | الملف المختار الوحيد أو البديل الأقرب |
|---|---|
| بطاقة الهوية | `/home/ubuntu/uori-mediator-kit/protocol/MANIFEST_AR.json` |
| الدستور | `docs/CONSTITUTION.md` |
| سجل المراحل الموحد | `STAGE_REGISTRY_AR.md` |
| خارطة الطريق | `ROADMAP.md` |
| جرد الكود الوظيفي — البديل الأقرب | `evidence/MAL_NEXT_PHASE_PROGRESS_REPORT_AR.md` |
| آخر دليل قبول مختصر | `evidence/STAGE7_CORRECTIVE_EXECUTION_REPORT_AR.md` |
| حالة Git الحالية | ناتج `git status --short --branch` و`git log -5 --oneline` الموجز أعلاه |

الملفات المتكررة أو الأقدم المستبعدة: `README_old.md`، `CONSTITUTION.md` الجذرية، تقارير Arena وGrammar وMAL-DIR الأقدم، ونسخ التشغيل المتعددة. استُبعدت كلياً ملفات `.asm` و`.stdout` و`.o` و`.wasm` و`.apk` و`.vo` و`.vok` و`.vos` و`.glob` و`.sqlite3` وسائر الثنائيات والمخرجات الخام.

## 7. حدود الاستخدام

هذه الحزمة للفهم الأولي فقط، ولا تحل محل ملفات الأدلة أو التحقق التنفيذي. عند الحاجة إلى بند محدد، يُرجع إلى الملف المختار لذلك الدور ثم إلى الدليل الخام المرتبط به. وبسبب عدم نظافة شجرة Git الحالية، لا يجوز إعلان الدمج أو الترقية أو سلامة baseline من هذه الحزمة وحدها.
