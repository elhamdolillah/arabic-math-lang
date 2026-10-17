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

    mov rax, 6
    mov [vars + 0], rax
    mov rax, 4
    mov [vars + 8], rax
    mov rax, 2
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 3
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 24], rax
    mov rax, [vars + 8]
    push rax
    mov rax, 2
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 32], rax
    mov rax, [vars + 16]
    mov [vars + 40], rax
    mov rax, 2
    mov [vars + 48], rax
    mov rax, 0
    mov [vars + 56], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 40]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 64], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 40]
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 72], rax
    mov rax, [vars + 64]
    push rax
    mov rax, [vars + 72]
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 80], rax
    mov rdi, 35
    call arena_alloc
    mov qword [rax], 27
    mov byte [rax + 8], 226
    mov byte [rax + 9], 136
    mov byte [rax + 10], 171
    mov byte [rax + 11], 226
    mov byte [rax + 12], 130
    mov byte [rax + 13], 128
    mov byte [rax + 14], 194
    mov byte [rax + 15], 178
    mov byte [rax + 16], 32
    mov byte [rax + 17], 40
    mov byte [rax + 18], 54
    mov byte [rax + 19], 120
    mov byte [rax + 20], 194
    mov byte [rax + 21], 178
    mov byte [rax + 22], 32
    mov byte [rax + 23], 43
    mov byte [rax + 24], 32
    mov byte [rax + 25], 52
    mov byte [rax + 26], 120
    mov byte [rax + 27], 32
    mov byte [rax + 28], 43
    mov byte [rax + 29], 32
    mov byte [rax + 30], 50
    mov byte [rax + 31], 41
    mov byte [rax + 32], 32
    mov byte [rax + 33], 100
    mov byte [rax + 34], 120
    call print_str
    mov rdi, 21
    call arena_alloc
    mov qword [rax], 13
    mov byte [rax + 8], 61
    mov byte [rax + 9], 32
    mov byte [rax + 10], 70
    mov byte [rax + 11], 40
    mov byte [rax + 12], 50
    mov byte [rax + 13], 41
    mov byte [rax + 14], 32
    mov byte [rax + 15], 45
    mov byte [rax + 16], 32
    mov byte [rax + 17], 70
    mov byte [rax + 18], 40
    mov byte [rax + 19], 48
    mov byte [rax + 20], 41
    call print_str
    mov rdi, 10
    call arena_alloc
    mov qword [rax], 2
    mov byte [rax + 8], 61
    mov byte [rax + 9], 32
    push rax
    mov rax, [vars + 64]
    test rax, rax
    jns .npos_22
    neg rax
    mov byte [negflag], 1
.npos_22:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_22:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_22
    cmp byte [negflag], 1
    jne .nskip2_22
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_22:
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
.ntc_22:
    test rcx, rcx
    jz .ntd_22
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_22
.ntd_22:
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
.cpy1_23:
    test rax, rax
    jz .c1d_23
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_23
.c1d_23:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_23:
    test rax, rax
    jz .c2d_23
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_23
.c2d_23:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 45
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
    push rax
    mov rax, [vars + 72]
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
    mov rdi, 10
    call arena_alloc
    mov qword [rax], 2
    mov byte [rax + 8], 61
    mov byte [rax + 9], 32
    push rax
    mov rax, [vars + 80]
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

    mov rax, 60
    xor rdi, rdi
    syscall
