global _start
section .bss
    vars resq 256
    num_buf resb 32
    read_buf resb 256
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

    xor rcx, rcx
.rd_loop_8:
    lea rsi, [read_buf + rcx]
    xor rdi, rdi
    mov rdx, 1
    xor rax, rax
    push rcx
    syscall
    pop rcx
    test rax, rax
    jz .rd_end_8
    mov al, [read_buf + rcx]
    cmp al, 10
    je .rd_end_8
    inc rcx
    jmp .rd_loop_8
.rd_end_8:
    mov rax, rcx
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov [rax], rcx
    push rax
    push rcx
    lea rsi, [read_buf]
    lea rdi, [rax + 8]
.rd_copy_8:
    test rcx, rcx
    jz .rd_cdone_8
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .rd_copy_8
.rd_cdone_8:
    pop rcx
    pop rax
    mov [vars + 0], rax
    mov rax, [vars + 0]
    mov rax, [rax]
    mov [vars + 8], rax
    mov rax, 8
    mov [vars + 16], rax
    mov rax, 0
    mov [vars + 24], rax
    mov rax, 1
    mov [vars + 32], rax
.while_3:
    mov rax, [vars + 32]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    je .wend_3
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 16]
    pop rbx
    mov rcx, rax
    mov rax, [rbx]
    cmp rcx, rax
    jge .ch_err_4
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_4
.ch_err_4:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_4:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rax, 32
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setne al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_6
    mov rax, [vars + 24]
    push rax
    mov rax, 10
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 40]
    pop rbx
    add rax, rbx
    push rax
    mov rax, 48
    pop rbx
    sub rbx, rax
    mov rax, rbx
    jmp .end_6
.else_6:
    mov rax, [vars + 24]
.end_6:
    mov [vars + 24], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_7
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_7
.else_7:
    mov rax, [vars + 16]
.end_7:
    mov [vars + 16], rax
    jmp .while_3
.wend_3:
    mov rax, [vars + 16]
    push rax
    mov rax, 12
    pop rbx
    add rax, rbx
    mov [vars + 16], rax
    mov rdi, 8
    call arena_alloc
    mov qword [rax], 0
    mov [vars + 48], rax
    mov rax, 1
    mov [vars + 32], rax
.while_4:
    mov rax, [vars + 32]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    je .wend_4
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 16]
    pop rbx
    mov rcx, rax
    mov rax, [rbx]
    cmp rcx, rax
    jge .ch_err_5
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_5
.ch_err_5:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_5:
    mov [vars + 56], rax
    mov rax, [vars + 56]
    push rax
    mov rax, 34
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setne al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_8
    mov rax, [vars + 56]
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    pop rbx
    mov [rax + 8], bl
    jmp .end_8
.else_8:
    mov rdi, 8
    call arena_alloc
    mov qword [rax], 0
.end_8:
    mov [vars + 64], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_9
    mov rax, [vars + 48]
    push rax
    mov rax, [vars + 64]
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
.cpy1_9:
    test rax, rax
    jz .c1d_9
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_9
.c1d_9:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_9:
    test rax, rax
    jz .c2d_9
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_9
.c2d_9:
    pop r11
    pop r10
    mov rax, r12
    jmp .end_9
.else_9:
    mov rax, [vars + 48]
.end_9:
    mov [vars + 48], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_10
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_10
.else_10:
    mov rax, [vars + 16]
.end_10:
    mov [vars + 16], rax
    jmp .while_4
.wend_4:
    mov rax, [vars + 48]
    mov rax, [rax]
    mov [vars + 72], rax
    mov rax, 34
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    pop rbx
    mov [rax + 8], bl
    mov [vars + 80], rax
    mov rdi, 21
    call arena_alloc
    mov qword [rax], 13
    mov byte [rax + 8], 115
    mov byte [rax + 9], 101
    mov byte [rax + 10], 99
    mov byte [rax + 11], 116
    mov byte [rax + 12], 105
    mov byte [rax + 13], 111
    mov byte [rax + 14], 110
    mov byte [rax + 15], 32
    mov byte [rax + 16], 46
    mov byte [rax + 17], 100
    mov byte [rax + 18], 97
    mov byte [rax + 19], 116
    mov byte [rax + 20], 97
    call print_str
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 109
    mov byte [rax + 9], 115
    mov byte [rax + 10], 103
    mov byte [rax + 11], 32
    mov byte [rax + 12], 100
    mov byte [rax + 13], 98
    mov byte [rax + 14], 32
    push rax
    mov rax, [vars + 80]
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
    push rax
    mov rax, [vars + 48]
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
.cpy1_11:
    test rax, rax
    jz .c1d_11
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_11
.c1d_11:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_11:
    test rax, rax
    jz .c2d_11
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_11
.c2d_11:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 80]
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
    mov rdi, 21
    call arena_alloc
    mov qword [rax], 13
    mov byte [rax + 8], 115
    mov byte [rax + 9], 101
    mov byte [rax + 10], 99
    mov byte [rax + 11], 116
    mov byte [rax + 12], 105
    mov byte [rax + 13], 111
    mov byte [rax + 14], 110
    mov byte [rax + 15], 32
    mov byte [rax + 16], 46
    mov byte [rax + 17], 116
    mov byte [rax + 18], 101
    mov byte [rax + 19], 120
    mov byte [rax + 20], 116
    call print_str
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 109
    mov byte [rax + 9], 111
    mov byte [rax + 10], 118
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 99
    mov byte [rax + 14], 120
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    push rax
    mov rax, [vars + 24]
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
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 46
    mov byte [rax + 9], 108
    mov byte [rax + 10], 111
    mov byte [rax + 11], 111
    mov byte [rax + 12], 112
    mov byte [rax + 13], 58
    call print_str
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 112
    mov byte [rax + 9], 117
    mov byte [rax + 10], 115
    mov byte [rax + 11], 104
    mov byte [rax + 12], 32
    mov byte [rax + 13], 114
    mov byte [rax + 14], 99
    mov byte [rax + 15], 120
    call print_str
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 109
    mov byte [rax + 9], 111
    mov byte [rax + 10], 118
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 97
    mov byte [rax + 14], 120
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    mov byte [rax + 17], 49
    call print_str
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 109
    mov byte [rax + 9], 111
    mov byte [rax + 10], 118
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 100
    mov byte [rax + 14], 105
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    mov byte [rax + 17], 49
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 108
    mov byte [rax + 9], 101
    mov byte [rax + 10], 97
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 115
    mov byte [rax + 14], 105
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    mov byte [rax + 17], 91
    mov byte [rax + 18], 109
    mov byte [rax + 19], 115
    mov byte [rax + 20], 103
    mov byte [rax + 21], 93
    call print_str
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 109
    mov byte [rax + 9], 111
    mov byte [rax + 10], 118
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 100
    mov byte [rax + 14], 120
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    push rax
    mov rax, [vars + 72]
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
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 115
    mov byte [rax + 9], 121
    mov byte [rax + 10], 115
    mov byte [rax + 11], 99
    mov byte [rax + 12], 97
    mov byte [rax + 13], 108
    mov byte [rax + 14], 108
    call print_str
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 112
    mov byte [rax + 9], 111
    mov byte [rax + 10], 112
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 99
    mov byte [rax + 14], 120
    call print_str
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 100
    mov byte [rax + 9], 101
    mov byte [rax + 10], 99
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 99
    mov byte [rax + 14], 120
    call print_str
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 106
    mov byte [rax + 9], 110
    mov byte [rax + 10], 122
    mov byte [rax + 11], 32
    mov byte [rax + 12], 46
    mov byte [rax + 13], 108
    mov byte [rax + 14], 111
    mov byte [rax + 15], 111
    mov byte [rax + 16], 112
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
