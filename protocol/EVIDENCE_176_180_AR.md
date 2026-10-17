# سجل الأدلة الحاكم للآليات 176–180

## 176 — `std::variant` و`std::visit`

يمثل `std::variant` اتحادًا آمنًا نوعيًا، لكنه قد يدخل حالة `valueless_by_exception`، كما أن `std::get` يرمي `std::bad_variant_access` عند الوصول إلى بديل غير نشط. لذلك لا يصح وصف كل حالة بأنها دالة نقية أو خالية من الاستثناءات. كما أن `std::visit` يفرض قابلية استدعاء الزائر للتركيبات التي قد يمررها، لكنه لا يثبت وحده أن جسم الزائر يغطي دلاليًا كل حالة.

المصدر: https://en.cppreference.com/w/cpp/utility/variant

## 177 — `final` في Java

تمنع الفئة `final` الوراثة، لكن ذلك لا يساوي قاعدة لغوية بأن كل استدعاء سيُنفذ دائمًا باستدعاء ثابت أو أن المترجم سيزيل كل آليات الربط الافتراضي. التحسينات مثل devirtualization اختيارية وتابعة للمترجم وبيئة التشغيل. المثال يستخدم دالة static أصلًا، ولذلك لا يثبت دعوى dispatch الخاصة بطرائق instance.

المصدر المرجعي العام: https://docs.oracle.com/javase/specs/jls/se21/html/jls-12.html

## 178 — `sealed` والمطابقة الشاملة

تسمح Java الحديثة بالتحقق من شمولية switch expression، ويمكن أن تساعد sealed hierarchies في إثبات تغطية الفئات المسموح بها. لكن صفحة Java 17 المعنية تصف pattern switch بوصفه preview feature، كما أن المثال بلا `default` يتطلب نسخة/خيارات لغة مناسبة، ولا يثبت غياب كل استثناء runtime؛ فالقيم null، والأخطاء داخل الفروع، وأخطاء الحساب ما تزال ممكنة.

المصادر: https://docs.oracle.com/en/java/javase/17/language/pattern-matching-switch-expressions-and-statements.html و https://openjdk.org/jeps/441

## 179 — `std::atomic_thread_fence`

لا تنشئ fence علاقة synchronization وحدها؛ يلزم وجود العملية الذرية المناسبة وقراءة القيمة الملائمة وفق نموذج C++. المثال المرفق غير سليم كإثبات عام: consumer يقرأ `ready` قراءة relaxed ثم ينفذ acquire fence، وهذا قد يحقق fence-atomic synchronization فقط بشروط محددة، لكن الوصول إلى `data` غير الذري يحتاج إثباتًا كاملًا للعلاقة happens-before. لا يجوز تعميم أن fence يمنع كل السباقات أو يجعل الخوارزمية lock-free.

المصدر: https://en.cppreference.com/w/cpp/atomic/atomic_thread_fence

## 180 — `yield return` في C#

يولد compiler آلة تعداد ويؤجل التنفيذ إلى وقت التعداد، لكن ذلك لا يجعل التسلسل دالة نقية ولا مستقلة عن كل العوامل الخارجية. الآثار الجانبية، الحالة الملتقطة، إعادة التعداد، الاستثناءات، والإلغاء قد تغير السلوك. مثال Fibonacci نفسه حتمي عند تثبيت المدخلات وعدم وجود آثار جانبية، لكن الضمان لا ينتقل تلقائيًا إلى كل iterator.

المصدر: https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/statements/yield

## الحكم الحاكم

تبقى الآليات 176–180 في تصنيف `RESEARCH`. تُوسم الآلية 179 `ABSTAIN` للمثال المرفق حتى يثبت نموذج التزامن كاملًا، وتُوسم الآلية 177 `RESEARCH` مع حذف دعوى dispatch الإلزامي، بينما تُقبل 176 و178 و180 فقط بصياغة محدودة لا تدعي النقاء أو الحتمية الشاملة.
