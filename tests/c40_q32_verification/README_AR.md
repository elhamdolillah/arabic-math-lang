# أدلة تحقق C40 وQ32.32

هذا المجلد يضم نماذج عددية واختبارات Assembly حتمية مرتبطة بتشخيص دالة `أُس` في C40.

الملفات لا تمثل patchًا مدموجًا في النواة. الغرض منها هو إعادة الإنتاج، ومراجعة تصميم Q64.64، واختبار عملية الضرب المختلط على x86_64.

## النتائج المنشورة

- اختبار الضرب المختلط Python: `265/265` ناجح.
- اختبار Assembly مقابل مرجع C `__int128`: `10016/10016` ناجح.
- اختبار إعادة إنتاج C40 الأساسي: `8/8` ناجح بعد إصلاح السالب الأحادي في worktree.
- اختبار الإجهاد القديم: `17/21` ناجح؛ ما زالت دقة `exp` الموجبة الكبيرة تحتاج إصلاحًا.

## إعادة الإنتاج

يمكن فحص صياغة Python وتشغيل الاختبارات المرفقة بالأوامر التالية من جذر المستودع:

```sh
python3 -m py_compile tests/c40_q32_verification/*.py
python3 tests/c40_q32_verification/test_q6464_mixed_product.py
nasm -f elf64 tests/c40_q32_verification/mixed_mul_q64.asm -o /tmp/mixed_mul_q64.o
gcc -O2 -Wall -Wextra tests/c40_q32_verification/test_mixed_mul_q64.c /tmp/mixed_mul_q64.o -o /tmp/mixed_mul_q64
/tmp/mixed_mul_q64
```

> لا تُستخدم هذه النتائج وحدها لإثبات صحة النواة أو السماح بالدمج. يلزم اختبار المصدر الكامل، واختبار WASM/Assembly التفاضلي، والتحقق من حدود overflow وunderflow.
