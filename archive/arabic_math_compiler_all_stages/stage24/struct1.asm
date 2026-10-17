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
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 216
    mov byte [rax + 11], 173
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 175
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 129
    mov byte [rax + 10], 216
    mov byte [rax + 11], 167
    mov byte [rax + 12], 216
    mov byte [rax + 13], 183
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 216
    mov byte [rax + 17], 169
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 138
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 3
    mov rax, 30
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 25
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 35
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 8], rax
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 3
    mov rax, 175
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 160
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 180
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 16], rax
    mov rdi, 31
    call arena_alloc
    mov qword [rax], 23
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 216
    mov byte [rax + 11], 175
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 32
    mov byte [rax + 15], 216
    mov byte [rax + 16], 167
    mov byte [rax + 17], 217
    mov byte [rax + 18], 132
    mov byte [rax + 19], 216
    mov byte [rax + 20], 163
    mov byte [rax + 21], 216
    mov byte [rax + 22], 180
    mov byte [rax + 23], 216
    mov byte [rax + 24], 174
    mov byte [rax + 25], 216
    mov byte [rax + 26], 167
    mov byte [rax + 27], 216
    mov byte [rax + 28], 181
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
    push rax
    mov rax, [vars + 0]
    mov rax, [rax]
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
    mov rdi, 35
    call arena_alloc
    mov qword [rax], 27
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 216
    mov byte [rax + 24], 163
    mov byte [rax + 25], 216
    mov byte [rax + 26], 185
    mov byte [rax + 27], 217
    mov byte [rax + 28], 133
    mov byte [rax + 29], 216
    mov byte [rax + 30], 167
    mov byte [rax + 31], 216
    mov byte [rax + 32], 177
    mov byte [rax + 33], 58
    mov byte [rax + 34], 32
    push rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    xor rbx, rbx
.sl_loop_1:
    test rcx, rcx
    jz .sl_done_1
    mov rdx, rcx
    dec rdx
    add rbx, [rax + rdx * 8 + 8]
    dec rcx
    jmp .sl_loop_1
.sl_done_1:
    mov rax, rbx
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_3:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_3
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
.ntc_3:
    test rcx, rcx
    jz .ntd_3
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_3
.ntd_3:
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
    mov rdi, 35
    call arena_alloc
    mov qword [rax], 27
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 216
    mov byte [rax + 24], 163
    mov byte [rax + 25], 216
    mov byte [rax + 26], 183
    mov byte [rax + 27], 217
    mov byte [rax + 28], 136
    mov byte [rax + 29], 216
    mov byte [rax + 30], 167
    mov byte [rax + 31], 217
    mov byte [rax + 32], 132
    mov byte [rax + 33], 58
    mov byte [rax + 34], 32
    push rax
    mov rax, [vars + 16]
    mov rcx, [rax]
    xor rbx, rbx
.sl_loop_2:
    test rcx, rcx
    jz .sl_done_2
    mov rdx, rcx
    dec rdx
    add rbx, [rax + rdx * 8 + 8]
    dec rcx
    jmp .sl_loop_2
.sl_done_2:
    mov rax, rbx
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
