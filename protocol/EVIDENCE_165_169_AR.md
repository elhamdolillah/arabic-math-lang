# سجل أدلة مراجعة الآليات 165–169

## الآلية 165 — SERIALIZABLE

يقرر توثيق PostgreSQL الرسمي أن مستوى `Serializable` يحاكي تنفيذ المعاملات تسلسليًا، وأن التنفيذ المتزامن لمجموعة معاملات serializable مضمون أن ينتج الأثر نفسه لتشغيلها واحدة تلو الأخرى **في ترتيب ما**. لذلك يثبت مستوى العزل قابلية التفسير التسلسلي، لكنه لا يثبت وحده ترتيبًا وحيدًا محددًا مسبقًا، ولا يثبت حتمية النتيجة إذا اختلفت سياسة إعادة المحاولة أو ترتيب الالتزام أو الآثار الخارجية.

المصدر: https://www.postgresql.org/docs/current/transaction-iso.html

## الآلية 166 — Ada `rem` و`mod`

يحدد Ada Reference Manual أن `rem` يحقق العلاقة `A = (A/B)*B + (A rem B)` ويكون للباقي إشارة المقسوم وقيمة مطلقة أصغر من المقسوم عليه، بينما يكون `mod` ذا إشارة المقسوم عليه وقيمة مطلقة أصغر منه. هذه دلالة معيارية مفيدة، لكن المثال المرفق يجب أن يصرح أيضًا بأن القسمة على الصفر ترفع `Constraint_Error`، وأن ضمان MAL يحتاج عقدًا صريحًا للعرض، overflow، ونطاق الأنواع.

المصدر: https://www.adaic.org/resources/add_content/standards/05rm/html/RM-4-5-5.html

## الآلية 167 — C `fetestexcept`

يعرّف توثيق POSIX/Open Group `fetestexcept` لفحص أعلام استثناءات الفاصلة العائمة المدعومة، لكنه يربط ذلك بدعم التنفيذ، ويشترط الانتباه إلى `FENV_ACCESS`؛ إذ إن استعمال البيئة العائمة دون تفعيل السياق المناسب قد يؤدي إلى سلوك غير معرف. لذلك لا يكفي وجود الدالة لإثبات حتمية عبر المنصات، بل يلزم عقد IEEE-754، وcompiler flags، وABI، وسياسة rounding، واختبار platform matrix.

المصدر: https://pubs.opengroup.org/onlinepubs/009695399/basedefs/fenv.h.html

## الآلية 168 — JavaScript `Object.is`

تعرّف ECMAScript خوارزمية `SameValue` التي يقوم عليها `Object.is`، وتفرق بين `+0` و`-0` وتعد `NaN` مساويًا لـ `NaN` ضمن دلالتها. لا يصح تعميم ذلك إلى أن المقارنة لا تتأثر بهوية الكائنات؛ فالكائنات المختلفة تُقارن وفق الهوية، كما أن الآلية جزء من دلالات ECMAScript وليست إثباتًا تلقائيًا لحتمية كل بنية بيانات أو ترتيب تنفيذ.

المصدر: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is

## الآلية 169 — JavaScript `String.prototype.normalize`

يحول `normalize` السلسلة إلى أحد أشكال Unicode المحددة (`NFC`, `NFD`, `NFKC`, `NFKD`) ويساعد على توحيد التمثيلات المتكافئة. لكن اختيار الشكل دلالي، و`NFKC` و`NFKD` قد يغيران التمثيل لأغراض التوافق؛ لذلك يجب على MAL اختيار الشكل وتثبيت إصدار جداول Unicode قبل استخدام الناتج في hash أو ABI.

المصدر: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize

## ملاحظة حاكمة

لا يُقبل الادعاء بأن `SERIALIZABLE` وحده يجعل النتيجة النهائية واحدة لكل جدولة، ولا أن `fetestexcept` يثبت حتمية عابرة للمنصات، ولا أن `Object.is` أو `normalize` يحلان وحدهما مسائل الهوية أو ABI. تبقى الآليات 165–169 في `RESEARCH` إلى حين عقود MAL مستقلة وأدلة تنفيذ مزدوجة.
