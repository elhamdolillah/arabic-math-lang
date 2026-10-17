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
.rd_loop_1:
    lea rsi, [read_buf + rcx]
    xor rdi, rdi
    mov rdx, 1
    xor rax, rax
    push rcx
    syscall
    pop rcx
    test rax, rax
    jz .rd_end_1
    mov al, [read_buf + rcx]
    cmp al, 10
    je .rd_end_1
    inc rcx
    jmp .rd_loop_1
.rd_end_1:
    mov rax, rcx
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov [rax], rcx
    push rax
    push rcx
    lea rsi, [read_buf]
    lea rdi, [rax + 8]
.rd_copy_1:
    test rcx, rcx
    jz .rd_cdone_1
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .rd_copy_1
.rd_cdone_1:
    pop rcx
    pop rax
    mov [vars + 0], rax
    mov rax, [vars + 0]
    mov rax, [rax]
    mov [vars + 8], rax
    mov rax, 5
    mov [vars + 16], rax
    mov rdi, 8
    call arena_alloc
    mov qword [rax], 0
    mov [vars + 24], rax
    mov rax, 1
    mov [vars + 32], rax
.while_1:
    mov rax, [vars + 32]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    je .wend_1
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 16]
    pop rbx
    mov rcx, rax
    mov rax, [rbx]
    cmp rcx, rax
    jge .ch_err_1
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_1
.ch_err_1:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_1:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rax, 34
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setne al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_1
    mov rax, [vars + 40]
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    pop rbx
    mov [rax + 8], bl
    jmp .end_1
.else_1:
    mov rdi, 8
    call arena_alloc
    mov qword [rax], 0
.end_1:
    mov [vars + 48], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_2
    mov rax, [vars + 24]
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
    jmp .end_2
.else_2:
    mov rax, [vars + 24]
.end_2:
    mov [vars + 24], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_3
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_3
.else_3:
    mov rax, [vars + 16]
.end_3:
    mov [vars + 16], rax
    jmp .while_1
.wend_1:
    mov rax, [vars + 24]
    mov rax, [rax]
    mov [vars + 56], rax
    mov rax, 34
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    pop rbx
    mov [rax + 8], bl
    mov [vars + 64], rax
    mov rdi, 21
    call arena_alloc
    mov qword [rax], 13
    mov byte [rax + 8], 103
    mov byte [rax + 9], 108
    mov byte [rax + 10], 111
    mov byte [rax + 11], 98
    mov byte [rax + 12], 97
    mov byte [rax + 13], 108
    mov byte [rax + 14], 32
    mov byte [rax + 15], 95
    mov byte [rax + 16], 115
    mov byte [rax + 17], 116
    mov byte [rax + 18], 97
    mov byte [rax + 19], 114
    mov byte [rax + 20], 116
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
.cpy1_5:
    test rax, rax
    jz .c1d_5
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_5
.c1d_5:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_5:
    test rax, rax
    jz .c2d_5
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_5
.c2d_5:
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
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 95
    mov byte [rax + 9], 115
    mov byte [rax + 10], 116
    mov byte [rax + 11], 97
    mov byte [rax + 12], 114
    mov byte [rax + 13], 116
    mov byte [rax + 14], 58
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 97
    mov byte [rax + 18], 120
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 49
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 100
    mov byte [rax + 18], 105
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 49
    call print_str
    mov rdi, 26
    call arena_alloc
    mov qword [rax], 18
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 108
    mov byte [rax + 13], 101
    mov byte [rax + 14], 97
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 115
    mov byte [rax + 18], 105
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 91
    mov byte [rax + 22], 109
    mov byte [rax + 23], 115
    mov byte [rax + 24], 103
    mov byte [rax + 25], 93
    call print_str
    mov rdi, 21
    call arena_alloc
    mov qword [rax], 13
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 100
    mov byte [rax + 18], 120
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    push rax
    mov rax, [vars + 56]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_6:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_6
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
.ntc_6:
    test rcx, rcx
    jz .ntd_6
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_6
.ntd_6:
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
.cpy1_7:
    test rax, rax
    jz .c1d_7
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_7
.c1d_7:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_7:
    test rax, rax
    jz .c2d_7
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_7
.c2d_7:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 115
    mov byte [rax + 13], 121
    mov byte [rax + 14], 115
    mov byte [rax + 15], 99
    mov byte [rax + 16], 97
    mov byte [rax + 17], 108
    mov byte [rax + 18], 108
    call print_str
    mov rdi, 23
    call arena_alloc
    mov qword [rax], 15
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 97
    mov byte [rax + 18], 120
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 54
    mov byte [rax + 22], 48
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 120
    mov byte [rax + 13], 111
    mov byte [rax + 14], 114
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 100
    mov byte [rax + 18], 105
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 114
    mov byte [rax + 22], 100
    mov byte [rax + 23], 105
    call print_str
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 115
    mov byte [rax + 13], 121
    mov byte [rax + 14], 115
    mov byte [rax + 15], 99
    mov byte [rax + 16], 97
    mov byte [rax + 17], 108
    mov byte [rax + 18], 108
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
