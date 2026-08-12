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
    mov rax, [vars + 24]
    mov [vars + 40], rax
    mov rdi, 28
    call arena_alloc
    mov qword [rax], 20
    mov byte [rax + 8], 102
    mov byte [rax + 9], 40
    mov byte [rax + 10], 120
    mov byte [rax + 11], 41
    mov byte [rax + 12], 32
    mov byte [rax + 13], 61
    mov byte [rax + 14], 32
    mov byte [rax + 15], 51
    mov byte [rax + 16], 120
    mov byte [rax + 17], 194
    mov byte [rax + 18], 178
    mov byte [rax + 19], 32
    mov byte [rax + 20], 43
    mov byte [rax + 21], 32
    mov byte [rax + 22], 50
    mov byte [rax + 23], 120
    mov byte [rax + 24], 32
    mov byte [rax + 25], 43
    mov byte [rax + 26], 32
    mov byte [rax + 27], 49
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 102
    mov byte [rax + 9], 39
    mov byte [rax + 10], 40
    mov byte [rax + 11], 120
    mov byte [rax + 12], 41
    mov byte [rax + 13], 32
    mov byte [rax + 14], 61
    mov byte [rax + 15], 32
    mov byte [rax + 16], 54
    mov byte [rax + 17], 120
    mov byte [rax + 18], 32
    mov byte [rax + 19], 43
    mov byte [rax + 20], 32
    mov byte [rax + 21], 50
    call print_str
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 102
    mov byte [rax + 9], 39
    mov byte [rax + 10], 39
    mov byte [rax + 11], 40
    mov byte [rax + 12], 120
    mov byte [rax + 13], 41
    mov byte [rax + 14], 32
    mov byte [rax + 15], 61
    mov byte [rax + 16], 32
    push rax
    mov rax, [vars + 40]
    test rax, rax
    jns .npos_37
    neg rax
    mov byte [negflag], 1
.npos_37:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_37:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_37
    cmp byte [negflag], 1
    jne .nskip2_37
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_37:
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
.ntc_37:
    test rcx, rcx
    jz .ntd_37
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_37
.ntd_37:
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
.cpy1_38:
    test rax, rax
    jz .c1d_38
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_38
.c1d_38:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_38:
    test rax, rax
    jz .c2d_38
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_38
.c2d_38:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 65
    call arena_alloc
    mov qword [rax], 57
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 180
    mov byte [rax + 16], 216
    mov byte [rax + 17], 170
    mov byte [rax + 18], 217
    mov byte [rax + 19], 130
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 216
    mov byte [rax + 28], 171
    mov byte [rax + 29], 216
    mov byte [rax + 30], 167
    mov byte [rax + 31], 217
    mov byte [rax + 32], 134
    mov byte [rax + 33], 217
    mov byte [rax + 34], 138
    mov byte [rax + 35], 216
    mov byte [rax + 36], 169
    mov byte [rax + 37], 32
    mov byte [rax + 38], 216
    mov byte [rax + 39], 171
    mov byte [rax + 40], 216
    mov byte [rax + 41], 167
    mov byte [rax + 42], 216
    mov byte [rax + 43], 168
    mov byte [rax + 44], 216
    mov byte [rax + 45], 170
    mov byte [rax + 46], 216
    mov byte [rax + 47], 169
    mov byte [rax + 48], 32
    mov byte [rax + 49], 61
    mov byte [rax + 50], 32
    mov byte [rax + 51], 216
    mov byte [rax + 52], 167
    mov byte [rax + 53], 217
    mov byte [rax + 54], 132
    mov byte [rax + 55], 216
    mov byte [rax + 56], 170
    mov byte [rax + 57], 216
    mov byte [rax + 58], 179
    mov byte [rax + 59], 216
    mov byte [rax + 60], 167
    mov byte [rax + 61], 216
    mov byte [rax + 62], 177
    mov byte [rax + 63], 216
    mov byte [rax + 64], 185
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
