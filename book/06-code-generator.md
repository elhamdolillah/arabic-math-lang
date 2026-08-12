# الفصل 6: مولّد الكود (Code Generator) بالتفصيل

## مقدمة

مولّد الكود هو **المرحلة الأخيرة** في المُجمّع. يأخذ شجرة AST المُتحقق منها ويُنتج كود x86_64 Assembly جاهز للتجميع.

```text
AST مُتحقق → [CodeGen] → x86_64 Assembly
    Assign(...)     ⚙️        mov rax, 42...
```

---

## بنية CodeGen

```python
class CodeGen:
    def __init__(self):
        self.data = []          # قسم .data (ثوابت)
        self.bss = []           # قسم .bss (متغيرات غير مهيأة)
        self.text = []          # قسم .text (الكود)
        self.vars = {}          # جدول المتغيرات → إزاحة
        self.var_offset = 0     # الإزاحة الحالية
        self.str_count = 0      # عداد النصوص
        self.label_count = 0    # عداد التسميات
```

### الأقسام الثلاثة في ELF

```asm
section .data           ; البيانات الثابتة (النصوص)
    str_1 db "مرحبا", 0
    str_1_len equ $ - str_1

section .bss            ; المتغيرات (ذاكرة غير مهيأة)
    arena_ptr resq 1
    arena_mem resb 262144   ; 256KB
    vars resb 1024

section .text           ; الكود التنفيذي
    global _start
_start:
    ; ... الكود المولد ...
```

---

## توليد التعبيرات الحسابية

### مثال: `5 + 3 · 2`

```text
AST:
  BinOp(+)
  ├── Num(5)
  └── BinOp(·)
      ├── Num(3)
      └── Num(2)
```

### الكود المولد

```asm
; توليد الطرف الأيمن أولاً (3 · 2)
mov rax, 3          ; rax = 3
push rax            ; حفظ في المكدس
mov rax, 2          ; rax = 2
mov rbx, rax        ; rbx = 2
pop rax             ; rax = 3
imul rax, rbx       ; rax = 6
push rax            ; حفظ الناتج

; توليد الطرف الأيسر (5)
mov rax, 5          ; rax = 5
mov rbx, rax        ; rbx = 5
pop rax             ; rax = 6 (من المكدس)
add rax, rbx        ; rax = 11 (خطأ! يجب عكسها)
```

### الكود الصحيح

```asm
; الطرف الأيمن: 3 · 2
mov rax, 3
push rax
mov rax, 2
mov rbx, rax
pop rax
imul rax, rbx       ; rax = 6
push rax            ; حفظ الناتج

; الطرف الأيسر: 5
mov rax, 5
mov rbx, rax        ; rbx = 5
pop rax             ; rax = 6
xchg rax, rbx       ; rax = 5, rbx = 6
add rax, rbx        ; rax = 11 ✅
```

---

## توليد الإسناد

### مثال: `س ≔ 42`

```python
def compile_assign(self, name, expr):
    # حجز مكان للمتغير إذا لم يكن موجوداً
    if name not in self.vars:
        self.vars[name] = self.var_offset
        self.var_offset += 8   # 8 بايت لكل عدد
    
    # توليد التعبير (النتيجة في rax)
    self.compile_expr(expr)
    
    # حفظ النتيجة في المتغير
    offset = self.vars[name]
    self.emit(f"    mov [vars + {offset}], rax")
```

### الكود المولد

```asm
mov rax, 42
mov [vars + 0], rax    ; س = 42
```

---

## توليد الطباعة

### طباعة الأعداد (`⎕ 42`)

```asm
mov rax, 42
call print_int

; print_int routine:
print_int:
    push rax
    push rbx
    push rcx
    push rdx
    
    ; معالجة الأعداد السالبة
    test rax, rax
    jns .positive
    neg rax
    push rax
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    lea rsi, [minus_str]
    mov rdx, 1
    syscall
    pop rax

.positive:
    ; تحويل إلى نص (من اليمين لليسار)
    mov rbx, 10         ; الأساس 10
    mov rcx, 0
    lea rdi, [num_buf + 31]

.loop:
    xor rdx, rdx
    div rbx             ; rax ÷ 10
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .loop
    
    ; طباعة
    mov rsi, rdi
    mov byte [rsi + rcx], 10  ; سطر جديد
    inc rcx
    mov rdi, 1
    mov rax, 1
    mov rdx, rcx
    syscall
    
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
```

### طباعة النصوص (`⎕ "مرحبا"`)

```asm
; النص محفوظ في .data
section .data
    str_1 db 197, 163, 198, 177, 198, 173, 198, 176, 198, 168, 198, 167
    str_1_len equ 12

; الكود المولد
mov rdi, 1              ; stdout
lea rsi, [str_1]        ; عنوان النص
mov rdx, str_1_len      ; الطول
mov rax, 1              ; sys_write
syscall

; سطر جديد
mov rdi, 1
lea rsi, [newline]
mov rdx, 1
mov rax, 1
syscall
```

---

## توليد الشروط

### الشرط الثلاثي (`س > 5 ؟ 1 : 0`)

```asm
; توليد الشرط: س > 5
mov rax, [vars + 0]     ; rax = س
cmp rax, 5
jle .tern_false         ; إذا <= 5، اذهب للفرع الخاطئ

; الفرع الصحيح: 1
mov rax, 1
jmp .tern_end

.tern_false:
; الفرع الخاطئ: 0
mov rax, 0

.tern_end:
; النتيجة في rax
```

---

## توليد الحلقات

### حلقة `μ` (while)

```arabic
ع ≔ 1
μ ع <= 5 : ﴿
    ⎕ ع
    ⋄ ع ≔ ع + 1
﴾
```

```asm
; تهيئة المتغير
mov qword [vars + 0], 1    ; ع = 1

.loop_start:
; فحص الشرط
mov rax, [vars + 0]        ; rax = ع
cmp rax, 5
jg .loop_end               ; إذا > 5، اخرج

; جسم الحلقة: ⎕ ع
mov rax, [vars + 0]
call print_int

; جسم الحلقة: ع ≔ ع + 1
mov rax, [vars + 0]
add rax, 1
mov [vars + 0], rax

jmp .loop_start            ; العودة للبداية

.loop_end:
; استمرار البرنامج
```

### حلقة `∀` (for each)

```arabic
ق ≔ ⟨1, 2, 3⟩
∀ ع ∈ ق : ﴿
    ⎕ ع
﴾
```

```asm
; ق محفوظة في arena كقائمة
; قائمة = [length, elem1, elem2, elem3]
mov rbx, [vars + q_offset]    ; rbx = عنوان القائمة
mov rcx, [rbx]                 ; rcx = length
mov rdi, 0                     ; index = 0

.for_loop:
cmp rdi, rcx
jge .for_end

; استخراج العنصر
mov rax, [rbx + 8 + rdi*8]    ; rax = ق[index]
mov [vars + elem_offset], rax ; حفظ في 'ع'

; جسم الحلقة
mov rax, [vars + elem_offset]
call print_int

inc rdi
jmp .for_loop

.for_end:
```

---

## توليد الدوال

### دالة Lambda: `مربع ≡ λس. س · س`

```asm
; تعريف الدالة
func_مربع:
    push rbp
    mov rbp, rsp
    
    ; المعامل في [rbp + 16]
    mov rax, [rbp + 16]
    imul rax, rax        ; س · س
    
    pop rbp
    ret

; الاستدعاء: مربع(5)
push 5                   ; المعامل
call func_مربع
add rsp, 8               ; تنظيف المكدس
; النتيجة في rax
```

---

## إدارة الذاكرة (Arena Allocator)

### التخصيص

```asm
; arena_alloc(size in rdi) → pointer in rax
arena_alloc:
    mov rax, [arena_ptr]
    test rax, rax
    jnz .init_done
    lea rax, [arena_mem]
    mov [arena_ptr], rax

.init_done:
    mov rdx, rax
    add rdx, rdi         ; المؤشر الجديد
    mov [arena_ptr], rdx
    ret                  ; rax = العنوان القديم
```

### تمثيل النصوص

```text
┌────────────────────────────────┐
│ Offset 0: length (8 bytes)     │
│ Offset 8: data (UTF-8 bytes)   │
└────────────────────────────────┘
```

```asm
; إنشاء نص "مرحبا"
mov rdi, 20              ; 8 + 12 بايت
call arena_alloc
mov rbx, rax             ; rbx = عنوان النص
mov qword [rbx], 12      ; length = 12
; نسخ البيانات من .data
lea rsi, [str_1]
lea rdi, [rbx + 8]
mov rcx, 12
rep movsb
```

---

## توليد الملكية الخطية

### نقل الملكية (`⊸`)

```arabic
ق١ ≔ ⟨1, 2, 3⟩
ق٢ ≔ ق١ ⊸
```

```asm
; ق١ محفوظة في [vars + q1_offset]
mov rax, [vars + q1_offset]
mov [vars + q2_offset], rax    ; نقل المؤشر

; ق١ لم تعد صالحة — لا نولّد أي كود لها
; المُجمّع يمنع الوصول في وقت التجميع
```

---

## الملف النهائي

### الهيكل الكامل

```asm
; ═══════════════════════════════════════════════════
; Generated by Arabic Mathematical Language Compiler
; ═══════════════════════════════════════════════════

global _start

section .bss
    arena_ptr resq 1
    arena_mem resb 262144
    num_buf resb 32
    vars resb 1024

section .data
    newline db 10
    minus_str db '-'
    str_1 db "السلام عليكم"
    str_1_len equ 12

section .text

; ─────────────────────────────────────────────
; Routines
; ─────────────────────────────────────────────
arena_alloc:
    ; ... (كما سبق)

print_int:
    ; ... (كما سبق)

; ─────────────────────────────────────────────
; User Code
; ─────────────────────────────────────────────
_start:
    mov qword [arena_ptr], 0
    
    ; ⎕ "السلام عليكم"
    mov rdi, 1
    lea rsi, [str_1]
    mov rdx, str_1_len
    mov rax, 1
    syscall
    ; ... newline ...
    
    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall
```

---

## التحسينات المستقبلية

### 1. Constant Folding
```text
قبل: mov rax, 5; add rax, 3
بعد: mov rax, 8
```

### 2. Dead Code Elimination
```text
حذف المتغيرات غير المستخدمة
```

### 3. Register Allocation
```text
استخدام السجلات بدلاً من المكدس حيث أمكن
```

### 4. Function Inlining
```text
دمج الدوال الصغيرة في موقع الاستدعاء
```

---

## تمارين الفصل السادس

1. **تمرين 1:** أضف دعم الأس `^`
2. **تمرين 2:** نفّذ `print_float`
3. **تمرين 3:** أضف `constant folding` بسيط
4. **تمرين 4:** ولّد كود للقوائم المتداخلة

---

## الخلاصة

مولّد الكود هو **الجسر** بين البرنامج المجرد والآلة الحقيقية:
- يترجم AST إلى تعليمات CPU
- يدير الذاكرة بكفاءة
- يضمن صحة الملكية الخطية
- ينتج ملفات ELF صغيرة وسريعة

في الفصل التالي، سندرس **إدارة الذاكرة** بالتفصيل.

**﴿وقل رب زدني علماً﴾**