# تقرير بوابة المرحلة الأولى: Lexer وParser وAST

**التاريخ:** 2026-08-25  
**المرجع المجمد:** `d187ce9`  
**النطاق:** تنفيذ Lexer وParser محدودين فوق `FixedArena` مع AST ذي حقول ثابتة

## الملخص التنفيذي

أُضيفت وحدة Lexer حتمية تعتمد على شرائح المصدر `&str` وتخزّن الرموز داخل `FixedArena`، مع معرّفات `NodeID` متتابعة. كما أُضيف Parser محدود النحو يبني عقدة تعريف وعقدة عدد داخل `FixedArena`، ويرفض التعبيرات المحظورة، والنقص النحوي، والرموز الإضافية، والفيض العددي.

لا يستخدم المسار الجديد `eval` أو `exec` أو مؤشرات خام أو `Vec` أو `String` أو `unsafe`. وتظل `Arena` القديمة منفصلة، كما لم يُنشأ بعد مشغل مستقل يقرأ ملفات `.ar` من واجهة مصدر كاملة.

## الاختبار الفعلي

نُفذ الأمر التالي:

```text
cd rust/mal_ownership_arena
cargo test --release
```

وكانت النتيجة الخام:

| المجموعة | الناجح | الفاشل |
|---|---:|---:|
| اختبارات الوحدة القديمة | 5 | 0 |
| اختبارات FixedArena | 3 | 0 |
| اختبارات Lexer | 5 | 0 |
| اختبارات Parser | 4 | 0 |
| الإجمالي | 17 | 0 |

حُفظ المخرج في:

```text
evidence/MAL_RUNTIME_STAGE1_LEXER_PARSER_TEST.stdout
evidence/MAL_RUNTIME_STAGE1_LEXER_PARSER_TEST.sha256
```

## التغييرات المنفذة

| الملف | الغرض |
|---|---|
| `src/ast.rs` | تعريف `AstOpcode` و`AstNode` ذي الشرائح والروابط المحددة |
| `src/lexer.rs` | تقطيع UTF-8 حتمي مع كشف المحظورات والفيض وحدود السعة |
| `src/parser.rs` | تحليل صيغة `بنية_... = عدد` وربط العدد بعقدة التعريف |
| `src/lib.rs` | تصدير الوحدات وإتاحة `next_node_id` |
| `tests/stage1_parser.rs` | اختبارات البناء والرفض الدستوري والنحوي |

## الحكم الدستوري

تثبت الأدلة نجاحًا محصورًا في امتداد Rust المحلي لوحدات Lexer وParser وAST، ولا تثبت بعد مشغل MAL سياديًا أو تنفيذ ملفات `.ar` من المصدر. لذلك لا يجوز ترفيع حالة المشغل أو إنشاء Sidecar تنفيذي.

```text
STAGE0_FIXED_ARENA=PASSED
STAGE1_LEXER=EXTENSION_SCOPED_PROVEN
STAGE1_PARSER_AST=EXTENSION_SCOPED_PROVEN
STAGE1_FULL_LANGUAGE=ABSTAIN_UNTIL_SPEC_EXPANSION
MAL_AR_RUNTIME=UNAVAILABLE
SOURCE_EXECUTION=NOT_PERFORMED
DIFFERENTIAL_EXECUTION=NOT_PERFORMED
AUTO_PROMOTION=DENY
BASELINE_FREEZE=ACTIVE
BASELINE_MODIFIED=NO
```

## القيود المتبقية

النحو المثبت حاليًا هو صيغة محدودة، وليس مواصفة MAL كاملة. لم يُثبت بعد تحليل جميع الكلمات المفتاحية أو بناء جدول رموز شامل أو توليد IR أو تشغيل Corpus الملفات `.ar`. كما أن نجاح اختبار Rust لا يساوي نجاح تنفيذ المصدر العربي؛ لذلك بقي `MAL_AR_RUNTIME=UNAVAILABLE` عمدًا.

## المراجع

[1]: `../rust/mal_ownership_arena/src/ast.rs` — تعريف AST.
[2]: `../rust/mal_ownership_arena/src/lexer.rs` — Lexer الحتمي.
[3]: `../rust/mal_ownership_arena/src/parser.rs` — Parser المحدود.
[4]: `../rust/mal_ownership_arena/tests/stage1_lexer.rs` — اختبارات Lexer.
[5]: `../rust/mal_ownership_arena/tests/stage1_parser.rs` — اختبارات Parser.
[6]: `../evidence/MAL_RUNTIME_STAGE1_LEXER_PARSER_TEST.stdout` — السجل الخام.
[7]: `../evidence/MAL_RUNTIME_STAGE1_LEXER_PARSER_TEST.sha256` — بصمة السجل.
