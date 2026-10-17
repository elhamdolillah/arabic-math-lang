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

    mov rdi, 24
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov rax, 1
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 2
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 24
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov rax, 3
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 4
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    pop rax
    mov [vars + 8], rax
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_17
    mov rax, [rax + 8]
    jmp .hdne_17
.hemp_17:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_17:
    mov [vars + 16], rax
    mov rax, [vars + 8]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_18
    mov rax, [rax + 8]
    jmp .hdne_18
.hemp_18:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_18:
    mov [vars + 24], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_45
    push rax
    dec rcx
    mov rdi, rcx
    shl rdi, 3
    add rdi, 8
    call arena_alloc
    mov r12, rax
    mov [rax], rcx
    pop rsi
    add rsi, 16
    lea rdi, [r12 + 8]
.tcopy_45:
    test rcx, rcx
    jz .tcd_45
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_45
.tcd_45:
    mov rax, r12
    jmp .taine_45
.taihemp_45:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_45:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_19
    mov rax, [rax + 8]
    jmp .hdne_19
.hemp_19:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_19:
    mov [vars + 32], rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_46
    push rax
    dec rcx
    mov rdi, rcx
    shl rdi, 3
    add rdi, 8
    call arena_alloc
    mov r12, rax
    mov [rax], rcx
    pop rsi
    add rsi, 16
    lea rdi, [r12 + 8]
.tcopy_46:
    test rcx, rcx
    jz .tcd_46
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_46
.tcd_46:
    mov rax, r12
    jmp .taine_46
.taihemp_46:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_46:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_20
    mov rax, [rax + 8]
    jmp .hdne_20
.hemp_20:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_20:
    mov [vars + 40], rax
    mov rdi, 40
    call arena_alloc
    mov qword [rax], 32
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
    mov byte [rax + 24], 32
    mov byte [rax + 25], 216
    mov byte [rax + 26], 167
    mov byte [rax + 27], 217
    mov byte [rax + 28], 132
    mov byte [rax + 29], 216
    mov byte [rax + 30], 163
    mov byte [rax + 31], 216
    mov byte [rax + 32], 181
    mov byte [rax + 33], 217
    mov byte [rax + 34], 132
    mov byte [rax + 35], 217
    mov byte [rax + 36], 138
    mov byte [rax + 37], 216
    mov byte [rax + 38], 169
    mov byte [rax + 39], 58
    call print_str
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 91
    push rax
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_21
    mov rax, [rax + 8]
    jmp .hdne_21
.hemp_21:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_21:
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
    push rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_51
    push rax
    dec rcx
    mov rdi, rcx
    shl rdi, 3
    add rdi, 8
    call arena_alloc
    mov r12, rax
    mov [rax], rcx
    pop rsi
    add rsi, 16
    lea rdi, [r12 + 8]
.tcopy_51:
    test rcx, rcx
    jz .tcd_51
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_51
.tcd_51:
    mov rax, r12
    jmp .taine_51
.taihemp_51:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_51:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_22
    mov rax, [rax + 8]
    jmp .hdne_22
.hemp_22:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_22:
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
.cpy1_53:
    test rax, rax
    jz .c1d_53
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_53
.c1d_53:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_53:
    test rax, rax
    jz .c2d_53
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_53
.c2d_53:
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
    mov rax, [vars + 8]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_23
    mov rax, [rax + 8]
    jmp .hdne_23
.hemp_23:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_23:
    test rax, rax
    jns .npos_54
    neg rax
    mov byte [negflag], 1
.npos_54:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_54:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_54
    cmp byte [negflag], 1
    jne .nskip2_54
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_54:
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
.ntc_54:
    test rcx, rcx
    jz .ntd_54
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_54
.ntd_54:
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
.cpy1_56:
    test rax, rax
    jz .c1d_56
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_56
.c1d_56:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_56:
    test rax, rax
    jz .c2d_56
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_56
.c2d_56:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_58
    push rax
    dec rcx
    mov rdi, rcx
    shl rdi, 3
    add rdi, 8
    call arena_alloc
    mov r12, rax
    mov [rax], rcx
    pop rsi
    add rsi, 16
    lea rdi, [r12 + 8]
.tcopy_58:
    test rcx, rcx
    jz .tcd_58
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_58
.tcd_58:
    mov rax, r12
    jmp .taine_58
.taihemp_58:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_58:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_24
    mov rax, [rax + 8]
    jmp .hdne_24
.hemp_24:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_24:
    test rax, rax
    jns .npos_57
    neg rax
    mov byte [negflag], 1
.npos_57:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_57:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_57
    cmp byte [negflag], 1
    jne .nskip2_57
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_57:
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
.ntc_57:
    test rcx, rcx
    jz .ntd_57
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_57
.ntd_57:
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
.cpy1_59:
    test rax, rax
    jz .c1d_59
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_59
.c1d_59:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_59:
    test rax, rax
    jz .c2d_59
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_59
.c2d_59:
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
.cpy1_60:
    test rax, rax
    jz .c1d_60
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_60
.c1d_60:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_60:
    test rax, rax
    jz .c2d_60
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_60
.c2d_60:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 42
    call arena_alloc
    mov qword [rax], 34
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
    mov byte [rax + 24], 32
    mov byte [rax + 25], 216
    mov byte [rax + 26], 167
    mov byte [rax + 27], 217
    mov byte [rax + 28], 132
    mov byte [rax + 29], 217
    mov byte [rax + 30], 133
    mov byte [rax + 31], 217
    mov byte [rax + 32], 134
    mov byte [rax + 33], 217
    mov byte [rax + 34], 130
    mov byte [rax + 35], 217
    mov byte [rax + 36], 136
    mov byte [rax + 37], 217
    mov byte [rax + 38], 132
    mov byte [rax + 39], 216
    mov byte [rax + 40], 169
    mov byte [rax + 41], 58
    call print_str
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 91
    push rax
    mov rax, [vars + 16]
    test rax, rax
    jns .npos_61
    neg rax
    mov byte [negflag], 1
.npos_61:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_61:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_61
    cmp byte [negflag], 1
    jne .nskip2_61
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_61:
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
.ntc_61:
    test rcx, rcx
    jz .ntd_61
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_61
.ntd_61:
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
.cpy1_62:
    test rax, rax
    jz .c1d_62
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_62
.c1d_62:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_62:
    test rax, rax
    jz .c2d_62
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_62
.c2d_62:
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
.cpy1_63:
    test rax, rax
    jz .c1d_63
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_63
.c1d_63:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_63:
    test rax, rax
    jz .c2d_63
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_63
.c2d_63:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 24]
    test rax, rax
    jns .npos_64
    neg rax
    mov byte [negflag], 1
.npos_64:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_64:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_64
    cmp byte [negflag], 1
    jne .nskip2_64
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_64:
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
.ntc_64:
    test rcx, rcx
    jz .ntd_64
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_64
.ntd_64:
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
.cpy1_65:
    test rax, rax
    jz .c1d_65
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_65
.c1d_65:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_65:
    test rax, rax
    jz .c2d_65
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_65
.c2d_65:
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
.cpy1_66:
    test rax, rax
    jz .c1d_66
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_66
.c1d_66:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_66:
    test rax, rax
    jz .c2d_66
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_66
.c2d_66:
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
    mov rax, [vars + 32]
    test rax, rax
    jns .npos_67
    neg rax
    mov byte [negflag], 1
.npos_67:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_67:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_67
    cmp byte [negflag], 1
    jne .nskip2_67
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_67:
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
.ntc_67:
    test rcx, rcx
    jz .ntd_67
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_67
.ntd_67:
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
.cpy1_68:
    test rax, rax
    jz .c1d_68
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_68
.c1d_68:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_68:
    test rax, rax
    jz .c2d_68
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_68
.c2d_68:
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
.cpy1_69:
    test rax, rax
    jz .c1d_69
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_69
.c1d_69:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_69:
    test rax, rax
    jz .c2d_69
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_69
.c2d_69:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 40]
    test rax, rax
    jns .npos_70
    neg rax
    mov byte [negflag], 1
.npos_70:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_70:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_70
    cmp byte [negflag], 1
    jne .nskip2_70
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_70:
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
.ntc_70:
    test rcx, rcx
    jz .ntd_70
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_70
.ntd_70:
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
.cpy1_71:
    test rax, rax
    jz .c1d_71
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_71
.c1d_71:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_71:
    test rax, rax
    jz .c2d_71
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_71
.c2d_71:
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
.cpy1_72:
    test rax, rax
    jz .c1d_72
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_72
.c1d_72:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_72:
    test rax, rax
    jz .c2d_72
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_72
.c2d_72:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
