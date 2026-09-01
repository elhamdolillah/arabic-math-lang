# مصادر بحث GADT وrank-polymorphism

## GADT

توثق وثائق OCaml أن GADT توسّع الأنواع المجموعية بقيود قد تتغير بحسب constructor، وقد تتضمن متغيرات وجودية. تُستعاد القيود عبر pattern matching وتبقى صالحة داخل الفرع المعني؛ كما يجب ألا تتسرب الأنواع الوجودية خارج نطاق الفرع. توضح الوثيقة أيضاً أن استنتاج الأنواع مع GADT صعب، وأن فحص الاكتمال يمكنه استخدام القيود لاكتشاف الحالات غير الممكنة. المصدر: [OCaml GADTs](https://ocaml.org/manual/4.10/gadts.html).

## rank-polymorphism

توثق وثائق GHC أن arbitrary-rank polymorphism يسمح بـ `forall` صريح داخل أنواع الدوال، بما في ذلك rank-2 وrank-3، وأن `RankNTypes` يتيح التعشيق. كما تذكر أن GHC لا يستنتج عموماً الأنواع الأعلى رتبة دون مساعدة من annotations، وأن الاستنتاج العام للأنظمة الأعلى رتبة undecidable، بينما تستخدم الخوارزميات العملية قيوداً وتعليقات نوعية للحصول على قرار قابل للحساب. المصدر: [GHC Arbitrary-rank polymorphism](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/rank_polymorphism.html).

## الاستنتاج المنهجي

تدعم هذه المصادر تصنيف GADT وrank-polymorphism في MAL/UORI كـ `RESEARCH` لا `PROVEN`: يلزم تحديد syntax صريح، نطاق للأنواع الوجودية والمتغيرات skolem، خوارزمية type checking bidirectional قابلة للقرار، canonical IR، وحدود موارد. لا يُسمح بالاستنتاج غير المحدود أو بتسرب النوع أو بإدخال side effects غير موثقة.

ويشير بحث Microsoft إلى أن complete type inference للأنظمة الأعلى رتبة غير قابل للقرار عموماً، وأن annotations تساعد في جعل الممارسة قابلة للاستخدام. المصدر: [Practical type inference for arbitrary-rank types](https://www.microsoft.com/en-us/research/publication/practical-type-inference-for-arbitrary-rank-types/).

كما يصف بحث ACM formalization ميكانيكياً نظاماً bidirectional للأنواع الأعلى رتبة مع نتائج soundness وcompleteness وdecidability للنظام المدروس، لكنه لا يثبت تلقائياً أن كل تصميم MAL يملك هذه الخصائص. المصدر: [A mechanical formalization of higher-ranked polymorphic type inference](https://dl.acm.org/doi/10.1145/3341716).
