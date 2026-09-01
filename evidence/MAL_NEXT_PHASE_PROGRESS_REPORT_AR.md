# تقرير التقدم المرحلي لـMAL وUORI

## 1. policy comparator وAdmission Gate

تم تنفيذ `mal_policy_gate_comparator.py` كطبقة مقارنة ساكنة. يقرأ ملف السياسة على مستوى bytes، يحسب SHA-256، ويقارن الإصدار والبصمة والحقول المحظورة دون تنفيذ محتوى السياسة أو المصدر.

| الحالة | القرار | السبب | النتيجة |
|---|---|---|---|
| `policy_match` | `ALLOW` | `POLICY_MATCH` | PASS |
| `policy_hash_mismatch` | `ABSTAIN` | `POLICY_MISMATCH` | PASS |
| `policy_hash_malformed` | `ABSTAIN` | `POLICY_MISMATCH` | PASS |
| `policy_version_mismatch` | `ABSTAIN` | `POLICY_MISMATCH` | PASS |
| `forbidden_source_ref` | `DENY` | `FORBIDDEN_CONSTRUCT` | PASS |
| `forbidden_exec` | `DENY` | `FORBIDDEN_CONSTRUCT` | PASS |
| `missing_envelope` | `ABSTAIN` | `INPUT_SHAPE` | PASS |

البصمة الفعلية لملف السياسة المرجعي في هذا التشغيل هي:

```text
45a638036554ac0ac5d3e13d161a0d64eb422fae7cddd6ad5f38149734609e19
```

أُعيد التشغيل ثلاث مرات، وكانت المخرجات JSON متطابقة byte-for-byte: `TOTAL=7`, `MATCHED=7`, `MISMATCHED=0`.

## 2. MAL-DIR validator

تبيّن في التشغيل الأول أن harness افترض وجود حقل `status` داخل سجل MAL-DIR، بينما البنية الفعلية تستخدم وجود الحقل `ir` للدلالة على الحالات القابلة للتحويل. صُحح harness دون تغيير IR أو parser، ثم نجح validator.

```text
MAL_DIR_VALIDATOR=PASS
CASES_VALIDATED=6
TOTAL_NODES=58
SOURCE_EXECUTED=NO
NETWORK=DISABLED_BY_CONTRACT
```

جميع العقد الستة صالحة بنيوياً: NodeIDs متصلة، الجذر هو العقدة الأخيرة، المراجع تشير إلى عقد سابقة فقط، الأنواع معروفة، و`source_ref_executed=false`.

## 3. الحالة الحالية والحدود

أصبح لدينا الآن comparator موثق لحالات Grammar، ومسار مستقل لحالات DENY وpolicy hash، وvalidator بنيوي لـMAL-DIR. هذه الأدلة لا تثبت type checking أو name resolution أو SSA أو register allocation أو backend؛ تلك المراحل تبقى `RESEARCH` إلى أن تُبنى بعقود واختبارات مستقلة.

كما أن policy comparator الحالي يثبت صحة ربط البصمة والحقول السياسة في corpus الاختباري، لكنه لا يثبت أماناً شاملاً لكل بنية Python أو كل توقيع تشفيري محتمل. `ALLOW` يظل `ALLOW_STATIC_ONLY` ولا يفتح التنفيذ.

## 4. حالة baseline

العمل مسجل على فرع adoption مستقل، وworktree نظيف بعد كل commit. لا يوجد كائن Git محلي لـ`f56b8bd` في adoption repo أو المستودع المرجعي المتاح، لذلك تبقى مصادقة diff النهائية مع baseline معلقة إلى أن يتوفر مستودع أو كائن ذلك commit.

## 5. الأدلة

| الملف | الدليل |
|---|---|
| `extensions/mal_policy_gate_comparator.py` | policy hash وDENY comparator |
| `tests/run_mal_policy_gate_comparator.py` | اختبار سبع حالات سياسة |
| `evidence/MAL_POLICY_GATE_COMPARATOR_RUN1.stdout` | stdout الخام |
| `evidence/MAL_POLICY_GATE_COMPARATOR_REPRO.sha256` | بصمات التشغيلات |
| `extensions/mal_dir_validator.py` | validator البنيوي |
| `tests/run_mal_dir_validator.py` | اختبار MAL-DIR |
| `evidence/MAL_DIR_VALIDATOR.stdout` | stdout الخام للـvalidator |
| `evidence/MAL_DIR_VALIDATOR.sha256` | بصمات validator |
