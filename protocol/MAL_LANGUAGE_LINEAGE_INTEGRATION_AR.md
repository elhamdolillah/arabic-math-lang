# مصفوفة السلالة التاريخية وقرار دمج السمات في MAL/UORI

## الغرض

لا تُدمج لغات البرمجة في MAL بوصفها حزمًا كاملة. تُستخدم السلالة التاريخية لتحديد أصل كل فكرة، ثم تُعاد صياغة الفكرة وفق دستور MAL/UORI: حتمية قابلة لإعادة الإنتاج، تحليل ساكن، عدم وجود raw pointers، ملكية قابلة للتحقق، وامتناع آمن عند الغموض أو انتهاك العقد.

## الخط الزمني الانتقائي

| الترتيب | المحطة | السنة التقريبية | الفكرة التاريخية | قرار MAL/UORI |
|---:|---|---:|---|---|
| 1 | خوارزمية Ada Lovelace لمحرك Babbage | 1843 | تمثيل خطوات حساب عامة | PROVEN كمبدأ تاريخي، لا كتنفيذ مباشر |
| 2 | Plankalkül | 1945 | لغة خوارزمية مبكرة وتمثيل مسائل عامة | RESEARCH |
| 3 | Assembly/Shortcode | 1949 | تقريب التعليمات من الآلة | DENY كواجهة مصدر عامة؛ يسمح ABI موثق فقط |
| 4 | Autocode/A-0 | 1952 | الترجمة من صياغة أعلى إلى آلة | EXTENSION_SCOPED_PROVEN |
| 5 | FORTRAN | 1957 | الصياغة العددية والترجمة العلمية | EXTENSION_SCOPED_PROVEN للأنواع العددية الثابتة |
| 6 | ALGOL 58/60 | 1958–1960 | النطاق المعجمي، الكتل، الوصف الرياضي، BNF | PROVEN كأساس Grammar وMAL-DIR |
| 7 | LISP | 1958/1959 | التعبيرات الشجرية، القوائم، الاستدعاء الذاتي | EXTENSION_SCOPED_PROVEN بعد حدود عمق وحجم ثابتة |
| 8 | COBOL | 1959/1960 | قابلية القراءة وأوصاف البيانات | RESEARCH؛ لا تُعتمد natural-language execution |
| 9 | APL | 1962 | عمليات مصفوفية مختصرة | RESEARCH؛ تتطلب عقد Unicode وامتناعاً عند الغموض |
| 10 | BASIC | 1964 | تعليم المبتدئين والتفاعل | RESEARCH؛ لا يُنقل النمط التفاعلي غير الحتمي |
| 11 | Simula/Smalltalk | 1965/1970s | objects والرسائل | RESEARCH؛ لا dynamic dispatch غير مقيد |
| 12 | Pascal | 1970 | أنواع وبنى منظمة وتعليم المترجمات | EXTENSION_SCOPED_PROVEN |
| 13 | C وUnix | 1969–1973 | كفاءة الأنظمة وواجهات ABI | EXTENSION_SCOPED_PROVEN للـ ABI المعلن؛ raw pointers DENY |
| 14 | SQL | 1970s | استعلامات البيانات | RESEARCH؛ يتطلب مصدر بيانات ثابتاً وسجلّاً حتمياً |
| 15 | Ada/SPARK | 1980s | الأنواع القوية وفحوص الحدود والتحقق | EXTENSION_SCOPED_PROVEN |
| 16 | ML/Haskell | 1970s–1990 | الأنواع algebraic والمطابقة والوظائف النقية | EXTENSION_SCOPED_PROVEN |
| 17 | C++/Java | 1983/1995 | objects وgenerics وruntime ecosystems | RESEARCH؛ لا تُنقل إدارة runtime تلقائياً |
| 18 | Python/JavaScript/Ruby/PHP | 1991–1995 | scripting والديناميكية والانعكاس | DENY للـ eval/reflection غير المقيد؛ subset ثابت فقط |
| 19 | Go | 2009 | بساطة الأنظمة والتزامن | RESEARCH؛ التزامن لا يدخل Tier-0 قبل ساعة منطقية |
| 20 | Rust | 2010s | الملكية والاستعارة والسلامة دون GC | EXTENSION_SCOPED_PROVEN عبر Arena/Handle؛ لا unsafe |
| 21 | Swift | 2014 | أنواع حديثة وواجهات آمنة | RESEARCH |

## تطبيق الدستور

### PROVEN

تدخل هذه السمات إلى المواصفة الأساسية فقط إذا كانت قابلة للاختبار دون اعتماد على عنوان الذاكرة أو وقت الجدار أو ترتيب غير مضبوط. تشمل ذلك القواعد الرسمية على نمط ALGOL، النطاق المعجمي، البنية الشجرية، والترقيم الحتمي للعقد في MAL-DIR.

### EXTENSION_SCOPED_PROVEN

تدخل هذه السمات في امتداد مستقل بعقد وcorpus وبصمة خاصة. ينطبق ذلك على الأنواع العددية الثابتة، الأنواع النطاقية، المطابقة، وArena ذات `NodeID` و`generation`. لا تصبح جزءاً من Tier-0 قبل نجاح اختبارات cross-environment.

### RESEARCH

تبقى المصفوفات المختصرة، objects، التزامن، قواعد البيانات، والواجهات الديناميكية في مسار بحثي. وجود فائدة عملية لا يكفي لاعتمادها؛ يلزم نموذج حتمي ومحدد الموارد.

### DENY

يُمنع `eval` و`exec` و`source_ref` غير الموثق، وraw pointers، وunchecked casts، والانعكاس الذي يغير البرنامج أثناء التشغيل، وأي وصول مباشر إلى العتاد خارج عقد UORI.

### ABSTAIN

إذا كان الأصل التاريخي أو الإصدار أو semantics غير محدد، أو إذا تعارضت السمة مع أكثر من تفسير حتمي، تعاد `ABSTAIN` ولا تُضاف إلى Grammar أو backend.

## خطة الدمج في المترجم

يُضاف أولاً سجل معرفة ثابت بصيغة JSON يربط كل سمة بمصدرها وقرارها. ثم تُضاف فقط سمات ALGOL/Pascal/Ada/Rust المصنفة ضمن النطاق المثبت إلى Grammar v0.2 أو امتداداتها. بعد ذلك تُولّد عقد MAL-DIR، وتتحقق تمريرة الملكية من المقابض والأجيال، ثم يُشغّل corpus مستقل على Ubuntu وAlpine. لا يُسمح بتعديل baseline المجمد `f56b8bd`.

## مبدأ حاكم

> لا يرث MAL أخطاء اللغات تاريخياً؛ يرث الأفكار القابلة للإثبات فقط، ويعيد رفض كل سلوك يعتمد على التخمين أو البيئة أو التنفيذ غير المصرح به.

## المصادر

[1] IEEE Computer Society، [Coding From 1849 to 2022](https://www.computer.org/publications/tech-news/insider-membership-news/timeline-of-programming-languages).

[2] Computer History Museum، [Software and Languages Timeline](https://www.computerhistory.org/timeline/software-languages/).

[3] Steven J. Zeil، Old Dominion University، [A Brief History of Programming Languages](https://www.cs.odu.edu/~tkennedy/cs355/s26/Public/history/index.html).

[4] Jean E. Sammet، ACM، [Programming languages: history and future](https://dl.acm.org/doi/abs/10.1145/361454.361485).

[5] Rust Project، [What Is Ownership?](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html).

[6] AdaCore، [Memory Safety in Ada and SPARK](https://www.adacore.com/blog/memory-safety-in-ada-and-spark-through-language-features-and-tool-support).
