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

    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 3
    mov rdi, 43
    call arena_alloc
    mov qword [rax], 35
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 180
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 216
    mov byte [rax + 17], 179
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 170
    mov byte [rax + 21], 216
    mov byte [rax + 22], 180
    mov byte [rax + 23], 216
    mov byte [rax + 24], 177
    mov byte [rax + 25], 217
    mov byte [rax + 26], 130
    mov byte [rax + 27], 32
    mov byte [rax + 28], 217
    mov byte [rax + 29], 133
    mov byte [rax + 30], 217
    mov byte [rax + 31], 134
    mov byte [rax + 32], 32
    mov byte [rax + 33], 216
    mov byte [rax + 34], 167
    mov byte [rax + 35], 217
    mov byte [rax + 36], 132
    mov byte [rax + 37], 216
    mov byte [rax + 38], 180
    mov byte [rax + 39], 216
    mov byte [rax + 40], 177
    mov byte [rax + 41], 217
    mov byte [rax + 42], 130
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 41
    call arena_alloc
    mov qword [rax], 33
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 216
    mov byte [rax + 17], 161
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 138
    mov byte [rax + 21], 216
    mov byte [rax + 22], 186
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 217
    mov byte [rax + 26], 138
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 185
    mov byte [rax + 30], 217
    mov byte [rax + 31], 134
    mov byte [rax + 32], 216
    mov byte [rax + 33], 175
    mov byte [rax + 34], 32
    mov byte [rax + 35], 217
    mov byte [rax + 36], 133
    mov byte [rax + 37], 216
    mov byte [rax + 38], 166
    mov byte [rax + 39], 216
    mov byte [rax + 40], 169
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 45
    call arena_alloc
    mov qword [rax], 37
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 163
    mov byte [rax + 14], 216
    mov byte [rax + 15], 177
    mov byte [rax + 16], 216
    mov byte [rax + 17], 182
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 170
    mov byte [rax + 21], 216
    mov byte [rax + 22], 175
    mov byte [rax + 23], 217
    mov byte [rax + 24], 136
    mov byte [rax + 25], 216
    mov byte [rax + 26], 177
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 173
    mov byte [rax + 30], 217
    mov byte [rax + 31], 136
    mov byte [rax + 32], 217
    mov byte [rax + 33], 132
    mov byte [rax + 34], 32
    mov byte [rax + 35], 216
    mov byte [rax + 36], 167
    mov byte [rax + 37], 217
    mov byte [rax + 38], 132
    mov byte [rax + 39], 216
    mov byte [rax + 40], 180
    mov byte [rax + 41], 217
    mov byte [rax + 42], 133
    mov byte [rax + 43], 216
    mov byte [rax + 44], 179
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 216
    mov byte [rax + 17], 161
    mov [vars + 8], rax
    mov rdi, 8
    call arena_alloc
    mov qword [rax], 0
    mov [vars + 16], rax
    mov rax, 0
    mov [vars + 24], rax
    mov rax, [vars + 0]
    mov r14, [rax]
    lea rbx, [rax + 8]
.fe_1:
    test r14, r14
    jz .feend_1
    mov rax, [rbx]
    mov [vars + 32], rax
    push rbx
    push r14
    mov rax, [vars + 32]
    push rax
    mov rax, 0
    pop rbx
    mov rcx, rax
    test rcx, rcx
    jns .rc_pos_1
    mov rdx, [rbx]
    add rcx, rdx
.rc_pos_1:
    mov rax, [rbx]
    test rcx, rcx
    jl .ch_err_idx_1
    cmp rcx, rax
    jge .ch_err_1
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_1
.ch_err_idx_1:
.ch_err_1:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_1:
    mov [vars + 40], rax
    mov rax, [vars + 32]
    push rax
    mov rax, 2
    pop rbx
    mov rcx, rax
    test rcx, rcx
    jns .rc_pos_2
    mov rdx, [rbx]
    add rcx, rdx
.rc_pos_2:
    mov rax, [rbx]
    test rcx, rcx
    jl .ch_err_idx_2
    cmp rcx, rax
    jge .ch_err_2
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_2
.ch_err_idx_2:
.ch_err_2:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_2:
    mov [vars + 48], rax
    mov rax, [vars + 32]
    push rax
    mov rax, 4
    pop rbx
    mov rcx, rax
    test rcx, rcx
    jns .rc_pos_3
    mov rdx, [rbx]
    add rcx, rdx
.rc_pos_3:
    mov rax, [rbx]
    test rcx, rcx
    jl .ch_err_idx_3
    cmp rcx, rax
    jge .ch_err_3
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_3
.ch_err_idx_3:
.ch_err_3:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_3:
    mov [vars + 56], rax
    mov rax, [vars + 40]
    push rax
    mov rax, 216
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    push rax
    mov rax, [vars + 48]
    push rax
    mov rax, 217
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 56]
    push rax
    mov rax, 217
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    pop rbx
    imul rax, rbx
    mov [vars + 64], rax
    mov rax, [vars + 64]
    cmp rax, 0
    je .else_1
    mov rax, [vars + 32]
    jmp .end_1
.else_1:
    mov rax, [vars + 16]
.end_1:
    mov [vars + 16], rax
    mov rax, [vars + 64]
    cmp rax, 0
    je .else_2
    mov rax, 1
    jmp .end_2
.else_2:
    mov rax, [vars + 24]
.end_2:
    mov [vars + 24], rax
    pop r14
    pop rbx
    add rbx, 8
    dec r14
    jmp .fe_1
.feend_1:
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 179
    mov byte [rax + 14], 216
    mov byte [rax + 15], 164
    mov byte [rax + 16], 216
    mov byte [rax + 17], 167
    mov byte [rax + 18], 217
    mov byte [rax + 19], 132
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
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
.cpy1_3:
    test rax, rax
    jz .c1d_3
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_3
.c1d_3:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_3:
    test rax, rax
    jz .c2d_3
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_3
.c2d_3:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 165
    mov byte [rax + 14], 216
    mov byte [rax + 15], 172
    mov byte [rax + 16], 216
    mov byte [rax + 17], 167
    mov byte [rax + 18], 216
    mov byte [rax + 19], 168
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 58
    mov byte [rax + 23], 32
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
.cpy1_4:
    test rax, rax
    jz .c1d_4
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_4
.c1d_4:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_4:
    test rax, rax
    jz .c2d_4
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_4
.c2d_4:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 217
    mov byte [rax + 9], 136
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 58
    mov byte [rax + 15], 32
    push rax
    mov rax, [vars + 24]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_5:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_5
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
.ntc_5:
    test rcx, rcx
    jz .ntd_5
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_5
.ntd_5:
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
.cpy1_6:
    test rax, rax
    jz .c1d_6
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_6
.c1d_6:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_6:
    test rax, rax
    jz .c2d_6
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_6
.c2d_6:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
