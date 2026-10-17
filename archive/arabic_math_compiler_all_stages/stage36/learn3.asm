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

    mov rax, 10
    mov [vars + 0], rax
    mov rax, 20
    mov [vars + 8], rax
    mov rax, 30
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 8]
    pop rbx
    add rax, rbx
    mov [vars + 24], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 16]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rdi, 40
    call arena_alloc
    mov qword [rax], 32
    mov byte [rax + 8], 216
    mov byte [rax + 9], 170
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 32
    mov byte [rax + 19], 49
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    mov byte [rax + 22], 216
    mov byte [rax + 23], 172
    mov byte [rax + 24], 217
    mov byte [rax + 25], 133
    mov byte [rax + 26], 216
    mov byte [rax + 27], 185
    mov byte [rax + 28], 40
    mov byte [rax + 29], 49
    mov byte [rax + 30], 48
    mov byte [rax + 31], 216
    mov byte [rax + 32], 140
    mov byte [rax + 33], 32
    mov byte [rax + 34], 50
    mov byte [rax + 35], 48
    mov byte [rax + 36], 41
    mov byte [rax + 37], 32
    mov byte [rax + 38], 61
    mov byte [rax + 39], 32
    push rax
    mov rax, [vars + 24]
    test rax, rax
    jns .npos_27
    neg rax
    mov byte [negflag], 1
.npos_27:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_27:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_27
    cmp byte [negflag], 1
    jne .nskip2_27
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_27:
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
.ntc_27:
    test rcx, rcx
    jz .ntd_27
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_27
.ntd_27:
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
    push rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_14
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 32
    mov byte [rax + 9], 226
    mov byte [rax + 10], 156
    mov byte [rax + 11], 147
    jmp .end_14
.else_14:
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 32
    mov byte [rax + 9], 226
    mov byte [rax + 10], 156
    mov byte [rax + 11], 151
.end_14:
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
    mov rax, 7
    mov [vars + 0], rax
    mov rax, 8
    mov [vars + 8], rax
    mov rax, 15
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 8]
    pop rbx
    add rax, rbx
    mov [vars + 24], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 16]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rdi, 38
    call arena_alloc
    mov qword [rax], 30
    mov byte [rax + 8], 216
    mov byte [rax + 9], 170
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 32
    mov byte [rax + 19], 50
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    mov byte [rax + 22], 216
    mov byte [rax + 23], 172
    mov byte [rax + 24], 217
    mov byte [rax + 25], 133
    mov byte [rax + 26], 216
    mov byte [rax + 27], 185
    mov byte [rax + 28], 40
    mov byte [rax + 29], 55
    mov byte [rax + 30], 216
    mov byte [rax + 31], 140
    mov byte [rax + 32], 32
    mov byte [rax + 33], 56
    mov byte [rax + 34], 41
    mov byte [rax + 35], 32
    mov byte [rax + 36], 61
    mov byte [rax + 37], 32
    push rax
    mov rax, [vars + 24]
    test rax, rax
    jns .npos_30
    neg rax
    mov byte [negflag], 1
.npos_30:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_30:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_30
    cmp byte [negflag], 1
    jne .nskip2_30
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_30:
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
.ntc_30:
    test rcx, rcx
    jz .ntd_30
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_30
.ntd_30:
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
.cpy1_31:
    test rax, rax
    jz .c1d_31
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_31
.c1d_31:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_31:
    test rax, rax
    jz .c2d_31
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_31
.c2d_31:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_15
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 32
    mov byte [rax + 9], 226
    mov byte [rax + 10], 156
    mov byte [rax + 11], 147
    jmp .end_15
.else_15:
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 32
    mov byte [rax + 9], 226
    mov byte [rax + 10], 156
    mov byte [rax + 11], 151
.end_15:
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
    call print_str
    mov rax, 8
    mov [vars + 40], rax
    mov rax, 1
    mov [vars + 16], rax
    mov rax, [vars + 40]
    push rax
    mov rax, 2
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    push rax
    mov rax, 2
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 40]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_16
    mov rax, 1
    jmp .end_16
.else_16:
    mov rax, 0
.end_16:
    mov [vars + 48], rax
    mov rdi, 36
    call arena_alloc
    mov qword [rax], 28
    mov byte [rax + 8], 216
    mov byte [rax + 9], 170
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 32
    mov byte [rax + 19], 51
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    mov byte [rax + 22], 216
    mov byte [rax + 23], 178
    mov byte [rax + 24], 217
    mov byte [rax + 25], 136
    mov byte [rax + 26], 216
    mov byte [rax + 27], 172
    mov byte [rax + 28], 217
    mov byte [rax + 29], 138
    mov byte [rax + 30], 40
    mov byte [rax + 31], 56
    mov byte [rax + 32], 41
    mov byte [rax + 33], 32
    mov byte [rax + 34], 61
    mov byte [rax + 35], 32
    push rax
    mov rax, [vars + 48]
    test rax, rax
    jns .npos_33
    neg rax
    mov byte [negflag], 1
.npos_33:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_33:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_33
    cmp byte [negflag], 1
    jne .nskip2_33
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_33:
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
.ntc_33:
    test rcx, rcx
    jz .ntd_33
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_33
.ntd_33:
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
.cpy1_34:
    test rax, rax
    jz .c1d_34
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_34
.c1d_34:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_34:
    test rax, rax
    jz .c2d_34
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_34
.c2d_34:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 48]
    push rax
    mov rax, [vars + 16]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    je .else_17
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 32
    mov byte [rax + 9], 226
    mov byte [rax + 10], 156
    mov byte [rax + 11], 147
    jmp .end_17
.else_17:
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 32
    mov byte [rax + 9], 226
    mov byte [rax + 10], 156
    mov byte [rax + 11], 151
.end_17:
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
