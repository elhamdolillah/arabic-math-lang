# مراجعة دستورية للآليات 40–45

## نطاق المراجعة

المرجع المجمد هو `MAL_GRAMMAR_SPEC_v0.1_AR.md`. لم يُعدّل baseline، ولم تُنفذ أمثلة Kotlin أو Erlang أو Objective-C أو TypeScript أو Haskell أو Dart. هذه مراجعة نطاقية لتحديد ما يمكن بحثه لاحقاً داخل امتداد MAL مستقل.

## النتيجة العامة

الآليات الست موجودة في الأدبيات واللغات المستهدفة، لكن الادعاءات المرفقة صيغت أحياناً كضمانات مطلقة. الدستور يفرق بين تحقق ساكن، ودلالة runtime، وحتمية النتيجة خارجياً. لذلك لم تُقبل أي آلية كميزة تنفيذية في Grammar أو UORI.

| رقم | المفهوم الموحد | التصنيف | التصحيح الحاكم |
|---:|---|---|---|
| 40 | تمييز النوع القابل للعدم وغير القابل له | `RESEARCH` | التحقق الساكن يقلل مسارات null، لكنه لا يثبت غياب الفشل عند `!!` أو Java interop أو عدم اتساق التهيئة؛ يلزم `ABSTAIN` عند حد خارجي غير مثبت |
| 41 | مطابقة bitstring بأحجام واتجاهات صريحة | `RESEARCH` | الاستخراج حتمي لمدخل ثابت ونمط ثابت؛ malformed input يجب أن ينتج رفضاً منظماً لا crash، ويلزم تحديد width وendianness وsignedness |
| 42 | عدّ المراجع الآلي | `RESEARCH` | lifetime المرجعي قابل للتتبع، لكن weak/unsafe references وautorelease/runtime وABI قد تغير الحدود؛ لا يثبت حتمية كل resource أو destructor |
| 43 | أنواع قوالب السلاسل | `RESEARCH` | template literal types تتحقق من مجموعة أو شكل نوعي؛ `#${string}` لا يثبت أن hex صالح، والمدخل الديناميكي يحتاج runtime validator |
| 44 | ترتيب المؤثرات عبر IO monad | `POLICY + RESEARCH` | ترتيب تركيب الأفعال دلالة لغة، لكنه لا يجعل filesystem/network أو جدولة خارجية حتمية؛ MAL يعتمد effect witness وقرار `ABSTAIN` للبيئة غير المثبتة |
| 45 | ثوابت عميقة غير قابلة للتغيير | `RESEARCH` | const expression ثابت ضمن مواصفة runtime محددة؛ canonical identity ليست بديلاً عن قيمة canonical، ولا تُعمم على كل backend دون ABI/runtime corpus |

## حواجز مشتركة

يجب أن تكون الأنواع والحدود وعمليات التحويل canonical، وأن تُحدد أخطاء null وshape وoverflow وinvalid encoding وresource exhaustion. لا يُسمح بالـ `eval` أو `exec` أو shell أو network أو `source_ref` أثناء المراجعة. لا تُستخدم أمثلة ناجحة أو شيوع ميزة في لغة أخرى كدليل على تنفيذ MAL.

## خطة بحث قابلة للإثبات

ينشأ لكل مفهوم عقد مستقل وcorpus صغير، ثم نسخة `.ar` ومرجع `.py`، مع مقارنة status/error/value وstdout وSHA-256 في Ubuntu وAlpine. أي غياب لمنفذ `.ar` أو اختلاف غير مفسر يسجل `GAP/ABSTAIN` ولا يتحول إلى PASS. تبقى كل الآليات خارج kernel وWASM وGrammar v0.1 إلى حين اكتمال الأدلة.

```text
CONSTITUTION_REVIEW=PASS_WITH_GUARDS
RULES_EXECUTIVELY_ADOPTED=0
SOURCE_EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
BASELINE_MODIFIED=NO
```
