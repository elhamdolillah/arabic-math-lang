# تقرير بوابة المرحلة صفر لبناء مشغل MAL

**التاريخ:** 2026-08-25  
**النطاق:** المرحلة صفر من مواصفة بناء المشغل: تأسيس Arena والنواة النوعية  
**المرجع:** `pasted_content.txt`  
**حالة baseline:** مجمدة ولم تُعدّل

## النتيجة التنفيذية

أُجري البناء الفعلي للـ crate الموجود `rust/mal_ownership_arena` باستخدام `cargo test --release`. نجحت الاختبارات المحلية الخمسة الخاصة بمكتبة Arena، ولم تفشل أي منها. غير أن ذلك لا يحقق بوابة المرحلة صفر كاملة كما صيغت في المواصفة المرفقة، لأن التنفيذ الحالي ليس مطابقًا حرفيًا لكل شروطها: فهو يستخدم `Vec` داخليًا، ويعرّف `Handle` بدل واجهة `NodeID` المطلوبة، ولا يقدّم `allocate<T>() -> Result<NodeID, ArenaError>` أو `get<T>()` بالمواصفة المقترحة، كما لم يُنفذ اختبار 10,000 عقدة ضمن هذه الدفعة.

وعليه تكون الحالة:

```text
ARENA_LOCAL_TESTS=PASS
STAGE0_GATE=ABSTAIN
MAL_AR_RUNTIME=UNAVAILABLE
SOURCE_EXECUTION=NOT_PERFORMED
AUTO_PROMOTION=DENY
BASELINE_FREEZE=ACTIVE
```

## الأمر المنفذ

```text
cd /home/ubuntu/uori-mal-pr/rust/mal_ownership_arena
cargo test --release
```

## المخرج الفعلي

```text
running 5 tests
test tests::borrow_rules_are_fail_closed ... ok
test tests::scope_and_type_and_arena_mismatch_are_rejected ... ok
test tests::deterministic_first_free_slot_and_reuse_generation ... ok
test tests::capacity_and_type_contracts_are_rejected ... ok
test tests::stale_handle_is_rejected_after_release ... ok

test result: ok. 5 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

STATUS=0
```

المخرج الخام محفوظ في:

```text
evidence/MAL_RUNTIME_STAGE0_CARGO_TEST_2026-08-25.stdout
evidence/MAL_RUNTIME_STAGE0_CARGO_TEST_2026-08-25.sha256
```

## مقارنة شروط المرحلة صفر بالتنفيذ الحالي

| الشرط | الحالة | الدليل أو الفجوة |
|---|---|---|
| منع `unsafe` | `PASS` محليًا | الملف يحتوي `#![forbid(unsafe_code)]` |
| تخصيص حتمي في Arena | `PASS` جزئيًا | الاختبار يثبت أول خانة وإعادة الاستخدام؛ لا يثبت مطابقة نموذج NodeID المطلوب |
| سعة ثابتة | `PASS` جزئيًا | السعة تُمرر عند الإنشاء، لكن التخزين الداخلي `Vec` |
| `NodeID(u32)` | `ABSTAIN` | الموجود هو `Handle` متعدد الحقول، وليس `NodeID` بالمواصفة |
| `allocate<T>() -> NodeID` | `ABSTAIN` | الموجود `allocate(&mut self, value, type_tag)` ويعيد `Handle` |
| `get<T>()` | `ABSTAIN` | الموجود `read(handle, scope)`؛ لا توجد الواجهة المطلوبة |
| 10,000 عقدة متتالية | `NOT_PERFORMED` | لم يُنفذ اختبار مستقل بهذا العدد |
| تجاوز السعة دون panic | `PASS` ضمن الاختبار الحالي | اختبار `ArenaExhausted` ناجح |
| فهرس خاطئ | `PASS` جزئيًا | توجد اختبارات مقبض قديم وعدم تطابق، لا اختبار `NodeID` المطلوب |
| عدم تخصيص heap في المسار الساخن | `ABSTAIN` | لم يُثبت؛ والبنية الحالية تستخدم `Vec` |
| مشغل ملفات `.ar` | `NOT_PERFORMED` | المرحلة صفر لا تنشئ parser أو interpreter |

## الحكم الدستوري

نجاح الاختبارات الخمسة دليل محلي على بعض قواعد الملكية والعمر والنوع والسعة في مكتبة Arena، وليس دليلًا على مشغل MAL. وبسبب غياب إثبات شرط `NodeID` وغياب اختبار 10,000 عقدة وعدم إغلاق مسألة التخصيص، لا يجوز إعلان `STAGE0_GATE=PASSED` بصورة كلية. التصنيف الأنسب هو `ABSTAIN_UNTIL_EVIDENCE`، مع إبقاء نتيجة المكتبة `PASS` في نطاقها المحدود.

لم تُضف واجهة تشغيل، ولم تُنفذ ملفات `.ar`، ولم تُنشأ بصمات AST أو IR أو ABI، ولم يُجرَ اختبار تفاضلي مقابل Python.

## العمل اللازم قبل إغلاق المرحلة صفر

يجب إنشاء عقد مستقل يحدد تمثيل `NodeID`، ونطاقه، وسلوك السعة، وأخطاء النوع والفهرس، ثم تعديل Arena أو إنشاء طبقة Arena جديدة لا تستخدم `Vec` في المسار الذي سيُعلن أنه بلا تخصيص. بعد ذلك يجب إضافة اختبار 10,000 عقدة واختبارات الحدود، وحفظ مخرجات خام قابلة لإعادة التشغيل، ثم التحقق من سلسلة SHA-256. لا يجوز الانتقال إلى lexer قبل إغلاق هذه الشروط أو تسجيل الامتناع صراحة.

## القرار

```text
STAGE0_LOCAL_ARENA_RESULT=PASS
STAGE0_CONSTITUTIONAL_GATE=ABSTAIN_UNTIL_EVIDENCE
PARSER_BUILD=NOT_STARTED
INTERPRETER_BUILD=NOT_STARTED
BASELINE_MODIFIED=NO
```

## المراجع

[1]: `../../upload/pasted_content.txt` — مواصفة البناء التصاعدي لمشغل MAL.
[2]: `../rust/mal_ownership_arena/src/lib.rs` — تنفيذ Arena واختباراته الحالية.
[3]: `../evidence/MAL_RUNTIME_STAGE0_CARGO_TEST_2026-08-25.stdout` — المخرج الخام للاختبار.
[4]: `../evidence/MAL_RUNTIME_STAGE0_CARGO_TEST_2026-08-25.sha256` — بصمة المخرج الخام.
[5]: `MAL_RUNTIME_EXECUTION_GATE_REPORT_2026-08-25_AR.md` — حالة فجوة التنفيذ السابقة.
