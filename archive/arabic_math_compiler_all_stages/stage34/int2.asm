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

    mov rax, 4
    mov [vars + 0], rax
    mov rax, 3
    mov [vars + 8], rax
    mov rax, 2
    mov [vars + 16], rax
    mov rax, 1
    mov [vars + 24], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 4
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 32], rax
    mov rax, [vars + 8]
    push rax
    mov rax, 3
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 40], rax
    mov rax, [vars + 16]
    push rax
    mov rax, 2
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 48], rax
    mov rax, [vars + 24]
    mov [vars + 56], rax
    mov rdi, 35
    call arena_alloc
    mov qword [rax], 27
    mov byte [rax + 8], 102
    mov byte [rax + 9], 40
    mov byte [rax + 10], 120
    mov byte [rax + 11], 41
    mov byte [rax + 12], 32
    mov byte [rax + 13], 61
    mov byte [rax + 14], 32
    mov byte [rax + 15], 52
    mov byte [rax + 16], 120
    mov byte [rax + 17], 194
    mov byte [rax + 18], 179
    mov byte [rax + 19], 32
    mov byte [rax + 20], 43
    mov byte [rax + 21], 32
    mov byte [rax + 22], 51
    mov byte [rax + 23], 120
    mov byte [rax + 24], 194
    mov byte [rax + 25], 178
    mov byte [rax + 26], 32
    mov byte [rax + 27], 43
    mov byte [rax + 28], 32
    mov byte [rax + 29], 50
    mov byte [rax + 30], 120
    mov byte [rax + 31], 32
    mov byte [rax + 32], 43
    mov byte [rax + 33], 32
    mov byte [rax + 34], 49
    call print_str
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 226
    mov byte [rax + 9], 136
    mov byte [rax + 10], 171
    mov byte [rax + 11], 102
    mov byte [rax + 12], 40
    mov byte [rax + 13], 120
    mov byte [rax + 14], 41
    mov byte [rax + 15], 100
    mov byte [rax + 16], 120
    mov byte [rax + 17], 32
    mov byte [rax + 18], 61
    mov byte [rax + 19], 32
    push rax
    mov rax, [vars + 32]
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
.cpy1_11:
    test rax, rax
    jz .c1d_11
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_11
.c1d_11:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_11:
    test rax, rax
    jz .c2d_11
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_11
.c2d_11:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 120
    mov byte [rax + 9], 226
    mov byte [rax + 10], 129
    mov byte [rax + 11], 180
    mov byte [rax + 12], 32
    mov byte [rax + 13], 43
    mov byte [rax + 14], 32
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
    mov rax, [vars + 40]
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
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 120
    mov byte [rax + 9], 194
    mov byte [rax + 10], 179
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
    mov rax, [vars + 48]
    test rax, rax
    jns .npos_16
    neg rax
    mov byte [negflag], 1
.npos_16:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_16:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_16
    cmp byte [negflag], 1
    jne .nskip2_16
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_16:
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
.ntc_16:
    test rcx, rcx
    jz .ntd_16
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_16
.ntd_16:
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
.cpy1_17:
    test rax, rax
    jz .c1d_17
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_17
.c1d_17:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_17:
    test rax, rax
    jz .c2d_17
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_17
.c2d_17:
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
    push rax
    mov rax, [vars + 56]
    test rax, rax
    jns .npos_19
    neg rax
    mov byte [negflag], 1
.npos_19:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_19:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_19
    cmp byte [negflag], 1
    jne .nskip2_19
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_19:
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
.ntc_19:
    test rcx, rcx
    jz .ntd_19
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_19
.ntd_19:
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
.cpy1_20:
    test rax, rax
    jz .c1d_20
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_20
.c1d_20:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_20:
    test rax, rax
    jz .c2d_20
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_20
.c2d_20:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 13
    call arena_alloc
    mov qword [rax], 5
    mov byte [rax + 8], 120
    mov byte [rax + 9], 32
    mov byte [rax + 10], 43
    mov byte [rax + 11], 32
    mov byte [rax + 12], 67
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
.cpy1_21:
    test rax, rax
    jz .c1d_21
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_21
.c1d_21:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_21:
    test rax, rax
    jz .c2d_21
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_21
.c2d_21:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
