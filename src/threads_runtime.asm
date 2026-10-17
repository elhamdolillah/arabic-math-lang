; ═══════════════════════════════════════════════════════════
; Runtime للبرمجة المتوازية
; Arabic Mathematical Language - Phase 41
; ═══════════════════════════════════════════════════════════

section .data
    ; Thread-local storage
    thread_id_addr dq 0
    
    ; Channel buffers
    recv_buffer dq 0
    
    ; Error messages
    thread_err db "خطأ في إنشاء الخيط", 10
    thread_err_len equ $ - thread_err
    
    oom_msg db "نفدت الذاكرة", 10
    oom_msg_len equ $ - oom_msg

section .bss
    ; Thread table (up to 256 threads)
    thread_table resq 256
    thread_count resq 1
    
    ; Mutex pool (up to 64 mutexes)
    mutex_pool resq 64
    mutex_count resq 1

section .text

; ═══════════════════════════════════════════════════════════
; Thread Management
; ═══════════════════════════════════════════════════════════

; clone flags
CLONE_VM        equ 0x00000100
CLONE_FS        equ 0x00000200
CLONE_FILES     equ 0x00000400
CLONE_SIGHAND   equ 0x00000800
CLONE_THREAD    equ 0x00010000
CLONE_SYSVSEM   equ 0x00040000
CLONE_PARENT_SETTID  equ 0x00100000
CLONE_CHILD_CLEARTID equ 0x00200000

CLONE_FLAGS equ CLONE_VM | CLONE_FS | CLONE_FILES | \
              CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM | \
              CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID

; ─────────────────────────────────────────────
; create_thread(func_ptr, arg) → thread_id
; ─────────────────────────────────────────────
global create_thread
create_thread:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    ; حفظ المعاملات
    mov [rbp - 8], rdi     ; func_ptr
    mov [rbp - 16], rsi    ; arg
    
    ; تخصيص stack للخيط الجديد (16 KB)
    mov rdi, 16384
    extern arena_alloc
    call arena_alloc
    mov r8, rax
    add r8, 16384          ; stack grows down
    
    ; حفظ func_ptr و arg في stack الجديد
    mov [r8 - 8], qword [rbp - 8]   ; func_ptr
    mov [r8 - 16], qword [rbp - 16] ; arg
    
    ; تجهيز parent_tid و child_tid
    lea rdx, [thread_id_addr]
    lea r10, [thread_id_addr]
    
    ; استدعاء clone
    mov rdi, CLONE_FLAGS
    mov rsi, r8
    ; rdx = parent_tid
    ; r10 = child_tid
    xor r8, r8             ; tls
    mov rax, 56            ; sys_clone
    syscall
    
    ; فحص النتيجة
    test rax, rax
    js .error              ; إذا سالب، خطأ
    jz .child_thread       ; إذا 0، الخيط الجديد
    
    ; الخيط الأصلي
    mov [rbp - 24], rax    ; حفظ thread_id
    
    ; إضافته للجدول
    mov rcx, [thread_count]
    mov [thread_table + rcx*8], rax
    inc qword [thread_count]
    
    mov rax, [rbp - 24]
    leave
    ret

.child_thread:
    ; الخيط الجديد
    ; استرجاع func_ptr و arg من الـ stack
    mov rdi, [rsp + 16376]  ; arg
    mov rax, [rsp + 16384]  ; func_ptr
    call rax
    
    ; الخروج من الخيط
    mov rax, 60
    xor rdi, rdi
    syscall

.error:
    ; طباعة رسالة خطأ
    mov rax, 1
    mov rdi, 2
    lea rsi, [thread_err]
    mov rdx, thread_err_len
    syscall
    mov rax, -1
    leave
    ret

; ─────────────────────────────────────────────
; wait_thread(thread_id)
; ─────────────────────────────────────────────
global wait_thread
wait_thread:
    push rbp
    mov rbp, rsp
    
    ; futex wait على child_tid
    mov rdi, [rbp + 16]      ; thread_id
    ; FUTEX_WAIT = 0
    mov rsi, 0
    xor rdx, rdx             ; expected value
    xor r10, r10             ; timeout = NULL
    mov rax, 202             ; sys_futex
    syscall
    
    leave
    ret

; ═══════════════════════════════════════════════════════════
; Channel Operations
; ═══════════════════════════════════════════════════════════

; ─────────────────────────────────────────────
; create_channel() → channel_handle
; ─────────────────────────────────────────────
global create_channel
create_channel:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    
    ; pipe2(fds, O_DIRECT)
    mov rdi, rsp
    mov rsi, 0x4000          ; O_DIRECT
    mov rax, 293             ; sys_pipe2
    syscall
    
    ; حفظ fds
    mov r8, [rsp]            ; read fd
    mov r9, [rsp + 8]        ; write fd
    
    ; إنشاء channel object
    mov rdi, 24
    extern arena_alloc
    call arena_alloc
    mov [rax], r8            ; read_fd
    mov [rax + 8], r9        ; write_fd
    mov qword [rax + 16], 0  ; closed = false
    
    add rsp, 16
    leave
    ret

; ─────────────────────────────────────────────
; channel_send(channel, value)
; ─────────────────────────────────────────────
global channel_send
channel_send:
    push rbp
    mov rbp, rsp
    
    mov rdi, [rdi + 8]       ; write_fd
    ; rsi = value (pointer to 8 bytes)
    mov rdx, 8
    mov rax, 1               ; sys_write
    syscall
    
    leave
    ret

; ─────────────────────────────────────────────
; channel_recv(channel) → value
; ─────────────────────────────────────────────
global channel_recv
channel_recv:
    push rbp
    mov rbp, rsp
    
    mov rdi, [rdi]           ; read_fd
    lea rsi, [recv_buffer]
    mov rdx, 8
    mov rax, 0               ; sys_read
    syscall
    
    mov rax, [recv_buffer]
    leave
    ret

; ═══════════════════════════════════════════════════════════
; Mutex Operations
; ═══════════════════════════════════════════════════════════

; FUTEX constants
FUTEX_WAIT equ 0
FUTEX_WAKE equ 1

; ─────────────────────────────────────────────
; create_mutex() → mutex_handle
; ─────────────────────────────────────────────
global create_mutex
create_mutex:
    push rbp
    mov rbp, rsp
    
    mov rdi, 8
    extern arena_alloc
    call arena_alloc
    mov qword [rax], 0       ; unlocked = 0
    
    leave
    ret

; ─────────────────────────────────────────────
; mutex_lock(mutex)
; ─────────────────────────────────────────────
global mutex_lock
mutex_lock:
    push rbp
    mov rbp, rsp

.try_lock:
    xor esi, esi             ; expected = 0 (unlocked)
    mov edx, 1               ; desired = 1 (locked)
    lock cmpxchg [rdi], rdx
    jz .acquired
    
    ; FUTEX_WAIT
    mov rsi, FUTEX_WAIT
    mov edx, 1               ; expected value
    xor r10, r10             ; timeout = NULL
    mov rax, 202             ; sys_futex
    syscall
    
    jmp .try_lock

.acquired:
    leave
    ret

; ─────────────────────────────────────────────
; mutex_unlock(mutex)
; ─────────────────────────────────────────────
global mutex_unlock
mutex_unlock:
    push rbp
    mov rbp, rsp
    
    mov qword [rdi], 0       ; unlocked
    
    ; FUTEX_WAKE
    mov rsi, FUTEX_WAKE
    mov edx, 1               ; wake 1 waiter
    mov rax, 202
    syscall
    
    leave
    ret

; ═══════════════════════════════════════════════════════════
; Utility Functions
; ═══════════════════════════════════════════════════════════

; ─────────────────────────────────────────────
; sleep_ms(milliseconds)
; ─────────────────────────────────────────────
global sleep_ms
sleep_ms:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    
    ; nanosleep
    mov [rsp], rdi           ; seconds (0)
    mov rax, rdi
    mov rdx, 1000000
    mul rdx                  ; milliseconds to nanoseconds
    mov [rsp + 8], rax       ; nanoseconds
    
    mov rdi, rsp             ; req
    xor rsi, rsi             ; rem = NULL
    mov rax, 35              ; sys_nanosleep
    syscall
    
    leave
    ret