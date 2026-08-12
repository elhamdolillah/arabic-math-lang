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
    mov rax, 0
    mov [vars + 16], rax
    mov rax, 0
    mov [vars + 24], rax
    mov rax, [vars + 0]
    mov r14, [rax]
    lea rbx, [rax + 8]
.fe_6:
    test r14, r14
    jz .feend_6
    mov rax, [rbx]
    mov [vars + 32], rax
    push rbx
    push r14
    mov rax, [vars + 32]
    push rax
    mov rax, 89
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_4
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_4
.else_4:
    mov rax, [vars + 8]
.end_4:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    push rax
    mov rax, 84
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_5
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_5
.else_5:
    mov rax, [vars + 16]
.end_5:
    mov [vars + 16], rax
    mov rax, [vars + 32]
    push rax
    mov rax, 85
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setl al
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_6
    mov rax, [vars + 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_6
.else_6:
    mov rax, [vars + 24]
.end_6:
    mov [vars + 24], rax
    pop r14
    pop rbx
    add rbx, 8
    dec r14
    jmp .fe_6
.feend_6:
    mov rdi, 27
    call arena_alloc
    mov qword [rax], 19
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 217
    mov byte [rax + 11], 133
    mov byte [rax + 12], 216
    mov byte [rax + 13], 170
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 216
    mov byte [rax + 17], 178
    mov byte [rax + 18], 32
    mov byte [rax + 19], 40
    mov byte [rax + 20], 62
    mov byte [rax + 21], 32
    mov byte [rax + 22], 56
    mov byte [rax + 23], 57
    mov byte [rax + 24], 41
    mov byte [rax + 25], 58
    mov byte [rax + 26], 32
    push rax
    mov rax, [vars + 8]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_13:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_13
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
.ntc_13:
    test rcx, rcx
    jz .ntd_13
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_13
.ntd_13:
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
.cpy1_14:
    test rax, rax
    jz .c1d_14
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_14
.c1d_14:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_14:
    test rax, rax
    jz .c2d_14
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_14
.c2d_14:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 23
    call arena_alloc
    mov qword [rax], 15
    mov byte [rax + 8], 216
    mov byte [rax + 9], 172
    mov byte [rax + 10], 217
    mov byte [rax + 11], 138
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 32
    mov byte [rax + 15], 40
    mov byte [rax + 16], 62
    mov byte [rax + 17], 32
    mov byte [rax + 18], 56
    mov byte [rax + 19], 52
    mov byte [rax + 20], 41
    mov byte [rax + 21], 58
    mov byte [rax + 22], 32
    push rax
    mov rax, [vars + 16]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_15:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_15
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
.ntc_15:
    test rcx, rcx
    jz .ntd_15
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_15
.ntd_15:
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
.cpy1_16:
    test rax, rax
    jz .c1d_16
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_16
.c1d_16:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_16:
    test rax, rax
    jz .c2d_16
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_16
.c2d_16:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 27
    call arena_alloc
    mov qword [rax], 19
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 170
    mov byte [rax + 12], 217
    mov byte [rax + 13], 136
    mov byte [rax + 14], 216
    mov byte [rax + 15], 179
    mov byte [rax + 16], 216
    mov byte [rax + 17], 183
    mov byte [rax + 18], 32
    mov byte [rax + 19], 40
    mov byte [rax + 20], 60
    mov byte [rax + 21], 32
    mov byte [rax + 22], 56
    mov byte [rax + 23], 53
    mov byte [rax + 24], 41
    mov byte [rax + 25], 58
    mov byte [rax + 26], 32
    push rax
    mov rax, [vars + 24]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_17:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_17
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
.ntc_17:
    test rcx, rcx
    jz .ntd_17
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_17
.ntd_17:
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
.cpy1_18:
    test rax, rax
    jz .c1d_18
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_18
.c1d_18:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_18:
    test rax, rax
    jz .c2d_18
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_18
.c2d_18:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
