global _start
section .bss
    vars resq 256
    num_buf resb 32
    negflag resb 1
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

    mov rax, 2
    mov [vars + 0], rax
    mov rax, 1
    mov [vars + 8], rax
    mov rax, 1
    mov [vars + 16], rax
    mov rax, 1
    mov [vars + 24], rax
    mov rax, 1
    mov [vars + 32], rax
    mov rax, 0
    push rax
    mov rax, 1
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 40], rax
    mov rax, 0
    push rax
    mov rax, 1
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 48], rax
    mov rax, 2
    mov [vars + 56], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 64], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 72], rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 80], rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 88], rax
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 65
    mov byte [rax + 9], 32
    mov byte [rax + 10], 195
    mov byte [rax + 11], 151
    mov byte [rax + 12], 32
    mov byte [rax + 13], 65
    mov byte [rax + 14], 226
    mov byte [rax + 15], 129
    mov byte [rax + 16], 187
    mov byte [rax + 17], 194
    mov byte [rax + 18], 185
    mov byte [rax + 19], 58
    call print_str
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 91
    push rax
    mov rax, [vars + 64]
    test rax, rax
    jns .npos_17
    neg rax
    mov byte [negflag], 1
.npos_17:
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
    cmp byte [negflag], 1
    jne .nskip2_17
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_17:
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
    mov byte [negflag], 0
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
    push rax
    mov rdi, 10
    call arena_alloc
    mov qword [rax], 2
    mov byte [rax + 8], 44
    mov byte [rax + 9], 32
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
.cpy1_19:
    test rax, rax
    jz .c1d_19
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_19
.c1d_19:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_19:
    test rax, rax
    jz .c2d_19
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_19
.c2d_19:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 72]
    test rax, rax
    jns .npos_20
    neg rax
    mov byte [negflag], 1
.npos_20:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_20:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_20
    cmp byte [negflag], 1
    jne .nskip2_20
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_20:
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
.ntc_20:
    test rcx, rcx
    jz .ntd_20
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_20
.ntd_20:
    mov byte [negflag], 0
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
.cpy1_21:
    test rax, rax
    jz .c1d_21
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_21
.c1d_21:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_21:
    test rax, rax
    jz .c2d_21
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_21
.c2d_21:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 93
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
.cpy1_22:
    test rax, rax
    jz .c1d_22
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_22
.c1d_22:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_22:
    test rax, rax
    jz .c2d_22
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_22
.c2d_22:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 91
    push rax
    mov rax, [vars + 80]
    test rax, rax
    jns .npos_23
    neg rax
    mov byte [negflag], 1
.npos_23:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_23:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_23
    cmp byte [negflag], 1
    jne .nskip2_23
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_23:
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
.ntc_23:
    test rcx, rcx
    jz .ntd_23
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_23
.ntd_23:
    mov byte [negflag], 0
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
.cpy1_24:
    test rax, rax
    jz .c1d_24
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_24
.c1d_24:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_24:
    test rax, rax
    jz .c2d_24
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_24
.c2d_24:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 10
    call arena_alloc
    mov qword [rax], 2
    mov byte [rax + 8], 44
    mov byte [rax + 9], 32
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
.cpy1_25:
    test rax, rax
    jz .c1d_25
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_25
.c1d_25:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_25:
    test rax, rax
    jz .c2d_25
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_25
.c2d_25:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 88]
    test rax, rax
    jns .npos_26
    neg rax
    mov byte [negflag], 1
.npos_26:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_26:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_26
    cmp byte [negflag], 1
    jne .nskip2_26
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_26:
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
.ntc_26:
    test rcx, rcx
    jz .ntd_26
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_26
.ntd_26:
    mov byte [negflag], 0
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
.cpy1_27:
    test rax, rax
    jz .c1d_27
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_27
.c1d_27:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_27:
    test rax, rax
    jz .c2d_27
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_27
.c2d_27:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 93
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
.cpy1_28:
    test rax, rax
    jz .c1d_28
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_28
.c1d_28:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_28:
    test rax, rax
    jz .c2d_28
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_28
.c2d_28:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rax, [vars + 64]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    je .else_1
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 217
    mov byte [rax + 9], 134
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    jmp .end_1
.else_1:
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 217
    mov byte [rax + 9], 132
    mov byte [rax + 10], 216
    mov byte [rax + 11], 167
.end_1:
    mov [vars + 96], rax
    mov rdi, 46
    call arena_alloc
    mov qword [rax], 38
    mov byte [rax + 8], 217
    mov byte [rax + 9], 135
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 32
    mov byte [rax + 13], 217
    mov byte [rax + 14], 135
    mov byte [rax + 15], 217
    mov byte [rax + 16], 138
    mov byte [rax + 17], 32
    mov byte [rax + 18], 217
    mov byte [rax + 19], 133
    mov byte [rax + 20], 216
    mov byte [rax + 21], 181
    mov byte [rax + 22], 217
    mov byte [rax + 23], 129
    mov byte [rax + 24], 217
    mov byte [rax + 25], 136
    mov byte [rax + 26], 217
    mov byte [rax + 27], 129
    mov byte [rax + 28], 216
    mov byte [rax + 29], 169
    mov byte [rax + 30], 32
    mov byte [rax + 31], 216
    mov byte [rax + 32], 167
    mov byte [rax + 33], 217
    mov byte [rax + 34], 132
    mov byte [rax + 35], 217
    mov byte [rax + 36], 136
    mov byte [rax + 37], 216
    mov byte [rax + 38], 173
    mov byte [rax + 39], 216
    mov byte [rax + 40], 175
    mov byte [rax + 41], 216
    mov byte [rax + 42], 169
    mov byte [rax + 43], 216
    mov byte [rax + 44], 159
    mov byte [rax + 45], 32
    push rax
    mov rax, [vars + 96]
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
.cpy1_29:
    test rax, rax
    jz .c1d_29
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_29
.c1d_29:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_29:
    test rax, rax
    jz .c2d_29
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_29
.c2d_29:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
