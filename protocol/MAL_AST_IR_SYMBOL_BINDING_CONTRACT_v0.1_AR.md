# عقد ربط AST وIR والرموز v0.1

## الغرض

يحدد هذا العقد التحويل الحتمي من عقدة AST إلى سجل IR ورمز مولد، مع حفظ العلاقة الفهرسية القابلة للتدقيق داخل Arena.

## السجل canonical

يمثل كل إدخال بالعلاقة `(ast_node_id, ir_ordinal, ir_operation, symbol_name)`. يجب أن يكون `ast_node_id` معرفًا موجبًا محدودًا بالسعة، وأن تبدأ الرتبة من واحد، وأن يكون ترتيب الإدخالات تصاعديًا حسب `ast_node_id` ثم `ir_ordinal`. لا يُسمح بعنوان ذاكرة أو معرف عشوائي أو وقت أو جدولة.

## المطابقة

لا تُنشأ عملية IR إلا لنوع AST مسجل في جدول الأنواع المعتمد. ويجب أن يكون لكل عقدة AST رمز واحد فقط داخل النطاق نفسه. يُرفض الإدخال عند غياب النوع، أو عدم تطابق العملية، أو تكرار المعرف، أو خرق الترتيب.

## حواجز ABI

لا يجوز لجدول الربط إصدار نداء خارجي أو اسم رمز غير canonical. تكون قائمة العمليات ثابتة، ويجب أن تمر كل عملية عبر بوابة تحقق قبل Codegen. أي عملية غير موجودة في قائمة ABI تعيد `ABSTAIN / ABI_OPERATION_UNAUTHORIZED`.

## حدود Arena

لا تُستخدم مؤشرات خام أو تخصيصات ديناميكية. عند تجاوز السعة يعاد `ABSTAIN / ARENA_EXHAUSTED`. لا يُسمح بالكتابة خارج الفهرس أو بإعادة استخدام NodeID.

## التصنيف

الحالة الحالية `POLICY / RESEARCH`. لا يصير الربط `EXTENSION_SCOPED_PROVEN` إلا بعد تشغيل MAL موثوق، وإثبات corpus موجب وسالب، وحفظ stdout والبصمات والتحقق من سلسلة الأدلة.

```text
RAW_POINTERS=DENY
DYNAMIC_ALLOCATION=DENY
ABI_UNAUTHORIZED_CALL=ABSTAIN
NON_DETERMINISTIC_ORDER=ABSTAIN
SOURCE_EXECUTION=NOT_PERFORMED
AUTO_PROMOTION=DENY
```
