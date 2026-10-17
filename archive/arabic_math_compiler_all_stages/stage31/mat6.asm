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
    mov rax, 2
    mov [vars + 8], rax
    mov rax, 3
    mov [vars + 16], rax
    mov rax, 4
    mov [vars + 24], rax
    mov rax, 5
    mov [vars + 32], rax
    mov rax, 6
    mov [vars + 40], rax
    mov rax, 7
    mov [vars + 48], rax
    mov rax, 8
    mov [vars + 56], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 64], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 72], rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 80], rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 40]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 88], rax
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 32
    mov byte [rax + 11], 195
    mov byte [rax + 12], 151
    mov byte [rax + 13], 32
    mov byte [rax + 14], 216
    mov byte [rax + 15], 168
    mov byte [rax + 16], 58
    call print_str
    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 91
    push rax
    mov rax, [vars + 64]
    test rax, rax
    jns .npos_87
    neg rax
    mov byte [negflag], 1
.npos_87:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_87:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_87
    cmp byte [negflag], 1
    jne .nskip2_87
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_87:
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
.ntc_87:
    test rcx, rcx
    jz .ntd_87
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_87
.ntd_87:
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
.cpy1_88:
    test rax, rax
    jz .c1d_88
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_88
.c1d_88:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_88:
    test rax, rax
    jz .c2d_88
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_88
.c2d_88:
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
.cpy1_89:
    test rax, rax
    jz .c1d_89
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_89
.c1d_89:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_89:
    test rax, rax
    jz .c2d_89
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_89
.c2d_89:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 72]
    test rax, rax
    jns .npos_90
    neg rax
    mov byte [negflag], 1
.npos_90:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_90:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_90
    cmp byte [negflag], 1
    jne .nskip2_90
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_90:
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
.ntc_90:
    test rcx, rcx
    jz .ntd_90
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_90
.ntd_90:
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
.cpy1_91:
    test rax, rax
    jz .c1d_91
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_91
.c1d_91:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_91:
    test rax, rax
    jz .c2d_91
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_91
.c2d_91:
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
.cpy1_92:
    test rax, rax
    jz .c1d_92
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_92
.c1d_92:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_92:
    test rax, rax
    jz .c2d_92
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_92
.c2d_92:
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
    mov rax, [vars + 80]
    test rax, rax
    jns .npos_93
    neg rax
    mov byte [negflag], 1
.npos_93:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_93:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_93
    cmp byte [negflag], 1
    jne .nskip2_93
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_93:
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
.ntc_93:
    test rcx, rcx
    jz .ntd_93
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_93
.ntd_93:
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
.cpy1_94:
    test rax, rax
    jz .c1d_94
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_94
.c1d_94:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_94:
    test rax, rax
    jz .c2d_94
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_94
.c2d_94:
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
.cpy1_95:
    test rax, rax
    jz .c1d_95
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_95
.c1d_95:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_95:
    test rax, rax
    jz .c2d_95
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_95
.c2d_95:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 88]
    test rax, rax
    jns .npos_96
    neg rax
    mov byte [negflag], 1
.npos_96:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_96:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_96
    cmp byte [negflag], 1
    jne .nskip2_96
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_96:
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
.ntc_96:
    test rcx, rcx
    jz .ntd_96
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_96
.ntd_96:
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
.cpy1_97:
    test rax, rax
    jz .c1d_97
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_97
.c1d_97:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_97:
    test rax, rax
    jz .c2d_97
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_97
.c2d_97:
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
.cpy1_98:
    test rax, rax
    jz .c1d_98
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_98
.c1d_98:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_98:
    test rax, rax
    jz .c2d_98
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_98
.c2d_98:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
