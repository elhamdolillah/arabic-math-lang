# مراجعة دستورية للآليات المرفقة 31–39

**الإصدار:** `0.1.0`

**المرجع المجمد:** `MAL_GRAMMAR_SPEC_v0.1_AR.md`

**النطاق:** مراجعة ساكنة للمقترحات المرفقة فقط. لا تعدّل هذه المراجعة Grammar v0.1، ولا تنفّذ أي مثال مصدر أو شبكة أو `source_ref` أو `eval` أو `exec`.

## قاعدة القرار

وجود آلية في لغة أخرى لا يثبت قابليتها للترجمة الحتمية إلى MAL أو UORI. لذلك تُفصل خاصية اللغة الأصلية عن عقد MAL المطلوب. الحتمية هنا تعني دلالة ونتيجة قابلة للتحديد ضمن مجال وشروط معلنة، لا مجرد تكرار تشغيل مثال واحد.

| الرقم | الآلية | التصنيف الحالي | القرار الدستوري المختصر |
|---:|---|---|---|
| 31 | أعداد صحيحة بدقة اعتباطية | `RESEARCH` | يمكن أن تكون سياسة امتداد، لكن MAL يحتاج تمثيل big-integer، حدود وقود/ذاكرة، وترميزاً canonical قبل الإثبات. |
| 32 | HashMap بمُجزِّئ يقدمه المستخدم | `ABSTAIN_UNTIL_EVIDENCE` | المُجزِّئ الثابت لا يضمن ترتيب iteration؛ يلزم جدول مرتب أو ترتيب مفروض قبل ادعاء الحتمية. |
| 33 | الذرّيات بترتيب `seq_cst` | `RESEARCH` | يضمن قيود الذاكرة وغياب data race في البرنامج الصحيح، لكنه لا يختار جدولة واحدة ولا نتيجة واحدة عبر كل interleavings. |
| 34 | decimal ثابت الدقة | `RESEARCH` | مناسب لامتداد عشري محدود، لكن يلزم تحديد precision وscale وrounding وoverflow وserialization بعيداً عن ثقافة العرض. |
| 35 | coroutine مع yield/resume صريح | `RESEARCH` | يمكن إثباته في نموذج تعاوني إذا كان تسلسل resume جزءاً من الإدخال؛ لا يثبت ذلك جدولة threads أو الزمن الحقيقي. |
| 36 | proper tail calls | `RESEARCH` | يزيل نمو stack في tail position ضمن تنفيذ مطابق للمواصفة، لكنه لا يضمن نجاحاً غير محدود مع نفاد الذاكرة أو مدخلات غير tail-recursive. |
| 37 | `repr(C)` لتثبيت layout | `RESEARCH` | يثبت layout بالنسبة إلى ABI/target محدد، لا عبر جميع المنصات؛ endian وpadding وunsafe transmute تحتاج عقداً منفصلاً. |
| 38 | ADT بمُنشئات مخفية | `RESEARCH` | يثبت إخفاء التمثيل وحدود البناء داخل module، لكن يلزم نظام وحدات/أنواع MAL وفحص عدم تسريب constructor. |
| 39 | STM مع retry حتمي | `ABSTAIN_UNTIL_EVIDENCE` | STM يحقق serializability، لكن ترتيب commits قد يتأثر بالجدولة؛ المثال الذي يعتمد على sleep لا يثبت الحتمية. |

## النتيجة التنفيذية

لم تُرفع أي آلية إلى `PROVEN` أو `EXTENSION_SCOPED_PROVEN`. الآليتان 32 و39 تحملان ادعاءً حتمياً غير كافٍ بصيغته المرفقة، ولذلك لا يجوز إصدار قيمة حتمية منهما. سيقتصر التنفيذ الحالي على checker ساكن يثبت وجود العقد والتصنيف وحدود السلامة، لا على تنفيذ runtime لهذه اللغات.

## حواجز MAL/UORI المشتركة

1. يبقى `MAL_GRAMMAR_SPEC_v0.1_AR.md` baseline غير معدل.
2. القرار الابتدائي هو `ABSTAIN` عند غياب النوع أو المجال أو الترتيب canonical أو حدود الفشل.
3. يمنع المسار `source_ref` و`eval` و`exec` والشبكة والمؤشرات الخام.
4. لا يُقبل ترتيب iteration أو commit أو scheduling كحتمي إلا إذا كان ممثلاً صراحة في المدخل أو مفروضاً بترتيب canonical.
5. لا تتحول دقة المثال، انخفاض الخطأ، أو وجود مكتبة خارجية إلى برهان على MAL/UORI.
6. التنفيذ المرفق هو `SOURCE_EXECUTION=NOT_PERFORMED`، وتصنيف الميزات يبقى بحثياً إلى حين parser وchecker وIR وcorpus وبصمة وسلسلة مستقلة.

## مصادر التحقق الأولية

المراجع الأولية التي تضبط حدود الادعاءات تشمل توثيق Python للأنواع العددية، وتوثيق Rust الذي يصف ترتيب `HashMap` بأنه arbitrary، وتوثيق C++ للذاكرة الذرية، ومواصفات Scheme وC# وRust وLua وHaskell وClojure. هذه المراجع تثبت خصائص اللغات الأصلية فقط، ولا تثبت ترجمتها إلى MAL.

## سجل الإثبات

```text
CONSTITUTION_REVIEW=PASS_WITH_GUARDS
RULES_EXECUTIVELY_ADOPTED=0
ATTACHED_RULES=9
SOURCE_EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
BASELINE_MODIFIED=NO
```

## مراجع

[1]: https://docs.python.org/3/library/stdtypes.html#numeric-types-int-float-complex "Python Standard Types — Numeric Types"
[2]: https://doc.rust-lang.org/std/collections/struct.HashMap.html "Rust std::collections::HashMap"
[3]: https://en.cppreference.com/w/cpp/atomic/memory_order.html "C++ memory_order"
[4]: https://www.rfc-editor.org/rfc/rfc3092 "RFC 3092 — The Proper Tail Recursion Requirement"
[5]: https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/floating-point-numeric-types "C# floating-point numeric types"
[6]: https://www.lua.org/manual/5.4/manual.html#2.6 "Lua coroutines"
[7]: https://doc.rust-lang.org/reference/type-layout.html#the-c-representation "Rust Type Layout — C representation"
[8]: https://www.haskell.org/onlinereport/haskell2010/haskellch5.html "Haskell 2010 — Modules"
[9]: https://clojure.org/reference/refs "Clojure Reference Types and Transactions"

## قيود

لم تُقرأ أو تُنفذ الشيفرات المرفقة. الأمثلة تبقى بيانات تعليمية غير موثوقة للتنفيذ، وأي انتقال إلى امتداد MAL يحتاج عقداً تنفيذياً منفصلاً.
