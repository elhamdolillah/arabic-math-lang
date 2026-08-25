# عقد البحث: GADT وrank-polymorphism في MAL/UORI

**الإصدار:** `RESEARCH-0.1`

**الحالة:** `RESEARCH`

**النطاق:** تصميم قابل للفحص فقط؛ لا يغيّر Grammar v0.1 ولا يفعّل التنفيذ في Tier-0.

## 1. قاعدة القبول

لا يُقبل أي اقتراح إلا إذا كان له نحو صريح، وفحص أنواع قابل للقرار، وتمثيل IR قانوني، وحدود موارد ثابتة، وحالات فشل مغلقة. غياب أحد هذه العناصر ينتج `ABSTAIN`، أما raw pointers والتنفيذ الديناميكي غير المصرح به فينتجان `DENY`.

```text
RESEARCH_ACCEPT = SYNTAX_DEFINED
                  ∧ TYPE_RULES_DEFINED
                  ∧ TERMINATING_CHECKER
                  ∧ CANONICAL_IR
                  ∧ RESOURCE_BOUND
                  ∧ CORPUS_PASS
```

## 2. GADT — نطاق البحث المحدود

يُبحث فقط نوع مجموعي مغلق، constructorاته معروفة مسبقاً، وكل constructor يحدد قيوداً على type index. يسمح الـ pattern matching باستعادة القيد داخل فرع محدود.

صيغة اقتراحية غير مفعلة:

```ebnf
نوع_مفهرس ::= "نوع_مفهرس" معرف "<" معرف ">" "=" مُنشئ { "|" مُنشئ } ;
مُنشئ     ::= معرف [ "(" نوع_امتداد ")" ] "يعطي" نوع_مفهرس ;
مطابقة   ::= "طابق" تعبير "مع" فرع { "|" فرع } ;
فرع       ::= مُنشئ "=>" تعبير ;
```

القيود الإلزامية:

1. النوع مغلق ولا يسمح بتركيب constructors من مصدر خارجي.
2. كل constructor يملك type index قابلاً للمقارنة قانونياً.
3. لا تتسرب الأنواع الوجودية خارج نطاق الفرع.
4. الفحص ثنائي الاتجاه: annotations مطلوبة عند مواضع الغموض.
5. exhaustive matching إلزامي؛ الفرع الناقص `ABSTAIN`، والتناقض الصريح `DENY`.
6. لا type-level computation غير محدود ولا reflection وقت التشغيل.

## 3. rank-polymorphism — نطاق البحث المحدود

يُبحث polymorphism من الرتبة الثانية فقط في الإصدار الأول: يسمح `forall` داخل نوع وسيط دالة، ولا يسمح بالرتبة الثالثة أو بالاستنتاج العام غير المقيّد.

صيغة اقتراحية غير مفعلة:

```ebnf
نوع_رتبي ::= "forall" معرف { معرف } "." نوع_رتبي
           | نوع_أساسي
           | "(" نوع_رتبي "->" نوع_رتبي ")" ;
توقيع_معلن ::= معرف ":" نوع_رتبي ;
```

القيود الإلزامية:

1. `forall` صريح في التوقيع؛ لا يُطلب استنتاج arbitrary-rank.
2. الحدود القصوى للرتبة: `rank <= 2`.
3. المتغيرات المكمّمة تعامل كسكولم داخل نطاقها ولا تُستبدل بقيم خارجية.
4. الفحص bidirectional مع بيئة أنواع مرتبة قانونياً.
5. لا unification غير محدود ولا impredicative instantiation.
6. أي غياب annotation أو تجاوز للرتبة `ABSTAIN`.

## 4. IR القانوني

لا تُحفظ عناوين ذاكرة أو ترتيب hash. تمثيل البحث المقترح:

```text
TypeID      = canonical integer
Constructor = (TypeID, ConstructorID, IndexConstraint)
Forall      = (BinderID, ScopeID, BodyTypeID)
Match       = (SubjectNodeID, sorted ConstructorID branches)
```

يُرتب كل binder وconstructor وbranch حسب ID. أي تمثيل غير قابل للتطبيع `ABSTAIN`.

## 5. حدود الذاكرة والتنفيذ

يُفرض حد ثابت على عمق الأنواع، عدد constructors، عدد فروع المطابقة، وعدد خطوات checker. عند نفاد أي fuel:

```text
fuel_remaining < 0 => ABSTAIN / FUEL_EXHAUSTED
```

لا يُنفّذ مصدر MAL أثناء البحث. النتيجة هي parse/type-check decision فقط.

## 6. القرارات المرحلية

| الحالة | القرار |
|---|---|
| syntax محدود + annotation صريح + checker منتهٍ + IR قانوني | `RESEARCH`، وليس `PROVEN` |
| constructor أو rank غير معروف | `ABSTAIN` |
| raw pointer أو reflection أو runtime symbol lookup | `DENY` |
| فحص نوع غير حتمي أو بلا حدود | `ABSTAIN` |

## 7. شروط الترقية

لا يمكن الترقية إلى `EXTENSION_SCOPED_PROVEN` قبل وجود parser فعلي، type checker ثنائي الاتجاه، canonical MAL-DIR، corpus موجب وسالب، اختبارات حدود، proof أو formal model للسلامة، ونتائج SHA-256 متطابقة عبر بيئتين على الأقل. لا يثبت هذا وحده سلامة kernel أو ABI أو كل تنفيذ Rust.

```text
SOURCE_EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
RAW_POINTERS=DENY
STATUS=RESEARCH
```
