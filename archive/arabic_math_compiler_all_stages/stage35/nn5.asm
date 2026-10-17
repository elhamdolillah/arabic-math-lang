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

    mov rax, 0
    mov [vars + 0], rax
    mov rax, 0
    mov [vars + 8], rax
    mov rax, 0
    mov [vars + 16], rax
    mov rax, 1
    mov [vars + 24], rax
    mov rax, 1
    mov [vars + 32], rax
    mov rax, 1
    mov [vars + 40], rax
    mov rax, 1
    mov [vars + 48], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 40]
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
    push rax
    mov rax, [vars + 16]
    pop rbx
    add rax, rbx
    mov [vars + 56], rax
    mov rax, [vars + 56]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 64], rax
    mov rax, [vars + 64]
    cmp rax, 0
    je .else_12
    mov rax, 1
    jmp .end_12
.else_12:
    mov rax, 0
.end_12:
    mov [vars + 72], rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 72]
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 80], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 80]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 0], rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 80]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 8], rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 80]
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 16], rax
    mov rdi, 47
    call arena_alloc
    mov qword [rax], 39
    mov byte [rax + 8], 217
    mov byte [rax + 9], 130
    mov byte [rax + 10], 216
    mov byte [rax + 11], 168
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    mov byte [rax + 14], 32
    mov byte [rax + 15], 216
    mov byte [rax + 16], 167
    mov byte [rax + 17], 217
    mov byte [rax + 18], 132
    mov byte [rax + 19], 216
    mov byte [rax + 20], 170
    mov byte [rax + 21], 216
    mov byte [rax + 22], 175
    mov byte [rax + 23], 216
    mov byte [rax + 24], 177
    mov byte [rax + 25], 217
    mov byte [rax + 26], 138
    mov byte [rax + 27], 216
    mov byte [rax + 28], 168
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
    mov byte [rax + 31], 217
    mov byte [rax + 32], 136
    mov byte [rax + 33], 61
    mov byte [rax + 34], 48
    mov byte [rax + 35], 44
    mov byte [rax + 36], 32
    mov byte [rax + 37], 216
    mov byte [rax + 38], 178
    mov byte [rax + 39], 61
    mov byte [rax + 40], 48
    mov byte [rax + 41], 44
    mov byte [rax + 42], 32
    mov byte [rax + 43], 216
    mov byte [rax + 44], 168
    mov byte [rax + 45], 61
    mov byte [rax + 46], 48
    call print_str
    mov rdi, 37
    call arena_alloc
    mov qword [rax], 29
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 135
    mov byte [rax + 14], 216
    mov byte [rax + 15], 175
    mov byte [rax + 16], 217
    mov byte [rax + 17], 129
    mov byte [rax + 18], 58
    mov byte [rax + 19], 32
    mov byte [rax + 20], 49
    mov byte [rax + 21], 44
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 216
    mov byte [rax + 28], 170
    mov byte [rax + 29], 217
    mov byte [rax + 30], 134
    mov byte [rax + 31], 216
    mov byte [rax + 32], 168
    mov byte [rax + 33], 216
    mov byte [rax + 34], 164
    mov byte [rax + 35], 58
    mov byte [rax + 36], 32
    push rax
    mov rax, [vars + 72]
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
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 44
    mov byte [rax + 9], 32
    mov byte [rax + 10], 216
    mov byte [rax + 11], 167
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    mov byte [rax + 14], 216
    mov byte [rax + 15], 174
    mov byte [rax + 16], 216
    mov byte [rax + 17], 183
    mov byte [rax + 18], 216
    mov byte [rax + 19], 163
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
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
    mov rax, [vars + 80]
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
    call print_str
    mov rdi, 34
    call arena_alloc
    mov qword [rax], 26
    mov byte [rax + 8], 216
    mov byte [rax + 9], 168
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 32
    mov byte [rax + 15], 216
    mov byte [rax + 16], 167
    mov byte [rax + 17], 217
    mov byte [rax + 18], 132
    mov byte [rax + 19], 216
    mov byte [rax + 20], 170
    mov byte [rax + 21], 216
    mov byte [rax + 22], 175
    mov byte [rax + 23], 216
    mov byte [rax + 24], 177
    mov byte [rax + 25], 217
    mov byte [rax + 26], 138
    mov byte [rax + 27], 216
    mov byte [rax + 28], 168
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
    mov byte [rax + 31], 217
    mov byte [rax + 32], 136
    mov byte [rax + 33], 61
    push rax
    mov rax, [vars + 0]
    test rax, rax
    jns .npos_28
    neg rax
    mov byte [negflag], 1
.npos_28:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_28:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_28
    cmp byte [negflag], 1
    jne .nskip2_28
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_28:
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
.ntc_28:
    test rcx, rcx
    jz .ntd_28
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_28
.ntd_28:
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
    push rax
    mov rdi, 13
    call arena_alloc
    mov qword [rax], 5
    mov byte [rax + 8], 44
    mov byte [rax + 9], 32
    mov byte [rax + 10], 216
    mov byte [rax + 11], 178
    mov byte [rax + 12], 61
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
.cpy1_30:
    test rax, rax
    jz .c1d_30
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_30
.c1d_30:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_30:
    test rax, rax
    jz .c2d_30
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_30
.c2d_30:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 8]
    test rax, rax
    jns .npos_31
    neg rax
    mov byte [negflag], 1
.npos_31:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_31:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_31
    cmp byte [negflag], 1
    jne .nskip2_31
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_31:
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
.ntc_31:
    test rcx, rcx
    jz .ntd_31
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_31
.ntd_31:
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
.cpy1_32:
    test rax, rax
    jz .c1d_32
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_32
.c1d_32:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_32:
    test rax, rax
    jz .c2d_32
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_32
.c2d_32:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 13
    call arena_alloc
    mov qword [rax], 5
    mov byte [rax + 8], 44
    mov byte [rax + 9], 32
    mov byte [rax + 10], 216
    mov byte [rax + 11], 168
    mov byte [rax + 12], 61
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
.cpy1_33:
    test rax, rax
    jz .c1d_33
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_33
.c1d_33:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_33:
    test rax, rax
    jz .c2d_33
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_33
.c2d_33:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 16]
    test rax, rax
    jns .npos_34
    neg rax
    mov byte [negflag], 1
.npos_34:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_34:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_34
    cmp byte [negflag], 1
    jne .nskip2_34
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_34:
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
.ntc_34:
    test rcx, rcx
    jz .ntd_34
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_34
.ntd_34:
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
.cpy1_35:
    test rax, rax
    jz .c1d_35
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_35
.c1d_35:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_35:
    test rax, rax
    jz .c2d_35
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_35
.c2d_35:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
