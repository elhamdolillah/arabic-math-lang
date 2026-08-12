global _start
section .bss
    vars resq 256
    num_buf resb 32
    arena_ptr resq 1
    arena_mem resb 262144

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
.piloop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .piloop
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

print_str:
    push rax
    push rdx
    push rsi
    push rdi
    mov rsi, rax
    add rsi, 8
    mov rdx, [rax]
    mov rdi, 1
    mov rax, 1
    syscall
    mov rsi, nl_ptr
    mov rdx, 1
    mov rdi, 1
    mov rax, 1
    syscall
    pop rdi
    pop rsi
    pop rdx
    pop rax
    ret

section .data
nl_ptr: db 10
section .text

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
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 216
    mov byte [rax + 9], 168
    mov byte [rax + 10], 216
    mov byte [rax + 11], 167
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    mov byte [rax + 14], 216
    mov byte [rax + 15], 185
    mov byte [rax + 16], 216
    mov byte [rax + 17], 177
    mov byte [rax + 18], 216
    mov byte [rax + 19], 168
    mov byte [rax + 20], 217
    mov byte [rax + 21], 138
    mov byte [rax + 22], 216
    mov byte [rax + 23], 169
    push rax
    pop rdi
    mov r10, [vars + 0]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    call print_int

    mov rax, 60
    xor rdi, rdi
    syscall

func_0:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 216
    mov byte [rax + 13], 173
    mov byte [rax + 14], 216
    mov byte [rax + 15], 168
    mov byte [rax + 16], 216
    mov byte [rax + 17], 167
    mov byte [rax + 18], 32
    push rax
    mov rax, [rbp - 8]
    mov r11, rax
    pop r10
    push r10
    push r11
    mov rax, [r10]
    add rax, [r11]
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov r12, rax
    mov rax, [r10]
    add rax, [r11]
    mov [r12], rax
    mov rax, [r10]
    lea rsi, [r10 + 8]
    lea rdi, [r12 + 8]
.cpy1_3:
    test rax, rax
    jz .c1d_3
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_3
.c1d_3:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_3:
    test rax, rax
    jz .c2d_3
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_3
.c2d_3:
    pop r11
    pop r10
    mov rax, r12
    leave
    ret