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
    mov rax, 0
    mov [vars + 8], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 8]
    pop rbx
    add rax, rbx
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 100
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 16]
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 24], rax
    mov rdi, 31
    call arena_alloc
    mov qword [rax], 23
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 217
    mov byte [rax + 11], 133
    mov byte [rax + 12], 216
    mov byte [rax + 13], 171
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 216
    mov byte [rax + 17], 169
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 181
    mov byte [rax + 21], 216
    mov byte [rax + 22], 173
    mov byte [rax + 23], 217
    mov byte [rax + 24], 138
    mov byte [rax + 25], 216
    mov byte [rax + 26], 173
    mov byte [rax + 27], 216
    mov byte [rax + 28], 169
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
    push rax
    mov rax, [vars + 0]
    test rax, rax
    jns .npos_36
    neg rax
    mov byte [negflag], 1
.npos_36:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_36:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_36
    cmp byte [negflag], 1
    jne .nskip2_36
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_36:
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
.ntc_36:
    test rcx, rcx
    jz .ntd_36
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_36
.ntd_36:
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
.cpy1_37:
    test rax, rax
    jz .c1d_37
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_37
.c1d_37:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_37:
    test rax, rax
    jz .c2d_37
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_37
.c2d_37:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 31
    call arena_alloc
    mov qword [rax], 23
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 217
    mov byte [rax + 11], 133
    mov byte [rax + 12], 216
    mov byte [rax + 13], 171
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 216
    mov byte [rax + 17], 169
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 174
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 216
    mov byte [rax + 24], 183
    mov byte [rax + 25], 216
    mov byte [rax + 26], 166
    mov byte [rax + 27], 216
    mov byte [rax + 28], 169
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
    push rax
    mov rax, [vars + 8]
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
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 217
    mov byte [rax + 15], 130
    mov byte [rax + 16], 216
    mov byte [rax + 17], 169
    mov byte [rax + 18], 58
    mov byte [rax + 19], 32
    push rax
    mov rax, [vars + 24]
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
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 37
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
