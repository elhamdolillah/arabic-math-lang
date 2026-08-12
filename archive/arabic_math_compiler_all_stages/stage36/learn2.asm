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

    mov rdi, 48
    call arena_alloc
    push rax
    mov qword [rax], 5
    mov rax, 2
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 4
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 3
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rax, 6
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 32], rcx
    mov rax, 5
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 40], rcx
    pop rax
    mov [vars + 0], rax
    mov rax, 0
    mov [vars + 8], rax
    mov rax, 0
    mov [vars + 16], rax
    mov rax, [vars + 0]
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
    mov [vars + 24], rax
    mov rax, [vars + 24]
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
    mov rax, [vars + 24]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_4
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_4
.else_4:
    mov rax, [vars + 8]
.end_4:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_5
    mov rax, [vars + 16]
    jmp .end_5
.else_5:
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
.end_5:
    mov [vars + 16], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_13
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
.tcopy_13:
    test rcx, rcx
    jz .tcd_13
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_13
.tcd_13:
    mov rax, r12
    jmp .taine_13
.taihemp_13:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_13:
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
    mov [vars + 24], rax
    mov rax, [vars + 24]
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
    mov rax, [vars + 24]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_6
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_6
.else_6:
    mov rax, [vars + 8]
.end_6:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_7
    mov rax, [vars + 16]
    jmp .end_7
.else_7:
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
.end_7:
    mov [vars + 16], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_15
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
.tcopy_15:
    test rcx, rcx
    jz .tcd_15
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_15
.tcd_15:
    mov rax, r12
    jmp .taine_15
.taihemp_15:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_15:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_14
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
.tcopy_14:
    test rcx, rcx
    jz .tcd_14
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_14
.tcd_14:
    mov rax, r12
    jmp .taine_14
.taihemp_14:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_14:
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
    mov [vars + 24], rax
    mov rax, [vars + 24]
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
    mov rax, [vars + 24]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_8
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_8
.else_8:
    mov rax, [vars + 8]
.end_8:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_9
    mov rax, [vars + 16]
    jmp .end_9
.else_9:
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
.end_9:
    mov [vars + 16], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_18
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
.tcopy_18:
    test rcx, rcx
    jz .tcd_18
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_18
.tcd_18:
    mov rax, r12
    jmp .taine_18
.taihemp_18:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_18:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_17
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
.tcopy_17:
    test rcx, rcx
    jz .tcd_17
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_17
.tcd_17:
    mov rax, r12
    jmp .taine_17
.taihemp_17:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_17:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_16
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
.tcopy_16:
    test rcx, rcx
    jz .tcd_16
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_16
.tcd_16:
    mov rax, r12
    jmp .taine_16
.taihemp_16:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_16:
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
    mov [vars + 24], rax
    mov rax, [vars + 24]
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
    mov rax, [vars + 24]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_10
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_10
.else_10:
    mov rax, [vars + 8]
.end_10:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_11
    mov rax, [vars + 16]
    jmp .end_11
.else_11:
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
.end_11:
    mov [vars + 16], rax
    mov rax, [vars + 0]
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
    jz .hemp_14
    mov rax, [rax + 8]
    jmp .hdne_14
.hemp_14:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_14:
    mov [vars + 24], rax
    mov rax, [vars + 24]
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
    mov rax, [vars + 24]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_12
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_12
.else_12:
    mov rax, [vars + 8]
.end_12:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_13
    mov rax, [vars + 16]
    jmp .end_13
.else_13:
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
.end_13:
    mov [vars + 16], rax
    mov rdi, 43
    call arena_alloc
    mov qword [rax], 35
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 163
    mov byte [rax + 14], 216
    mov byte [rax + 15], 185
    mov byte [rax + 16], 216
    mov byte [rax + 17], 175
    mov byte [rax + 18], 216
    mov byte [rax + 19], 167
    mov byte [rax + 20], 216
    mov byte [rax + 21], 175
    mov byte [rax + 22], 58
    mov byte [rax + 23], 32
    mov byte [rax + 24], 226
    mov byte [rax + 25], 159
    mov byte [rax + 26], 168
    mov byte [rax + 27], 50
    mov byte [rax + 28], 44
    mov byte [rax + 29], 32
    mov byte [rax + 30], 52
    mov byte [rax + 31], 44
    mov byte [rax + 32], 32
    mov byte [rax + 33], 51
    mov byte [rax + 34], 44
    mov byte [rax + 35], 32
    mov byte [rax + 36], 54
    mov byte [rax + 37], 44
    mov byte [rax + 38], 32
    mov byte [rax + 39], 53
    mov byte [rax + 40], 226
    mov byte [rax + 41], 159
    mov byte [rax + 42], 169
    call print_str
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 178
    mov byte [rax + 10], 217
    mov byte [rax + 11], 136
    mov byte [rax + 12], 216
    mov byte [rax + 13], 172
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 58
    mov byte [rax + 17], 32
    push rax
    mov rax, [vars + 8]
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
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 129
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 58
    mov byte [rax + 17], 32
    push rax
    mov rax, [vars + 16]
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
    mov rdi, 56
    call arena_alloc
    mov qword [rax], 48
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 130
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 216
    mov byte [rax + 19], 175
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 58
    mov byte [rax + 23], 32
    mov byte [rax + 24], 216
    mov byte [rax + 25], 178
    mov byte [rax + 26], 217
    mov byte [rax + 27], 136
    mov byte [rax + 28], 216
    mov byte [rax + 29], 172
    mov byte [rax + 30], 217
    mov byte [rax + 31], 138
    mov byte [rax + 32], 40
    mov byte [rax + 33], 216
    mov byte [rax + 34], 179
    mov byte [rax + 35], 41
    mov byte [rax + 36], 32
    mov byte [rax + 37], 226
    mov byte [rax + 38], 159
    mov byte [rax + 39], 186
    mov byte [rax + 40], 32
    mov byte [rax + 41], 40
    mov byte [rax + 42], 216
    mov byte [rax + 43], 179
    mov byte [rax + 44], 195
    mov byte [rax + 45], 183
    mov byte [rax + 46], 50
    mov byte [rax + 47], 41
    mov byte [rax + 48], 194
    mov byte [rax + 49], 183
    mov byte [rax + 50], 50
    mov byte [rax + 51], 32
    mov byte [rax + 52], 61
    mov byte [rax + 53], 32
    mov byte [rax + 54], 216
    mov byte [rax + 55], 179
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
