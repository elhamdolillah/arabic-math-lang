global _start
section .bss
    vars resq 256
    num_buf resb 32
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

    mov rdi, 40
    call arena_alloc
    push rax
    mov qword [rax], 4
    mov rdi, 49
    call arena_alloc
    mov qword [rax], 41
    mov byte [rax + 8], 216
    mov byte [rax + 9], 178
    mov byte [rax + 10], 217
    mov byte [rax + 11], 136
    mov byte [rax + 12], 216
    mov byte [rax + 13], 172
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 32
    mov byte [rax + 17], 61
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 138
    mov byte [rax + 21], 217
    mov byte [rax + 22], 130
    mov byte [rax + 23], 216
    mov byte [rax + 24], 168
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 167
    mov byte [rax + 30], 217
    mov byte [rax + 31], 132
    mov byte [rax + 32], 217
    mov byte [rax + 33], 130
    mov byte [rax + 34], 216
    mov byte [rax + 35], 179
    mov byte [rax + 36], 217
    mov byte [rax + 37], 133
    mov byte [rax + 38], 216
    mov byte [rax + 39], 169
    mov byte [rax + 40], 32
    mov byte [rax + 41], 216
    mov byte [rax + 42], 185
    mov byte [rax + 43], 217
    mov byte [rax + 44], 132
    mov byte [rax + 45], 217
    mov byte [rax + 46], 137
    mov byte [rax + 47], 32
    mov byte [rax + 48], 50
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 54
    call arena_alloc
    mov qword [rax], 46
    mov byte [rax + 8], 217
    mov byte [rax + 9], 129
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 32
    mov byte [rax + 17], 61
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 132
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 32
    mov byte [rax + 24], 217
    mov byte [rax + 25], 138
    mov byte [rax + 26], 217
    mov byte [rax + 27], 130
    mov byte [rax + 28], 216
    mov byte [rax + 29], 168
    mov byte [rax + 30], 217
    mov byte [rax + 31], 132
    mov byte [rax + 32], 32
    mov byte [rax + 33], 216
    mov byte [rax + 34], 167
    mov byte [rax + 35], 217
    mov byte [rax + 36], 132
    mov byte [rax + 37], 217
    mov byte [rax + 38], 130
    mov byte [rax + 39], 216
    mov byte [rax + 40], 179
    mov byte [rax + 41], 217
    mov byte [rax + 42], 133
    mov byte [rax + 43], 216
    mov byte [rax + 44], 169
    mov byte [rax + 45], 32
    mov byte [rax + 46], 216
    mov byte [rax + 47], 185
    mov byte [rax + 48], 217
    mov byte [rax + 49], 132
    mov byte [rax + 50], 217
    mov byte [rax + 51], 137
    mov byte [rax + 52], 32
    mov byte [rax + 53], 50
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 67
    call arena_alloc
    mov qword [rax], 59
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 217
    mov byte [rax + 11], 136
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 32
    mov byte [rax + 17], 61
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 138
    mov byte [rax + 21], 217
    mov byte [rax + 22], 130
    mov byte [rax + 23], 216
    mov byte [rax + 24], 168
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 167
    mov byte [rax + 30], 217
    mov byte [rax + 31], 132
    mov byte [rax + 32], 217
    mov byte [rax + 33], 130
    mov byte [rax + 34], 216
    mov byte [rax + 35], 179
    mov byte [rax + 36], 217
    mov byte [rax + 37], 133
    mov byte [rax + 38], 216
    mov byte [rax + 39], 169
    mov byte [rax + 40], 32
    mov byte [rax + 41], 216
    mov byte [rax + 42], 185
    mov byte [rax + 43], 217
    mov byte [rax + 44], 132
    mov byte [rax + 45], 217
    mov byte [rax + 46], 137
    mov byte [rax + 47], 32
    mov byte [rax + 48], 49
    mov byte [rax + 49], 32
    mov byte [rax + 50], 217
    mov byte [rax + 51], 136
    mov byte [rax + 52], 217
    mov byte [rax + 53], 134
    mov byte [rax + 54], 217
    mov byte [rax + 55], 129
    mov byte [rax + 56], 216
    mov byte [rax + 57], 179
    mov byte [rax + 58], 217
    mov byte [rax + 59], 135
    mov byte [rax + 60], 32
    mov byte [rax + 61], 217
    mov byte [rax + 62], 129
    mov byte [rax + 63], 217
    mov byte [rax + 64], 130
    mov byte [rax + 65], 216
    mov byte [rax + 66], 183
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rdi, 37
    call arena_alloc
    mov qword [rax], 29
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 216
    mov byte [rax + 13], 168
    mov byte [rax + 14], 216
    mov byte [rax + 15], 185
    mov byte [rax + 16], 32
    mov byte [rax + 17], 61
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 185
    mov byte [rax + 21], 216
    mov byte [rax + 22], 175
    mov byte [rax + 23], 216
    mov byte [rax + 24], 175
    mov byte [rax + 25], 32
    mov byte [rax + 26], 195
    mov byte [rax + 27], 151
    mov byte [rax + 28], 32
    mov byte [rax + 29], 217
    mov byte [rax + 30], 134
    mov byte [rax + 31], 217
    mov byte [rax + 32], 129
    mov byte [rax + 33], 216
    mov byte [rax + 34], 179
    mov byte [rax + 35], 217
    mov byte [rax + 36], 135
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 32], rcx
    pop rax
    mov [vars + 0], rax
    mov rax, 7
    mov [vars + 8], rax
    mov rax, 0
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
    mov rax, [vars + 24]
    push rax
    mov rax, 2
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_5
    mov rax, 1
    jmp .end_5
.else_5:
    mov rax, 0
.end_5:
    mov [vars + 16], rax
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 185
    mov byte [rax + 14], 216
    mov byte [rax + 15], 175
    mov byte [rax + 16], 216
    mov byte [rax + 17], 175
    mov byte [rax + 18], 58
    mov byte [rax + 19], 32
    push rax
    mov rax, [vars + 8]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_13:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_13
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
.ntc_13:
    test rcx, rcx
    jz .ntd_13
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_13
.ntd_13:
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
    call print_str
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 216
    mov byte [rax + 9], 178
    mov byte [rax + 10], 217
    mov byte [rax + 11], 136
    mov byte [rax + 12], 216
    mov byte [rax + 13], 172
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 216
    mov byte [rax + 17], 159
    mov byte [rax + 18], 32
    push rax
    mov rax, [vars + 16]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_15:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_15
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
.ntc_15:
    test rcx, rcx
    jz .ntd_15
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_15
.ntd_15:
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
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
