# دليل دمج اختبارات الـHarnesses الجديدة في Baseline

**المشروع:** MAL/UORI
**الفرع:** `integration/utf8-v5-lookup`
**النطاق:** `test_phases.py` و`test_all_phases.py`
**المبدأ الحاكم:** `FAIL_CLOSED=ACTIVE` و`AUTO_PROMOTION=DENY`
**الحالة:** مسودة دمج للمراجعة؛ لا تمثل موافقة على `commit` أو `push` أو `merge`.

## 1. الغرض

يشرح هذا الدليل طريقة إدخال harnesses الاختبار الجديدة إلى baseline بطريقة قابلة للتدقيق. يقتصر الدمج على ملفات الاختبار نفسها وأي توثيق يعتمد عليها، ولا يشمل الملفات التنفيذية أو ملفات Assembly المولدة أو مخرجات التشغيل المؤقتة.

> لا يجوز اعتبار نجاح الاختبار تفويضاً تلقائياً لتغيير baseline. نجاح الاختبار دليل نطاقي، أما إدخاله في المستودع فهو قرار مراجعة مستقل.

## 2. الملفات المرشحة

| الملف | الوظيفة | الحالة قبل الدمج |
|---|---|---|
| `test_phases.py` | تشغيل مراحل 47–51 بالترتيب، وإرجاع `RC=1` عند الغياب أو الفشل | جديد، غير staged |
| `test_all_phases.py` | تشغيل `test_phases.py` واختبارات المحرك وcache والفهرسة المركبة | جديد، غير staged |
| `INTEGRATION_ALLOWLIST_GUIDE_AR.md` | هذا الدليل | جديد، توثيقي |
| `HARNESS_CONSTITUTIONAL_REPORT_AR.md` | تقرير النتائج والحواجز الدستورية | جديد، توثيقي |

لا تُدرج في allowlist ملفات مثل `*.o` أو binaries أو ملفات `.asm` المولدة أو قواعد عامة في `.gitignore` إلا بقرار منفصل يحدد الاسم والغرض والدليل.

## 3. قائمة allowlist المقترحة

### 3.1 ملفات مسموحة مبدئياً

- `test_phases.py`
- `test_all_phases.py`
- `INTEGRATION_ALLOWLIST_GUIDE_AR.md`
- `HARNESS_CONSTITUTIONAL_REPORT_AR.md`

### 3.2 ملفات لا تدخل تلقائياً

- `uori_lookup` و`uori_lookup_v5` وأي binary ناتج.
- ملفات `*.o` و`*.asm` التي أنشأتها الاختبارات مؤقتاً.
- محتويات `/tmp/` أو سجلات التشغيل المؤقتة.
- `uori_lookup.ar` أو `uori_lookup_v5.ar` ما لم تُراجع دلالتهما ومصدرهما canonical بصورة مستقلة.
- أي تعديل سابق في `STAGE_REGISTRY_AR.md` أو `phase50_selfhost.asm` أو `test_compound_indexing.py`؛ فهذه تغييرات منفصلة عن إضافة harnesses.

## 4. بوابات ما قبل staging

ينفذ المراجع البشري الخطوات التالية من جذر المستودع، ويوقف العملية عند أول فشل:

```bash
cd /home/ubuntu/uori-mal-pr

git status --short
git diff --check
python3 -m py_compile test_phases.py test_all_phases.py
python3 test_phases.py
python3 test_all_phases.py
```

يجب حفظ stdout وstderr وRC لكل أمر. يجب أن تكون النتيجة `RC=0`، وأن تكون مخرجات التشغيل قابلة للإعادة. أي `ABSTAIN` أو ملف مفقود أو traceback يمنع staging.

## 5. المراجعة الساكنة

يُراجع diff قبل staging للتأكد من أن harnesses:

1. لا تستخدم `eval` أو `exec` ديناميكياً.
2. لا تستخدم `os.system` أو `shell=True` أو أوامر شبكة.
3. تستخدم `subprocess.run` فقط لتشغيل ملفات اختبار ثابتة، مع `cwd` معروف و`capture_output` وtimeout.
4. تعيد `RC=1` عند الملف المفقود أو الاستثناء أو فشل الاختبار.
5. لا تستدعي نفسها ولا تنشئ recursion غير محدود.
6. لا تغير Git أو baseline أو `.gitignore`.

## 6. staging المصرح به فقط

بعد اجتياز البوابات، ينفذ المراجع staging للملفات المحددة حرفياً، وليس wildcard:

```bash
git add -- test_phases.py test_all_phases.py \
  INTEGRATION_ALLOWLIST_GUIDE_AR.md \
  HARNESS_CONSTITUTIONAL_REPORT_AR.md

git diff --cached --check
git diff --cached --stat
git diff --cached -- test_phases.py test_all_phases.py \
  INTEGRATION_ALLOWLIST_GUIDE_AR.md \
  HARNESS_CONSTITUTIONAL_REPORT_AR.md
```

إذا ظهر أي ملف غير مقصود في staged diff، يجب تنفيذ `git restore --staged -- <file>` يدوياً وإعادة الفحص. لا تستخدم `git add .` أو `git add -A` في هذا المسار.

## 7. commit وpush وmerge

هذه إجراءات لاحقة وليست جزءاً من إنشاء allowlist. يتطلب `commit` موافقة صريحة بعد مراجعة `git diff --cached`. ويتطلب `push` مراجعة حالة الفرع ونتائج CI. أما `merge` إلى `main` فيتطلب مراجعة مستقلة للـPR وحالة baseline.

```bash
# لا تُنفذ إلا بعد موافقة مستقلة:
git commit -m "test: add fail-closed MAL phase harnesses"
git push origin integration/utf8-v5-lookup
```

لا يوصى بأي merge تلقائي؛ `AUTO_PROMOTION=DENY` يعني أن نجاح الاختبارات لا يرفع التصنيف ولا يدمج الفرع وحده.

## 8. شروط الإيقاف

تتوقف العملية وتُسجل `ABSTAIN` إذا كان التقرير الأصلي مفقوداً، أو كانت أسماء الملفات غير مطابقة، أو كانت الشجرة تحتوي تغييرات غير مفهومة، أو اختلفت مخرجات Triple-Run، أو ظهر اعتماد بيئي غير مثبت مثل `wat2wasm`.

## 9. سجل الأدلة

الأدلة السابقة محفوظة في المسارات التالية:

```text
/tmp/run_test_phases_local_20260828/
/tmp/run_test_all_phases_local_20260828/
/tmp/new_phase_harnesses_20260828/
```

ينبغي نسخ البصمات إلى سجل المراجعة، لا إلى مصدر الاختبار. لا تُستبدل البصمات القديمة بصمات جديدة دون تسجيل التاريخ والنسخة والبيئة.

## 10. القرار الافتراضي

حتى اكتمال staging والمراجعة، يكون القرار:

```text
HARNESS_ALLOWLIST=PROPOSED
BASELINE_INTEGRATION=NOT_PERFORMED
COMMIT=NOT_PERFORMED
PUSH=NOT_PERFORMED
MERGE=NOT_PERFORMED
FAIL_CLOSED=ACTIVE
AUTO_PROMOTION=DENY
```

هذا الملف يصف الإجراء المطلوب ولا ينفذ أياً من أوامر Git الواردة فيه.
