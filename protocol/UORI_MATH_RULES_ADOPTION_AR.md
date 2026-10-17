# قواعد رياضية قابلة للإثبات — سياسة دمج UORI

## الحالة

هذه وثيقة امتداد مستقلة فوق wheel اللغة العربية الرياضية. لا تعدل الـwheel المجمد ولا الوسم `uori-wave77-freeze-2026-08-24`.

## المبدأ الحاكم

لا تُدمج القاعدة الرياضية في Tier-0 لمجرد أنها مفيدة أو شائعة. تُقبل فقط إذا كان تمثيلها، وترتيب عملياتها، وحدود خطئها، وحالات فشلها قابلة للتحديد وإعادة الإنتاج. عند غياب شرط أو شهادة، تكون النتيجة `ABSTAIN`.

## القواعد التي يمكن دمجها الآن

| القاعدة | صياغة التنفيذ | الحالة |
|---|---|---|
| الحساب الصحيح | أعداد صحيحة أو كسور نسبية، مع رفض القسمة على صفر | قابل للتنفيذ |
| الحساب الثابت | Q-format بعرض معلن وتشبع/رفض overflow معلن | قابل للتنفيذ جزئياً؛ يحتاج kernel ABI |
| الحساب بالفواصل | كل قيمة تمثل مجالاً `[lower, upper]`، والعمليات توسع المجال محافظاً | قابل للتنفيذ كامتداد Python حتمي |
| شروط الشكل | أطوال المتجهات وأبعاد المصفوفات يجب أن تتطابق قبل العملية | قابل للتنفيذ |
| التجميع الحتمي | شجرة جمع وترتيب ثابتان؛ لا تعتمد النتيجة على ترتيب العمال | منفذ جزئياً |
| التقارب | لا تقبل نتيجة تقريبية دون معيار توقف وحد خطأ أو حد أقصى للوقود | قابل للتنفيذ كحاجز |
| الاحتمال التجريبي | نتيجة حتمية فقط عند تثبيت العينة والبذرة والمقدر؛ لا تعني حقيقة احتمالية | مشروط |

## القواعد التي تبقى مشروطة أو ممتنعة

العمليات العائمة العامة، التفاضل العددي بلا حد خطأ، التكامل بلا مجال أو قاعدة تقارب، حل المعادلات غير المستقر، والتنبؤ من سلسلة noisy بلا تحقق خارج العينة، لا تدخل Tier-0 تلقائياً. كما لا يجوز اعتبار WASM وحده دليلاً على السرعة أو الحتمية الكاملة.

## عقد الفواصل

إذا كان `x ∈ [a,b]` و`y ∈ [c,d]`، فالتنفيذ المحافظ يستخدم:

```text
x + y = [a+c, b+d]
x - y = [a-d, b-c]
x × y = [min(ac,ad,bc,bd), max(ac,ad,bc,bd)]
```

والقسمة تُرفض إذا احتوى المجال المقسوم عليه على الصفر. لا يجوز إسقاط حدود المجال لإنتاج رقم واحد.

## عقد الشكل

قبل عملية متجهية أو مصفوفية، يجب تثبيت الشكل. إذا اختلفت الأطوال أو الأبعاد، فالنتيجة:

```text
ABSTAIN / SHAPE_MISMATCH
```

ولا يسمح بالتوسيع الضمني أو broadcasting غير المعلن.

## عقد التقارب

كل خوارزمية تقريبية يجب أن تسجل: المدخل، المجال، عدد الخطوات، معيار التوقف، حد الخطأ، وميزانية الوقود. إذا لم يتحقق معيار التوقف قبل نفاد الوقود، تكون النتيجة `ABSTAIN / CONVERGENCE_UNPROVEN`.

## مصادر بحثية

[1]: https://webassembly.github.io/spec/core/exec/numerics.html "WebAssembly Core Specification — Numerics"

[2]: https://laas.hal.science/hal-03762945v1/document "Validated Numerics: Algorithms and Practical Applications"

[3]: https://arxiv.org/abs/2107.05784 "Validated numerics and rigorous error bounds"

[4]: https://pmc.ncbi.nlm.nih.gov/articles/PMC7324132/ "Fixed-point arithmetic and integer-based computation"

## الحكم

ما يثبت باختبار حتمي يدخل الامتداد مع بصمة مستقلة. وما يحتاج إلى مصدر kernel أو ABI أو قياس أداء يبقى `ABSTAIN_UNTIL_EVIDENCE`.

```text
EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
BASELINE_MODIFIED=NO
``` 

## References

[1] [WebAssembly Core Specification — Numerics](https://webassembly.github.io/spec/core/exec/numerics.html)

[2] [Validated Numerics: Algorithms and Practical Applications](https://laas.hal.science/hal-03762945v1/document)

[3] [Validated numerics and rigorous error bounds](https://arxiv.org/abs/2107.05784)

[4] [Fixed-point arithmetic and integer-based computation](https://pmc.ncbi.nlm.nih.gov/articles/PMC7324132/)

**المؤلف:** Manus AI
**التاريخ:** 2026-08-25
