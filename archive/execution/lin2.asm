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
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 32], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 32]
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 40], rax
    mov rax, 0
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 32]
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 48], rax
    mov rax, 0
    push rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 32]
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 56], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 32]
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 64], rax
    mov rdi, 36
    call arena_alloc
    mov qword [rax], 28
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 181
    mov byte [rax + 16], 217
    mov byte [rax + 17], 129
    mov byte [rax + 18], 217
    mov byte [rax + 19], 136
    mov byte [rax + 20], 217
    mov byte [rax + 21], 129
    mov byte [rax + 22], 216
    mov byte [rax + 23], 169
    mov byte [rax + 24], 58
    mov byte [rax + 25], 32
    mov byte [rax + 26], 91
    mov byte [rax + 27], 50
    mov byte [rax + 28], 44
    mov byte [rax + 29], 49
    mov byte [rax + 30], 59
    mov byte [rax + 31], 32
    mov byte [rax + 32], 49
    mov byte [rax + 33], 44
    mov byte [rax + 34], 49
    mov byte [rax + 35], 93
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 173
    mov byte [rax + 16], 216
    mov byte [rax + 17], 175
    mov byte [rax + 18], 216
    mov byte [rax + 19], 175
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    push rax
    mov rax, [vars + 32]
    test rax, rax
    jns .npos_3
    neg rax
    mov byte [negflag], 1
.npos_3:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_3:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_3
    cmp byte [negflag], 1
    jne .nskip2_3
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_3:
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
.ntc_3:
    test rcx, rcx
    jz .ntd_3
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_3
.ntd_3:
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
.cpy1_4:
    test rax, rax
    jz .c1d_4
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_4
.c1d_4:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_4:
    test rax, rax
    jz .c2d_4
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_4
.c2d_4:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 23
    call arena_alloc
    mov qword [rax], 15
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 185
    mov byte [rax + 16], 217
    mov byte [rax + 17], 131
    mov byte [rax + 18], 217
    mov byte [rax + 19], 136
    mov byte [rax + 20], 216
    mov byte [rax + 21], 179
    mov byte [rax + 22], 58
    call print_str
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 91
    push rax
    mov rax, [vars + 40]
    test rax, rax
    jns .npos_5
    neg rax
    mov byte [negflag], 1
.npos_5:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_5:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_5
    cmp byte [negflag], 1
    jne .nskip2_5
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_5:
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
.ntc_5:
    test rcx, rcx
    jz .ntd_5
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_5
.ntd_5:
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
.cpy1_6:
    test rax, rax
    jz .c1d_6
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_6
.c1d_6:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_6:
    test rax, rax
    jz .c2d_6
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_6
.c2d_6:
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
.cpy1_7:
    test rax, rax
    jz .c1d_7
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_7
.c1d_7:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_7:
    test rax, rax
    jz .c2d_7
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_7
.c2d_7:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 48]
    test rax, rax
    jns .npos_8
    neg rax
    mov byte [negflag], 1
.npos_8:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_8:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_8
    cmp byte [negflag], 1
    jne .nskip2_8
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_8:
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
.ntc_8:
    test rcx, rcx
    jz .ntd_8
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_8
.ntd_8:
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
.cpy1_9:
    test rax, rax
    jz .c1d_9
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_9
.c1d_9:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_9:
    test rax, rax
    jz .c2d_9
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_9
.c2d_9:
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
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 91
    push rax
    mov rax, [vars + 56]
    test rax, rax
    jns .npos_11
    neg rax
    mov byte [negflag], 1
.npos_11:
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
    cmp byte [negflag], 1
    jne .nskip2_11
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_11:
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
.cpy1_13:
    test rax, rax
    jz .c1d_13
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_13
.c1d_13:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_13:
    test rax, rax
    jz .c2d_13
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_13
.c2d_13:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 64]
    test rax, rax
    jns .npos_14
    neg rax
    mov byte [negflag], 1
.npos_14:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_14:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_14
    cmp byte [negflag], 1
    jne .nskip2_14
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_14:
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
.ntc_14:
    test rcx, rcx
    jz .ntd_14
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_14
.ntd_14:
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
.cpy1_15:
    test rax, rax
    jz .c1d_15
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_15
.c1d_15:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_15:
    test rax, rax
    jz .c2d_15
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_15
.c2d_15:
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

    mov rax, 60
    xor rdi, rdi
    syscall
