# تقرير التحقق — MAL-DIR v0.2 والآليات 137–142

## الحالة التنفيذية

تم توسيع مدقق MAL-DIR من تمثيل رأس الدليل إلى ساحة عقد مسطحة أحادية البعد. يتكون كل سجل عقدة من خمسة مواضع ثابتة: `id`, `kind`, `children_start`, `children_count`, و`flags`. لا تستخدم المرحلة مؤشرات خامًا، ولا تخصيصًا ديناميكيًا، ولا تنفيذًا لمراجع المصدر.

أُصلح خطأ حدي في حساب نهاية ساحة الأبناء. كانت الصيغة القديمة ترفض الحالة التي ينتهي فيها آخر نطاق عند آخر عنصر صحيح؛ وأصبحت الصيغة تقبل النهاية الشاملة الصحيحة مع بقاء الفهرس خارج المجال مرفوضًا.

## دليل التنفيذ المزدوج

```text
MAL_DIR_DIFFERENTIAL_V02=PASS
CASES=11
MATCHES=11
FAILURES=0
SOURCE_EXECUTION=PERFORMED_ON_GENERATED_TRUSTED_FIXTURES
AUTO_PROMOTION=DENY
```

تشمل الحالات ست حمولات موجبة وخمس حالات سلبية حتمية. تحقق المدقق العربي من القرار نفسه الذي أعاده النظير Python في جميع الحالات. كما جرى تجميع وتشغيل `extensions/mal_dir_validator.ar` بنجاح:

```text
COMPILE_RC=0
RUN_RC=0
MAL-DIR
VALID
```

## بوابة CI

نجح الفحص المحلي لملف workflow، وبقي عدد إعدادات الاحتفاظ سبعة أيام. أُصلحت بوابة CI لتتوقع اسم نجاح v0.2 الصحيح، وأضيفت عقود v0.2 وسجل وcorpus الآليات 137–142 إلى حزمة الأدلة. بقيت سياسة `AUTO_PROMOTION=DENY` و`BASELINE_MUTATION=NOT_PERFORMED` دون تغيير.

```text
WORKFLOW_YAML=PASS
RETENTION_DECLARATIONS=7
BASELINE_MUTATION=NOT_PERFORMED
```

## تصنيف الآليات 137–142

| الآلية | القرار | الحد الحاكم |
|---:|---|---|
| 137 | `RESEARCH` | تحتاج جدول رموز ثابتًا وتسمية عربية canonical قبل `nameof` حتمي. |
| 138 | `ABSTAIN_UNTIL_EVIDENCE` | تتطلب فصلًا مثبتًا بين التقييم الساكن والتنفيذ دون ازدواج دلالي. |
| 139 | `RESEARCH` | تحتاج خطأً ساكنًا canonical ومنع إنتاج artifact عند الفشل. |
| 140 | `ABSTAIN_UNTIL_EVIDENCE` | تخطيط ABI يتطلب target وendianness ومحاذاة مثبتة وحدود FFI صريحة. |
| 141 | `RESEARCH` | يمكن بحث فرع ساكن محدود بالثوابت، مع منع تسرب الفرع غير المختار إلى runtime. |
| 142 | `RESEARCH` | يتطلب عقد عروض صحيحة ثابتة للفيض والقسمة على صفر ونتيجة فشل منظمة. |

لم تُقبل أي ميزة runtime من الدفعة؛ `runtime_features_admitted=0`، ولم يُعدّل Grammar أو baseline النواة العامة.

## الحالة الحاكمة التالية

```text
MAL_DIR_V0_2=RESEARCH_IMPLEMENTED_PROTOTYPE
NODE_ARENA_CONTRACT=RESEARCH
DUAL_EXECUTION=REQUIRED
RAW_POINTERS=DENY
SOURCE_REF_EXECUTION=DENY
AUTO_PROMOTION=DENY
BASELINE_KERNEL=UNCHANGED
```

النتيجة تثبت امتدادًا عربيًا قابلًا للتكرار على corpus المحدد، ولا تدّعي التكافؤ العام لكل برامج MAL-DIR الممكنة. تبقى الآليات 137–142 في `RESEARCH` أو `ABSTAIN_UNTIL_EVIDENCE` حتى إنشاء corpus وأدلة مستقلة لكل عقد.
