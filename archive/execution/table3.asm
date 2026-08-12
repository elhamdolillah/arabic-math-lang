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
.fe_4:
    test r14, r14
    jz .feend_4
    mov rax, [rbx]
    mov [vars + 16], rax
    push rbx
    push r14
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 8]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 24], rax
    mov rax, [vars + 24]
    cmp rax, 0
    je .else_2
    mov rax, [vars + 16]
    jmp .end_2
.else_2:
    mov rax, [vars + 8]
.end_2:
    mov [vars + 8], rax
    pop r14
    pop rbx
    add rbx, 8
    dec r14
    jmp .fe_4
.feend_4:
    mov rax, 999
    mov [vars + 32], rax
    mov rax, [vars + 0]
    mov r14, [rax]
    lea rbx, [rax + 8]
.fe_5:
    test r14, r14
    jz .feend_5
    mov rax, [rbx]
    mov [vars + 16], rax
    push rbx
    push r14
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 32]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setl al
    mov [vars + 24], rax
    mov rax, [vars + 24]
    cmp rax, 0
    je .else_3
    mov rax, [vars + 16]
    jmp .end_3
.else_3:
    mov rax, [vars + 32]
.end_3:
    mov [vars + 32], rax
    pop r14
    pop rbx
    add rbx, 8
    dec r14
    jmp .fe_5
.feend_5:
    mov rdi, 27
    call arena_alloc
    mov qword [rax], 19
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    mov byte [rax + 14], 217
    mov byte [rax + 15], 137
    mov byte [rax + 16], 32
    mov byte [rax + 17], 216
    mov byte [rax + 18], 175
    mov byte [rax + 19], 216
    mov byte [rax + 20], 177
    mov byte [rax + 21], 216
    mov byte [rax + 22], 172
    mov byte [rax + 23], 216
    mov byte [rax + 24], 169
    mov byte [rax + 25], 58
    mov byte [rax + 26], 32
    push rax
    mov rax, [vars + 8]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_9:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_9
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
.ntc_9:
    test rcx, rcx
    jz .ntd_9
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_9
.ntd_9:
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
.cpy1_10:
    test rax, rax
    jz .c1d_10
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_10
.c1d_10:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_10:
    test rax, rax
    jz .c2d_10
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_10
.c2d_10:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 27
    call arena_alloc
    mov qword [rax], 19
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 216
    mov byte [rax + 11], 175
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 217
    mov byte [rax + 15], 137
    mov byte [rax + 16], 32
    mov byte [rax + 17], 216
    mov byte [rax + 18], 175
    mov byte [rax + 19], 216
    mov byte [rax + 20], 177
    mov byte [rax + 21], 216
    mov byte [rax + 22], 172
    mov byte [rax + 23], 216
    mov byte [rax + 24], 169
    mov byte [rax + 25], 58
    mov byte [rax + 26], 32
    push rax
    mov rax, [vars + 32]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_11:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_11
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
.ntc_11:
    test rcx, rcx
    jz .ntd_11
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_11
.ntd_11:
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
.cpy1_12:
    test rax, rax
    jz .c1d_12
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_12
.c1d_12:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_12:
    test rax, rax
    jz .c2d_12
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_12
.c2d_12:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
