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

    mov rax, 3
    mov [vars + 0], rax
    mov rax, 2
    mov [vars + 8], rax
    mov rax, 1
    mov [vars + 16], rax
    mov rax, 2
    push rax
    mov rax, [vars + 0]
    pop rbx
    imul rax, rbx
    mov [vars + 24], rax
    mov rax, [vars + 8]
    mov [vars + 32], rax
    mov rax, 1
    mov [vars + 40], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    pop rbx
    add rax, rbx
    mov [vars + 48], rax
    mov rax, 2
    mov [vars + 40], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    pop rbx
    add rax, rbx
    mov [vars + 56], rax
    mov rax, 5
    mov [vars + 40], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    pop rbx
    add rax, rbx
    mov [vars + 64], rax
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 102
    mov byte [rax + 9], 39
    mov byte [rax + 10], 40
    mov byte [rax + 11], 49
    mov byte [rax + 12], 41
    mov byte [rax + 13], 32
    mov byte [rax + 14], 61
    mov byte [rax + 15], 32
    push rax
    mov rax, [vars + 48]
    test rax, rax
    jns .npos_6
    neg rax
    mov byte [negflag], 1
.npos_6:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_6:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_6
    cmp byte [negflag], 1
    jne .nskip2_6
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_6:
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
.ntc_6:
    test rcx, rcx
    jz .ntd_6
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_6
.ntd_6:
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
.cpy1_7:
    test rax, rax
    jz .c1d_7
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_7
.c1d_7:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_7:
    test rax, rax
    jz .c2d_7
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_7
.c2d_7:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 102
    mov byte [rax + 9], 39
    mov byte [rax + 10], 40
    mov byte [rax + 11], 50
    mov byte [rax + 12], 41
    mov byte [rax + 13], 32
    mov byte [rax + 14], 61
    mov byte [rax + 15], 32
    push rax
    mov rax, [vars + 56]
    test rax, rax
    jns .npos_8
    neg rax
    mov byte [negflag], 1
.npos_8:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_8:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_8
    cmp byte [negflag], 1
    jne .nskip2_8
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_8:
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
.ntc_8:
    test rcx, rcx
    jz .ntd_8
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_8
.ntd_8:
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
    call print_str
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 102
    mov byte [rax + 9], 39
    mov byte [rax + 10], 40
    mov byte [rax + 11], 53
    mov byte [rax + 12], 41
    mov byte [rax + 13], 32
    mov byte [rax + 14], 61
    mov byte [rax + 15], 32
    push rax
    mov rax, [vars + 64]
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
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
