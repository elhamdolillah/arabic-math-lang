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

    mov rdi, 25
    call arena_alloc
    mov qword [rax], 17
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
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 134
    mov byte [rax + 21], 217
    mov byte [rax + 22], 136
    mov byte [rax + 23], 216
    mov byte [rax + 24], 177
    mov [vars + 0], rax
    mov rdi, 27
    call arena_alloc
    mov qword [rax], 19
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 172
    mov byte [rax + 14], 217
    mov byte [rax + 15], 135
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 184
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 133
    mov [vars + 8], rax
    mov rdi, 65
    call arena_alloc
    mov qword [rax], 57
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 216
    mov byte [rax + 11], 183
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    mov byte [rax + 14], 216
    mov byte [rax + 15], 168
    mov byte [rax + 16], 217
    mov byte [rax + 17], 136
    mov byte [rax + 18], 216
    mov byte [rax + 19], 167
    mov byte [rax + 20], 32
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 216
    mov byte [rax + 26], 185
    mov byte [rax + 27], 217
    mov byte [rax + 28], 132
    mov byte [rax + 29], 217
    mov byte [rax + 30], 133
    mov byte [rax + 31], 32
    mov byte [rax + 32], 217
    mov byte [rax + 33], 133
    mov byte [rax + 34], 217
    mov byte [rax + 35], 134
    mov byte [rax + 36], 32
    mov byte [rax + 37], 216
    mov byte [rax + 38], 167
    mov byte [rax + 39], 217
    mov byte [rax + 40], 132
    mov byte [rax + 41], 217
    mov byte [rax + 42], 133
    mov byte [rax + 43], 217
    mov byte [rax + 44], 135
    mov byte [rax + 45], 216
    mov byte [rax + 46], 175
    mov byte [rax + 47], 32
    mov byte [rax + 48], 216
    mov byte [rax + 49], 165
    mov byte [rax + 50], 217
    mov byte [rax + 51], 132
    mov byte [rax + 52], 217
    mov byte [rax + 53], 137
    mov byte [rax + 54], 32
    mov byte [rax + 55], 216
    mov byte [rax + 56], 167
    mov byte [rax + 57], 217
    mov byte [rax + 58], 132
    mov byte [rax + 59], 217
    mov byte [rax + 60], 132
    mov byte [rax + 61], 216
    mov byte [rax + 62], 173
    mov byte [rax + 63], 216
    mov byte [rax + 64], 175
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rdi, 10
    call arena_alloc
    mov qword [rax], 2
    mov byte [rax + 8], 46
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
.cpy1_15:
    test rax, rax
    jz .c1d_15
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_15
.c1d_15:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_15:
    test rax, rax
    jz .c2d_15
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_15
.c2d_15:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 10
    call arena_alloc
    mov qword [rax], 2
    mov byte [rax + 8], 46
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
.cpy1_17:
    test rax, rax
    jz .c1d_17
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_17
.c1d_17:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_17:
    test rax, rax
    jz .c2d_17
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_17
.c2d_17:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 46
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
.cpy1_18:
    test rax, rax
    jz .c1d_18
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_18
.c1d_18:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_18:
    test rax, rax
    jz .c2d_18
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_18
.c2d_18:
    pop r11
    pop r10
    mov rax, r12
    mov [vars + 24], rax
    mov rax, [vars + 24]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
