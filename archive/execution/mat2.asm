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
    mov rdi, 24
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov rax, 5
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 6
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    pop rax
    mov [vars + 16], rax
    mov rdi, 24
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov rax, 7
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 8
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    pop rax
    mov [vars + 24], rax
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_5
    mov rax, [rax + 8]
    jmp .hdne_5
.hemp_5:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_5:
    push rax
    mov rax, [vars + 16]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_6
    mov rax, [rax + 8]
    jmp .hdne_6
.hemp_6:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_6:
    pop rbx
    add rax, rbx
    mov [vars + 32], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_19
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
.tcopy_19:
    test rcx, rcx
    jz .tcd_19
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_19
.tcd_19:
    mov rax, r12
    jmp .taine_19
.taihemp_19:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_19:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_7
    mov rax, [rax + 8]
    jmp .hdne_7
.hemp_7:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_7:
    push rax
    mov rax, [vars + 16]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_20
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
.tcopy_20:
    test rcx, rcx
    jz .tcd_20
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_20
.tcd_20:
    mov rax, r12
    jmp .taine_20
.taihemp_20:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_20:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_8
    mov rax, [rax + 8]
    jmp .hdne_8
.hemp_8:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_8:
    pop rbx
    add rax, rbx
    mov [vars + 40], rax
    mov rax, [vars + 8]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_9
    mov rax, [rax + 8]
    jmp .hdne_9
.hemp_9:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_9:
    push rax
    mov rax, [vars + 24]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_10
    mov rax, [rax + 8]
    jmp .hdne_10
.hemp_10:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_10:
    pop rbx
    add rax, rbx
    mov [vars + 48], rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_21
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
.tcopy_21:
    test rcx, rcx
    jz .tcd_21
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_21
.tcd_21:
    mov rax, r12
    jmp .taine_21
.taihemp_21:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_21:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_11
    mov rax, [rax + 8]
    jmp .hdne_11
.hemp_11:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_11:
    push rax
    mov rax, [vars + 24]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_22
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
.tcopy_22:
    test rcx, rcx
    jz .tcd_22
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_22
.tcd_22:
    mov rax, r12
    jmp .taine_22
.taihemp_22:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_22:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_12
    mov rax, [rax + 8]
    jmp .hdne_12
.hemp_12:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_12:
    pop rbx
    add rax, rbx
    mov [vars + 56], rax
    mov rdi, 30
    call arena_alloc
    mov qword [rax], 22
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 216
    mov byte [rax + 15], 170
    mov byte [rax + 16], 217
    mov byte [rax + 17], 138
    mov byte [rax + 18], 216
    mov byte [rax + 19], 172
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 32
    mov byte [rax + 23], 91
    mov byte [rax + 24], 49
    mov byte [rax + 25], 44
    mov byte [rax + 26], 49
    mov byte [rax + 27], 93
    mov byte [rax + 28], 58
    mov byte [rax + 29], 32
    push rax
    mov rax, [vars + 32]
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
    call print_str
    mov rdi, 30
    call arena_alloc
    mov qword [rax], 22
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 216
    mov byte [rax + 15], 170
    mov byte [rax + 16], 217
    mov byte [rax + 17], 138
    mov byte [rax + 18], 216
    mov byte [rax + 19], 172
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 32
    mov byte [rax + 23], 91
    mov byte [rax + 24], 49
    mov byte [rax + 25], 44
    mov byte [rax + 26], 50
    mov byte [rax + 27], 93
    mov byte [rax + 28], 58
    mov byte [rax + 29], 32
    push rax
    mov rax, [vars + 40]
    test rax, rax
    jns .npos_25
    neg rax
    mov byte [negflag], 1
.npos_25:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_25:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_25
    cmp byte [negflag], 1
    jne .nskip2_25
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_25:
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
.ntc_25:
    test rcx, rcx
    jz .ntd_25
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_25
.ntd_25:
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
.cpy1_26:
    test rax, rax
    jz .c1d_26
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_26
.c1d_26:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_26:
    test rax, rax
    jz .c2d_26
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_26
.c2d_26:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 30
    call arena_alloc
    mov qword [rax], 22
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 216
    mov byte [rax + 15], 170
    mov byte [rax + 16], 217
    mov byte [rax + 17], 138
    mov byte [rax + 18], 216
    mov byte [rax + 19], 172
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 32
    mov byte [rax + 23], 91
    mov byte [rax + 24], 50
    mov byte [rax + 25], 44
    mov byte [rax + 26], 49
    mov byte [rax + 27], 93
    mov byte [rax + 28], 58
    mov byte [rax + 29], 32
    push rax
    mov rax, [vars + 48]
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
    call print_str
    mov rdi, 30
    call arena_alloc
    mov qword [rax], 22
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 216
    mov byte [rax + 15], 170
    mov byte [rax + 16], 217
    mov byte [rax + 17], 138
    mov byte [rax + 18], 216
    mov byte [rax + 19], 172
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 32
    mov byte [rax + 23], 91
    mov byte [rax + 24], 50
    mov byte [rax + 25], 44
    mov byte [rax + 26], 50
    mov byte [rax + 27], 93
    mov byte [rax + 28], 58
    mov byte [rax + 29], 32
    push rax
    mov rax, [vars + 56]
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
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
