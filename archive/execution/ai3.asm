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

    mov rdi, 48
    call arena_alloc
    push rax
    mov qword [rax], 5
    mov rdi, 31
    call arena_alloc
    mov qword [rax], 23
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 129
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 217
    mov byte [rax + 19], 132
    mov byte [rax + 20], 32
    mov byte [rax + 21], 217
    mov byte [rax + 22], 133
    mov byte [rax + 23], 216
    mov byte [rax + 24], 177
    mov byte [rax + 25], 217
    mov byte [rax + 26], 129
    mov byte [rax + 27], 217
    mov byte [rax + 28], 136
    mov byte [rax + 29], 216
    mov byte [rax + 30], 185
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 38
    call arena_alloc
    mov qword [rax], 30
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 129
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 217
    mov byte [rax + 19], 136
    mov byte [rax + 20], 217
    mov byte [rax + 21], 132
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 168
    mov byte [rax + 25], 217
    mov byte [rax + 26], 135
    mov byte [rax + 27], 32
    mov byte [rax + 28], 217
    mov byte [rax + 29], 133
    mov byte [rax + 30], 217
    mov byte [rax + 31], 134
    mov byte [rax + 32], 216
    mov byte [rax + 33], 181
    mov byte [rax + 34], 217
    mov byte [rax + 35], 136
    mov byte [rax + 36], 216
    mov byte [rax + 37], 168
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 33
    call arena_alloc
    mov qword [rax], 25
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 168
    mov byte [rax + 16], 216
    mov byte [rax + 17], 170
    mov byte [rax + 18], 216
    mov byte [rax + 19], 175
    mov byte [rax + 20], 216
    mov byte [rax + 21], 163
    mov byte [rax + 22], 32
    mov byte [rax + 23], 217
    mov byte [rax + 24], 133
    mov byte [rax + 25], 216
    mov byte [rax + 26], 177
    mov byte [rax + 27], 217
    mov byte [rax + 28], 129
    mov byte [rax + 29], 217
    mov byte [rax + 30], 136
    mov byte [rax + 31], 216
    mov byte [rax + 32], 185
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rdi, 29
    call arena_alloc
    mov qword [rax], 21
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 174
    mov byte [rax + 14], 216
    mov byte [rax + 15], 168
    mov byte [rax + 16], 216
    mov byte [rax + 17], 177
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 133
    mov byte [rax + 21], 216
    mov byte [rax + 22], 177
    mov byte [rax + 23], 217
    mov byte [rax + 24], 129
    mov byte [rax + 25], 217
    mov byte [rax + 26], 136
    mov byte [rax + 27], 216
    mov byte [rax + 28], 185
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 32], rcx
    mov rdi, 29
    call arena_alloc
    mov qword [rax], 21
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 173
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 133
    mov byte [rax + 21], 217
    mov byte [rax + 22], 134
    mov byte [rax + 23], 216
    mov byte [rax + 24], 181
    mov byte [rax + 25], 217
    mov byte [rax + 26], 136
    mov byte [rax + 27], 216
    mov byte [rax + 28], 168
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 40], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 38
    call arena_alloc
    mov qword [rax], 30
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 216
    mov byte [rax + 11], 175
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 32
    mov byte [rax + 15], 217
    mov byte [rax + 16], 130
    mov byte [rax + 17], 217
    mov byte [rax + 18], 136
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 216
    mov byte [rax + 22], 185
    mov byte [rax + 23], 216
    mov byte [rax + 24], 175
    mov byte [rax + 25], 32
    mov byte [rax + 26], 216
    mov byte [rax + 27], 167
    mov byte [rax + 28], 217
    mov byte [rax + 29], 132
    mov byte [rax + 30], 217
    mov byte [rax + 31], 134
    mov byte [rax + 32], 216
    mov byte [rax + 33], 173
    mov byte [rax + 34], 217
    mov byte [rax + 35], 136
    mov byte [rax + 36], 58
    mov byte [rax + 37], 32
    push rax
    mov rax, [vars + 0]
    mov rax, [rax]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_7:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_7
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
.ntc_7:
    test rcx, rcx
    jz .ntd_7
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_7
.ntd_7:
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
.cpy1_8:
    test rax, rax
    jz .c1d_8
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_8
.c1d_8:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_8:
    test rax, rax
    jz .c2d_8
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_8
.c2d_8:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rax, 0
    mov [vars + 8], rax
    mov rax, 0
    mov [vars + 16], rax
    mov rax, [vars + 0]
    mov r14, [rax]
    lea rbx, [rax + 8]
.fe_2:
    test r14, r14
    jz .feend_2
    mov rax, [rbx]
    mov [vars + 24], rax
    push rbx
    push r14
    mov rax, [vars + 24]
    mov rax, [rax]
    push rax
    mov rax, 1
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 32], rax
    mov rax, [vars + 24]
    push rax
    mov rax, [vars + 32]
    pop rbx
    mov rcx, rax
    test rcx, rcx
    jns .rc_pos_4
    mov rdx, [rbx]
    add rcx, rdx
.rc_pos_4:
    mov rax, [rbx]
    test rcx, rcx
    jl .ch_err_idx_4
    cmp rcx, rax
    jge .ch_err_4
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_4
.ch_err_idx_4:
.ch_err_4:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_4:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rax, 185
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_3
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_3
.else_3:
    mov rax, [vars + 8]
.end_3:
    mov [vars + 8], rax
    mov rax, [vars + 40]
    push rax
    mov rax, 168
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_4
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_4
.else_4:
    mov rax, [vars + 16]
.end_4:
    mov [vars + 16], rax
    pop r14
    pop rbx
    add rbx, 8
    dec r14
    jmp .fe_2
.feend_2:
    mov rdi, 35
    call arena_alloc
    mov qword [rax], 27
    mov byte [rax + 8], 217
    mov byte [rax + 9], 130
    mov byte [rax + 10], 217
    mov byte [rax + 11], 136
    mov byte [rax + 12], 216
    mov byte [rax + 13], 167
    mov byte [rax + 14], 216
    mov byte [rax + 15], 185
    mov byte [rax + 16], 216
    mov byte [rax + 17], 175
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 217
    mov byte [rax + 24], 133
    mov byte [rax + 25], 216
    mov byte [rax + 26], 177
    mov byte [rax + 27], 217
    mov byte [rax + 28], 129
    mov byte [rax + 29], 217
    mov byte [rax + 30], 136
    mov byte [rax + 31], 216
    mov byte [rax + 32], 185
    mov byte [rax + 33], 58
    mov byte [rax + 34], 32
    push rax
    mov rax, [vars + 8]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_9:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_9
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
.ntc_9:
    test rcx, rcx
    jz .ntd_9
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_9
.ntd_9:
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
.cpy1_10:
    test rax, rax
    jz .c1d_10
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_10
.c1d_10:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_10:
    test rax, rax
    jz .c2d_10
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_10
.c2d_10:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 35
    call arena_alloc
    mov qword [rax], 27
    mov byte [rax + 8], 217
    mov byte [rax + 9], 130
    mov byte [rax + 10], 217
    mov byte [rax + 11], 136
    mov byte [rax + 12], 216
    mov byte [rax + 13], 167
    mov byte [rax + 14], 216
    mov byte [rax + 15], 185
    mov byte [rax + 16], 216
    mov byte [rax + 17], 175
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 217
    mov byte [rax + 24], 133
    mov byte [rax + 25], 217
    mov byte [rax + 26], 134
    mov byte [rax + 27], 216
    mov byte [rax + 28], 181
    mov byte [rax + 29], 217
    mov byte [rax + 30], 136
    mov byte [rax + 31], 216
    mov byte [rax + 32], 168
    mov byte [rax + 33], 58
    mov byte [rax + 34], 32
    push rax
    mov rax, [vars + 16]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_11:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_11
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
.ntc_11:
    test rcx, rcx
    jz .ntd_11
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_11
.ntd_11:
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
.cpy1_12:
    test rax, rax
    jz .c1d_12
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_12
.c1d_12:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_12:
    test rax, rax
    jz .c2d_12
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_12
.c2d_12:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
