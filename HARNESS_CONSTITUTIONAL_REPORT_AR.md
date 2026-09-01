# تقرير نتائج Harnesses والتوافق الدستوري

**المشروع:** MAL/UORI
**الفرع:** `integration/utf8-v5-lookup`
**تاريخ التقرير:** 2026-08-28
**المبدأ:** `FAIL_CLOSED=ACTIVE` و`AUTO_PROMOTION=DENY`
**نوع التقرير:** تقرير تحقق نطاقي؛ لا يعلن `GLOBAL_PROJECT_FULL_GREEN`.

## 1. الملخص التنفيذي

أُنشئ `test_phases.py` لتشغيل اختبارات المراحل 47 إلى 51 بالترتيب، وأُنشئ `test_all_phases.py` لتوسيع التغطية إلى المحرك وذاكرة runtime والفهرسة المركبة وself-hosting. شُغّل كل harness ثلاث مرات محلياً. أعادت التشغيلات `RC=0`، وكانت stdout وstderr حتمية داخل كل harness.

النتيجة تثبت نجاح النطاق المختبر، لكنها لا تثبت سلامة كل ملفات المستودع ولا تكافؤ النسخة القديمة مع `uori_lookup_v5.ar`. كما أن نجاح harness لا يؤدي إلى commit أو push أو merge تلقائياً.

## 2. الاختبارات والنتائج

| المجموعة | التغطية | النتيجة |
|---|---|---|
| `test_phase47.py` | Event loop والتوافق المرتبط بالمرحلة 47 | `9/9 PASS`، و`RC=0` في كل تشغيل |
| `test_phase48.py` | Macros | `10/10 PASS`، و`RC=0` في كل تشغيل |
| `test_phase49.py` | Dependent Types | `10/10 PASS`، و`RC=0` في كل تشغيل |
| `test_phase50.py` | Self-hosting compatibility | `8/8 PASS`، و`RC=0` في كل تشغيل |
| `test_phase51_wasm.py` | WAT→WASM وتشغيل WASM حقيقي | `22/22 PASS`، و`RC=0` في كل تشغيل |
| `test_engine_uas.py` | ABI وتجميع NASM/LD واختبار الأس | `9/9 PASS`، و`RC=0` في كل تشغيل |
| `test_runtime_cache_fingerprint.py` | كشف mutation بنفس الحجم | `STATUS=PASS`، و`RC=0` في كل تشغيل |
| `test_compound_indexing.py` | الفهرسة المركبة وself-hosting | `9/9 PASS`، و`RC=0` في كل تشغيل |
| `test_phases.py` | جامع المراحل 47–51 | `STATUS=PASS`، و`RC=0` في كل تشغيل |
| `test_all_phases.py` | جامع التكامل الموسع | `STATUS=PASS`، و`RC=0` في كل تشغيل |

## 3. تفاصيل self-hosting والفهرسة

أثبت اختبار الفهرسة المركبة نجاح الفهرسة الأساسية، الفهرس التعبيري، حدود القوائم، الفهرسة المركبة، الفهرس الناتج عن دالة، الفهرس السالب، القائمة الفارغة، السلسلة المتداخلة، والفهرسة داخل الطابق. كما نجح harness self-hosting المرتبط:

```text
t_fact: PASS
t_block: PASS
t_read_echo: مرحبا
t_read_size: 5
math_aot_selfhost: RC=0
```

هذه النتائج تثبت النطاق التنفيذي الحالي، ولا تلغي الحاجة إلى مراجعة دلالات byte length مقابل code-point length في أي واجهة جديدة.

## 4. تفاصيل WASM

نجح تحويل WAT إلى WASM وتشغيل برنامج حقيقي بناتج `8`. كما نجحت اختبارات الثوابت، الجمع، القسمة، المقارنة، if/else، locals، memory load/store، helpers، imports/exports، وحالات النص والمطلق والجذر.

```text
WASM_PHASE51=PROVEN_FOR_PHASE51_TEST_MATRIX
WAT2WASM_VERSION=1.0.34
WASM_TRIPLE_RUN=PASS
```

الاعتماد البيئي على `wat2wasm` جزء من شروط إعادة الإنتاج؛ غيابه يجب أن ينتج `ABSTAIN` أو `RC=1`، لا تجاوز الاختبار.

## 5. تفاصيل lookup الحديث

شُغّلت `uori_lookup_v5.ar` ثلاثياً بعد عزل runtime المطلوب. كانت مخرجات التشغيل ثابتة:

```text
4
7
0
-1
2
```

وكانت حالات المقارنة:

```text
compile: RC=0,0,0
runtime: RC=0,0,0
stdout comparisons: equal/equal
```

هذا يثبت حتمية النسخة الحديثة ضمن حالات اختبارها. لا يثبت التكافؤ الدلالي مع `uori_lookup.ar` القديمة، لأن النسختين تستخدمان واجهات ومجموعات نتائج مختلفة.

## 6. Triple-Run والأدلة

شُغّل كل harness ثلاث مرات. النتائج:

| العنصر | التشغيلات | الحتمية |
|---|---|---|
| `test_phases.py` RC | `0,0,0` | PASS |
| `test_all_phases.py` RC | `0,0,0` | PASS |
| stdout لكل harness | ثلاث نسخ متطابقة | PASS |
| stderr لكل harness | فارغة ومتطابقة | PASS |
| `git diff --check` | `RC=0` | PASS |

الأدلة الخام محفوظة في:

```text
/tmp/run_test_phases_local_20260828/
/tmp/run_test_all_phases_local_20260828/
/tmp/new_phase_harnesses_20260828/
/tmp/modern_lookup_integration_20260828/
```

## 7. المراجعة الدستورية

| القيد | نتيجة المراجعة |
|---|---|
| `FAIL_CLOSED` عند ملف مفقود | مطبق؛ الملف المفقود يؤدي إلى failure و`RC=1` |
| `RC=1` عند فشل اختبار فرعي | مطبق |
| منع recursion بين الـharnesses | مطبق تصميمياً |
| منع `eval` و`exec` الديناميكي | لا توجد استدعاءات تنفيذ نصي ديناميكي |
| منع shell/network داخل harness | لا توجد `os.system` أو `shell=True` أو أدوات شبكة |
| ضبط `cwd` وtimeout | مطبق لكل subprocess |
| تغيير Git أو baseline | غير موجود في harnesses |
| كتابة artifacts في المصدر | لا ينشئ harness نفسه staging أو commit؛ الاختبارات الفرعية قد تولد artifacts مؤقتة |
| AUTO promotion | غير موجود؛ `AUTO_PROMOTION=DENY` |

استخدام `subprocess.run` مقيد بتشغيل ملفات Python الاختبارية الثابتة، مع arguments منفصلة و`cwd` ثابت وtimeout. لا يُعد ذلك تنفيذ shell أو تفسيراً لمحتوى المرفق.

## 8. الحدود والامتناعات

لا يُعلن `GLOBAL_PROJECT_FULL_GREEN` للأسباب التالية:

1. الحكم مثبت في نطاق harnesses المختبرة، وليس في كل ملفات أو كل مراحل المستودع.
2. working tree تحتوي تغييرات وملفات غير متتبعة من أعمال سابقة.
3. نجاح الاختبارات لا يثبت تلقائياً allowlist أو صلاحية إدخال artifacts المولدة.
4. `uori_lookup_v5.ar` حتمية ضمن مصفوفة الاختبار، لكن التكافؤ مع النسخة القديمة غير مثبت.
5. أي فحص شامل للـAssembly يحتاج مراجعة ABI وحدود الذاكرة، وليس فقط token scan.

## 9. الحكم النهائي

```text
TEST_PHASES=PROVEN_FOR_SCOPE
TEST_ALL_PHASES=PROVEN_FOR_SCOPE
MODERN_LOOKUP_TRIPLE_RUN=PASS_FOR_SCOPE
WASM_PHASE51=PROVEN_FOR_PHASE51_TEST_MATRIX
CONSTITUTIONAL_REVIEW=PASS_WITH_GUARDS
GLOBAL_PROJECT_FULL_GREEN=NOT_CLAIMED
FAIL_CLOSED=ACTIVE
AUTO_PROMOTION=DENY
COMMIT=NOT_PERFORMED
PUSH=NOT_PERFORMED
MERGE=NOT_PERFORMED
```

## 10. مراجع الأدلة المحلية

| المرجع | المسار |
|---|---|
| نتائج `test_phases.py` | `/tmp/run_test_phases_local_20260828/` |
| نتائج `test_all_phases.py` | `/tmp/run_test_all_phases_local_20260828/` |
| Triple-Run للـharnesses | `/tmp/new_phase_harnesses_20260828/` |
| Triple-Run للـlookup الحديث | `/tmp/modern_lookup_integration_20260828/` |
| diff والحاجز الساكن | `/tmp/new_harness_diff_audit_20260828/` |

هذا التقرير توثيقي فقط. لا يحتوي على أوامر Git تنفيذية ولا يمنح تفويضاً للدمج.
