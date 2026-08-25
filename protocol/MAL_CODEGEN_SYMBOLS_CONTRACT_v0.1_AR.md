# عقد أسماء رموز المولد الحتمي v0.1

## الغرض

يحدد هذا العقد قواعد إنشاء أسماء الرموز الخارجة من IR قبل توليد الأسمبلي، بحيث يكون الاسم ناتجًا عن معرّفات فهرسية ثابتة لا عن عنوان ذاكرة أو ترتيب بيئي.

## النموذج الحاكم

يُعرّف كل رمز بالسجل `(kind, node_id, ordinal)`، حيث تكون `kind` من مجموعة ثابتة، و`node_id` فهرسًا صحيحًا داخل Arena، و`ordinal` عدادًا محدودًا يبدأ من واحد ويزداد بترتيب الإدراج canonical. لا يُسمح بالمؤشرات الخام أو بالطوابع الزمنية أو بالعشوائية أو بالتوازي غير المحدد.

## قواعد التطبيع

يجب أن يكون ترتيب الرموز تصاعديًا بحسب `kind` ثم `node_id` ثم `ordinal`. ويجب أن يحول الاسم إلى تمثيل ASCII ثابت من النمط `mal_<kind>_<node_id>_<ordinal>`. تُرفض المحارف غير المسموح بها، والأسماء الفارغة، والتصادمات، والعدادات الخارجة عن السعة.

## حالات الامتناع

يعاد `ABSTAIN / INVALID_NODE_ID` عند فهرس غير صحيح، و`ABSTAIN / SYMBOL_COLLISION` عند تصادم اسمين، و`ABSTAIN / NON_CANONICAL_ORDER` عند اختلاف الترتيب، و`ABSTAIN / CAPACITY_EXCEEDED` عند نفاد السعة. لا يجوز متابعة التوليد بعد أي حالة امتناع.

## شروط الاعتماد

التصنيف الحالي `POLICY`؛ ولا يرفع إلى `EXTENSION_SCOPED_PROVEN` إلا بعد حفظ stdout خام، وcorpus موجب وسالب، وSHA-256، وإعادة بناء متطابقة، وتنفيذ مشغل MAL موثوق داخل النطاق نفسه.

## الحالة

```text
CONTRACT=PASS_WITH_GUARDS
RAW_POINTERS=DENY
NON_DETERMINISTIC_ORDER=DENY
SOURCE_EXECUTION=NOT_PERFORMED
BASELINE_MODIFIED=NO
AUTO_PROMOTION=DENY
```
