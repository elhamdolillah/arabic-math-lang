# تقرير اختبار comparator لبوابة قبول Grammar v0.1

## الحكم التنفيذي

نُفّذ comparator ساكن يربط كل حالة في `MAL_GRAMMAR_FREEZE_CORPUS_v0.1.json` بمخرجات parser canonical، ثم يقارن ثلاثية `expected_status` و`expected_error` و`expected_root` بالقرار والسبب الناتجين. لا يقيّم comparator المصدر، ولا ينفّذ `source_ref`، ولا يفتح شبكة أو shell.

| المؤشر | النتيجة |
|---|---:|
| الحالات الكلية | 12 |
| المطابقات | 12 |
| عدم المطابقة | 0 |
| التشغيلات المتكررة | 3 |
| تطابق JSON byte-for-byte | نعم |
| التنفيذ | `NOT_PERFORMED` |
| المصدر المنفذ | `NO` |
| الشبكة | `DISABLED_BY_CONTRACT` |

## مصفوفة القرار

| الحالة | القرار | reason_code | المطابقة |
|---|---|---|---|
| `valid_empty_program` | `ALLOW` | `STATIC_ACCEPT` | PASS |
| `valid_integer_declaration` | `ALLOW` | `STATIC_ACCEPT` | PASS |
| `valid_arithmetic_expression` | `ALLOW` | `STATIC_ACCEPT` | PASS |
| `valid_function_if_loop` | `ALLOW` | `STATIC_ACCEPT` | PASS |
| `valid_struct` | `ALLOW` | `STATIC_ACCEPT` | PASS |
| `invalid_unknown_token` | `ABSTAIN` | `UNKNOWN_TOKEN` | PASS |
| `invalid_missing_semicolon` | `ABSTAIN` | `SYNTAX_ERROR` | PASS |
| `invalid_mismatched_block` | `ABSTAIN` | `SYNTAX_ERROR` | PASS |
| `boundary_real_arithmetic` | `ABSTAIN` | `REAL_ARITHMETIC_CONTRACT_MISSING` | PASS |
| `boundary_unary_operator` | `ABSTAIN` | `UNSUPPORTED_UNARY_OPERATOR` | PASS |
| `boundary_reserved_as_identifier` | `ABSTAIN` | `RESERVED_WORD_AS_IDENTIFIER` | PASS |
| `security_source_ref` | `ABSTAIN` | `UNTRUSTED_SOURCE` | PASS |

## تفسير حدود الاختبار

هذا comparator هو طبقة ربط خاصة بقبول Grammar corpus. فهو يثبت أن parser evidence يطابق التوقعات المثبتة في corpus، وأن الحالات الخمس الصحيحة تصل إلى `ALLOW/STATIC_ACCEPT`، بينما تبقى الحالات غير الصالحة والحدّية والأمنية في `ABSTAIN` مع أسباب معلنة.

لا يعني `ALLOW` هنا السماح بتنفيذ البرنامج. كما لا يعيد comparator فحوص Admission Gate العامة مثل policy hash أو clock witness أو target allowlist أو ABI؛ هذه الفحوص تبقى مسؤولية البوابة العامة. لذلك يكون القرار المناسب لحالة Grammar هو:

```text
GRAMMAR_GATE_COMPARATOR=PROVEN_FOR_12_CASES
GRAMMAR_FREEZE=READY_FOR_FINAL_CHAIN_CHECK
EXECUTION=NOT_PERFORMED
```

## الأدلة

| الملف | الوظيفة |
|---|---|
| `extensions/mal_grammar_gate_comparator.py` | comparator الحتمي |
| `tests/run_mal_gate_comparator.py` | مشغل الاختبار |
| `evidence/MAL_GRAMMAR_GATE_COMPARATOR.stdout` | النتيجة canonical لكل الحالات |
| `evidence/MAL_GRAMMAR_GATE_COMPARATOR_RUN1.stdout` إلى `RUN3.stdout` | stdout الخام للتكرار |
| `evidence/MAL_GRAMMAR_GATE_COMPARATOR_RUN1.json` إلى `RUN3.json` | مخرجات JSON للمقارنة |
| `evidence/MAL_GRAMMAR_GATE_COMPARATOR.sha256` | بصمات المخرجات |

**الحالة:** `PASS` للمقارنة؛ لا تزال أي مصادقة نهائية على baseline أو سلسلة خارجية منفصلة عن هذا الاختبار.
