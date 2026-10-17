global _start
section .bss
    vars resq 256
    num_buf resb 32

section .text
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
    mov rax, func_0
    mov [vars + 0], rax
    mov rax, 5
    push rax
    pop rdi
    mov r10, [vars + 0]
    call r10
    call print_int

    mov rax, 60
    xor rdi, rdi
    syscall

func_0:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rax, [rbp - 8]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    je .else_2
    mov rax, 1
    jmp .end_2
.else_2:
    mov rax, [rbp - 8]
    push rax
    mov rax, [rbp - 8]
    push rax
    mov rax, 1
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    pop rdi
    mov r10, [vars + 0]
    call r10
    pop rbx
    imul rax, rbx
.end_2:
    leave
    ret