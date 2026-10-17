# مواصفة التمثيل الوسيط الحتمي MAL-DIR v0.1

**الحالة:** `RESEARCH / IMPLEMENTED-PROTOTYPE`، ولا تغيّر حالة Grammar v0.1.

## الغرض والنطاق

MAL-DIR هو تمثيل وسيط canonical ناتج عن AST المقبول نحويًا. وظيفته حفظ بنية البرنامج في سجل قابل لإعادة الإنتاج قبل أي semantic lowering أو SSA أو backend. لا ينفّذ المصدر، ولا يفتح ملفات أو شبكة، ولا يحمل عناوين ذاكرة أو أسماء كائنات runtime.

## العقد الحتمية

كل عقدة تملك `id` صحيحًا موجبًا، وتُرقّم بترتيب إنشاء pre-order من `1`. كل مرجع إلى عقدة أخرى هو `id` صحيح، وليس pointer. الحقول والقوائم مرتبة، وJSON canonical يستخدم UTF-8، `sort_keys=true`، وفواصل compact، وLF نهائي.

| الحقل | القاعدة |
|---|---|
| `dir` | القيمة الثابتة `MAL-DIR` |
| `version` | `0.1.0` |
| `root` | NodeID الجذر |
| `nodes` | قائمة مرتبة حسب NodeID |
| `kind` | نوع عقدة محدود مشتق من AST |
| `type` | نوع MAL المعلن عند توفره |
| `children` | قائمة NodeIDs مرتبة |
| `value` | قيمة literal canonical فقط |

## الأنواع المثبتة في prototype

`program`, `decl`, `type`, `literal_int`, `literal_real`, `literal_text`, `literal_bool`, `name`, `binary`, `call`, `return`, `block`, `if`, `loop`, `function`, `struct`.

## الثوابت الأمنية

لا يسمح builder بـ`eval` أو `exec` أو subprocess أو network. لا تُحوّل عقدة `source_ref` إلى تنفيذ؛ تُحفظ كـ`call` نحوي فقط عند نجاح parser، ويظل قرار الثقة والبوابة خارج MAL-DIR. real literal يُمثّل بنص canonical ويحتاج عقد IEEE-754 مستقلًا قبل التنفيذ الحتمي.

## حدود الإصدار

لا يثبت هذا الإصدار type checking أو name resolution أو control-flow validation أو SSA أو register allocation أو machine code. هذه طبقات مستقلة، وتظل `RESEARCH` حتى تثبت بعقود وcorpora منفصلة.

## معيار التحقق

يجب أن ينتج المصدر نفسه نفس JSON byte-for-byte في ثلاث تشغيلات على الأقل، وأن تكون `source_sha256` و`dir_sha256` ظاهرة في سجل الأدلة. أي اختلاف أو عقد غير معروف يؤدي إلى `ABSTAIN`، ولا يُنتج backend output.
