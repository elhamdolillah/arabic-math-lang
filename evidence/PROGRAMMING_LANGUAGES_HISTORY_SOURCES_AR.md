# مصادر خط تاريخ لغات البرمجة

## IEEE Computer Society

URL: https://www.computer.org/publications/tech-news/insider-membership-news/timeline-of-programming-languages

المقال المنشور في 10 يونيو 2022 يعرض محطات: خوارزمية Ada Lovelace سنة 1843، Plankalkül في أربعينيات القرن العشرين، Assembly وShortcode سنة 1949، Autocode سنة 1952، FORTRAN سنة 1957، ALGOL وLISP سنة 1958، COBOL سنة 1959، BASIC سنة 1964، Pascal سنة 1970، Smalltalk وC وSQL سنة 1972، Ada في الثمانينيات، C++ وObjective-C سنة 1983، Perl سنة 1987، Haskell سنة 1990، Python وVisual Basic سنة 1991، Ruby سنة 1993، Java وJavaScript وPHP سنة 1995، C# سنة 2000، Scala وGroovy سنة 2003، Go سنة 2009، Swift سنة 2014.

## Computer History Museum

URL: https://www.computerhistory.org/timeline/software-languages/

يذكر المتحف: بدء Plankalkül سنة 1945، A-0 سنة 1952، Speedcode سنة 1953، FORTRAN سنة 1957، COBOL سنة 1960، APL سنة 1962، BASIC سنة 1964، Simula سنة 1965، LOGO سنة 1967، Pascal سنة 1970. ويعرض أن APL استخدم رموزاً خاصة وعمليات موجزة، وأن Simula جمع البيانات والتعليمات في objects، وأن BASIC صُمم للتعلم.

## Old Dominion University — Steven J. Zeil

URL: https://www.cs.odu.edu/~tkennedy/cs355/s26/Public/history/index.html

المصدر التعليمي يميز بين machine code وassembly واللغات عالية المستوى. يصف FORTRAN للعددية، وLISP للمعالجة الرمزية والاستدعاء الذاتي والبرمجة الوظيفية، وALGOL قربه من الترميز الرياضي وتأثيره على لغات لاحقة واعتماده على BNF، وCOBOL للمعالجة التجارية، وC المطور بين 1969 و1973 لبناء Unix. كما يعرض صعود Ada وSmalltalk وC++ وJava وفترة انفجار لغات التخصص.

## ACM — Jean E. Sammet

URL: https://dl.acm.org/doi/abs/10.1145/361454.361485

المقال: Programming languages: history and future، Communications of the ACM، المجلد 15، العدد 7، الصفحات 601–610، منشور في 1 يوليو 1972. الملخص يذكر أن المقال يعرض شجرة زمنية وعلاقات تطور اللغات وأسباب تكاثرها والمفاهيم الرئيسية خارج أسماء اللغات.

## ملاحظة منهجية

التواريخ ليست دائماً سنة واحدة متفقاً عليها؛ قد يدل التاريخ على بدء التصميم أو أول تنفيذ أو أول إصدار تجاري أو أول استعمال واسع. لذلك يجب تسجيل نوع التاريخ في قاعدة MAL وعدم دمج أي سمة في اللغة لمجرد ورودها تاريخياً.

## Rust — The Rust Programming Language

URL: https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html

يوثق الكتاب أن الملكية مجموعة قواعد يفحصها المترجم، وأن لكل قيمة مالكاً واحداً، ولا يوجد إلا مالك واحد في الوقت نفسه، وتُسقط القيمة عند خروج المالك من النطاق. كما يصف الفرق بين stack وheap، وضرورة مطابقة التخصيص مع التحرير. هذه مبادئ قابلة للاستفادة منها في MAL، لكن تنفيذنا الحالي يستخدم مقابض مفهرسة وArena بدلاً من كشف مؤشرات للمصدر العربي.

## Ada/SPARK — AdaCore

URL: https://www.adacore.com/blog/memory-safety-in-ada-and-spark-through-language-features-and-tool-support

يوثق المصدر دور الأنواع القوية، أوضاع المعاملات `in` و`out` و`in out`، فحوص الحدود والمدى والفيض والسعة، والتحليل الساكن والديناميكي في Ada/SPARK. كما يذكر أن Ada توفر storage pools وفحوصاً تمنع الوصول خارج الحدود. ستُنقل إلى MAL كأنواع نطاقية وفحوص قبول صريحة، لا كمؤشرات أو تحويلات unchecked.

## نتيجة أولية للدمج

خط التاريخ لا يعني دمج اللغات كاملة. ستُستخلص سمات محددة: من ALGOL شكل القواعد الرسمية والنطاق المعجمي؛ من FORTRAN الأنواع العددية الصريحة؛ من LISP بنية التعبيرات الشجرية والاستدعاء الذاتي المقيد؛ من Pascal/Ada الأنواع والنطاقات والفحوص؛ من C وUnix وسم ABI فقط دون pointer semantics؛ من Haskell/ML المطابقة والأنواع algebraic؛ ومن Rust الملكية والمقابض والتحقق الساكن. أما dynamic eval وreflection غير المقيد وraw pointers وFFI غير الموثق فتظل DENY أو ABSTAIN.
