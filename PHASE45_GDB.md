# gdb findings — trait_0 returns 10

Breakpoint at trait_0+0x61 (pop rbx, قبل add):
- rax = 0xa = 10 (نتيجة س[1]!!)
- rbx = 0x2 = 2 (القيمة الموضوعة = زوج ptr؟ لا!)

انتظر: الرتبة في الجسد:
1. س[0]: push زوج, index 0, mov rax,[r11+r10*8+8] → يجب 10
2. push rax (10)
3. mov rax,[rbp-8] → زوج ptr
4. push زوج
5. index 1: mov r10=1, pop r11 (زوج), mov rbx=[r11]=2(len), cmp 1<2 ok, mov rax,[r11+r10*8+8]=[زوج+16]=20 → rax=20
6. pop rbx → rbx=10
7. add → 30

لكن gdb عند 0x61 (pop rbx): rax=10, rbx=2!!!
- rax=10 هنا = نتيجة الخطوة 1 (س[0])!! يعني الخطوة 5 لم تُنفَّذ — القفز بعد indx_ok_1: jmp .indx_ok_1 ثم... 

عند 0x61 الرتبة pop rbx مباشرة بعد mov rax,[r11+r10*8+8] للخطوة 5؟ لا — الخطوة 1 تنتهي بـ mov rax=[...] ثم jmp indx_ok_1 ثم push rax (0x38) ثم mov rax,[rbp-8]... 

0x61 = pop rbx بعد mov رخصة س[1]. لكن rax=10 عند هذه النقطة يعني آخر mov rax=[r11+r10*8+8] قرأ 10.
ومع rbx=2 = [r11] حيث r11 من pop r11.

الاستنتاج: الرخصة س[1] قرأت من زوج ptr لكن r11 = زوج و[r11+8]=0(tag)! الرخصة س[0] استخدمت index 0 → [زوج+0*8+8]=[زوج+8]=0(tag)=0!! لكن الناتج رخصة س[0] = 0؟ لا — الخرج 10.

لا! layout الجديد (من إصلاح PHASE45_LAYOUT_PLAN):
- [r11] = len
- [r11+8] = tag
- [r11+16] = field0
- [r11+24] = field1
وindexing code: mov rax,[r11 + r10*8 + 8] — عند r10=0 → [r11+8]=tag=0!! عند r10=1 → [r11+16]=10!!
هذا خطأ indexing: index يجب أن يبدأ من [r11 + r10*8 + 16] = r10*8+16!

gdb يتفق: س[0] → rax=0 (tag!) ثم push 0... انتظر الخرج النهائي 10 وليس 0. س[0]=0، س[1]=10، pop rbx=0، add → 10!! ✓✓✓ مطابق للخروج 10.

## الخلل الحقيقي
indexing codegen في stage44 (فهرسة القوائم) يستخدم إزاحة +8 بعد tag: [r11 + r10*8 + 8]
- قبل إصلاح layout: [ptr]=tag، fields عند [ptr+8+k*8] — كان صحيحًا.
- بعد إصلاح layout (len عند [ptr]): fields عند [ptr+16+k*8]، tag عند [ptr+8].
- لكن codegen الفهرسة لم يُحدَّث! يجب [r11 + r10*8 + 16] وlen يُقرأ من [r11] (كان [r11] سابقًا tag؟ لا، سابقًا [ptr]=tag؟).

تحقق من patch44_adt.py patch 6/7 layout الحالي وcodegen الفهرسة (compile_expr فهرسة branch في المحرك).

## إصلاحات P8/P9 لا تزال معلقة:
- P8: type inference للـ trait calls (نص/عدد حسب body)
- P9: dispatch fallback (متغير args، unambiguous impl)
