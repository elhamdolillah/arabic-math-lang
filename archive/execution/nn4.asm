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

    mov rax, 1
    mov [vars + 0], rax
    mov rax, 0
    mov [vars + 8], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 8]
    pop rbx
    add rax, rbx
    mov [vars + 16], rax
    mov rax, [vars + 16]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 24], rax
    mov rax, 0
    push rax
    mov rax, [vars + 0]
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    mov rax, [vars + 8]
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    mov rax, 2
    pop rbx
    add rax, rbx
    mov [vars + 32], rax
    mov rax, [vars + 32]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 40], rax
    mov rax, [vars + 24]
    push rax
    mov rax, 1
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 40]
    push rax
    mov rax, 1
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    push rax
    mov rax, 1
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 48], rax
    mov rax, [vars + 48]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 56], rax
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 88
    mov byte [rax + 9], 79
    mov byte [rax + 10], 82
    mov byte [rax + 11], 40
    mov byte [rax + 12], 49
    mov byte [rax + 13], 44
    mov byte [rax + 14], 48
    mov byte [rax + 15], 41
    mov byte [rax + 16], 32
    mov byte [rax + 17], 61
    mov byte [rax + 18], 32
    push rax
    mov rax, [vars + 56]
    cmp rax, 0
    je .else_9
    mov rax, 1
    jmp .end_9
.else_9:
    mov rax, 0
.end_9:
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
    mov rax, 1
    mov [vars + 0], rax
    mov rax, 1
    mov [vars + 8], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 8]
    pop rbx
    add rax, rbx
    mov [vars + 16], rax
    mov rax, [vars + 16]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 24], rax
    mov rax, 0
    push rax
    mov rax, [vars + 0]
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    mov rax, [vars + 8]
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    mov rax, 2
    pop rbx
    add rax, rbx
    mov [vars + 32], rax
    mov rax, [vars + 32]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 40], rax
    mov rax, [vars + 24]
    push rax
    mov rax, 1
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 40]
    push rax
    mov rax, 1
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    push rax
    mov rax, 1
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 48], rax
    mov rax, [vars + 48]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 56], rax
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 88
    mov byte [rax + 9], 79
    mov byte [rax + 10], 82
    mov byte [rax + 11], 40
    mov byte [rax + 12], 49
    mov byte [rax + 13], 44
    mov byte [rax + 14], 49
    mov byte [rax + 15], 41
    mov byte [rax + 16], 32
    mov byte [rax + 17], 61
    mov byte [rax + 18], 32
    push rax
    mov rax, [vars + 56]
    cmp rax, 0
    je .else_10
    mov rax, 1
    jmp .end_10
.else_10:
    mov rax, 0
.end_10:
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
    call print_str
    mov rax, 0
    mov [vars + 0], rax
    mov rax, 0
    mov [vars + 8], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 8]
    pop rbx
    add rax, rbx
    mov [vars + 16], rax
    mov rax, [vars + 16]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 24], rax
    mov rax, 0
    push rax
    mov rax, [vars + 0]
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    mov rax, [vars + 8]
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    mov rax, 2
    pop rbx
    add rax, rbx
    mov [vars + 32], rax
    mov rax, [vars + 32]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 40], rax
    mov rax, [vars + 24]
    push rax
    mov rax, 1
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 40]
    push rax
    mov rax, 1
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    push rax
    mov rax, 1
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 48], rax
    mov rax, [vars + 48]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 56], rax
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 88
    mov byte [rax + 9], 79
    mov byte [rax + 10], 82
    mov byte [rax + 11], 40
    mov byte [rax + 12], 48
    mov byte [rax + 13], 44
    mov byte [rax + 14], 48
    mov byte [rax + 15], 41
    mov byte [rax + 16], 32
    mov byte [rax + 17], 61
    mov byte [rax + 18], 32
    push rax
    mov rax, [vars + 56]
    cmp rax, 0
    je .else_11
    mov rax, 1
    jmp .end_11
.else_11:
    mov rax, 0
.end_11:
    test rax, rax
    jns .npos_21
    neg rax
    mov byte [negflag], 1
.npos_21:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_21:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_21
    cmp byte [negflag], 1
    jne .nskip2_21
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_21:
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
.ntc_21:
    test rcx, rcx
    jz .ntd_21
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_21
.ntd_21:
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
.cpy1_22:
    test rax, rax
    jz .c1d_22
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_22
.c1d_22:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_22:
    test rax, rax
    jz .c2d_22
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_22
.c2d_22:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
