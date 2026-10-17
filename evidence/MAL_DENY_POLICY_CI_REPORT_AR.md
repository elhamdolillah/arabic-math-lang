# تقرير سياسة المنع ودمجها في CI/CD

## الحالة

- `MAL_DENY_POLICY_CI=PASS`
- الحقول المحظورة المختبرة: 8
- تغيير bytes السياسة: `ABSTAIN / POLICY_MISMATCH`
- التنفيذ: `NOT_PERFORMED`
- تنفيذ المصدر: `NO`
- الشبكة: `DISABLED_BY_CONTRACT`

## العقد

تمنع البوابة وجود أي من الحقول `source_ref` و`eval` و`exec` و`shell_command` و`callable` و`callback` و`executable_path` و`network_url_for_execution`. وجود أحدها ينتج `DENY / FORBIDDEN_CONSTRUCT` قبل فحص الإصدار أو البصمة. هذا ترتيب fail-closed، لأن الحقل المحظور لا يصبح مقبولاً بسبب hash صحيح.

إذا تطابقت البصمة والإصدار، تكون النتيجة `ALLOW / POLICY_MATCH` بمعنى قبول ساكن فقط. إذا تغيّرت bytes السياسة أو الإصدار، تكون النتيجة `ABSTAIN / POLICY_MISMATCH`؛ ولا يسمح comparator بتحويل عدم التطابق إلى `ALLOW`.

## تأثير CI

يشغّل `scripts/run_mal_deterministic_ci.sh` اختبار DENY مرتين ويقارن stdout حرفياً. يفشل job عند عدم منع أي حقل، أو عند عدم اكتشاف policy mutation، أو عند ظهور تنفيذ للمصدر. كما يستمر في تشغيل Grammar comparator وMAL-DIR validator، ويتحقق من `TOTAL_NODES=58` والبصمات المسجلة.

يُرفع هذا التقرير وstdout والبصمات كـartifact في GitHub Actions. ويجب ضبط job كـrequired status check قبل الدمج. لا يعني `ALLOW` تشغيل أي مصدر؛ لا توجد في هذا المسار مرحلة تنفيذ.

## الدليل المحلي

نجح التشغيل المحلي بعد دمج الاختبار في runner، وسُجلت التغييرات في فرع adoption المستقل. لا يثبت هذا التقرير تشغيل GitHub Actions عن بُعد ما لم يتم دفع الفرع إلى remote وتشغيل workflow فعلياً.
