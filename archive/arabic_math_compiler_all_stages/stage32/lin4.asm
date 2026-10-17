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
    mov rax, 5
    mov [vars + 32], rax
    mov rax, 3
    mov [vars + 40], rax
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
    mov [vars + 48], rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    mov rax, [vars + 48]
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 56], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    mov rax, [vars + 48]
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 64], rax
    mov rdi, 43
    call arena_alloc
    mov qword [rax], 35
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 216
    mov byte [rax + 15], 184
    mov byte [rax + 16], 216
    mov byte [rax + 17], 167
    mov byte [rax + 18], 217
    mov byte [rax + 19], 133
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    mov byte [rax + 22], 50
    mov byte [rax + 23], 120
    mov byte [rax + 24], 32
    mov byte [rax + 25], 43
    mov byte [rax + 26], 32
    mov byte [rax + 27], 121
    mov byte [rax + 28], 32
    mov byte [rax + 29], 61
    mov byte [rax + 30], 32
    mov byte [rax + 31], 53
    mov byte [rax + 32], 44
    mov byte [rax + 33], 32
    mov byte [rax + 34], 120
    mov byte [rax + 35], 32
    mov byte [rax + 36], 43
    mov byte [rax + 37], 32
    mov byte [rax + 38], 121
    mov byte [rax + 39], 32
    mov byte [rax + 40], 61
    mov byte [rax + 41], 32
    mov byte [rax + 42], 51
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
    mov rax, [vars + 48]
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
    call print_str
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 120
    mov byte [rax + 9], 32
    mov byte [rax + 10], 61
    mov byte [rax + 11], 32
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
    call print_str
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 121
    mov byte [rax + 9], 32
    mov byte [rax + 10], 61
    mov byte [rax + 11], 32
    push rax
    mov rax, [vars + 64]
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
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 170
    mov byte [rax + 14], 216
    mov byte [rax + 15], 173
    mov byte [rax + 16], 217
    mov byte [rax + 17], 130
    mov byte [rax + 18], 217
    mov byte [rax + 19], 130
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    mov byte [rax + 22], 50
    mov byte [rax + 23], 40
    push rax
    mov rax, [vars + 56]
    test rax, rax
    jns .npos_36
    neg rax
    mov byte [negflag], 1
.npos_36:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_36:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_36
    cmp byte [negflag], 1
    jne .nskip2_36
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_36:
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
.ntc_36:
    test rcx, rcx
    jz .ntd_36
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_36
.ntd_36:
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
    push rax
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 41
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
.cpy1_38:
    test rax, rax
    jz .c1d_38
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_38
.c1d_38:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_38:
    test rax, rax
    jz .c2d_38
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_38
.c2d_38:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 64]
    test rax, rax
    jns .npos_39
    neg rax
    mov byte [negflag], 1
.npos_39:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_39:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_39
    cmp byte [negflag], 1
    jne .nskip2_39
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_39:
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
.ntc_39:
    test rcx, rcx
    jz .ntd_39
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_39
.ntd_39:
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
.cpy1_40:
    test rax, rax
    jz .c1d_40
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_40
.c1d_40:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_40:
    test rax, rax
    jz .c2d_40
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_40
.c2d_40:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 61
    mov byte [rax + 10], 32
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
.cpy1_41:
    test rax, rax
    jz .c1d_41
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_41
.c1d_41:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_41:
    test rax, rax
    jz .c2d_41
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_41
.c2d_41:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, 2
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 64]
    pop rbx
    add rax, rbx
    test rax, rax
    jns .npos_42
    neg rax
    mov byte [negflag], 1
.npos_42:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_42:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_42
    cmp byte [negflag], 1
    jne .nskip2_42
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_42:
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
.ntc_42:
    test rcx, rcx
    jz .ntd_42
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_42
.ntd_42:
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
.cpy1_43:
    test rax, rax
    jz .c1d_43
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_43
.c1d_43:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_43:
    test rax, rax
    jz .c2d_43
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_43
.c2d_43:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
