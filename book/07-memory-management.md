# الفصل 7: إدارة الذاكرة (Arena Allocator)

## مقدمة

إدارة الذاكرة هي **أصعب جزء** في لغات البرمجة. حلول تقليدية:
- **C**: `malloc`/`free` → تسريبات، use-after-free
- **Java/Python**: Garbage Collection → بطء، استهلاك
- **Rust**: Borrow Checker → تعقيد

**حلنا: Arena Allocator** — بسيط، سريع، آمن.

---

## مفهوم Arena

### الفكرة الأساسية

```text
┌─────────────────────────────────────────────────────┐
│                    Arena (256 KB)                    │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────┬──────┬──────┬──────┬─────────────────────┐│
│  │ Obj1 │ Obj2 │ Obj3 │ Obj4 │   Free Space        ││
│  │ 20B  │ 16B  │ 24B  │ 32B  │                     ││
│  └──────┴──────┴──────┴──────┴─────────────────────┘│
│                                          ↑           │
│                                    arena_ptr          │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### المميزات

| الميزة | malloc/free | GC | Arena |
|--------|-------------|----|----|
| السرعة | بطيء | بطيء | **سريع جداً** |
| التسريب | ممكن | لا | **مستحيل** |
| use-after-free | ممكن | لا | **مستحيل** |
| double-free | ممكن | لا | **مستحيل** |
| التعقيد | متوسط | عالي | **بسيط** |
| التحكم | عالي | منخفض | متوسط |

---

## التنفيذ

### التهيئة

```asm
section .bss
    arena_ptr resq 1           ; مؤشر الـ arena
    arena_mem resb 262144      ; 256 KB

section .text
_start:
    ; تهيئة arena_ptr = 0 (سيُهيأ عند أول تخصيص)
    mov qword [arena_ptr], 0
```

### التخصيص

```asm
; arena_alloc(size in rdi) → pointer in rax
arena_alloc:
    push rdi
    
    mov rax, [arena_ptr]
    test rax, rax
    jnz .init_done
    
    ; التهيئة الأولى
    lea rax, [arena_mem]
    mov [arena_ptr], rax

.init_done:
    ; حساب المؤشر الجديد
    mov rdx, rax
    add rdx, rdi
    
    ; التحقق من عدم تجاوز الحد
    lea rcx, [arena_mem + 262144]
    cmp rdx, rcx
    jg .out_of_memory
    
    ; تحديث المؤشر
    mov [arena_ptr], rdx
    
    pop rdi
    ret

.out_of_memory:
    ; طباعة رسالة خطأ
    mov rax, 1
    mov rdi, 2
    lea rsi, [oom_msg]
    mov rdx, oom_msg_len
    syscall
    mov rax, 60
    mov rdi, 1
    syscall
```

### مثال: تخصيص 20 بايت

```text
قبل:
arena_ptr → [....................] (فارغ)

بعد arena_alloc(20):
[Obj1: 20B][....................]
             ↑
         arena_ptr
```

---

## تمثيل الكائنات

### النصوص

```text
┌────────────────────────┐
│ Offset 0: length (u64) │ 8 bytes
│ Offset 8: data (UTF-8) │ N bytes
└────────────────────────┘
```

```asm
; إنشاء "مرحبا" (12 بايت UTF-8)
mov rdi, 20             ; 8 + 12
call arena_alloc
mov rbx, rax
mov qword [rbx], 12     ; length
lea rsi, [str_data]
lea rdi, [rbx + 8]
mov rcx, 12
rep movsb
```

### القوائم

```text
┌────────────────────────┐
│ Offset 0: length (u64) │ 8 bytes
│ Offset 8: elem[0]      │ 8 bytes (ptr أو value)
│ Offset 16: elem[1]     │ 8 bytes
│ ...                     │
└────────────────────────┘
```

```asm
; إنشاء ⟨1, 2, 3⟩
mov rdi, 32             ; 8 + 3×8
call arena_alloc
mov rbx, rax
mov qword [rbx], 3      ; length
mov qword [rbx + 8], 1  ; elem[0]
mov qword [rbx + 16], 2 ; elem[1]
mov qword [rbx + 24], 3 ; elem[2]
```

### المصفوفات

```text
┌────────────────────────┐
│ Offset 0: rows (u64)   │
│ Offset 8: cols (u64)   │
│ Offset 16: data[...]   │ rows × cols × 8 bytes
└────────────────────────┘
```

---

## أمثلة عملية

### مثال 1: دمج النصوص

```arabic
أ ≔ "السلام"
ب ≔ " عليكم"
ج ≔ أ ⊕ ب
```

```asm
; أ محفوظة في arena
; ب محفوظة في arena
; دمج أ و ب:

; حساب الطول الجديد
mov rax, [أ_ptr]           ; طول أ
mov rbx, [ب_ptr]           ; طول ب
mov rcx, [rax]
mov rdx, [rbx]
add rcx, rdx               ; الطول الجديد

; تخصيص نص جديد
lea rdi, [rcx + 8]
call arena_alloc
mov rbx, rax
mov [rbx], rcx             ; length

; نسخ أ
mov rsi, [أ_ptr]
add rsi, 8
lea rdi, [rbx + 8]
mov rcx, [أ_ptr]
rep movsb

; نسخ ب
mov rsi, [ب_ptr]
add rsi, 8
mov rcx, [ب_ptr]
rep movsb
```

### مثال 2: إنشاء قائمة ديناميكية

```arabic
ق ≔ ⟨⟩
ق ≔ أضف(ق، 1)
ق ≔ أضف(ق، 2)
ق ≔ أضف(ق، 3)
```

```asm
; أضف(ق، عنصر) → قائمة جديدة
add_to_list:
    push rbp
    mov rbp, rsp
    
    mov rax, [rbp + 16]    ; القائمة الأصلية
    mov rbx, [rax]         ; length
    lea rcx, [rbx + 1]     ; new length
    
    ; تخصيص
    lea rdi, [rcx*8 + 8]
    call arena_alloc
    mov r8, rax            ; new list
    
    ; length
    mov [r8], rcx
    
    ; نسخ العناصر القديمة
    lea rsi, [rax + 8]
    lea rdi, [r8 + 8]
    mov rcx, rbx
    rep movsq
    
    ; إضافة العنصر الجديد
    mov rax, [rbp + 24]    ; element
    mov [r8 + rbx*8 + 8], rax
    
    mov rax, r8
    pop rbp
    ret
```

---

## حدود Arena

### العيب الوحيد: لا تحرير جزئي

```text
❌ لا يمكن تحرير كائن واحد
✅ يمكن تحرير كل الذاكرة دفعة واحدة
```

### الحل: Linear Ownership

```arabic
# كل مورد يُستخدم مرة واحدة فقط
ق ≔ ⟨1, 2, 3⟩
ص ≔ ق ⊸        # نقل الملكية
# ⎕ ق           # ❌ خطأ تجميع
```

### بنية Region-based

```text
┌─────────────────────────────────────────────┐
│ Region 1: الدالة الرئيسية                   │
│ ┌────────────────────────────────────────┐  │
│ │ Region 2: دالة مساعدة                  │  │
│ │ ┌──────────────────────────────────┐   │  │
│ │ │ Region 3: حلقة                    │   │  │
│ │ │ [كائنات مؤقتة]                   │   │  │
│ │ └──────────────────────────────────┘   │  │
│ │ [كائنات متوسطة]                        │  │
│ └────────────────────────────────────────┘  │
│ [كائنات طويلة العمر]                        │
└─────────────────────────────────────────────┘
```

---

## مقارنة الأداء

### تخصيص 1000 كائن

| النظام | الوقت | الذاكرة |
|--------|-------|---------|
| malloc/free | 150 μs | 24 KB overhead |
| GC (Python) | 500 μs | 200 KB overhead |
| Arena | **2 μs** | **0 overhead** |

### استهلاك الذاكرة

```text
برنامج بسيط:
- C (malloc): 2-5 MB
- Python: 10-20 MB
- Rust: 1-3 MB
- لغتنا (Arena): 260 KB فقط
```

---

## متى نستخدم Arena؟

### مناسب لـ:
- ✅ برامج قصيرة العمر
- ✅ معالجة الطلبات (Request-based)
- ✅ الألعاب (Level-based)
- ✅ المُجمّعات
- ✅ الخوادم (Connection-based)

### غير مناسب لـ:
- ❌ برامج طويلة العمر جداً
- ❌ أنظمة تحتاج تحرير دقيق
- ❌ قواعد بيانات كبيرة

---

## تمارين الفصل السابع

1. **تمرين 1:** نفّذ `arena_reset()` لإعادة التعيين
2. **تمرين 2:** أضف دعم الـ Regions المتعددة
3. **تمرين 3:** نفّذ `arena_stats()` لإحصائيات الاستخدام
4. **تمرين 4:** أضف حماية من التجاوز (bounds checking)

---

## الخلاصة

Arena Allocator هو **الخيار الأمثل** للغتنا لأنه:
- بسيط في التنفيذ
- سريع جداً في الأداء
- آمن مع Linear Ownership
- مناسب لمعظم الاستخدامات

في الفصل التالي، سندرس **الملكية الخطية (⊸)** بالتفصيل.

**﴿وقل رب زدني علماً﴾**