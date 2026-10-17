# الفصل الخامس: توليد الكود (CodeGen)

## 5.1 من AST إلى x86_64

كل عقدة AST تترجم إلى سلسلة تعليمات NASM، بجمع سلاسل نصية (`push rax`، `mov rcx, rax`...) مع سجلات مؤقتة r10/r11 وعدادات فريدة للتسميات.

## 5.2 Arena Allocator

`mmap` مخصصة 256KB تُدار بمؤشر متزايد — لا freeing فردي، لا تسريب، ولا GC.

## 5.3 Heap Layout الموحد

كل البنى (قوائم، ADTs، closures، strings) تتبع Layout واحدًا:

```
[ptr + 0]      = الطول / عدد الحقول
[ptr + 8]      = الوسم (tag)
[ptr + 16+k*8] = الحقل k / العنصر k
```

## 5.4 فحص الحدود الآمن

`س[ك]` يُولّد `cmp rcx, rax / jge .err` — تجاوز الحدود ينهي البرنامج فورًا (مبدأ الحفظ).

## 5.5 الثنائيات المستقلة

```
math_complete.py → program.asm → nasm → program.o → ld → ELF
```

بدون libc — syscalls خام: `sys_write(1)`, `sys_exit(60)`, `mmap(9)`.

> أمان الذاكرة بالبناء — المبدأ السادس
