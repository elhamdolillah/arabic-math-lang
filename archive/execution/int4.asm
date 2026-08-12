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

    mov rax, 6
    mov [vars + 0], rax
    mov rax, 4
    mov [vars + 8], rax
    mov rax, 2
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 3
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 24], rax
    mov rax, [vars + 8]
    push rax
    mov rax, 2
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 32], rax
    mov rax, [vars + 16]
    mov [vars + 40], rax
    mov rax, 3
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    mov [vars + 48], rax
    mov rax, 2
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    mov [vars + 56], rax
    mov rax, [vars + 40]
    mov [vars + 64], rax
    mov rdi, 34
    call arena_alloc
    mov qword [rax], 26
    mov byte [rax + 8], 226
    mov byte [rax + 9], 136
    mov byte [rax + 10], 171
    mov byte [rax + 11], 102
    mov byte [rax + 12], 32
    mov byte [rax + 13], 100
    mov byte [rax + 14], 120
    mov byte [rax + 15], 32
    mov byte [rax + 16], 61
    mov byte [rax + 17], 32
    mov byte [rax + 18], 50
    mov byte [rax + 19], 120
    mov byte [rax + 20], 194
    mov byte [rax + 21], 179
    mov byte [rax + 22], 32
    mov byte [rax + 23], 43
    mov byte [rax + 24], 32
    mov byte [rax + 25], 50
    mov byte [rax + 26], 120
    mov byte [rax + 27], 194
    mov byte [rax + 28], 178
    mov byte [rax + 29], 32
    mov byte [rax + 30], 43
    mov byte [rax + 31], 32
    mov byte [rax + 32], 50
    mov byte [rax + 33], 120
    call print_str
    mov rdi, 30
    call arena_alloc
    mov qword [rax], 22
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 180
    mov byte [rax + 12], 216
    mov byte [rax + 13], 170
    mov byte [rax + 14], 217
    mov byte [rax + 15], 130
    mov byte [rax + 16], 216
    mov byte [rax + 17], 169
    mov byte [rax + 18], 40
    mov byte [rax + 19], 226
    mov byte [rax + 20], 136
    mov byte [rax + 21], 171
    mov byte [rax + 22], 102
    mov byte [rax + 23], 32
    mov byte [rax + 24], 100
    mov byte [rax + 25], 120
    mov byte [rax + 26], 41
    mov byte [rax + 27], 32
    mov byte [rax + 28], 61
    mov byte [rax + 29], 32
    push rax
    mov rax, [vars + 48]
    test rax, rax
    jns .npos_29
    neg rax
    mov byte [negflag], 1
.npos_29:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_29:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_29
    cmp byte [negflag], 1
    jne .nskip2_29
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_29:
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
.ntc_29:
    test rcx, rcx
    jz .ntd_29
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_29
.ntd_29:
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
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 120
    mov byte [rax + 9], 194
    mov byte [rax + 10], 178
    mov byte [rax + 11], 32
    mov byte [rax + 12], 43
    mov byte [rax + 13], 32
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
    mov rax, [vars + 56]
    test rax, rax
    jns .npos_32
    neg rax
    mov byte [negflag], 1
.npos_32:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_32:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_32
    cmp byte [negflag], 1
    jne .nskip2_32
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_32:
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
.ntc_32:
    test rcx, rcx
    jz .ntd_32
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_32
.ntd_32:
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
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 120
    mov byte [rax + 9], 32
    mov byte [rax + 10], 43
    mov byte [rax + 11], 32
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
    mov rax, [vars + 64]
    test rax, rax
    jns .npos_35
    neg rax
    mov byte [negflag], 1
.npos_35:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_35:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_35
    cmp byte [negflag], 1
    jne .nskip2_35
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_35:
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
.ntc_35:
    test rcx, rcx
    jz .ntd_35
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_35
.ntd_35:
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
.cpy1_36:
    test rax, rax
    jz .c1d_36
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_36
.c1d_36:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_36:
    test rax, rax
    jz .c2d_36
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_36
.c2d_36:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rax, [vars + 48]
    push rax
    mov rax, [vars + 0]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    push rax
    mov rax, [vars + 56]
    push rax
    mov rax, [vars + 8]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 64]
    push rax
    mov rax, [vars + 16]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    pop rbx
    imul rax, rbx
    mov [vars + 72], rax
    mov rdi, 71
    call arena_alloc
    mov qword [rax], 63
    mov byte [rax + 8], 217
    mov byte [rax + 9], 135
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 32
    mov byte [rax + 13], 217
    mov byte [rax + 14], 133
    mov byte [rax + 15], 216
    mov byte [rax + 16], 180
    mov byte [rax + 17], 216
    mov byte [rax + 18], 170
    mov byte [rax + 19], 217
    mov byte [rax + 20], 130
    mov byte [rax + 21], 216
    mov byte [rax + 22], 169
    mov byte [rax + 23], 32
    mov byte [rax + 24], 216
    mov byte [rax + 25], 167
    mov byte [rax + 26], 217
    mov byte [rax + 27], 132
    mov byte [rax + 28], 216
    mov byte [rax + 29], 170
    mov byte [rax + 30], 217
    mov byte [rax + 31], 131
    mov byte [rax + 32], 216
    mov byte [rax + 33], 167
    mov byte [rax + 34], 217
    mov byte [rax + 35], 133
    mov byte [rax + 36], 217
    mov byte [rax + 37], 132
    mov byte [rax + 38], 32
    mov byte [rax + 39], 61
    mov byte [rax + 40], 32
    mov byte [rax + 41], 216
    mov byte [rax + 42], 167
    mov byte [rax + 43], 217
    mov byte [rax + 44], 132
    mov byte [rax + 45], 216
    mov byte [rax + 46], 175
    mov byte [rax + 47], 216
    mov byte [rax + 48], 167
    mov byte [rax + 49], 217
    mov byte [rax + 50], 132
    mov byte [rax + 51], 216
    mov byte [rax + 52], 169
    mov byte [rax + 53], 32
    mov byte [rax + 54], 216
    mov byte [rax + 55], 167
    mov byte [rax + 56], 217
    mov byte [rax + 57], 132
    mov byte [rax + 58], 216
    mov byte [rax + 59], 163
    mov byte [rax + 60], 216
    mov byte [rax + 61], 181
    mov byte [rax + 62], 217
    mov byte [rax + 63], 132
    mov byte [rax + 64], 217
    mov byte [rax + 65], 138
    mov byte [rax + 66], 216
    mov byte [rax + 67], 169
    mov byte [rax + 68], 216
    mov byte [rax + 69], 159
    mov byte [rax + 70], 32
    push rax
    mov rax, [vars + 72]
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
.cpy1_37:
    test rax, rax
    jz .c1d_37
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_37
.c1d_37:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_37:
    test rax, rax
    jz .c2d_37
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_37
.c2d_37:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
