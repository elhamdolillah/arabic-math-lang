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
    mov rdi, 29
    call arena_alloc
    mov qword [rax], 21
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 181
    mov byte [rax + 14], 217
    mov byte [rax + 15], 129
    mov byte [rax + 16], 32
    mov byte [rax + 17], 216
    mov byte [rax + 18], 167
    mov byte [rax + 19], 217
    mov byte [rax + 20], 132
    mov byte [rax + 21], 216
    mov byte [rax + 22], 163
    mov byte [rax + 23], 217
    mov byte [rax + 24], 136
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 58
    mov byte [rax + 28], 32
    push rax
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_1
    mov rax, [rax + 8]
    jmp .hdne_1
.hemp_1:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_1:
    test rax, rax
    jns .npos_1
    neg rax
    mov byte [negflag], 1
.npos_1:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_1:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_1
    cmp byte [negflag], 1
    jne .nskip2_1
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_1:
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
.ntc_1:
    test rcx, rcx
    jz .ntd_1
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_1
.ntd_1:
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
.cpy1_2:
    test rax, rax
    jz .c1d_2
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_2
.c1d_2:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_2:
    test rax, rax
    jz .c2d_2
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_2
.c2d_2:
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
.cpy1_3:
    test rax, rax
    jz .c1d_3
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_3
.c1d_3:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_3:
    test rax, rax
    jz .c2d_3
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_3
.c2d_3:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_5
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
.tcopy_5:
    test rcx, rcx
    jz .tcd_5
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_5
.tcd_5:
    mov rax, r12
    jmp .taine_5
.taihemp_5:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_5:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_2
    mov rax, [rax + 8]
    jmp .hdne_2
.hemp_2:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_2:
    test rax, rax
    jns .npos_4
    neg rax
    mov byte [negflag], 1
.npos_4:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_4:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_4
    cmp byte [negflag], 1
    jne .nskip2_4
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_4:
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
.ntc_4:
    test rcx, rcx
    jz .ntd_4
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_4
.ntd_4:
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
    call print_str
    mov rdi, 31
    call arena_alloc
    mov qword [rax], 23
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 181
    mov byte [rax + 14], 217
    mov byte [rax + 15], 129
    mov byte [rax + 16], 32
    mov byte [rax + 17], 216
    mov byte [rax + 18], 167
    mov byte [rax + 19], 217
    mov byte [rax + 20], 132
    mov byte [rax + 21], 216
    mov byte [rax + 22], 171
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 134
    mov byte [rax + 27], 217
    mov byte [rax + 28], 138
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
    push rax
    mov rax, [vars + 8]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_3
    mov rax, [rax + 8]
    jmp .hdne_3
.hemp_3:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_3:
    test rax, rax
    jns .npos_7
    neg rax
    mov byte [negflag], 1
.npos_7:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_7:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_7
    cmp byte [negflag], 1
    jne .nskip2_7
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_7:
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
.ntc_7:
    test rcx, rcx
    jz .ntd_7
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_7
.ntd_7:
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
.cpy1_8:
    test rax, rax
    jz .c1d_8
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_8
.c1d_8:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_8:
    test rax, rax
    jz .c2d_8
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_8
.c2d_8:
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
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_11
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
.tcopy_11:
    test rcx, rcx
    jz .tcd_11
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_11
.tcd_11:
    mov rax, r12
    jmp .taine_11
.taihemp_11:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_11:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_4
    mov rax, [rax + 8]
    jmp .hdne_4
.hemp_4:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_4:
    test rax, rax
    jns .npos_10
    neg rax
    mov byte [negflag], 1
.npos_10:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_10:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_10
    cmp byte [negflag], 1
    jne .nskip2_10
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_10:
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
.ntc_10:
    test rcx, rcx
    jz .ntd_10
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_10
.ntd_10:
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
    call print_str
    mov rdi, 40
    call arena_alloc
    mov qword [rax], 32
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 216
    mov byte [rax + 24], 181
    mov byte [rax + 25], 217
    mov byte [rax + 26], 129
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 167
    mov byte [rax + 30], 217
    mov byte [rax + 31], 132
    mov byte [rax + 32], 216
    mov byte [rax + 33], 163
    mov byte [rax + 34], 217
    mov byte [rax + 35], 136
    mov byte [rax + 36], 217
    mov byte [rax + 37], 132
    mov byte [rax + 38], 58
    mov byte [rax + 39], 32
    push rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    xor rbx, rbx
.sl_loop_1:
    test rcx, rcx
    jz .sl_done_1
    mov rdx, rcx
    dec rdx
    add rbx, [rax + rdx * 8 + 8]
    dec rcx
    jmp .sl_loop_1
.sl_done_1:
    mov rax, rbx
    test rax, rax
    jns .npos_13
    neg rax
    mov byte [negflag], 1
.npos_13:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_13:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_13
    cmp byte [negflag], 1
    jne .nskip2_13
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_13:
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
.ntc_13:
    test rcx, rcx
    jz .ntd_13
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_13
.ntd_13:
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
.cpy1_14:
    test rax, rax
    jz .c1d_14
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_14
.c1d_14:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_14:
    test rax, rax
    jz .c2d_14
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_14
.c2d_14:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 42
    call arena_alloc
    mov qword [rax], 34
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 216
    mov byte [rax + 24], 181
    mov byte [rax + 25], 217
    mov byte [rax + 26], 129
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 167
    mov byte [rax + 30], 217
    mov byte [rax + 31], 132
    mov byte [rax + 32], 216
    mov byte [rax + 33], 171
    mov byte [rax + 34], 216
    mov byte [rax + 35], 167
    mov byte [rax + 36], 217
    mov byte [rax + 37], 134
    mov byte [rax + 38], 217
    mov byte [rax + 39], 138
    mov byte [rax + 40], 58
    mov byte [rax + 41], 32
    push rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    xor rbx, rbx
.sl_loop_2:
    test rcx, rcx
    jz .sl_done_2
    mov rdx, rcx
    dec rdx
    add rbx, [rax + rdx * 8 + 8]
    dec rcx
    jmp .sl_loop_2
.sl_done_2:
    mov rax, rbx
    test rax, rax
    jns .npos_15
    neg rax
    mov byte [negflag], 1
.npos_15:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_15:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_15
    cmp byte [negflag], 1
    jne .nskip2_15
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_15:
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
.ntc_15:
    test rcx, rcx
    jz .ntd_15
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_15
.ntd_15:
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
    mov rdi, 37
    call arena_alloc
    mov qword [rax], 29
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 217
    mov byte [rax + 24], 133
    mov byte [rax + 25], 216
    mov byte [rax + 26], 181
    mov byte [rax + 27], 217
    mov byte [rax + 28], 129
    mov byte [rax + 29], 217
    mov byte [rax + 30], 136
    mov byte [rax + 31], 217
    mov byte [rax + 32], 129
    mov byte [rax + 33], 216
    mov byte [rax + 34], 169
    mov byte [rax + 35], 58
    mov byte [rax + 36], 32
    push rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    xor rbx, rbx
.sl_loop_3:
    test rcx, rcx
    jz .sl_done_3
    mov rdx, rcx
    dec rdx
    add rbx, [rax + rdx * 8 + 8]
    dec rcx
    jmp .sl_loop_3
.sl_done_3:
    mov rax, rbx
    push rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    xor rbx, rbx
.sl_loop_4:
    test rcx, rcx
    jz .sl_done_4
    mov rdx, rcx
    dec rdx
    add rbx, [rax + rdx * 8 + 8]
    dec rcx
    jmp .sl_loop_4
.sl_done_4:
    mov rax, rbx
    pop rbx
    add rax, rbx
    test rax, rax
    jns .npos_17
    neg rax
    mov byte [negflag], 1
.npos_17:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_17:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_17
    cmp byte [negflag], 1
    jne .nskip2_17
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_17:
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
.ntc_17:
    test rcx, rcx
    jz .ntd_17
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_17
.ntd_17:
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
.cpy1_18:
    test rax, rax
    jz .c1d_18
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_18
.c1d_18:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_18:
    test rax, rax
    jz .c2d_18
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_18
.c2d_18:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
