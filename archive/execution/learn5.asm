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

    mov rax, 2
    mov [vars + 0], rax
    mov rax, 5
    mov [vars + 8], rax
    mov rax, 10
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 8]
    pop rbx
    imul rax, rbx
    mov [vars + 24], rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 24]
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 32], rax
    mov rdi, 52
    call arena_alloc
    mov qword [rax], 44
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
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 217
    mov byte [rax + 28], 130
    mov byte [rax + 29], 216
    mov byte [rax + 30], 175
    mov byte [rax + 31], 217
    mov byte [rax + 32], 138
    mov byte [rax + 33], 217
    mov byte [rax + 34], 133
    mov byte [rax + 35], 216
    mov byte [rax + 36], 169
    mov byte [rax + 37], 58
    mov byte [rax + 38], 32
    mov byte [rax + 39], 216
    mov byte [rax + 40], 182
    mov byte [rax + 41], 216
    mov byte [rax + 42], 177
    mov byte [rax + 43], 216
    mov byte [rax + 44], 168
    mov byte [rax + 45], 32
    mov byte [rax + 46], 217
    mov byte [rax + 47], 129
    mov byte [rax + 48], 217
    mov byte [rax + 49], 138
    mov byte [rax + 50], 32
    mov byte [rax + 51], 50
    call print_str
    mov rdi, 61
    call arena_alloc
    mov qword [rax], 53
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 171
    mov byte [rax + 16], 216
    mov byte [rax + 17], 167
    mov byte [rax + 18], 217
    mov byte [rax + 19], 132
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    mov byte [rax + 22], 53
    mov byte [rax + 23], 216
    mov byte [rax + 24], 140
    mov byte [rax + 25], 32
    mov byte [rax + 26], 216
    mov byte [rax + 27], 167
    mov byte [rax + 28], 217
    mov byte [rax + 29], 132
    mov byte [rax + 30], 217
    mov byte [rax + 31], 133
    mov byte [rax + 32], 216
    mov byte [rax + 33], 170
    mov byte [rax + 34], 217
    mov byte [rax + 35], 136
    mov byte [rax + 36], 217
    mov byte [rax + 37], 130
    mov byte [rax + 38], 216
    mov byte [rax + 39], 185
    mov byte [rax + 40], 58
    mov byte [rax + 41], 32
    mov byte [rax + 42], 49
    mov byte [rax + 43], 48
    mov byte [rax + 44], 216
    mov byte [rax + 45], 140
    mov byte [rax + 46], 32
    mov byte [rax + 47], 216
    mov byte [rax + 48], 167
    mov byte [rax + 49], 217
    mov byte [rax + 50], 132
    mov byte [rax + 51], 217
    mov byte [rax + 52], 129
    mov byte [rax + 53], 216
    mov byte [rax + 54], 185
    mov byte [rax + 55], 217
    mov byte [rax + 56], 132
    mov byte [rax + 57], 217
    mov byte [rax + 58], 138
    mov byte [rax + 59], 58
    mov byte [rax + 60], 32
    push rax
    mov rax, [vars + 24]
    test rax, rax
    jns .npos_43
    neg rax
    mov byte [negflag], 1
.npos_43:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_43:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_43
    cmp byte [negflag], 1
    jne .nskip2_43
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_43:
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
.ntc_43:
    test rcx, rcx
    jz .ntd_43
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_43
.ntd_43:
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
.cpy1_44:
    test rax, rax
    jz .c1d_44
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_44
.c1d_44:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_44:
    test rax, rax
    jz .c2d_44
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_44
.c2d_44:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 174
    mov byte [rax + 14], 216
    mov byte [rax + 15], 183
    mov byte [rax + 16], 216
    mov byte [rax + 17], 163
    mov byte [rax + 18], 58
    mov byte [rax + 19], 32
    push rax
    mov rax, [vars + 32]
    test rax, rax
    jns .npos_45
    neg rax
    mov byte [negflag], 1
.npos_45:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_45:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_45
    cmp byte [negflag], 1
    jne .nskip2_45
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_45:
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
.ntc_45:
    test rcx, rcx
    jz .ntd_45
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_45
.ntd_45:
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
.cpy1_46:
    test rax, rax
    jz .c1d_46
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_46
.c1d_46:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_46:
    test rax, rax
    jz .c2d_46
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_46
.c2d_46:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rax, [vars + 32]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_18
    mov rax, [vars + 0]
    jmp .end_18
.else_18:
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 8]
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
.end_18:
    mov [vars + 48], rax
    mov rdi, 51
    call arena_alloc
    mov qword [rax], 43
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
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 216
    mov byte [rax + 28], 172
    mov byte [rax + 29], 216
    mov byte [rax + 30], 175
    mov byte [rax + 31], 217
    mov byte [rax + 32], 138
    mov byte [rax + 33], 216
    mov byte [rax + 34], 175
    mov byte [rax + 35], 216
    mov byte [rax + 36], 169
    mov byte [rax + 37], 58
    mov byte [rax + 38], 32
    mov byte [rax + 39], 216
    mov byte [rax + 40], 182
    mov byte [rax + 41], 216
    mov byte [rax + 42], 177
    mov byte [rax + 43], 216
    mov byte [rax + 44], 168
    mov byte [rax + 45], 32
    mov byte [rax + 46], 217
    mov byte [rax + 47], 129
    mov byte [rax + 48], 217
    mov byte [rax + 49], 138
    mov byte [rax + 50], 32
    push rax
    mov rax, [vars + 48]
    test rax, rax
    jns .npos_47
    neg rax
    mov byte [negflag], 1
.npos_47:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_47:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_47
    cmp byte [negflag], 1
    jne .nskip2_47
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_47:
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
.ntc_47:
    test rcx, rcx
    jz .ntd_47
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_47
.ntd_47:
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
.cpy1_48:
    test rax, rax
    jz .c1d_48
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_48
.c1d_48:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_48:
    test rax, rax
    jz .c2d_48
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_48
.c2d_48:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
