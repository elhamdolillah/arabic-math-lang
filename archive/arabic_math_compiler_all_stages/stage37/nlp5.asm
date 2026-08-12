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

str_eq:
    mov rcx, [rdi]
    mov rdx, [rsi]
    cmp rcx, rdx
    jne str_eq_ne
    add rdi, 8
    add rsi, 8
str_eq_loop:
    test rcx, rcx
    jz str_eq_eq
    mov al, [rdi]
    cmp al, [rsi]
    jne str_eq_ne
    inc rdi
    inc rsi
    dec rcx
    jmp str_eq_loop
str_eq_eq:
    mov rax, 1
    ret
str_eq_ne:
    mov rax, 0
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

    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 185
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov [vars + 0], rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 217
    mov byte [rax + 9], 134
    mov byte [rax + 10], 217
    mov byte [rax + 11], 136
    mov byte [rax + 12], 216
    mov byte [rax + 13], 177
    mov [vars + 8], rax
    mov rdi, 37
    call arena_alloc
    mov qword [rax], 29
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 172
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 32
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 217
    mov byte [rax + 26], 133
    mov byte [rax + 27], 217
    mov byte [rax + 28], 136
    mov byte [rax + 29], 217
    mov byte [rax + 30], 132
    mov byte [rax + 31], 216
    mov byte [rax + 32], 175
    mov byte [rax + 33], 216
    mov byte [rax + 34], 169
    mov byte [rax + 35], 58
    mov byte [rax + 36], 32
    push rax
    mov rax, [vars + 0]
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
.cpy1_47:
    test rax, rax
    jz .c1d_47
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_47
.c1d_47:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_47:
    test rax, rax
    jz .c2d_47
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_47
.c2d_47:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 32
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
    push rax
    mov rax, [vars + 8]
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
.cpy1_49:
    test rax, rax
    jz .c1d_49
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_49
.c1d_49:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_49:
    test rax, rax
    jz .c2d_49
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_49
.c2d_49:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 217
    mov byte [rax + 9], 138
    mov byte [rax + 10], 216
    mov byte [rax + 11], 182
    mov byte [rax + 12], 217
    mov byte [rax + 13], 138
    mov byte [rax + 14], 216
    mov byte [rax + 15], 161
    mov [vars + 16], rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 185
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov [vars + 24], rax
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 183
    mov byte [rax + 14], 216
    mov byte [rax + 15], 177
    mov byte [rax + 16], 217
    mov byte [rax + 17], 138
    mov byte [rax + 18], 217
    mov byte [rax + 19], 130
    mov [vars + 32], rax
    mov rdi, 37
    call arena_alloc
    mov qword [rax], 29
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 172
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 32
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 217
    mov byte [rax + 26], 129
    mov byte [rax + 27], 216
    mov byte [rax + 28], 185
    mov byte [rax + 29], 217
    mov byte [rax + 30], 132
    mov byte [rax + 31], 217
    mov byte [rax + 32], 138
    mov byte [rax + 33], 216
    mov byte [rax + 34], 169
    mov byte [rax + 35], 58
    mov byte [rax + 36], 32
    push rax
    mov rax, [vars + 16]
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
.cpy1_50:
    test rax, rax
    jz .c1d_50
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_50
.c1d_50:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_50:
    test rax, rax
    jz .c2d_50
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_50
.c2d_50:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 32
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
.cpy1_51:
    test rax, rax
    jz .c1d_51
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_51
.c1d_51:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_51:
    test rax, rax
    jz .c2d_51
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_51
.c2d_51:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 24]
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
.cpy1_52:
    test rax, rax
    jz .c1d_52
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_52
.c1d_52:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_52:
    test rax, rax
    jz .c2d_52
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_52
.c2d_52:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 32
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
.cpy1_53:
    test rax, rax
    jz .c1d_53
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_53
.c1d_53:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_53:
    test rax, rax
    jz .c2d_53
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_53
.c2d_53:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 32]
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
.cpy1_54:
    test rax, rax
    jz .c1d_54
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_54
.c1d_54:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_54:
    test rax, rax
    jz .c2d_54
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_54
.c2d_54:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
