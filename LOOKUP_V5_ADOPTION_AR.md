# patch اعتماد `uori_lookup_v5.ar` كمصدر canonical

**الحالة:** patch مراجعة مستقل
**الفرع:** `adoption/uori-lookup-v5-constitutional`
**السياسة:** `FAIL_CLOSED=ACTIVE`، `AUTO_PROMOTION=DENY`

## الغرض

يضيف هذا patch المسار الرسمي `uori_lookup.ar` بوصفه نسخة canonical مطابقة بايتياً لـ`uori_lookup_v5.ar`. لا يحذف patch مصدر v5، ولا يستبدل ملفاً قديماً بصمت، ولا ينشئ tag أو ينفذ push.

## التغيير المحدود

| التغيير | الغرض |
|---|---|
| إضافة `uori_lookup.ar` | تثبيت الاسم canonical صراحةً؛ الملف مطابق تماماً لـv5 |
| الإبقاء على `uori_lookup_v5.ar` | حفظ provenance واسم الإصدار المرشح |
| إضافة `test_lookup_v5_adoption.py` | بوابة حتمية للمقارنة والبناء والتشغيل الثلاثي |
| إضافة هذا المستند | توثيق العقد وحدود الحكم |

## شروط البوابة

يفشل الاختبار برمز خروج `1` إذا غاب أي من compiler أو lexicon أو runtime أو المصدرين، أو إذا اختلفت بصمة canonical عن v5، أو فشل التجميع، أو فشل التنفيذ، أو اختلف خرج Triple-Run.

المصفوفة الحالية هي مصفوفة v5 الموجودة في المصدر، وخرجها المتوقع:

```text
4
7
0
-1
2
```

هذا يثبت **مطابقة canonical للمرشح ضمن مصفوفة الاختبار الحالية**، ولا يثبت سلامة كل مدخلات MAL ولا اكتمال kernel ولا صحة ملفات Wasmi المفقودة.

## قرار الاعتماد

بعد اجتياز `test_lookup_v5_adoption.py` و`git diff --check` وحفظ SHA-256، يكون الحكم:

```text
CANONICAL_LOOKUP_V5=PROVEN_FOR_TEST_MATRIX
LEGACY_LOOKUP=NOT_REPLACED_SILENTLY
KERNEL_COMPLETENESS=OUT_OF_SCOPE
WASMI_SOURCES=ABSTAIN_IF_MISSING
AUTO_PROMOTION=DENY
FAIL_CLOSED=ACTIVE
```

ولا يجوز ترقية الحكم إلى اعتماد شامل أو إصدار مستقر إلا عبر مراجعة مستقلة للـdiff، وتثبيت manifest في سلسلة الأدلة، ومراجعة فجوات kernel/Wasmi.

## التراجع

التراجع قابل للعكس بحذف commit الخاص بهذا patch من فرع الاعتماد أو بإعادة الفرع إلى commit ما قبل patch. لا توجد عمليات destructive على `main` ضمن هذا الإجراء.
