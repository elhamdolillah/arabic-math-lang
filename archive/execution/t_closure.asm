global _start
section .bss
    vars resq 256
    num_buf resb 32
    arena_ptr resq 1
    arena_mem resb 65536

section .text
arena_alloc:
    mov rax, [arena_ptr]
    add rdi, 15
    and rdi, -16
    add [arena_ptr], rdi
    ret

print_int:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .loop
    mov rsi, rdi
    mov byte [rsi + rcx], 10
    inc rcx
    mov rdi, 1
    mov rax, 1
    mov rdx, rcx
    syscall
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

_start:
    lea rax, [arena_mem]
    mov [arena_ptr], rax

    mov rdi, 8
    call arena_alloc
    push rax
    mov rcx, func_0
    mov [rax], rcx
    pop rax
    mov [vars + 0], rax
    mov rax, 10
    push rax
    pop rdi
    mov r10, [vars + 0]
    push r15
    mov r15, [r10 + 8]
    mov r10, [r10]
    call r10
    pop r15
    mov [vars + 8], rax
    mov rax, 5
    push rax
    pop rdi
    mov r10, [vars + 8]
    push r15
    mov r15, [r10 + 8]
    mov r10, [r10]
    call r10
    pop r15
    call print_int

    mov rax, 60
    xor rdi, rdi
    syscall

func_1:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rax, [r15 + 8]
    push rax
    mov rax, [rbp - 8]
    pop rbx
    add rax, rbx
    leave
    ret
func_0:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rdi, 16
    call arena_alloc
    push rax
    mov rcx, func_1
    mov [rax], rcx
    mov rcx, [rbp - 8]
    mov [rax + 8], rcx
    pop rax
    leave
    ret