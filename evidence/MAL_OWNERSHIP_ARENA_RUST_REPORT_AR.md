# تقرير مرحلة Arena والملكية بلغة Rust

## الحالة

الحالة التنفيذية لهذه المرحلة هي `PROVEN_FOR_PROTOTYPE_SCOPE`. تم تنفيذ نموذج Arena مفهرس بلا مؤشرات خام، مع منع `unsafe` على مستوى صندوق Rust بواسطة `#![forbid(unsafe_code)]`.

## العقد المثبت

يمثل كل مرجع بالمقبض:

```text
Handle(arena_id, slot_id, generation, type_tag)
```

ويُقبل الوصول فقط عند تحقق تطابق Arena، وصلاحية الفهرس، وتطابق الجيل، وتطابق النوع، وصلاحية نطاق الملكية، وبقاء الخلية في حالة مملوكة. عند فشل أي شرط تُعاد قيمة خطأ صريحة؛ لا توجد قراءة بديلة ولا تنفيذ تلقائي.

يختار التخصيص أول خانة قابلة للتخصيص حسب ترتيب الفهرس. وتعيد الخانة المحررة استخدام الفهرس نفسه مع الجيل الذي رفعته عملية التحرير، مما يجعل المقبض القديم غير صالح ويمنع `use-after-free` منطقياً.

## الاختبارات

شملت الاختبارات خمسة invariants قابلة لإعادة الإنتاج: التخصيص الأول وإعادة الاستخدام الحتمي، رفض المقبض القديم بعد التحرير، منع تعارض الاستعارة المشتركة والحصرية، عزل النطاق والنوع وArena، ورفض النوع الصفري والسعة المنتهية.

النتيجة التنفيذية:

```text
MAL_OWNERSHIP_ARENA_RUST=PASS
TESTS=5
RAW_POINTERS=FORBIDDEN
UNSAFE_CODE=FORBIDDEN
GENERATION_CHECK=PASS
BORROW_RULES=PASS
SCOPE_ISOLATION=PASS
CAPACITY_RULE=PASS
EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
STATUS=0
```

بصمة الخرج الخام محفوظة في `MAL_OWNERSHIP_ARENA_RUST.sha256`، ولا تعتمد الاختبارات على الشبكة أو crates خارجية.

## الحدود

هذا يثبت النموذج الأولي للـ Arena والمقابض المفهرسة في Rust فقط. لا يثبت بعد تكامل grammar أو MAL-DIR أو ABI أو backend أو WASM، ولا يثبت سلامة نظام تشغيل كامل. لذلك يبقى الانتقال إلى `PROVEN` الرسمي في مواصفة MAL-DIR v0.2 مشروطاً بإضافة corpus مستقل، وتمرير AST، واختبارات ABI، واختبارات cross-environment للـ Rust toolchain.
