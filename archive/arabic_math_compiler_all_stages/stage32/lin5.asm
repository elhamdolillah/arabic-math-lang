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

    mov rax, 3
    mov [vars + 0], rax
    mov rax, 4
    mov [vars + 8], rax
    mov rax, 1
    mov [vars + 16], rax
    mov rax, 0
    mov [vars + 24], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 32], rax
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
    add rax, rbx
    mov [vars + 40], rax
    mov rdi, 38
    call arena_alloc
    mov qword [rax], 30
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 217
    mov byte [rax + 15], 130
    mov byte [rax + 16], 216
    mov byte [rax + 17], 183
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 32
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 216
    mov byte [rax + 26], 163
    mov byte [rax + 27], 216
    mov byte [rax + 28], 181
    mov byte [rax + 29], 217
    mov byte [rax + 30], 132
    mov byte [rax + 31], 217
    mov byte [rax + 32], 138
    mov byte [rax + 33], 216
    mov byte [rax + 34], 169
    mov byte [rax + 35], 58
    mov byte [rax + 36], 32
    mov byte [rax + 37], 40
    push rax
    mov rax, [vars + 0]
    test rax, rax
    jns .npos_44
    neg rax
    mov byte [negflag], 1
.npos_44:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_44:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_44
    cmp byte [negflag], 1
    jne .nskip2_44
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_44:
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
.ntc_44:
    test rcx, rcx
    jz .ntd_44
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_44
.ntd_44:
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
.cpy1_45:
    test rax, rax
    jz .c1d_45
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_45
.c1d_45:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_45:
    test rax, rax
    jz .c2d_45
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_45
.c2d_45:
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
.cpy1_46:
    test rax, rax
    jz .c1d_46
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_46
.c1d_46:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_46:
    test rax, rax
    jz .c2d_46
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_46
.c2d_46:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 8]
    test rax, rax
    jns .npos_47
    neg rax
    mov byte [negflag], 1
.npos_47:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_47:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_47
    cmp byte [negflag], 1
    jne .nskip2_47
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_47:
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
.ntc_47:
    test rcx, rcx
    jz .ntd_47
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_47
.ntd_47:
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
.cpy1_48:
    test rax, rax
    jz .c1d_48
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_48
.c1d_48:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_48:
    test rax, rax
    jz .c2d_48
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_48
.c2d_48:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 41
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
.cpy1_49:
    test rax, rax
    jz .c1d_49
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_49
.c1d_49:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_49:
    test rax, rax
    jz .c2d_49
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_49
.c2d_49:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 32
    call arena_alloc
    mov qword [rax], 24
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
    mov byte [rax + 22], 173
    mov byte [rax + 23], 217
    mov byte [rax + 24], 136
    mov byte [rax + 25], 217
    mov byte [rax + 26], 138
    mov byte [rax + 27], 217
    mov byte [rax + 28], 132
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
    mov byte [rax + 31], 40
    push rax
    mov rax, [vars + 32]
    test rax, rax
    jns .npos_50
    neg rax
    mov byte [negflag], 1
.npos_50:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_50:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_50
    cmp byte [negflag], 1
    jne .nskip2_50
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_50:
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
.ntc_50:
    test rcx, rcx
    jz .ntd_50
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_50
.ntd_50:
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
.cpy1_51:
    test rax, rax
    jz .c1d_51
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_51
.c1d_51:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_51:
    test rax, rax
    jz .c2d_51
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_51
.c2d_51:
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
.cpy1_52:
    test rax, rax
    jz .c1d_52
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_52
.c1d_52:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_52:
    test rax, rax
    jz .c2d_52
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_52
.c2d_52:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 40]
    test rax, rax
    jns .npos_53
    neg rax
    mov byte [negflag], 1
.npos_53:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_53:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_53
    cmp byte [negflag], 1
    jne .nskip2_53
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_53:
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
.ntc_53:
    test rcx, rcx
    jz .ntd_53
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_53
.ntd_53:
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
.cpy1_54:
    test rax, rax
    jz .c1d_54
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_54
.c1d_54:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_54:
    test rax, rax
    jz .c2d_54
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_54
.c2d_54:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 41
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
.cpy1_55:
    test rax, rax
    jz .c1d_55
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_55
.c1d_55:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_55:
    test rax, rax
    jz .c2d_55
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_55
.c2d_55:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
