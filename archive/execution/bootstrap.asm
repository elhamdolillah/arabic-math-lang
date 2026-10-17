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
    push rax
    mov rax, 4
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
    push rax
    mov rax, 48
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 8], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 6
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
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 8
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
    push rax
    mov rax, 48
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 24], rax
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
    mov rax, [vars + 8]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_2:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_2
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
.ntc_2:
    test rcx, rcx
    jz .ntd_2
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_2
.ntd_2:
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
    mov rax, [vars + 24]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_4:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_4
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
.ntc_4:
    test rcx, rcx
    jz .ntd_4
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_4
.ntd_4:
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
    mov [vars + 32], rax
    mov rax, [vars + 16]
    push rax
    mov rax, 45
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_1
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
    jmp .end_1
.else_1:
    mov rax, [vars + 32]
.end_1:
    mov [vars + 32], rax
    mov rax, [vars + 16]
    push rax
    mov rax, 42
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_2
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
    jmp .end_2
.else_2:
    mov rax, [vars + 32]
.end_2:
    mov [vars + 32], rax
    mov rax, [vars + 32]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
