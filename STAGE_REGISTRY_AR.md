# سجل مراحل UORI وMAL

## مرجع الحوكمة

هذا السجل يعمل تحت القيود التالية:

```text
AUTO_PROMOTION=DENY
FAIL_CLOSED=ACTIVE
BASELINE_FREEZE=ACTIVE
UNSAFE_CODE=PROHIBITED
DYNAMIC_HEAP_ALLOCATION=PROHIBITED
```

لا يرفع هذا السجل أي حكم محدود النطاق إلى إثبات شامل للنواة أو للغة MAL كاملة أو لتكافؤ Python/Rust.

## الحالة المرحلية

| المرحلة أو المكوّن | التصنيف | نطاق الحكم | الأدلة | القيود المفتوحة |
|---|---|---|---|---|
| `mal_runner` Rust التشخيصي | `PROVEN_FOR_SCOPE` | قبول وتحليل Corpus ذي النطاق الموثق في Stage 7، مع مخرجات canonical قابلة للتكرار | `evidence/STAGE7_CORRECTIVE_CARGO_TEST.stdout`، `evidence/STAGE7_CORRECTIVE_UNSAFE_SCAN.stdout`، `evidence/STAGE7_CORRECTIVE_DIFFERENTIAL.stdout` | لا يثبت اكتمال Parser العام أو سيادة MAL المطلقة |
| Corpus Stage 7 التصحيحي | `PROVEN_FOR_SCOPE` | 179 حالة ضمن 64 ملفاً تصحيحياً، وفق manifest والتشغيل التفاضلي الموثق | `corpus/stage7_correction_64_files/MANIFEST.tsv`، `evidence/STAGE7_CORRECTIVE_CORPUS_VERIFY.stdout`، `evidence/STAGE7_CORRECTIVE_DIFFERENTIAL.stdout` | الحكم محصور في الحالات الفعلية الموجودة في Corpus ولا يمتد إلى مدخلات غير مختبرة |
| `Phase 5.2 Kernel ALLOW` | `PROVEN_FOR_PHASE52_TEST_MATRIX` | ثلاث حالات ALLOW صالحة، وحالات PLAN_HASH_MISMATCH وUNKNOWN_INTENT وRESOURCE_BUDGET مرفوضة؛ اختبار `هاش(مثل_الخطة(...))` وTriple-Run ناجحان | `/tmp/math_compiler_fix/TEXT_COMPARE_ALLOW_REPORT_AR.md`، `/tmp/math_compiler_fix/phase52_text_compare_run_1.stdout`، بصمة stdout: `8a5ca2512b0341e00fe45f06c86677d11a6d99ea010d35b348616a9e3520136e`، بصمة stderr: `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | الحكم محصور في مصفوفة Phase 5.2 المختبرة؛ لا يثبت اكتمال النواة أو `ابحث` العامة أو الدمج الشامل |
| `MAL self-hosting harness` | `PROVEN_FOR_SCOPE` | `t_fact` و`t_block` و`t_read_echo` و`t_read_size` نجحت، مع فشل propagating حتمي؛ اختبار compound indexing نجح 9/9 بعد ربط المسار المصحح | `/home/ubuntu/work/t_read_size_unicode_fix/compound_relinked_v2.stdout`، `/home/ubuntu/work/t_read_size_unicode_fix/compound_relinked_v2.rc`، `/home/ubuntu/work/t_read_size_unicode_fix/math_aot_selfhost.py` | الحكم محصور في النسخة المعزولة المرتبطة؛ لا يثبت اكتمال WASM أو كل self-hosting غير المختبر |
| الحتمية والتشغيل الثلاثي | `PROVEN_FOR_SCOPE` | تطابق مخرجات JSON الثلاثية، مع حفظ البصمات التشغيلية في أدلة Stage 7 | `evidence/STAGE7_CORRECTIVE_TRIPLE_HASHES.stdout`، `evidence/STAGE7_CORRECTIVE_TRIPLE_JSON_HASHES.stdout` | لا يثبت التكافؤ الدلالي مع نموذج مرجعي غير متوفر |
| تكافؤ Python/Rust على Corpus Parser | `RESEARCH` / `ABSTAIN` | لم يثبت بسبب غياب واجهة Python Lexer/Parser مكافئة تقرأ `.ar` وتصدر مخطط نتائج مماثلاً | `/tmp/PYTHON_RUST_COMPARISON_REPORT_AR.md`، بصمة التقرير: `ce851f5281814c29c820306e3292503019c02d47c6d88c3b37ef7c8966ed4f9f` | يلزم نموذج Python Parser مستقل بعقد إدخال وإخراج موحدين؛ لا يجوز تحويل نموذج Arena/Ownership إلى Parser بالاستنتاج |

## أساس تصنيف Phase 5.2 وStage 7

يُعتمد التصنيف `PROVEN_FOR_PHASE52_TEST_MATRIX` لمسار Kernel ALLOW بمعنى مقيد: الدليل يثبت النتائج الفعلية لمصفوفة الاختبار الستية والتشغيل الثلاثي المتطابق في النسخة المثبتة، ولا يرفع الحكم إلى إثبات شامل للنواة أو لكل مدخلات MAL. تبقى الفجوات العامة، ومنها `ابحث`، خارج نطاق هذا التصنيف.


يُعتمد التصنيف `PROVEN_FOR_SCOPE` للمشغل وCorpus الموسع بمعنى مقيد: الدليل يثبت الحتمية وقبول الحالات التي شُغّلت فعلياً داخل نطاق Corpus Stage 7 المحفوظ، ولا يثبت اكتمال اللغة أو توافقاً بين تطبيقين مختلفين. يشمل نطاق الدليل بناء Rust واختباراته، فحص منع الشفرة غير الآمنة، التشغيل التفاضلي، والتشغيل الثلاثي مع البصمات المحفوظة.

> `PROVEN_FOR_SCOPE` ليس `PROVEN` مطلقاً، ولا يساوي ترقية تلقائية، ولا يغيّر خط الأساس المجمد.

## تفسير امتناع Python

الملفان المستعادان `extensions/mal_ownership_arena.py` و`tests/run_mal_ownership_arena.py` يقدمان نموذجاً لعمليات `Arena` والملكية والاستعارة والنقل والتحرير، واختباراً داخلياً لهذه العمليات. لا يقدمان واجهة CLI لمسار `.ar` أو مجلد Corpus، ولا Lexer أو Parser Python مكافئاً، ولا مخطط إخراج يقابل سجل `mal_runner`. وعليه بقي الحكم على التكافؤ `RESEARCH`، ومع نقص واجهة قابلة للتشغيل يكون قرار التنفيذ المقارن `ABSTAIN` وفق بروتوكول Fail-Closed.

## حالة الدمج

```text
STAGE7_REGISTRY_CLASSIFICATION=PROVEN_FOR_SCOPE
PHASE52_KERNEL_ALLOW=PROVEN_FOR_PHASE52_TEST_MATRIX
MAL_SELF_HOSTING=PROVEN_FOR_SCOPE
GENERAL_LOOKUP_UTF8=PROVEN_FOR_ISOLATED_MATRIX
WASM_PHASE51=PROVEN_FOR_PHASE51_TEST_MATRIX
PYTHON_RUST_EQUIVALENCE=RESEARCH_OR_ABSTAIN
BASELINE_MODIFIED=NO
AUTO_PROMOTION=DENY
FAIL_CLOSED=ACTIVE
```

هذا الملف يسجل الحكم المحدود فقط. `MAL_SELF_HOSTING=PROVEN_FOR_SCOPE` و`WASM_PHASE51=PROVEN_FOR_PHASE51_TEST_MATRIX` لا يعنيان تلقائياً أن كل مراحل المشروع `FULL_GREEN`؛ يجب أن تكون بقية الاختبارات والاعتمادات مثبتة بأدلة مستقلة، كما أن أي دمج لفرع Stage 7 أو تحديث لسلسلة أدلة مستقلة هو إجراء إداري منفصل، ولا يُستنتج من إنشاء هذا السجل وحده.

_المؤلف: Manus AI_


## تدقيق المسار التنفيذي — 2026-08-28

أُعيدت قراءة خطة تصحيح المسار ونُفذت فقط الإجراءات القابلة للعكس والمثبتة مادياً. أُنشئت نسخة احتياطية للحالة الحالية في `/tmp/working_tree_backup_20260828_005757`، وحُفظت فروقات staging وworking tree وقائمة الملفات غير المتتبعة مع بصماتها. أُعيد تشغيل `test_phases.py` و`test_all_phases.py` فعلياً؛ كلاهما أعاد `RC=0`، وكانت مخرجات `WASM_PHASE51` وcompound indexing وself-hosting ناجحة ضمن نطاق harness المثبت.

لم تُنفذ عمليات `checkout` أو `merge` أو `tag` أو `push`. لا تزال ملفات `kernel/linker.ld` و`kernel/wasmi/src/buffer.rs` و`kernel/wasmi/src/mod.rs` غير متوفرة في مواضعها المفحوصة. كما أن `uori_lookup.ar` غير متتبعة و`uori_lookup_v5.ar` هي الملف المتتبع؛ لذلك لم يُستبدل baseline ولم يُعلن أن v5 هو المصدر الرسمي. تبقى الأرشفة الشاملة والدمج والإصدار النهائي في حالة `ABSTAIN_UNTIL_EVIDENCE`.

```text
CURRENT_HARNESS_TESTS=PASS_RC0
WASM_PHASE51=PROVEN_FOR_PHASE51_TEST_MATRIX
MAL_SELF_HOSTING=PROVEN_FOR_SCOPE
ARCHIVE=ABSTAIN_UNTIL_EVIDENCE
LOOKUP_CANONICAL_SOURCE=ABSTAIN_UNTIL_REVIEW
MERGE=BLOCKED_WORKTREE_AND_ARCHIVE_GATES
STABLE_TAG=BLOCKED
BASELINE_MODIFIED=NO
AUTO_PROMOTION=DENY
FAIL_CLOSED=ACTIVE
```

## تدقيق اعتماد `uori_lookup_v5` والدمج المحدد النطاق — 2026-08-28

بعد إنشاء ورفع الإصدار المرشح `v5.2.0-lookup-rc1`، أُجري دمج محلي محدد النطاق لفرع `adoption/uori-lookup-v5-constitutional` إلى `main` باستخدام `--no-ff`.

```text
PRE_MERGE_ANCHOR=release/pre-lookup-v5-merge-2026-08-28
PRE_MERGE_COMMIT=31d34b33ac4f5b79081b922bf52870af6b06e0f8
MERGE_COMMIT=9e880f55e7001ddfe25830072a929a4607e96448
BRANCH=main
```

اجتازت بوابات ما بعد الدمج فعلياً:

```text
LOOKUP_V5_ADOPTION=RC0
TEST_PHASES=RC0
TEST_ALL_PHASES=RC0
RUNTIME_CACHE=RC0
DIFF_CHECK=RC0
TRIPLE_RUN=PASS
WORKTREE=REQUIRES_ARTIFACT_STASH
```

وتطابقت بصمات `uori_lookup.ar` و`uori_lookup_v5.ar`:

```text
440b52951203bd20ec118a747777f32a3889bafe050bcccb30039aa8a7be2700
```

هذا الدمج يثبت اعتماد v5 ضمن مصفوفة الاختبار المحددة فقط. لا يثبت اكتمال kernel أو Wasmi، ولا يلغي `ABSTAIN` للملفات المرجعية الناقصة، ولا ينشئ stable release.

```text
LOOKUP_V5=PROVEN_FOR_CURRENT_INTEGRATION_MATRIX
KERNEL_ARCHIVE=ABSTAIN
WASMI_SOURCES=ABSTAIN_MISSING
STABLE_RELEASE=BLOCKED
AUTO_PROMOTION=DENY
FAIL_CLOSED=ACTIVE
```
