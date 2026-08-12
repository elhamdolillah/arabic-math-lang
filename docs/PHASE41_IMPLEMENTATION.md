# ⚡ المرحلة 41: البرمجة المتوازية - التنفيذ الفعلي
## Threads, Channels, and Mutexes in Arabic Math Language

---

## 🎯 الهدف

إضافة دعم كامل للبرمجة المتوازية:
- **Threads** (الخيوط) عبر `clone` syscall
- **Channels** (القنوات) عبر `pipe2` syscall
- **Mutexes** (المزاليج) عبر `futex` syscall

---

## 📐 التصميم

### 1. الصياغة المقترحة

```arabic
# ═══ Threads ═══
# إنشاء thread
عامل ≡ λ(). ﴿
    ⎕ "مرحباً من الخيط"
﴾
خيط ≔ خيط(عامل)

# انتظار
انتظر(خيط)

# ═══ Channels ═══
# إنشاء قناة
ق ≔ قناة()

# إرسال واستقبال
أرسل(ق، 42)
قيمة ≔ استقبل(ق)

# ═══ Mutexes ═══
قفل ≔ مزلاج()
أغلق(قفل)
# ... منطقة حرجة ...
افتح(قفل)
```

### 2. الـ syscalls المطلوبة

```asm
; Linux x86_64 syscalls
sys_clone    equ 56     ; إنشاء thread
sys_futex    equ 202    ; mutex operations
sys_pipe2    equ 293    ; channels
sys_wait4    equ 61     ; انتظار process/thread
sys_exit     equ 60     ; خروج thread
```

---

## 🔧 التنفيذ التقني

### 1. Threads عبر clone

#### الـ flags المطلوبة

```asm
CLONE_VM        equ 0x00000100   ; مشاركة الذاكرة
CLONE_FS        equ 0x00000200   ; مشاركة filesystem info
CLONE_FILES     equ 0x00000400   ; مشاركة file descriptors
CLONE_SIGHAND   equ 0x00000800   ; مشاركة signal handlers
CLONE_THREAD    equ 0x00010000   ; نفس thread group
CLONE_SYSVSEM   equ 0x00040000   ; مشاركة SEM_UNDO
CLONE_PARENT_SETTID  equ 0x00100000
CLONE_CHILD_CLEARTID equ 0x00200000

; الـ flags المُجتمعة
CLONE_FLAGS equ CLONE_VM | CLONE_FS | CLONE_FILES | \
              CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM | \
              CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID
```

#### كود إنشاء thread

```asm
; create_thread(func_ptr, arg) → thread_id
create_thread:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    
    ; تخصيص stack للخيط الجديد (16 KB)
    mov rdi, 16384
    call arena_alloc
    mov r8, rax
    add r8, 16384        ; stack grows down
    
    ; حفظ func_ptr و arg
    mov [rbp - 8], rdi   ; func_ptr
    mov [rbp - 16], rsi  ; arg
    
    ; تجهيز المعاملات لـ clone
    mov rdi, CLONE_FLAGS       ; flags
    mov rsi, r8                ; stack pointer
    mov rdx, [thread_id_addr]  ; parent_tid
    mov r10, [thread_id_addr]  ; child_tid
    mov r8, 0                  ; tls
    
    mov rax, 56                ; sys_clone
    syscall
    
    ; rax = 0 في الخيط الجديد
    ; rax = thread_id في الخيط الأصلي
    test rax, rax
    jnz .parent
    
.child:
    ; الخيط الجديد
    mov rdi, [rbp - 16]        ; arg
    call [rbp - 8]             ; func_ptr(arg)
    
    ; الخروج من الخيط
    mov rax, 60                ; sys_exit
    xor rdi, rdi
    syscall
    
.parent:
    ; الخيط الأصلي — rax يحتوي thread_id
    leave
    ret
```

### 2. Channels عبر pipe2

```asm
; create_channel() → channel_handle
create_channel:
    sub rsp, 16
    
    ; pipe2(fds, O_DIRECT)
    mov rdi, rsp               ; int fds[2]
    mov rsi, 0x4000            ; O_DIRECT
    mov rax, 293               ; sys_pipe2
    syscall
    
    ; حفظ fds
    mov r8, [rsp]              ; read fd
    mov r9, [rsp + 8]          ; write fd
    
    ; إنشاء channel object في arena
    mov rdi, 24
    call arena_alloc
    mov [rax], r8              ; read_fd
    mov [rax + 8], r9          ; write_fd
    mov qword [rax + 16], 0    ; closed = false
    
    add rsp, 16
    ret

; send(channel, value)
channel_send:
    mov rdi, [rsi + 8]         ; write_fd
    mov rsi, rdx               ; value (pointer)
    mov rdx, 8                 ; size
    mov rax, 1                 ; sys_write
    syscall
    ret

; receive(channel) → value
channel_recv:
    mov rdi, [rsi]             ; read_fd
    lea rsi, [recv_buffer]
    mov rdx, 8
    mov rax, 0                 ; sys_read
    syscall
    mov rax, [recv_buffer]
    ret
```

### 3. Mutexes عبر futex

```asm
; create_mutex() → mutex_handle
create_mutex:
    mov rdi, 8
    call arena_alloc
    mov qword [rax], 0         ; unlocked = 0
    ret

; lock(mutex)
mutex_lock:
.lock_loop:
    xor esi, esi               ; expected = 0 (unlocked)
    mov edx, 1                 ; desired = 1 (locked)
    lock cmpxchg [rdi], rdx
    jz .acquired               ; إذا نجح، اكتسبنا القفل
    
    ; انتظار حتى يتغير
    mov esi, 0                 ; FUTEX_WAIT
    mov edx, 1                 ; expected value
    xor r10, r10               ; timeout = NULL
    mov rax, 202               ; sys_futex
    syscall
    
    jmp .lock_loop

.acquired:
    ret

; unlock(mutex)
mutex_unlock:
    mov qword [rdi], 0         ; unlocked
    
    ; إيقاظ منتظر واحد
    mov rsi, 1                 ; FUTEX_WAKE
    mov edx, 1                 ; wake 1 waiter
    mov rax, 202
    syscall
    ret
```

---

## 📝 تحديث المُجمّع

### 1. Lexer: إضافة رموز جديدة

```python
# إضافة للكلمات المحجوزة
KEYWORDS = {
    'خيط': 'THREAD',
    'قناة': 'CHANNEL',
    'مزلاج': 'MUTEX',
    'أرسل': 'SEND',
    'استقبل': 'RECV',
    'انتظر': 'WAIT',
    'أغلق': 'LOCK',
    'افتح': 'UNLOCK',
}
```

### 2. Parser: معالجة الصياغة الجديدة

```python
def parse_thread_create(self):
    self.expect('KW', 'خيط')
    self.expect('OP', '(')
    func = self.parse_expr()
    self.expect('OP', ')')
    return ('thread_create', func)

def parse_channel_ops(self):
    if self.peek().value == 'أرسل':
        self.advance()
        self.expect('OP', '(')
        channel = self.parse_expr()
        self.expect('OP', ',')
        value = self.parse_expr()
        self.expect('OP', ')')
        return ('channel_send', channel, value)
    # ... إلخ
```

### 3. CodeGen: توليد الكود

```python
def compile_thread_create(self, func):
    label = self.new_label("thread_func")
    
    # توليد الدالة
    self.emit(f"{label}:")
    self.compile_function_body(func)
    
    # استدعاء create_thread
    self.emit(f"    mov rdi, {label}")
    self.emit(f"    xor rsi, rsi")
    self.emit(f"    call create_thread")
```

---

## 🧪 أمثلة الاختبار

### مثال 1: Thread بسيط

```arabic
# thread_simple.ar
عامل ≡ λ(). ﴿
    ع ≔ 1
    ⋄ μ ع <= 5 : ﴿
        ⎕ "خيط: " ⊕ نص(ع)
        ⋄ ع ≔ ع + 1
    ﴾
﴾

خ ≔ خيط(عامل)
⎕ "الخيط الرئيسي"
انتظر(خ)
⎕ "انتهى"
```

### مثال 2: Channel بين خيطَين

```arabic
# channel_example.ar
ق ≔ قناة()

مرسل ≡ λ(). ﴿
    ع ≔ 1
    ⋄ μ ع <= 5 : ﴿
        أرسل(ق، ع)
        ⋄ ع ≔ ع + 1
    ﴾
    ⋄ أرسل(ق، 0)   # إشارة الانتهاء
﴾

مستقبل ≡ λ(). ﴿
    μ 1 = 1 : ﴿
        قيمة ≔ استقبل(ق)
        ⋄ م ≔ قيمة = 0
        ⋄ م ؟ ﴿ ⎕ "انتهى" ﴾ : ﴿ ⎕ "استلمت: " ⊕ نص(قيمة) ﴾
    ﴾
﴾

خ١ ≔ خيط(مرسل)
خ٢ ≔ خيط(مستقبل)
انتظر(خ١)
انتظر(خ٢)
```

### مثال 3: Mutex للعدّاد المشترك

```arabic
# mutex_example.ar
قفل ≔ مزلاج()
عداد ≔ 0

عامل ≡ λ(). ﴿
    ع ≔ 1
    ⋄ μ ع <= 1000 : ﴿
        أغلق(قفل)
        ⋄ عداد ≔ عداد + 1
        ⋄ افتح(قفل)
        ⋄ ع ≔ ع + 1
    ﴾
﴾

خ١ ≔ خيط(عامل)
خ٢ ≔ خيط(عامل)
انتظر(خ١)
انتظر(خ٢)
⎕ "العداد النهائي: " ⊕ نص(عداد)  # يجب أن يكون 2000
```

---

## 📋 خارطة الطريق

### الأسبوع 1: الأساسيات
- [x] التصميم الأولي
- [ ] إضافة syscalls للـ runtime
- [ ] تحديث Lexer
- [ ] تحديث Parser

### الأسبوع 2: Threads
- [ ] تنفيذ `clone` wrapper
- [ ] اختبار thread creation
- [ ] تنفيذ `join` (انتظار)
- [ ] اختبار متعدد الخيوط

### الأسبوع 3: Channels
- [ ] تنفيذ `pipe2` wrapper
- [ ] اختبار send/receive
- [ ] قنوات متعددة
- [ ] buffered channels

### الأسبوع 4: Mutexes
- [ ] تنفيذ `futex` wrapper
- [ ] اختبار lock/unlock
- [ ] اختبار race conditions
- [ ] تحسين الأداء

### الأسبوع 5: التوثيق والنشر
- [ ] كتابة التوثيق
- [ ] أمثلة شاملة
- [ ] اختبار نهاية لنهاية
- [ ] النشر كإصدار v41.0

---

## ⚠️ التحديات

### 1. Arena المشترك

**المشكلة:** Arena الحالي مشترك بين جميع الـ threads.

**الحل:**
- استخدام mutex لحماية الـ arena
- أو: arena لكل thread مع region-based cleanup

### 2. Linear Ownership عبر الـ threads

**المشكلة:** كيف ننقل الملكية بين threads؟

**الحل:**
- `Send` trait: فقط القيم الآمنة تُنقل
- Channels تنقل الملكية تلقائياً

### 3. Error Handling

**المشكلة:** كيف نبلّغ عن خطأ في خيط آخر؟

**الحل:**
- Result channels: `channel<Result<T, Error>>`
- Thread panic handlers

---

## 📊 مقارنة مع لغات أخرى

| الميزة | لغتنا | Rust | Go | Java |
|--------|-------|------|----|------|
| Thread creation | `clone` | `std::thread` | `go` | `Thread` |
| Channels | pipe2 | mpsc | channels | BlockingQueue |
| Mutexes | futex | `Mutex` | `sync.Mutex` | `synchronized` |
| Memory model | Linear | Ownership | GC | GC |
| Safety | Compile-time | Compile-time | Runtime | Runtime |

---

## 🎯 النجاح

عند إكمال هذه المرحلة، ستكون لغتنا:
- ✅ تدعم التوازي الكامل
- ✅ آمنة في بيئة متعددة الخيوط
- ✅ قادرة على معالجة مشاكل العالم الحقيقي
- ✅ منافساً حقيقياً للغات الحديثة

**﴿وقل رب زدني علماً﴾**