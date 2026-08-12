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
    xor rcx, rcx
.rd_loop_2:
    lea rsi, [read_buf + rcx]
    xor rdi, rdi
    mov rdx, 1
    xor rax, rax
    push rcx
    syscall
    pop rcx
    test rax, rax
    jz .rd_end_2
    mov al, [read_buf + rcx]
    cmp al, 10
    je .rd_end_2
    inc rcx
    jmp .rd_loop_2
.rd_end_2:
    mov rax, rcx
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov [rax], rcx
    push rax
    push rcx
    lea rsi, [read_buf]
    lea rdi, [rax + 8]
.rd_copy_2:
    test rcx, rcx
    jz .rd_cdone_2
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .rd_copy_2
.rd_cdone_2:
    pop rcx
    pop rax
    mov [vars + 8], rax
    mov rax, [vars + 0]
    mov rax, [rax]
    mov [vars + 16], rax
    mov rax, [vars + 8]
    mov rax, [rax]
    mov [vars + 24], rax
    mov rax, 7
    mov [vars + 32], rax
    mov rax, 0
    mov [vars + 40], rax
    mov rax, 1
    mov [vars + 48], rax
.while_1:
    mov rax, [vars + 48]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    je .wend_1
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 16]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setl al
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_1
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 32]
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
    jmp .end_1
.else_1:
    mov rax, 32
.end_1:
    mov [vars + 56], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_2
    mov rax, [vars + 40]
    push rax
    mov rax, 10
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 56]
    pop rbx
    add rax, rbx
    push rax
    mov rax, 48
    pop rbx
    sub rbx, rax
    mov rax, rbx
    jmp .end_2
.else_2:
    mov rax, [vars + 40]
.end_2:
    mov [vars + 40], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_3
    mov rax, [vars + 32]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_3
.else_3:
    mov rax, [vars + 32]
.end_3:
    mov [vars + 32], rax
    jmp .while_1
.wend_1:
    mov rax, [vars + 8]
    push rax
    mov rax, 7
    pop rbx
    mov rcx, rax
    mov rax, [rbx]
    cmp rcx, rax
    jge .ch_err_2
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_2
.ch_err_2:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_2:
    mov [vars + 64], rax
    mov rax, 9
    mov [vars + 32], rax
    mov rax, 0
    mov [vars + 72], rax
    mov rax, 1
    mov [vars + 48], rax
.while_2:
    mov rax, [vars + 48]
    push rax
    mov rax, 1
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    je .wend_2
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 24]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setl al
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_4
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 32]
    pop rbx
    mov rcx, rax
    mov rax, [rbx]
    cmp rcx, rax
    jge .ch_err_3
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_3
.ch_err_3:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_3:
    jmp .end_4
.else_4:
    mov rax, 32
.end_4:
    mov [vars + 56], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_5
    mov rax, [vars + 72]
    push rax
    mov rax, 10
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 56]
    pop rbx
    add rax, rbx
    push rax
    mov rax, 48
    pop rbx
    sub rbx, rax
    mov rax, rbx
    jmp .end_5
.else_5:
    mov rax, [vars + 72]
.end_5:
    mov [vars + 72], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_6
    mov rax, [vars + 32]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_6
.else_6:
    mov rax, [vars + 32]
.end_6:
    mov [vars + 32], rax
    jmp .while_2
.wend_2:
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 97
    mov byte [rax + 9], 100
    mov byte [rax + 10], 100
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 97
    mov byte [rax + 14], 120
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    mov byte [rax + 17], 114
    mov byte [rax + 18], 98
    mov byte [rax + 19], 120
    mov [vars + 80], rax
    mov rax, [vars + 64]
    push rax
    mov rax, 45
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_7
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 115
    mov byte [rax + 9], 117
    mov byte [rax + 10], 98
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 97
    mov byte [rax + 14], 120
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    mov byte [rax + 17], 114
    mov byte [rax + 18], 98
    mov byte [rax + 19], 120
    jmp .end_7
.else_7:
    mov rax, [vars + 80]
.end_7:
    mov [vars + 80], rax
    mov rax, [vars + 64]
    push rax
    mov rax, 42
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_8
    mov rdi, 21
    call arena_alloc
    mov qword [rax], 13
    mov byte [rax + 8], 105
    mov byte [rax + 9], 109
    mov byte [rax + 10], 117
    mov byte [rax + 11], 108
    mov byte [rax + 12], 32
    mov byte [rax + 13], 114
    mov byte [rax + 14], 97
    mov byte [rax + 15], 120
    mov byte [rax + 16], 44
    mov byte [rax + 17], 32
    mov byte [rax + 18], 114
    mov byte [rax + 19], 98
    mov byte [rax + 20], 120
    jmp .end_8
.else_8:
    mov rax, [vars + 80]
.end_8:
    mov [vars + 80], rax
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 109
    mov byte [rax + 9], 111
    mov byte [rax + 10], 118
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 97
    mov byte [rax + 14], 120
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    push rax
    mov rax, [vars + 40]
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
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 109
    mov byte [rax + 9], 111
    mov byte [rax + 10], 118
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 98
    mov byte [rax + 14], 120
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    push rax
    mov rax, [vars + 72]
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
    mov rax, [vars + 80]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
