# التقرير النهائي — إغلاق فجوة مدقق MAL-DIR

**التاريخ:** 2026-08-25

## النتيجة التنفيذية

تم تنفيذ أصغر امتداد آمن لازم لتشغيل مدقق MAL-DIR بالعربية الرياضية باستخدام **ساحة ثابتة ممثلة بقائمة وفهارس صحيحة**. لم تُضف مؤشرات خام، ولا سجلات runtime جديدة، ولا تخصيص يدوي، ولا تنفيذ للمصدر أو الشبكة. بقيت Grammar v0.1 وMAL-DIR v0.1 دون تغيير في الإصدار.

## ما نُفّذ

| العنصر | الحالة |
|---|---|
| عقد الساحة المسطحة | أُضيف في `protocol/MAL_FLAT_INDEX_ARENA_CONTRACT_v0.1_AR.md` |
| المدقق العربي | أُعيدت كتابته في `extensions/mal_dir_validator.ar` باستعمال قائمة ثابتة وفهارس bounds-checked |
| المقارنة الثنائية | أُضيف `scripts/mal_dir_validator_differential.py` |
| اختبارات موجبة | 6 حالات MAL-DIR محكومة |
| اختبارات سالبة | حالتان اصطناعيتان للرأس والإصدار والجذر |
| النتيجة المقارنة | `CASES=8`, `MATCHES=8`, `FAILURES=0` |
| التجميع والتنفيذ | `COMPILE_RC=0`, `RUN_RC=0`، والخرج `MAL-DIR / VALID` |
| سياسة الترفيع | `AUTO_PROMOTION=DENY`؛ لم يحدث أي ترفيع تلقائي |
| إصلاح CI | تنظيف `evidence/cross-env` قبل التشغيل، ورفع الأدلة فقط بعد النجاح |
| احتفاظ الأدلة | `retention-days: 7` في مواضع رفع الأدلة |

## القرار الحاكم

تثبت الأدلة الحالية تكافؤًا دلاليًا على corpus المحدد، لا اكتمال المدقق العام لكل تمثيلات MAL-DIR الممكنة. لذلك يصنف الامتداد **RESEARCH / IMPLEMENTED-PROTOTYPE**، ولا يصح إعلان `PROVEN` أو `AUTO_PROMOTION=ALLOW` قبل إضافة اختبارات مستقلة للتغطية الكاملة، وإثبات تكرار ثلاثي byte-for-byte، ومراجعة قبول منفصلة.

> نجاح التجميع والتنفيذ لا يساوي وحده تكافؤًا عامًا؛ البوابة بقيت مغلقة عمدًا وفق مبدأ الامتناع الآمن.

## بصمات الأدلة

| الملف | SHA-256 |
|---|---|
| `evidence/MAL_DIR_VALIDATOR_DIFFERENTIAL.json` | `e0f0cfcc3175071a67d7684bdb4e448703bfdf1a9459d48420b40e34d5a99fe7` |
| `evidence/FINAL_MAL_DIFFERENTIAL.stdout` | `364aa6580e2ff35dec6d94f4f14b8896995f6c7ee0ceec1fd979bfc9f90428a0` |
| `evidence/FINAL_MAL_AR_RUN.stdout` | `1ba94ea3bd760749189fe3cb288bc6f4db8951e3699575c0175be39e43393ff8` |
| `evidence/mal-flat-index-arena-2026-08-25.tar.gz` | `6b87a721f2ab192a67691e1088e6617af646ce25c0cd759f3088d21feb372e89` |

## حالة المستودع

لم يُنشأ commit ولم تُنفذ عملية دمج أو تغيير تلقائي في baseline. التغييرات الحالية محلية ومحصورة في عقد الامتداد، المصدر العربي، أداة المقارنة، وفقرات workflow الخاصة بتنظيف الأدلة واحتفاظها. الملفات التنفيذية وملفات الأسمبلي المؤقتة أزيلت من شجرة العمل بعد التحقق.

## النواقص المتبقية

لا يزال المدقق العربي الحالي يثبت رأس MAL-DIR فقط، بينما يستمر فحص العقد الداخلية التفصيلي في Python. كما أن أداة المقارنة تولد fixtures عربية موثوقة من payloads مشتركة؛ وهذا يثبت المسار التنفيذي، لكنه ليس بعدُ استبدالًا كاملاً لمدقق Python العام. يلزم لاحقًا توسيع عقد الساحة لتمثيل عقد node arrays نفسها، ثم تكرار المقارنة على حالات فساد مرجعية مستقلة، مع إبقاء الترفيع مغلقًا حتى اكتمال الأدلة.

## الملفات المرجعية

`protocol/MAL_DIR_SPEC_v0.1_AR.md`، `protocol/MAL_FLAT_INDEX_ARENA_CONTRACT_v0.1_AR.md`، `extensions/mal_dir_validator.ar`، `extensions/mal_dir_validator.py`، `scripts/mal_dir_validator_differential.py`، `.github/workflows/mal-deterministic-audit.yml`، و`evidence/mal-flat-index-arena-2026-08-25.tar.gz`.
