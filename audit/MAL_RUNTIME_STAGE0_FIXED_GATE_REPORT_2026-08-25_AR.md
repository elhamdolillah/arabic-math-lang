# تقرير إغلاق بوابة المرحلة صفر — FixedArena وNodeID

**التاريخ:** 2026-08-25  
**النطاق:** إضافة واجهة `NodeID(u32)` و`FixedArena<T, N>` واختبار حدود 10,000 عقدة  
**حالة baseline:** مجمدة؛ لم يُستبدل المسار القديم ولم تُحذف واجهاته

## النتيجة

أضيفت طبقة ثابتة السعة باسم `FixedArena` إلى الصندوق `mal_ownership_arena`، مع معرّف مسطح `NodeID(pub u32)`، ومن دون استخدام `Vec` داخل هذه الطبقة. أضيفت ثلاثة اختبارات تكاملية، من بينها تخصيص 10,000 عقدة متتالية والتحقق من أن التخصيص رقم 10,001 يعيد `CapacityExceeded` دون panic.

شُغّلت الاختبارات بوضع release، وكانت النتيجة:

```text
اختبارات الوحدة: 5 ناجحة
اختبارات FixedArena التكاملية: 3 ناجحة
الاختبارات الفاشلة: 0
STATUS=0
```

## الأدلة

```text
evidence/MAL_RUNTIME_STAGE0_CARGO_TEST_FIXED.stdout
evidence/MAL_RUNTIME_STAGE0_CARGO_TEST_FIXED.sha256
```

## التغييرات

| العنصر | الحالة |
|---|---|
| `NodeID(u32)` | مضاف ومصدّر من الصندوق |
| `FixedArena<T, N>` | مضافة بسعة ثابتة ومصفوفة `Option<T>` |
| تجاوز السعة | يعيد `FixedArenaError::CapacityExceeded` |
| الفهرس غير الصحيح | يعيد `FixedArenaError::InvalidIndex` |
| اختبار 10,000 عقدة | ناجح |
| استخدام `Vec` في FixedArena | غير موجود |
| `Arena` القديمة | باقية دون تغيير للحفاظ على التوافق |
| parser/interpreter لملفات `.ar` | غير موجود في هذه المرحلة |

## الحكم الدستوري الدقيق

تُغلق بوابة **طبقة FixedArena المحلية** بنجاح، لا بوابة المشغل الكامل. بقاء `Arena` القديمة التي تستخدم `Vec` يعني أن شرط منع التخصيص لا يمكن نسبته إلى الصندوق كله؛ إنما يثبت فقط للطبقة الجديدة وفق نطاقها. كما أن هذه النتيجة لا تثبت قراءة أو تحليل أو تنفيذ أي ملف `.ar`.

لذلك تكون الحالة المعتمدة:

```text
STAGE0_FIXED_ARENA=PASSED
STAGE0_10K_CORPUS=PASSED
STAGE0_FULL_ARENA_GATE=ABSTAIN_UNTIL_MIGRATION
MAL_AR_RUNTIME=UNAVAILABLE
SOURCE_EXECUTION=NOT_PERFORMED
AUTO_PROMOTION=DENY
BASELINE_FREEZE=ACTIVE
BASELINE_MODIFIED=NO
```

لا يجوز تحويل `MAL_AR_RUNTIME` إلى `AVAILABLE_FOR_PARSER` استنادًا إلى هذه الاختبارات وحدها؛ فهذا يتطلب parser/interpreter حقيقيًا وCorpus ملفات `.ar` ومخرجات canonical واختبارًا تفاضليًا.

## الالتزام التالي

بعد مراجعة هذا التقرير، يمكن بدء تصميم Lexer حتمي يستخدم `FixedArena`، مع إبقاء Python مرجعًا للمقارنة فقط. يجب أن يظل الانتقال إلى Parser مشروطًا بإثبات المخرجات الخام والبصمات وإرجاع `ABSTAIN` لكل حالة غير معرفة.

## المراجع

[1]: `../rust/mal_ownership_arena/src/lib.rs` — تعريف `NodeID` و`FixedArena`.
[2]: `../rust/mal_ownership_arena/tests/stage0_fixed_arena.rs` — اختبارات المرحلة صفر.
[3]: `../evidence/MAL_RUNTIME_STAGE0_CARGO_TEST_FIXED.stdout` — سجل الاختبار الخام.
[4]: `../evidence/MAL_RUNTIME_STAGE0_CARGO_TEST_FIXED.sha256` — بصمة سجل الاختبار.
[5]: `MAL_RUNTIME_STAGE0_GATE_REPORT_2026-08-25_AR.md` — تقرير الفجوة السابقة.
