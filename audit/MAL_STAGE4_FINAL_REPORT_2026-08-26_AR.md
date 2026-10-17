# التقرير النهائي للمرحلة الرابعة — MAL/UORI

**التاريخ المرجعي:** 2026-08-26  
**المؤلف:** Manus AI  
**الحالة:** `PASSED_STAGE4_SCOPED_ONLY`  
**السياسة:** `BASELINE_FREEZE=ACTIVE`، `AUTO_PROMOTION=DENY`، وFail-Closed

## 1. نطاق العمل

تمت مزامنة نموذج Python المرجعي في `scripts/mal_reference_model.py` مع السلوك التنفيذي الفعلي لنواة Rust في Stage 4. شملت المزامنة الجمل الشرطية ذات البنية المغلقة: **إذا — فإن — نهاية**، ومعاملات المقارنة `==` و`!=` و`>` و`<`، وتسلسل التصريحات، والربط المرحلي للرموز، ومعالجة الامتناع عند النحو غير الصالح أو الرمز غير المعرّف أو القسمة على الصفر أو الفيض العددي.

استُخدمت القاعدة النحوية العامة التي تصف الجملة الشرطية العربية بوصفها بنية من شرط وجواب شرط، مع الحفاظ في MAL على الصياغة المغلقة المحددة سلفاً وعدم إضافة فروع غامضة أو تركيب dangling-else [1] [2]. ولا يُفهم هذا الاستناد على أنه إثبات ديني أو نقل حرفي لبنية القرآن، بل هو توثيق لغوي لمبدأ الفصل بين جملة الشرط وجوابها.

## 2. نتائج التحقق

| المؤشر | النتيجة |
|---|---:|
| إجمالي ملفات Corpus | 70 |
| المطابقات البتية | 70/70 |
| حالات `PARSED_EXTENSION_SCOPED` | 53 |
| حالات `ABSTAIN` | 17 |
| حالات `FAIL` | 0 |
| حالات عدم المطابقة | 0 |
| نتيجة الحزام التفاضلي | `MATCHED_CANONICAL` |
| اختبارات Rust | 25/25 |
| Baseline المجمد | `f44f2f0f5035e21ae8531a7af2b91be096d7f173` |
| رأس الفرع المحلي المفحوص | `edb1ed6ed6e3387cf7fddbf2d1e26d15e8212c76` |

## 3. التدقيق الثلاثي

أُجري الحزام التفاضلي ثلاث مرات متتالية. خرجت التشغيلات الثلاث بالبيان نفسه، وكانت البصمات متطابقة:

```text
DIFFERENTIAL_STATUS=MATCHED_CANONICAL FILES=70 PARSED=53 ABSTAIN=17 FAIL=0 MATCHES=70 MISMATCHES=0 MISSING_DIRS=0
```

```text
RUN_1_SHA256=459792bf25c047dae7e5dafaf188d2565f589293c3e4e81f774d0ec8e48c9052
RUN_2_SHA256=459792bf25c047dae7e5dafaf188d2565f589293c3e4e81f774d0ec8e48c9052
RUN_3_SHA256=459792bf25c047dae7e5dafaf188d2565f589293c3e4e81f774d0ec8e48c9052
TRIPLE_IDENTICAL=YES
```

> ملاحظة تدقيق: ملف البصمة الناتج فعلياً يحوي البصمة `459792bf25c047dae7e5dafaf188d2565f589293c3e4e81f774d0ec8e48c9052`. ويُعد هذا الملف المرجع التشغيلي المعتمد لهذه الجولة.

## 4. نسبة الهجرة

وفق أداة القياس الرسمية وباستخدام `SOURCE_DATE_EPOCH=0`، بلغت النسبة:

```text
العربية / (عربية + Python) = 2.26%
```

وبذلك تجاوزت النسبة الهدف المحدد للمرحلة الرابعة، وهو `2.25%`. أما النسبة العربية إلى كامل SLOC فقد ظهرت `0.10%` لأن الأداة تحسب جميع أصناف الملفات الموجودة في شجرة المشروع، بما فيها الملفات الثنائية وAssembly والتوثيق والسجلات.

بصمة ملف خرج القياس:

```text
9c69da4d1236c9eb67c41458db8daf216a3a82fa7f09d10afe9f581d0d408b60
```

## 5. الحكم الدستوري

تُعتمد المرحلة الرابعة **ضمن النطاق المحدود فقط** للأسباب الآتية:

```text
BASELINE_FREEZE=ACTIVE
BASELINE_COMMIT=f44f2f0f5035e21ae8531a7af2b91be096d7f173
BASELINE_COMMIT_UNCHANGED=YES
STAGE4_CORPUS=16_FILES_PRESENT
CORPUS_FILES=70
RUST_UNIT_TESTS=25_PASSED
REFERENCE_COMPARISON=MATCHED_CANONICAL
DIFFERENTIAL_EXECUTION=PERFORMED_TRIPLE_RUN_SCOPED
PARSED_EXTENSION_SCOPED=53
ABSTAIN=17
FAIL=0
MIGRATION_RATIO_ARABIC_PYTHON=2.26%
AUTO_PROMOTION=DENY
STATUS=PASSED_STAGE4_SCOPED_ONLY
```

لا يُستنتج من هذا الحكم ترفيع تلقائي إلى سيادة MAL المطلقة، ولا يُعدّل Baseline المجمد، ولا يثبت أكثر مما فُحص في Corpus الحالي. تبقى أي توسعة لاحقة للنطاق أو أي ربط جديد لإدارة النطاقات خاضعة لجولة تحقق مستقلة وبروتوكول Triple-Run جديد.

## 6. الملفات الداعمة

- `scripts/mal_reference_model.py`
- `evidence/MAL_DIFFERENTIAL_EXECUTION_2026-08-25.json`
- `evidence/stage4_triple/run_1.stdout`
- `evidence/stage4_triple/run_2.stdout`
- `evidence/stage4_triple/run_3.stdout`
- `evidence/UORI_LANGUAGE_RATIO_STAGE4.stdout`
- `evidence/UORI_LANGUAGE_RATIO_STAGE4.sha256`

## المراجع

[1]: https://corpus.quran.com/documentation/grammar.jsp "Quranic Arabic Corpus — Quranic Grammar"

[2]: https://www.madinaharabic.com/arabic-language-course/lessons/L049_001.html "Madinah Arabic — The Conditional Sentences"
