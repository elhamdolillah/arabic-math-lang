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
    mov rax, 3
    mov [vars + 16], rax
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_13
    mov rax, [rax + 8]
    jmp .hdne_13
.hemp_13:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_13:
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    mov [vars + 24], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_31
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
.tcopy_31:
    test rcx, rcx
    jz .tcd_31
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_31
.tcd_31:
    mov rax, r12
    jmp .taine_31
.taihemp_31:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_31:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_14
    mov rax, [rax + 8]
    jmp .hdne_14
.hemp_14:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_14:
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    mov [vars + 32], rax
    mov rax, [vars + 8]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_15
    mov rax, [rax + 8]
    jmp .hdne_15
.hemp_15:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_15:
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    mov [vars + 40], rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_32
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
.tcopy_32:
    test rcx, rcx
    jz .tcd_32
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_32
.tcd_32:
    mov rax, r12
    jmp .taine_32
.taihemp_32:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_32:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_16
    mov rax, [rax + 8]
    jmp .hdne_16
.hemp_16:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_16:
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    mov [vars + 48], rax
    mov rdi, 30
    call arena_alloc
    mov qword [rax], 22
    mov byte [rax + 8], 51
    mov byte [rax + 9], 32
    mov byte [rax + 10], 195
    mov byte [rax + 11], 151
    mov byte [rax + 12], 32
    mov byte [rax + 13], 216
    mov byte [rax + 14], 167
    mov byte [rax + 15], 217
    mov byte [rax + 16], 132
    mov byte [rax + 17], 217
    mov byte [rax + 18], 133
    mov byte [rax + 19], 216
    mov byte [rax + 20], 181
    mov byte [rax + 21], 217
    mov byte [rax + 22], 129
    mov byte [rax + 23], 217
    mov byte [rax + 24], 136
    mov byte [rax + 25], 217
    mov byte [rax + 26], 129
    mov byte [rax + 27], 216
    mov byte [rax + 28], 169
    mov byte [rax + 29], 58
    call print_str
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 91
    push rax
    mov rax, [vars + 24]
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
    push rax
    mov rax, [vars + 32]
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
    mov rax, [vars + 48]
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
.cpy1_44:
    test rax, rax
    jz .c1d_44
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_44
.c1d_44:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_44:
    test rax, rax
    jz .c2d_44
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_44
.c2d_44:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
