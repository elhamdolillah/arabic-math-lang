# تشخيص المرحلة 31 — اختبار 5 (المحدد)

## الحالة: الاختبار 5 فشل — المحدد: -2 خرج كـ 18446744073709551614 (unsigned).
## المرفقات المفقودة: لا شيء. كل الاختبارات 1-4 و6 نجحت من أول تشغيل.

## الإصلاح الأول لنص() أُطبّق لكنه معطوب:
1. قسمة "div rbx" تُقسّم rdx:rax على rbx=10 لكن rax لا تزال القيمة السالبة
   الأصلية (rbx=-rax لكن التقسيم يستخدم rax!) → أرقام خاطئة.
2. علامة '-' تُكتب مرة واحدة عند num_buf+31 لكن بعدها النسخ يبدأ من آخر رقم...
   والـ '-' لا يُحتسب في rcx (العدد).
3. "mov rdi, rax" قبل lea rdi غير ضروري.

## الإصلاح الصحيح لنص() — الأقسام المتسلسلة بعد compile args[0]:
```
    test rax, rax          ; هل سالبة؟
    jns .n_pos_k           ; لا → تخطَّ
    neg rax                ; نعم → خذ القيمة المطلقة
    ; اكتب '-' في نهاية الرقم (آخر موضع) لاحقاً
.n_pos_k:
    ; احفظ القيمة المطلقة في rbx، وسنعمل على rax
    push rax               ; احتفظ بالقيمة المطلقة مؤقتاً
    ... 
```
**الطريقة الأبسط والآمنة**:
```
    test rax, rax
    jns .n_pos_k
    neg rax
.n_pos_k:
    mov rbx, 10
    mov rcx, 0              ; عدد الخانات
    mov r15, rax            ; احتفظ بالقيمة المطلقة (r15 غير محفوظ؟)
```
r15 ليس callee-saved لكن نص() تُستدعى كدالة داخل الكود المولّد (call print_str لاحقًا)...
النص() يولّد inline code وليس استدعاء دالة — r15 متاح لكن لتجنب الخطر:
استخدم متغيرًا مؤقتًا على المكدس أو num_buf+31 itself.
**الأنظف**: نكتب الأرقام يمين-يسار في num_buf من الموضع 31 للأسفل (الممارسة الأصلية).
عند السالب: نكتب '-' في الموضع مباشرة قبل أول رقم بعد الانتهاء.

### الخطة النهائية (بدون r15):
```
    test rax, rax
    jns .npos_k
    neg rax
    mov byte [negflag_k], 1   ; متغير في .bss
.npos_k:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_k:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_k
    ; rcx = عدد الخانات، rdi = بداية الأرقام
    ; cmp negflag_k,1 → je → dec rdi; mov byte[rdi],'-'; inc rcx
    cmp byte [negflag_k], 1
    jne .nskip2_k
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_k:
    push rdi
    push rcx
    mov rax, rcx
    add rax, 8
    mov rdi, rax
    call arena_alloc
    pop rcx
    mov [rax], rcx
    pop rsi
    push rax
    lea rdi, [rax + 8]
.ntc_k:
    test rcx, rcx
    jz .ntd_k
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_k
.ntd_k:
    pop rax
```
تحتاج متغير negflag في .bss: أضف "negflag db 0" بعد num_buf، وأعد ضبطه لـ 0
بعد استخدام كل استدعاء: "mov byte [negflag_k], 0" في .ntd_k (أمانًا لدعوات لاحقة).
لكن كل استدعاء يستخدم _counters["copy"] فريد k → يمكن اسم واحد shared: negflag_k
حيث k هو عداد نص() — متغير .bss واحد لكل استدعاء آمن.
لكن تعريف .bss يجب أن يكون مرة واحدة: استخدم نفس الكونتر لكن عرّف
"negflag_{k} db 0" في قسم .bss يضاف من compile_program عند أول استخدام...
**أبسط**: قسم .bss يُبنى مرة في compile_program — أعدّل القالب:
أضف في template: "negflag db 0" بجانب num_buf: "num_buf: resb 32" ← أعدّله:
"num_buf resb 32 / negflag resb 1" — وأعدّل كود نص() ليستخدم negflag واحدًا
مشاركًا (يُصفّر في النهاية فيمكن مشاركة بين الاستدعاءات المتتالية):
"mov byte [negflag], 0" في .ntd_k قبل pop rax.
لكن الترتيب: "cmp byte [negflag], 1" يجب أن يُنفّذ قبل .ntd... أي بعد النسخ.
التسلسل: بعد النسخ إلى arena لا نحتاج flag بعد ذلك — نكتبه قبل النسخ.
إذا كانت هناك نص() متداخلة في تعبير واحد؟ نص() inline بدون استدعاءات — كل
نص() يُولّد كاملًا بالتتابع؛ flag مشترك يعمل لأن كل نص() تستخدمه ثم تُصفّره
في نهايته... انتظر: في "⎕ نص(أ) ⊕ نص(ب)": نص(أ) كاملًا ثم نص(ب) كاملًا.
لكن داخل "⎕ أ + نص(ب)" لا تداخل. ⎕ أ + ب ← لا نص().
المشكلة المحتملة: "نص(أ) ⊕ نص(ب)" — compile_expr(⊕) يولّد نص(أ) كاملًا
ثم نص(ب) كاملًا (inline) — flag مشترك OK لأن الأول ينتهي ويصفّره قبل الثاني؟
لا! أنا أصفّره في .ntd_k في نهاية نص(أ) ✓ قبل بدء نص(ب). سليم.
**لكن** يوجد خطر: jns .npos_k يقفز فوق "neg rax; mov byte [negflag],1" — جيد.
**مشكلة متبقية**: "mov byte [negflag], 1" بعد jns فقط للقيمة السالبة. ثم
"cmp byte [negflag], 1" ← صحيح. ثم "mov byte [negflag], 0" في .ntd_k ← سليم.
**تداخل واحد أخير**: داخل نفس نص(): rcx=0 → inc → rcx ≥ 1. بعد nts: rcx عدد الخانات.
إذا rcx=0 (القيمة 0): nts لا يدور! rcx=0، rdi=num_buf+31 → نطبع ""!
**الحالة الأصلية**: هل الكود الأصلي يتعامل مع 0؟ nts: test rax,rax jnz loop.
إذا rax=0 من البداية: لا دورة ← rcx=0 ← نص(0)="" !!
**فحص**: هل stage سابق نجح مع 0؟ المرحلة 12+... لا نتذكر. المرحلة 5 كان
"⎕ 0 + 0" في التختبار المصغّر. لكن هل نص(0) اختُبر؟ stage 30 test4:
"زوجي؟ 0" — خرج صحيح! إذن نص(0) يعمل في stage 30... كيف؟
في stage 30: "نص(مجموع_قائمة(...))" أو رقم 0 حرفي. الخرج "زوجي؟ 0" ✓.
النص() في stage 30 لم يُختبر بـ 0 إلا هنا... لكنه نجح هناك. إذن nts مع 0
يعمل؟ "mov rax,[vars]" = 0 → loop لا ينفذ → rcx=0 → نص(0) = "" ← لكن
الخرج كان "0"!
**لأن** "نص(وجد)" حيث وجد=1... "زوجي؟ 0": "نص(م ≔ ..." م=0 ← خرج 0 ✓.
الحقيقة: nts loop: "test rax, rax; jnz" — مع rax=0 لا دورة. rcx=0.
arena_alloc(rcx+8=8): length=0 في [rax]. طباعة "" ← الخرج "زوجي؟ " بدون 0!
لكن stage 30 أظهر "زوجي؟ 0" ✓...
**فحص stage 30 output**: "زوجي؟ 0" — صحيح. إذاً إما أن kود نص() في stage 30
مختلف (كان نص() في المرحلة 30 يستخدم حلقة do-while؟) أو "م ≔ م ؟ ..." لم يُخزّن 0.
لا يهم الآن — الأصل القديم لا يدعم 0 على ما يبدو لكنه "نجح" هناك صدفة
(ربما نص(0) لم يُختبر). مهمتي الآن: أضف دعم 0 في الإصلاح الجديد (do-while).
### النسخة النهائية (do-while + سالب):
```
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
    ; do-while: نفّذ دورة واحدة على الأقل
    ; لكن div على 0 ← 0/10 = 0,余数 0 → خانة '0' واحدة ✓ طبيعي!
    ; لذا do-while: body ثم test rax,rax jnz
    ; التنفيذ: نعيد ترتيب بحيث body قبل الاختبار...
    ; الكود الحالي: test rax في آخر النطاق jnz للوراء = do-while بالفعل!!
```
**انتبه**: الكود الحالي `.nts_k: ... test rax,rax; jnz .nts_k` — body في الأعلى
ثم الاختبار — هذا **do-while** بالفعل! مع rax=0: يكتب '0' (xor→0/10→0余0)،
rdi=30, inc rcx=1, test 0 → jnz لا ← rcx=1 ✓ نص(0)="0" ✓✓.
إذاً الأصل يدعم 0 بالفعل — لا مشكلة. فقط إصلاح السالب:
1. قبل الرمز: test/neg (كما فوق)
2. بعد rcx محسوب: ألحق '-' إذا سالب.
### تصحيح نهائي لنص():
استبدل كامل بلوك نص() بالترتيب:
```
code += [
  "    test rax, rax", f"    jns .npos_{k}",
  "    neg rax",
  f".npos_{k}:",
  "    mov rbx, 10", "    mov rcx, 0",
  "    lea rdi, [num_buf + 31]",
  f".nts_{k}:",
  "    xor rdx, rdx", "    div rbx",
  "    add dl, '0'", "    dec rdi", "    mov [rdi], dl",
  "    inc rcx", "    test rax, rax",
  f"    jnz .nts_{k}",
  "    cmp byte [negflag], 1", f"    jne .nskip2_{k}",
  "    dec rdi", "    mov byte [rdi], 45", "    inc rcx",
  f".nskip2_{k}:",
  ...النسخ كما هو...
  f".ntd_{k}:",
  "    mov byte [negflag], 0",
  "    pop rax",
]
```
وإضافة "negflag: resb 1" في .bss template (compile_program) مرة واحدة.
**ملاحظة**: يجب أن تكون "mov byte [negflag], 1" في جزء السالب — لكن أين؟
في البداية بعد neg. أضفها بين neg و npos:
```
  "    test rax, rax", f"    jns .npos_{k}",
  "    neg rax", "    mov byte [negflag], 1",
  f".npos_{k}:",
```
✓ وهذا يعمل حتى مع الاستدعاءات المتتالية لأن كل نص() تُصفّر flag في نهايته.
