

## مصادر خارجية ونتائج المراجعة الأولية

### 206 — Scala `lazy val`
المصدر: [Scala 3 Lazy Vals Initialization](http://nightly.scala-lang.org/docs/reference/changed-features/lazy-vals-init.html).

يصف المصدر آلية تهيئة متزامنة ذات حالات داخلية، ويذكر أن التهيئة الناجحة تُنشر بعد اكتمالها، وأن التهيئة العودية قد تؤدي إلى سلوك غير معرّف أو جمود. لذلك لا يُقبل ادعاء أن كل تعبير مهيئ دالة نقية أو أن النتيجة مستقلة عن الآثار الجانبية والجدولة؛ ويجب تثبيت إصدار Scala ومنع recursion غير المثبت.

### 207 — Prolog `when/2`
المصدر: [SWI-Prolog when/2](https://www.swi-prolog.org/pldoc/man?predicate=when/2).

يؤجل المسند الهدف إلى تحقق شرط من الشروط المدعومة مثل `nonvar` أو `ground`، ويُنفذ عبر attributed variables في مكتبة `when`. هذا لا يثبت أن تغيير ترتيب الأهداف لا يغيّر قابلية الإيقاظ أو النجاح أو عدد الحلول؛ إذ تبقى دلالات Prolog التشغيلية والآثار الجانبية ومجال الشرط ذات صلة. لذلك يصنف كبحث مع امتناع عند ادعاء ترتيب مستقل عام.

### 208 — Erlang `receive`
المصدر: [Erlang Reference Manual — Expressions](https://www.erlang.org/docs/21/reference_manual/expressions.html).

تُفحص الرسائل في صندوق البريد بالتتابع الزمني حتى العثور على رسالة تطابق نمطًا وحارسًا صحيحين، وتُزال الرسالة المطابقة بينما تبقى غير المطابقة. هذا يثبت سياسة اختيار محددة لصندوق بريد ثابت، لكنه لا يثبت ثبات ترتيب وصول الرسائل أو حتمية حالة الصندوق بين التشغيلات أو أولوية مطلقة مستقلة عن الرسائل الأقدم المطابقة.

### 209 — COBOL `INSPECT`
المصدر: [IBM COBOL INSPECT statement](https://www.ibm.com/docs/en/cobol-zos/6.4.0?topic=statements-inspect-statement) و[IBM Tallying and replacing](https://www.ibm.com/docs/en/cobol-linux-x86/1.2.0?topic=strings-tallying-replacing-data-items-inspect).

يحدد المصدر العد والاستبدال والتحويل، ويصف عمليات `ALL` بوصفها غير متداخلة وتبدأ من الموضع الأيسر إلى الأيمن ضمن مجال البيانات. غير أن دلالة النص تعتمد على `USAGE` و`DISPLAY` أو `NATIONAL` وDBCS والترميز، لذلك لا يجوز تعميم الحتمية العابرة للمنصات دون تثبيت dialect والترميز والتنفيذ.

### 210 — BASIC `DATA/READ/RESTORE`
المصادر: [Microsoft BASIC Language Reference عبر PCjs](https://www.pcjs.org/documents/books/mspl13/basic/b7lang/) و[QB64 DATA](https://qb64.com/wiki/DATA.html).

تثبت المراجع أن `DATA` تخزن قيمًا حرفية وأن `READ` يستهلكها، بينما يعيد `RESTORE` موضع القراءة، مع خطأ عند تجاوز البيانات. لكن هذه ليست مواصفة BASIC موحدة؛ فتفاصيل الوسوم والمواضع وموضع `DATA` تختلف بين dialects، ولذلك يلزم تثبيت dialect والإصدار قبل قبولها كضمان حتمي قابل للنقل.

## حكم أولي

تبقى الآليات 206–210 في `RESEARCH`. وتُستخدم `ABSTAIN_UNTIL_EVIDENCE` عند ادعاء الحتمية العابرة للمنصات، أو نقاء التهيئة، أو استقلال الترتيب، أو ثبات الترميز والدialect دون مواصفة مثبتة.
