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
    mov rax, 1
    mov [vars + 8], rax
    mov rax, 0
    mov [vars + 16], rax
    mov rax, 1
    mov [vars + 24], rax
    mov rax, 0
    mov [vars + 32], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 16]
    pop rbx
    add rax, rbx
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 48], rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 79
    mov byte [rax + 9], 82
    mov byte [rax + 10], 40
    mov byte [rax + 11], 49
    mov byte [rax + 12], 44
    mov byte [rax + 13], 48
    mov byte [rax + 14], 41
    mov byte [rax + 15], 32
    mov byte [rax + 16], 61
    mov byte [rax + 17], 32
    push rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_4
    mov rax, 1
    jmp .end_4
.else_4:
    mov rax, 0
.end_4:
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
    call print_str
    mov rax, 0
    mov [vars + 24], rax
    mov rax, 0
    mov [vars + 32], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 16]
    pop rbx
    add rax, rbx
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 48], rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 79
    mov byte [rax + 9], 82
    mov byte [rax + 10], 40
    mov byte [rax + 11], 48
    mov byte [rax + 12], 44
    mov byte [rax + 13], 48
    mov byte [rax + 14], 41
    mov byte [rax + 15], 32
    mov byte [rax + 16], 61
    mov byte [rax + 17], 32
    push rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_5
    mov rax, 1
    jmp .end_5
.else_5:
    mov rax, 0
.end_5:
    test rax, rax
    jns .npos_9
    neg rax
    mov byte [negflag], 1
.npos_9:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_9:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_9
    cmp byte [negflag], 1
    jne .nskip2_9
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_9:
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
.ntc_9:
    test rcx, rcx
    jz .ntd_9
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_9
.ntd_9:
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
.cpy1_10:
    test rax, rax
    jz .c1d_10
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_10
.c1d_10:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_10:
    test rax, rax
    jz .c2d_10
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_10
.c2d_10:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rax, 1
    mov [vars + 24], rax
    mov rax, 1
    mov [vars + 32], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 16]
    pop rbx
    add rax, rbx
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 48], rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 79
    mov byte [rax + 9], 82
    mov byte [rax + 10], 40
    mov byte [rax + 11], 49
    mov byte [rax + 12], 44
    mov byte [rax + 13], 49
    mov byte [rax + 14], 41
    mov byte [rax + 15], 32
    mov byte [rax + 16], 61
    mov byte [rax + 17], 32
    push rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_6
    mov rax, 1
    jmp .end_6
.else_6:
    mov rax, 0
.end_6:
    test rax, rax
    jns .npos_11
    neg rax
    mov byte [negflag], 1
.npos_11:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_11:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_11
    cmp byte [negflag], 1
    jne .nskip2_11
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_11:
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
.ntc_11:
    test rcx, rcx
    jz .ntd_11
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_11
.ntd_11:
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

    mov rax, 60
    xor rdi, rdi
    syscall
