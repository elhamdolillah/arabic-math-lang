# عقد البناء القابل لإعادة الإنتاج — UORI/MAL

## النطاق

يطبق هذا العقد على إعادة إنتاج مخرجات الامتداد الموثوق والنصوص canonical فقط. لا يدعي حتمية binary native أو linker أو assembly أو bootstrap ذاتي.

## قواعد البيئة

```text
SOURCE_DATE_EPOCH=0
LC_ALL=C.UTF-8
LANG=C.UTF-8
NETWORK=DISABLED
ABSOLUTE_PATHS=REMAPPED_OR_EXCLUDED
SOURCE_REF_EXECUTED=NO
```

يجب أن تكون نسخة Python، نسخة الامتداد، corpus، والعقد مثبتة ببصمات SHA-256. لا يسمح العقد بقراءة الساعة أو العشوائية أو الشبكة أثناء إنتاج المخرج.

## المخرج المقبول

المخرج المقبول هو تمثيل UTF-8 canonical أو JSON canonical لنتيجة الامتداد. لا يجوز تضمين timestamp أو مسار مطلق أو ترتيب غير معرف. تطابق المخرج مرتين على الأقل byte-for-byte شرط لازم، وليس كافياً وحده لإثبات الصحة الرياضية.

## سياسة IEEE-754

المسار الحتمي الحالي لا يعتمد على IEEE-754 لإثبات الحساب العددي العام. القيم غير المنتهية `NaN` و`Infinity`، والتقريب غير المعلن، و`fast-math`، واختلاف rounding mode تؤدي إلى `ABSTAIN`. أي دعم مستقبلي للفاصلة العائمة يحتاج عقداً مستقلاً يثبت نوع المعالج، rounding mode، exception mode، compiler flags، وfixtures مرجعية.

## درجات الادعاء

```text
CANONICAL_AST_OR_TEXT       = ALLOW ضمن نطاق الامتداد إذا تطابقت البصمات
NATIVE_BINARY_REPRODUCIBLE  = RESEARCH
CROSS_ARCH_BINARY_EQUALITY  = ABSTAIN
BOOTSTRAP_SELF_HOSTING      = RESEARCH
```

## الأدلة المطلوبة

يجب حفظ stdout الخام، manifest المدخلات، بصمة المخرج، وسلسلة تحقق مستقلة. لا تضاف ملفات التحقق المتغيرة أثناء التشغيل إلى السلسلة نفسها. أي اختلاف أو ملف مفقود أو فشل SHA-256 يؤدي إلى `ABSTAIN`.

## الحوكمة

هذا العقد يضاف في فرع مستقل ولا يعدل baseline المجمد `f56b8bd`. الدمج يحتاج مراجعة لاحقة مستقلة، ولا يتم تلقائياً بهذا العقد.
