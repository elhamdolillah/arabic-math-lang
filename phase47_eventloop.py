# -*- coding: utf-8 -*-
# المسار: phase47_eventloop.py
"""
Event Loop للبرمجة غير المتزامنة
يُولّد كود x86_64 Assembly يعتمد على epoll syscalls
لا يحتاج libc — يعتمد على syscalls خام فقط

Syscalls المستخدمة:
  • epoll_create1(0)     → 291
  • epoll_ctl(epfd, op, fd, event) → 233
  • epoll_wait(epfd, events, max, timeout) → 232
  • eventfd(0, 0)        → 290 (لـ Futures)
"""

# ═══════════════════════════════════════════════════════════
# Syscall Numbers (Linux x86_64)
# ═══════════════════════════════════════════════════════════
SYS_READ        = 0
SYS_WRITE       = 1
SYS_CLOSE       = 3
SYS_MMAP        = 9
SYS_CLONE       = 56
SYS_WAIT4       = 61
SYS_EPOLL_CTL   = 233
SYS_EPOLL_WAIT  = 232
SYS_EPOLL_CREATE1 = 291
SYS_EVENTFD2    = 290
SYS_PIPE2       = 293

# EPOLL_CTL operations
EPOLL_CTL_ADD = 1
EPOLL_CTL_DEL = 2
EPOLL_CTL_MOD = 3

# EPOLL events
EPOLLIN  = 0x001
EPOLLOUT = 0x004
EPOLLERR = 0x008

# Future states
FUTURE_PENDING  = 0
FUTURE_RESOLVED = 1
FUTURE_FAILED   = 2

# ═══════════════════════════════════════════════════════════
# توليد كود Event Loop Assembly
# ═══════════════════════════════════════════════════════════
def توليد_كود_إيفنت_لوب():
    """
    توليد كود Assembly لـ Event Loop باستخدام epoll
    يُضاف إلى نهاية math_complete.py كـ functions مساعدة
    """
    كود = [
        # ═══ Event Loop Runtime ═══
        "; ═══════════════════════════════════════════════════════════",
        "; Event Loop Runtime — المرحلة 47",
        "; ═══════════════════════════════════════════════════════════",
        "",
        "; إنشاء epoll instance",
        "create_event_loop:",
        "    push rbx",
        "    push r12",
        "    xor rdi, rdi                ; flags = 0",
        f"    mov rax, {SYS_EPOLL_CREATE1}",
        "    syscall",
        "    test rax, rax",
        "    js .epoll_fail",
        "    mov r12, rax                ; حفظ epfd",
        "",
        "; تخصيص Future registry (8 futures كحد أقصى)",
        "    mov rdi, 512                ; 8 * 64 bytes",
        "    call arena_alloc",
        "    mov [future_registry], rax",
        "",
        "; تخصيص epoll_events buffer",
        "    mov rdi, 256                ; 16 events * 16 bytes",
        "    call arena_alloc",
        "    mov [epoll_events_buf], rax",
        "",
        "    mov rax, r12",
        "    pop r12",
        "    pop rbx",
        "    ret",
        "",
        ".epoll_fail:",
        "    mov rax, 60",
        "    mov rdi, 9",
        "    syscall",
        "",
        # ═══ Future Creation ═══
        "; إنشاء Future جديد — يُرجع مؤشر Future",
        "; Future layout: [state:8][value:8][eventfd:8][callback:8][padding:32]",
        "create_future:",
        "    push rbx",
        "    push r12",
        "    mov rdi, 64",
        "    call arena_alloc",
        "    mov r12, rax                ; future ptr",
        "",
        "; إنشاء eventfd للـ future",
        "    xor rdi, rdi                ; initval = 0",
        "    xor rsi, rsi                ; flags = 0",
        f"    mov rax, {SYS_EVENTFD2}",
        "    syscall",
        "    test rax, rax",
        "    js .future_fd_fail",
        "",
        "; تهيئة Future",
        f"    mov qword [r12 + 0], {FUTURE_PENDING}   ; state",
        "    mov qword [r12 + 8], 0              ; value",
        "    mov [r12 + 16], rax               ; eventfd",
        "    mov qword [r12 + 24], 0           ; callback",
        "",
        "    mov rax, r12",
        "    pop r12",
        "    pop rbx",
        "    ret",
        "",
        ".future_fd_fail:",
        "    mov rax, 60",
        "    mov rdi, 10",
        "    syscall",
        "",
        # ═══ Resolve Future ═══
        "; حل Future بقيمة — resolve_future(future, value)",
        "resolve_future:",
        "    push rbx",
        "    mov rbx, rdi                ; future ptr",
        f"    mov qword [rbx + 0], {FUTURE_RESOLVED}",
        "    mov [rbx + 8], rsi            ; value",
        "",
        "; كتابة إلى eventfd لإيقاظ الـ event loop",
        "    lea rsi, [rel future_wake_buf]",
        "    mov qword [rsi], 1",
        "    mov rdi, [rbx + 16]           ; eventfd",
        "    mov rdx, 8",
        f"    mov rax, {SYS_WRITE}",
        "    syscall",
        "    pop rbx",
        "    ret",
        "",
        # ═══ Await Future ═══
        "; انتظار Future — await_future(future) → value",
        "await_future:",
        "    push rbx",
        "    push r12",
        "    mov rbx, rdi                ; future ptr",
        "",
        ".await_loop:",
        "    cmp qword [rbx + 0], 0",
        f"    jne .await_done",
        "",
        "; قراءة من eventfd (blocking)",
        "    mov rdi, [rbx + 16]           ; eventfd",
        "    lea rsi, [rel future_wake_buf]",
        "    mov rdx, 8",
        f"    mov rax, {SYS_READ}",
        "    syscall",
        "    jmp .await_loop",
        "",
        ".await_done:",
        f"    cmp qword [rbx + 0], {FUTURE_FAILED}",
        "    je .await_failed",
        "    mov rax, [rbx + 8]            ; value",
        "    pop r12",
        "    pop rbx",
        "    ret",
        "",
        ".await_failed:",
        "    mov rax, 60",
        "    mov rdi, 11",
        "    syscall",
        "",
        # ═══ Run Event Loop ═══
        "; تشغيل Event Loop — run_event_loop(epfd, timeout_ms)",
        "run_event_loop:",
        "    push rbx",
        "    push r12",
        "    push r13",
        "    mov r12, rdi                ; epfd",
        "    mov r13d, esi               ; timeout_ms",
        "",
        ".loop:",
        "    mov rdi, r12",
        "    mov rsi, [epoll_events_buf]",
        "    mov rdx, 16                 ; max events",
        "    mov r10d, r13d",
        f"    mov rax, {SYS_EPOLL_WAIT}",
        "    syscall",
        "    test rax, rax",
        "    jle .loop_end",
        "",
        "; معالجة الأحداث",
        "    mov rcx, rax",
        "    mov rbx, [epoll_events_buf]",
        ".process_events:",
        "    ; TODO: dispatch to callbacks",
        "    add rbx, 16",
        "    dec rcx",
        "    jnz .process_events",
        "    jmp .loop",
        "",
        ".loop_end:",
        "    pop r13",
        "    pop r12",
        "    pop rbx",
        "    ret",
    ]
    return "\n".join(كود)

# ═══════════════════════════════════════════════════════════
# متغيرات BSS مطلوبة
# ═══════════════════════════════════════════════════════════
BSS_VARIABLES = [
    "    future_registry resq 1     ; مؤشر جدول Futures",
    "    epoll_events_buf resq 1    ; buffer لأحداث epoll",
    "    future_wake_buf resq 1     ; buffer لإيقاظ eventfd",
]

def جلب_BSS():
    """إرجاع سطور BSS المطلوبة"""
    return BSS_VARIABLES

# ═══════════════════════════════════════════════════════════
# إحصائيات
# ═══════════════════════════════════════════════════════════
SYSCALLS_USED = {
    "epoll_create1": SYS_EPOLL_CREATE1,
    "epoll_ctl": SYS_EPOLL_CTL,
    "epoll_wait": SYS_EPOLL_WAIT,
    "eventfd2": SYS_EVENTFD2,
    "read": SYS_READ,
    "write": SYS_WRITE,
}

def عدد_syscalls():
    return len(SYSCALLS_USED)
