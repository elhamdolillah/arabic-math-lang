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

    mov rax, 0
    push rax
    mov rax, 2
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 0], rax
    mov rax, 1
    mov [vars + 8], rax
    mov rax, 0
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    pop rbx
    add rax, rbx
    mov [vars + 24], rax
    mov rax, [vars + 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 32], rax
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 78
    mov byte [rax + 9], 79
    mov byte [rax + 10], 84
    mov byte [rax + 11], 40
    mov byte [rax + 12], 48
    mov byte [rax + 13], 41
    mov byte [rax + 14], 32
    mov byte [rax + 15], 61
    mov byte [rax + 16], 32
    push rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_7
    mov rax, 1
    jmp .end_7
.else_7:
    mov rax, 0
.end_7:
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
    mov rax, 1
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    pop rbx
    add rax, rbx
    mov [vars + 24], rax
    mov rax, [vars + 24]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 32], rax
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 78
    mov byte [rax + 9], 79
    mov byte [rax + 10], 84
    mov byte [rax + 11], 40
    mov byte [rax + 12], 49
    mov byte [rax + 13], 41
    mov byte [rax + 14], 32
    mov byte [rax + 15], 61
    mov byte [rax + 16], 32
    push rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_8
    mov rax, 1
    jmp .end_8
.else_8:
    mov rax, 0
.end_8:
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

    mov rax, 60
    xor rdi, rdi
    syscall
