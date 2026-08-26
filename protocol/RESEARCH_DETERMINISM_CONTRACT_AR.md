# عقد البحث في حتمية المترجم

## النطاق

هذا العقد يغطّي ثلاثة محاور بحثية فقط: bootstrap، وbinary diffing، وfuzzing ضد عدم الحتمية. لا يرفع أي محور إلى `PROVEN` أو `ALLOW` للنواة، ولا يعدل baseline المجمد.

## قواعد عامة

```text
BASELINE_MODIFIED=NO
ATTACHMENT_EXECUTED=NO
SOURCE_REF_EXECUTED=NO
NETWORK=DISABLED_BY_CONTRACT
NATIVE_EXECUTION=NOT_REQUIRED_FOR_FIXTURE_MODE
```

تستخدم الاختبارات fixtures ثابتة مولّدة داخل العقد، ولا تنفذ أي نص مصدر أو shell أو binary غير موثوق.

## Bootstrap

يُسمح في وضع fixture-only بمقارنة سلسلة artifacts ثابتة تمثل Stage 1 وStage 2 وStage 3. تطابق Stage 2 وStage 3 يثبت استقراراً تجريبياً داخل fixture والنطاق فقط. لا يعتبر DDC أو self-hosting مثبتاً دون compilerين مستقلين، toolchains مثبتة، وبيئتين hermetic منفصلتين.

```text
STAGE_2_SHA256 == STAGE_3_SHA256 → RESEARCH_PASS / STABILITY_ONLY
otherwise                       → ABSTAIN / BOOTSTRAP_MISMATCH
```

## Binary diffing

تُقارن ملفات ثنائية ثابتة فقط باستخدام مقارنة byte-for-byte وبصمات SHA-256. يحق لأداة التحليل وصف الاختلاف في fixture، ولا يحق لها استنتاج سلامة أو غياب backdoor. اختلاف أي byte يؤدي إلى `ABSTAIN / BINARY_MISMATCH` ما لم يكن الفرق متوقعاً ومثبتاً في policy.

لا تُفكك ملفات واردة من المرفقات ولا تُشغّل. التحليل البنيوي المستقبلي يحتاج أداة موثقة وmanifest لإصداراتها.

## Fuzzing

يقتصر fuzzing الحالي على مولد داخلي deterministic ذي seed ثابت ومجال محدود. كل case يحفظ canonical input وseed وoutput. هذا اختبار لاكتشاف عدم الحتمية، وليس برهاناً على غيابها.

```text
same_seed + same_fixture + different_runs → identical output required
mismatch → ABSTAIN / NONDETERMINISTIC
```

لا يُسمح بتشغيل fuzzing عشوائي غير محدود أو corpus خارجي غير مثبت.

## شروط النجاح

يجب حفظ: العقد، fixtures، manifest، stdout الخام، بصمة stdout، وسلسلة تحقق. يجب أن تكون النتيجة قابلة للإعادة ثلاث مرات داخل البيئة نفسها. أي اختلاف في المخرجات أو فشل بصمة أو غياب ملف يؤدي إلى `ABSTAIN`.

## حدود الادعاء

```text
FIXTURE_STABILITY       = RESEARCH_PASS
BOOTSTRAP_PROOF         = NOT_ESTABLISHED
BINARY_SECURITY         = NOT_ESTABLISHED
ABSENCE_OF_BACKDOOR     = NOT_ESTABLISHED
FUZZING_COMPLETENESS    = NOT_ESTABLISHED
```

## الحوكمة

يُحفظ هذا العقد في فرع بحثي مستقل. لا يتم الدمج في الفرع الرئيسي تلقائياً، ولا يُسمح بتعديل baseline أو تنفيذ محتوى المرفق ضمن هذا المسار.
