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

    mov rdi, 64
    call arena_alloc
    push rax
    mov qword [rax], 7
    mov rax, 10
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 25
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 30
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rax, 15
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 32], rcx
    mov rax, 40
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 40], rcx
    mov rax, 5
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 48], rcx
    mov rax, 50
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 56], rcx
    pop rax
    mov [vars + 0], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    xor rbx, rbx
.sl_loop_6:
    test rcx, rcx
    jz .sl_done_6
    mov rdx, rcx
    dec rdx
    add rbx, [rax + rdx * 8 + 8]
    dec rcx
    jmp .sl_loop_6
.sl_done_6:
    mov rax, rbx
    mov [vars + 8], rax
    mov rax, [vars + 0]
    mov rax, [rax]
    mov [vars + 16], rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 16]
    pop rbx
    mov rdx, 0
    mov rcx, rax
    mov rax, rbx
    div rcx
    mov [vars + 24], rax
    mov rax, 0
    mov [vars + 32], rax
    mov rax, [vars + 0]
    mov r14, [rax]
    lea rbx, [rax + 8]
.fe_7:
    test r14, r14
    jz .feend_7
    mov rax, [rbx]
    mov [vars + 40], rax
    push rbx
    push r14
    mov rax, [vars + 40]
    push rax
    mov rax, [vars + 32]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setg al
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_6
    mov rax, [vars + 40]
    jmp .end_6
.else_6:
    mov rax, [vars + 32]
.end_6:
    mov [vars + 32], rax
    pop r14
    pop rbx
    add rbx, 8
    dec r14
    jmp .fe_7
.feend_7:
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
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 172
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 217
    mov byte [rax + 19], 136
    mov byte [rax + 20], 216
    mov byte [rax + 21], 185
    mov byte [rax + 22], 58
    mov byte [rax + 23], 32
    push rax
    mov rax, [vars + 8]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_17:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_17
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
.ntc_17:
    test rcx, rcx
    jz .ntd_17
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_17
.ntd_17:
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
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 170
    mov byte [rax + 16], 217
    mov byte [rax + 17], 136
    mov byte [rax + 18], 216
    mov byte [rax + 19], 179
    mov byte [rax + 20], 216
    mov byte [rax + 21], 183
    mov byte [rax + 22], 58
    mov byte [rax + 23], 32
    push rax
    mov rax, [vars + 24]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_19:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_19
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
.ntc_19:
    test rcx, rcx
    jz .ntd_19
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_19
.ntd_19:
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
.cpy1_20:
    test rax, rax
    jz .c1d_20
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_20
.c1d_20:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_20:
    test rax, rax
    jz .c2d_20
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_20
.c2d_20:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 163
    mov byte [rax + 14], 217
    mov byte [rax + 15], 131
    mov byte [rax + 16], 216
    mov byte [rax + 17], 168
    mov byte [rax + 18], 216
    mov byte [rax + 19], 177
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    push rax
    mov rax, [vars + 32]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_21:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_21
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
.ntc_21:
    test rcx, rcx
    jz .ntd_21
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_21
.ntd_21:
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
.cpy1_22:
    test rax, rax
    jz .c1d_22
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_22
.c1d_22:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_22:
    test rax, rax
    jz .c2d_22
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_22
.c2d_22:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
