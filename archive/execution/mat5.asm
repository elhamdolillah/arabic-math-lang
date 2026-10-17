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
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 32], rax
    mov rdi, 27
    call arena_alloc
    mov qword [rax], 19
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 181
    mov byte [rax + 16], 217
    mov byte [rax + 17], 129
    mov byte [rax + 18], 217
    mov byte [rax + 19], 136
    mov byte [rax + 20], 217
    mov byte [rax + 21], 129
    mov byte [rax + 22], 216
    mov byte [rax + 23], 169
    mov byte [rax + 24], 58
    mov byte [rax + 25], 32
    mov byte [rax + 26], 91
    push rax
    mov rax, [vars + 0]
    test rax, rax
    jns .npos_73
    neg rax
    mov byte [negflag], 1
.npos_73:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_73:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_73
    cmp byte [negflag], 1
    jne .nskip2_73
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_73:
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
.ntc_73:
    test rcx, rcx
    jz .ntd_73
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_73
.ntd_73:
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
.cpy1_74:
    test rax, rax
    jz .c1d_74
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_74
.c1d_74:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_74:
    test rax, rax
    jz .c2d_74
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_74
.c2d_74:
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
.cpy1_75:
    test rax, rax
    jz .c1d_75
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_75
.c1d_75:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_75:
    test rax, rax
    jz .c2d_75
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_75
.c2d_75:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 8]
    test rax, rax
    jns .npos_76
    neg rax
    mov byte [negflag], 1
.npos_76:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_76:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_76
    cmp byte [negflag], 1
    jne .nskip2_76
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_76:
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
.ntc_76:
    test rcx, rcx
    jz .ntd_76
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_76
.ntd_76:
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
.cpy1_77:
    test rax, rax
    jz .c1d_77
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_77
.c1d_77:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_77:
    test rax, rax
    jz .c2d_77
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_77
.c2d_77:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 10
    call arena_alloc
    mov qword [rax], 2
    mov byte [rax + 8], 59
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
.cpy1_78:
    test rax, rax
    jz .c1d_78
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_78
.c1d_78:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_78:
    test rax, rax
    jz .c2d_78
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_78
.c2d_78:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 16]
    test rax, rax
    jns .npos_79
    neg rax
    mov byte [negflag], 1
.npos_79:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_79:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_79
    cmp byte [negflag], 1
    jne .nskip2_79
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_79:
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
.ntc_79:
    test rcx, rcx
    jz .ntd_79
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_79
.ntd_79:
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
.cpy1_80:
    test rax, rax
    jz .c1d_80
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_80
.c1d_80:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_80:
    test rax, rax
    jz .c2d_80
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_80
.c2d_80:
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
.cpy1_81:
    test rax, rax
    jz .c1d_81
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_81
.c1d_81:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_81:
    test rax, rax
    jz .c2d_81
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_81
.c2d_81:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 24]
    test rax, rax
    jns .npos_82
    neg rax
    mov byte [negflag], 1
.npos_82:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_82:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_82
    cmp byte [negflag], 1
    jne .nskip2_82
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_82:
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
.ntc_82:
    test rcx, rcx
    jz .ntd_82
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_82
.ntd_82:
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
.cpy1_83:
    test rax, rax
    jz .c1d_83
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_83
.c1d_83:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_83:
    test rax, rax
    jz .c2d_83
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_83
.c2d_83:
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
.cpy1_84:
    test rax, rax
    jz .c1d_84
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_84
.c1d_84:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_84:
    test rax, rax
    jz .c2d_84
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_84
.c2d_84:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 173
    mov byte [rax + 16], 216
    mov byte [rax + 17], 175
    mov byte [rax + 18], 216
    mov byte [rax + 19], 175
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    push rax
    mov rax, [vars + 32]
    test rax, rax
    jns .npos_85
    neg rax
    mov byte [negflag], 1
.npos_85:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_85:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_85
    cmp byte [negflag], 1
    jne .nskip2_85
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_85:
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
.ntc_85:
    test rcx, rcx
    jz .ntd_85
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_85
.ntd_85:
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
.cpy1_86:
    test rax, rax
    jz .c1d_86
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_86
.c1d_86:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_86:
    test rax, rax
    jz .c2d_86
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_86
.c2d_86:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
