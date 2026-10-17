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
    mov rax, [vars + 0]
    push rax
    mov rax, 3
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 16], rax
    mov rax, [vars + 8]
    push rax
    mov rax, 2
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 24], rax
    mov rax, 2
    mov [vars + 32], rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 40], rax
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 118
    mov byte [rax + 9], 40
    mov byte [rax + 10], 116
    mov byte [rax + 11], 41
    mov byte [rax + 12], 32
    mov byte [rax + 13], 61
    mov byte [rax + 14], 32
    mov byte [rax + 15], 51
    mov byte [rax + 16], 116
    mov byte [rax + 17], 194
    mov byte [rax + 18], 178
    mov byte [rax + 19], 32
    mov byte [rax + 20], 43
    mov byte [rax + 21], 32
    mov byte [rax + 22], 50
    mov byte [rax + 23], 116
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 115
    mov byte [rax + 9], 40
    mov byte [rax + 10], 116
    mov byte [rax + 11], 41
    mov byte [rax + 12], 32
    mov byte [rax + 13], 61
    mov byte [rax + 14], 32
    mov byte [rax + 15], 116
    mov byte [rax + 16], 194
    mov byte [rax + 17], 179
    mov byte [rax + 18], 32
    mov byte [rax + 19], 43
    mov byte [rax + 20], 32
    mov byte [rax + 21], 116
    mov byte [rax + 22], 194
    mov byte [rax + 23], 178
    call print_str
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 115
    mov byte [rax + 9], 40
    mov byte [rax + 10], 50
    mov byte [rax + 11], 41
    mov byte [rax + 12], 32
    mov byte [rax + 13], 61
    mov byte [rax + 14], 32
    push rax
    mov rax, [vars + 40]
    test rax, rax
    jns .npos_38
    neg rax
    mov byte [negflag], 1
.npos_38:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_38:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_38
    cmp byte [negflag], 1
    jne .nskip2_38
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_38:
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
.ntc_38:
    test rcx, rcx
    jz .ntd_38
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_38
.ntd_38:
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
.cpy1_39:
    test rax, rax
    jz .c1d_39
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_39
.c1d_39:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_39:
    test rax, rax
    jz .c2d_39
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_39
.c2d_39:
    pop r11
    pop r10
    mov rax, r12
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
    mov byte [rax + 15], 179
    mov byte [rax + 16], 216
    mov byte [rax + 17], 167
    mov byte [rax + 18], 217
    mov byte [rax + 19], 129
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 217
    mov byte [rax + 28], 133
    mov byte [rax + 29], 217
    mov byte [rax + 30], 130
    mov byte [rax + 31], 216
    mov byte [rax + 32], 183
    mov byte [rax + 33], 217
    mov byte [rax + 34], 136
    mov byte [rax + 35], 216
    mov byte [rax + 36], 185
    mov byte [rax + 37], 216
    mov byte [rax + 38], 169
    mov byte [rax + 39], 32
    mov byte [rax + 40], 217
    mov byte [rax + 41], 129
    mov byte [rax + 42], 217
    mov byte [rax + 43], 138
    mov byte [rax + 44], 32
    mov byte [rax + 45], 216
    mov byte [rax + 46], 171
    mov byte [rax + 47], 216
    mov byte [rax + 48], 167
    mov byte [rax + 49], 217
    mov byte [rax + 50], 134
    mov byte [rax + 51], 217
    mov byte [rax + 52], 138
    mov byte [rax + 53], 216
    mov byte [rax + 54], 170
    mov byte [rax + 55], 217
    mov byte [rax + 56], 138
    mov byte [rax + 57], 217
    mov byte [rax + 58], 134
    mov byte [rax + 59], 58
    mov byte [rax + 60], 32
    push rax
    mov rax, [vars + 40]
    test rax, rax
    jns .npos_40
    neg rax
    mov byte [negflag], 1
.npos_40:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_40:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_40
    cmp byte [negflag], 1
    jne .nskip2_40
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_40:
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
.ntc_40:
    test rcx, rcx
    jz .ntd_40
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_40
.ntd_40:
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
.cpy1_41:
    test rax, rax
    jz .c1d_41
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_41
.c1d_41:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_41:
    test rax, rax
    jz .c2d_41
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_41
.c2d_41:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 32
    mov byte [rax + 9], 217
    mov byte [rax + 10], 133
    mov byte [rax + 11], 216
    mov byte [rax + 12], 170
    mov byte [rax + 13], 216
    mov byte [rax + 14], 177
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
.cpy1_42:
    test rax, rax
    jz .c1d_42
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_42
.c1d_42:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_42:
    test rax, rax
    jz .c2d_42
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_42
.c2d_42:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
