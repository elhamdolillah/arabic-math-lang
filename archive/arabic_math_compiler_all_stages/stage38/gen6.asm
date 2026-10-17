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

    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 216
    mov byte [rax + 9], 183
    mov byte [rax + 10], 216
    mov byte [rax + 11], 167
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    mov byte [rax + 14], 216
    mov byte [rax + 15], 168
    mov [vars + 0], rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 216
    mov byte [rax + 13], 170
    mov byte [rax + 14], 217
    mov byte [rax + 15], 135
    mov byte [rax + 16], 216
    mov byte [rax + 17], 175
    mov [vars + 8], rax
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
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
.cpy1_31:
    test rax, rax
    jz .c1d_31
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_31
.c1d_31:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_31:
    test rax, rax
    jz .c2d_31
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_31
.c2d_31:
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
.cpy1_32:
    test rax, rax
    jz .c1d_32
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_32
.c1d_32:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_32:
    test rax, rax
    jz .c2d_32
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_32
.c2d_32:
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
.cpy1_33:
    test rax, rax
    jz .c1d_33
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_33
.c1d_33:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_33:
    test rax, rax
    jz .c2d_33
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_33
.c2d_33:
    pop r11
    pop r10
    mov rax, r12
    mov [vars + 16], rax
    mov rdi, 26
    call arena_alloc
    mov qword [rax], 18
    mov byte [rax + 8], 103
    mov byte [rax + 9], 101
    mov byte [rax + 10], 110
    mov byte [rax + 11], 101
    mov byte [rax + 12], 114
    mov byte [rax + 13], 97
    mov byte [rax + 14], 116
    mov byte [rax + 15], 101
    mov byte [rax + 16], 100
    mov byte [rax + 17], 95
    mov byte [rax + 18], 116
    mov byte [rax + 19], 101
    mov byte [rax + 20], 120
    mov byte [rax + 21], 116
    mov byte [rax + 22], 46
    mov byte [rax + 23], 116
    mov byte [rax + 24], 120
    mov byte [rax + 25], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_34:
    test rcx, rcx
    jz .fp_d_34
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_34
.fp_d_34:
    mov byte [rdi], 0
    lea rdi, [file_path_buf]
    mov rsi, 66
    mov rdx, 420
    mov rax, 2
    push rcx
    syscall
    pop rcx
    mov [vars + 24], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 16]
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 24]
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 32
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 24]
    push rax
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
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 24]
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 32
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 24]
    push rax
    mov rdi, 29
    call arena_alloc
    mov qword [rax], 21
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 185
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 185
    mov byte [rax + 21], 216
    mov byte [rax + 22], 168
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 216
    mov byte [rax + 26], 175
    mov byte [rax + 27], 216
    mov byte [rax + 28], 169
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 24]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rdi, 26
    call arena_alloc
    mov qword [rax], 18
    mov byte [rax + 8], 103
    mov byte [rax + 9], 101
    mov byte [rax + 10], 110
    mov byte [rax + 11], 101
    mov byte [rax + 12], 114
    mov byte [rax + 13], 97
    mov byte [rax + 14], 116
    mov byte [rax + 15], 101
    mov byte [rax + 16], 100
    mov byte [rax + 17], 95
    mov byte [rax + 18], 116
    mov byte [rax + 19], 101
    mov byte [rax + 20], 120
    mov byte [rax + 21], 116
    mov byte [rax + 22], 46
    mov byte [rax + 23], 116
    mov byte [rax + 24], 120
    mov byte [rax + 25], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_35:
    test rcx, rcx
    jz .fp_d_35
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_35
.fp_d_35:
    mov byte [rdi], 0
    lea rdi, [file_path_buf]
    mov rsi, 66
    mov rdx, 420
    mov rax, 2
    push rcx
    syscall
    pop rcx
    mov [vars + 24], rax
    mov rax, [vars + 24]
    push rax
    mov rax, 4096
    mov rdx, rax
    pop rdi
    lea rsi, [file_buf]
    push rcx
    mov rax, 0
    syscall
    pop rcx
    mov rcx, rax
    mov rdi, rax
    add rdi, 8
    call arena_alloc
    mov [rax], rcx
    push rax
    lea rsi, [file_buf]
    lea rdi, [rax + 8]
    mov rdx, rcx
.fr_c_36:
    test rdx, rdx
    jz .fr_d_36
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_36
.fr_d_36:
    pop rax
    mov [vars + 32], rax
    mov rax, [vars + 24]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rax, [vars + 32]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
