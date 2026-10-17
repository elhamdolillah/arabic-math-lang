# ملاحظات مرجعية — Rust cfg

المصدر الرسمي: https://doc.rust-lang.org/reference/conditional-compilation.html
العنوان: Rust Reference — Conditional compilation

المصدر الرسمي: https://doc.rust-lang.org/reference/attributes.html
العنوان: Rust Reference — Attributes

الحقائق المستخدمة:

1. `cfg` و`cfg_attr` و`cfg!` و`cfg_select!` هي آليات Rust للترجمة الشرطية.
2. المسندة يمكن أن تكون خيارًا، أو زوج مفتاح/قيمة، أو `all(...)`، أو `any(...)`، أو `not(...)`، أو `true`، أو `false`.
3. خيارات الإعداد تُحدد ساكنًا أثناء ترجمة الصندوق؛ بعضها يحدده المترجم وبعضها يأتي من مدخلات خارجية.
4. لا يمكن للمصدر داخل الصندوق أن يحدد خيارات الإعداد لنفس عملية الترجمة.
5. `cfg` و`cfg_attr` سمات نشطة تُعالج أثناء مرحلة السمات.

هذه الملاحظات مرجع دلالي للآلية 164 فقط، ولا تثبت تنفيذًا داخل MAL أو UORI. الحالة في UORI: RESEARCH.
