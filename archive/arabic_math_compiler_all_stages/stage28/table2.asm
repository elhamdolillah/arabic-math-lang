global _start
section .bss
    vars resq 256
    num_buf resb 32
    read_buf resb 256
    file_path_buf resb 256
    file_buf resb 4096
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

    mov rdi, 48
    call arena_alloc
    push rax
    mov qword [rax], 5
    mov rax, 90
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 85
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 95
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rax, 88
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 32], rcx
    mov rax, 92
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 40], rcx
    pop rax
    mov [vars + 0], rax
    mov rax, 0
    mov [vars + 8], rax
    mov rax, [vars + 0]
    mov r14, [rax]
    lea rbx, [rax + 8]
.fe_3:
    test r14, r14
    jz .feend_3
    mov rax, [rbx]
    mov [vars + 16], rax
    push rbx
    push r14
    mov rax, [vars + 16]
    push rax
    mov rax, 89
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 24], rax
    mov rax, [vars + 24]
    cmp rax, 0
    je .else_1
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_1
.else_1:
    mov rax, [vars + 8]
.end_1:
    mov [vars + 8], rax
    pop r14
    pop rbx
    add rbx, 8
    dec r14
    jmp .fe_3
.feend_3:
    mov rdi, 42
    call arena_alloc
    mov qword [rax], 34
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 216
    mov byte [rax + 11], 175
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 32
    mov byte [rax + 15], 216
    mov byte [rax + 16], 167
    mov byte [rax + 17], 217
    mov byte [rax + 18], 132
    mov byte [rax + 19], 217
    mov byte [rax + 20], 133
    mov byte [rax + 21], 217
    mov byte [rax + 22], 133
    mov byte [rax + 23], 216
    mov byte [rax + 24], 170
    mov byte [rax + 25], 216
    mov byte [rax + 26], 167
    mov byte [rax + 27], 216
    mov byte [rax + 28], 178
    mov byte [rax + 29], 217
    mov byte [rax + 30], 138
    mov byte [rax + 31], 217
    mov byte [rax + 32], 134
    mov byte [rax + 33], 32
    mov byte [rax + 34], 40
    mov byte [rax + 35], 62
    mov byte [rax + 36], 32
    mov byte [rax + 37], 56
    mov byte [rax + 38], 57
    mov byte [rax + 39], 41
    mov byte [rax + 40], 58
    mov byte [rax + 41], 32
    push rax
    mov rax, [vars + 8]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_7:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_7
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
.ntc_7:
    test rcx, rcx
    jz .ntd_7
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_7
.ntd_7:
    pop rax
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
.cpy1_8:
    test rax, rax
    jz .c1d_8
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_8
.c1d_8:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_8:
    test rax, rax
    jz .c2d_8
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_8
.c2d_8:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
