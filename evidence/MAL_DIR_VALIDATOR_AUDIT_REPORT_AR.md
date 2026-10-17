# تقرير تدقيق `mal_dir_validator` والعقد الـ58

## الحكم

أُعيد تشغيل `tests/run_mal_dir_validator.py` ثلاث مرات في بيئة UTF-8 مع `SOURCE_DATE_EPOCH=0` و`PYTHONHASHSEED=0`. نجحت التشغيلات الثلاث، وتطابقت ملفات stdout حرفياً.

```text
MAL_DIR_VALIDATOR=PASS
CASES_VALIDATED=6
TOTAL_NODES=58
SOURCE_EXECUTED=NO
NETWORK=DISABLED_BY_CONTRACT
REPLAY_STDOUT_IDENTICAL=YES
RUNS=3
```

## البصمات

| الملف | SHA-256 |
|---|---|
| `extensions/mal_dir_validator.py` | `f6d5df61ae31451a7b4dde5bd0fcad92ec3999f21649b77decd6ccdfe4afab2a` |
| `tests/run_mal_dir_validator.py` | `23ef8457b54d725148f7b8139c2e58499646cde5e6551e66fdec0fbe6cd0f060` |
| `evidence/MAL_DIR_VALIDATOR.stdout` | `fc8649168f3b05abf163587bbe5770577624f83473d50623e911fc5e42698785` |
| تشغيل 1–3 | `fc8649168f3b05abf163587bbe5770577624f83473d50623e911fc5e42698785` لكل تشغيل |

تم أيضاً تنفيذ `sha256sum -c evidence/MAL_DIR_VALIDATOR.sha256`، وكانت جميع العناصر المسجلة `OK`.

## مطابقة الحالات والعقد

| الحالة | عدد العقد | الجذر | NodeIDs | فحص الجذر |
|---|---:|---:|---|---|
| `valid_empty_program` | 1 | 1 | PASS | PASS |
| `valid_integer_declaration` | 4 | 4 | PASS | PASS |
| `valid_arithmetic_expression` | 8 | 8 | PASS | PASS |
| `valid_function_if_loop` | 35 | 35 | PASS | PASS |
| `valid_struct` | 6 | 6 | PASS | PASS |
| `boundary_real_arithmetic` | 4 | 4 | PASS | PASS |
| **المجموع** | **58** | — | **PASS** | **PASS** |

الحساب مستقل: `1 + 4 + 8 + 35 + 6 + 4 = 58`. كما أن كل حالة تحقق فيها أن قائمة IDs تساوي بالتحديد `1..N` وأن `root=N`.

## توزيع أنواع العقد

| الحالة | توزيع العقد |
|---|---|
| `valid_empty_program` | `program:1` |
| `valid_integer_declaration` | `program:1, decl:1, type:1, literal_int:1` |
| `valid_arithmetic_expression` | `program:1, decl:1, type:1, literal_int:3, binary:2` |
| `valid_function_if_loop` | `program:1, function:1, block:4, decl:2, if:1, loop:1, return:2, type:3, name:8, literal_int:6, binary:6` |
| `valid_struct` | `program:1, struct:1, decl:2, type:2` |
| `boundary_real_arithmetic` | `program:1, decl:1, type:1, literal_real:1` |

## حدود ما يثبته التدقيق

يثبت هذا التدقيق سلامة البنية المتسلسلة لـMAL-DIR في الحالات الست التي أنتجت IR، وثبات المخرجات والبصمات، وعدم التنفيذ. لا يثبت صحة الدلالة النوعية أو name resolution أو SSA أو backend؛ هذه مراحل لاحقة تتطلب عقوداً واختبارات مستقلة.
