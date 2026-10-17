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
    mov rax, 0
    mov [vars + 24], rax
    mov rax, 1
    mov [vars + 32], rax
    mov rax, 4
    mov [vars + 40], rax
    mov rax, 5
    mov [vars + 48], rax
    mov rax, 6
    mov [vars + 56], rax
    mov rax, 0
    mov [vars + 64], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 64]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 40]
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 64]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 40]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    push rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 56]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 48]
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    pop rbx
    imul rax, rbx
    pop rbx
    add rax, rbx
    mov [vars + 72], rax
    mov rdi, 47
    call arena_alloc
    mov qword [rax], 39
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
    mov byte [rax + 27], 49
    mov byte [rax + 28], 44
    mov byte [rax + 29], 50
    mov byte [rax + 30], 44
    mov byte [rax + 31], 51
    mov byte [rax + 32], 59
    mov byte [rax + 33], 32
    mov byte [rax + 34], 48
    mov byte [rax + 35], 44
    mov byte [rax + 36], 49
    mov byte [rax + 37], 44
    mov byte [rax + 38], 52
    mov byte [rax + 39], 59
    mov byte [rax + 40], 32
    mov byte [rax + 41], 53
    mov byte [rax + 42], 44
    mov byte [rax + 43], 54
    mov byte [rax + 44], 44
    mov byte [rax + 45], 48
    mov byte [rax + 46], 93
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
    mov rax, [vars + 72]
    test rax, rax
    jns .npos_1
    neg rax
    mov byte [negflag], 1
.npos_1:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_1:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_1
    cmp byte [negflag], 1
    jne .nskip2_1
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_1:
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
.ntc_1:
    test rcx, rcx
    jz .ntd_1
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_1
.ntd_1:
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
.cpy1_2:
    test rax, rax
    jz .c1d_2
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_2
.c1d_2:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_2:
    test rax, rax
    jz .c2d_2
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_2
.c2d_2:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
