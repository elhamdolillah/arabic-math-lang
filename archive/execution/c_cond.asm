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
.rd_loop_10:
    lea rsi, [read_buf + rcx]
    xor rdi, rdi
    mov rdx, 1
    xor rax, rax
    push rcx
    syscall
    pop rcx
    test rax, rax
    jz .rd_end_10
    mov al, [read_buf + rcx]
    cmp al, 10
    je .rd_end_10
    inc rcx
    jmp .rd_loop_10
.rd_end_10:
    mov rax, rcx
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov [rax], rcx
    push rax
    push rcx
    lea rsi, [read_buf]
    lea rdi, [rax + 8]
.rd_copy_10:
    test rcx, rcx
    jz .rd_cdone_10
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .rd_copy_10
.rd_cdone_10:
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
    mov [vars + 8], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 9
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
    push rax
    mov rax, 48
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 13
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
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 99
    mov byte [rax + 9], 109
    mov byte [rax + 10], 112
    mov byte [rax + 11], 32
    mov byte [rax + 12], 114
    mov byte [rax + 13], 97
    mov byte [rax + 14], 120
    mov byte [rax + 15], 44
    mov byte [rax + 16], 32
    mov byte [rax + 17], 48
    call print_str
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 106
    mov byte [rax + 9], 101
    mov byte [rax + 10], 32
    mov byte [rax + 11], 46
    mov byte [rax + 12], 101
    mov byte [rax + 13], 108
    mov byte [rax + 14], 115
    mov byte [rax + 15], 101
    call print_str
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
    mov rax, [vars + 16]
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
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 106
    mov byte [rax + 9], 109
    mov byte [rax + 10], 112
    mov byte [rax + 11], 32
    mov byte [rax + 12], 46
    mov byte [rax + 13], 101
    mov byte [rax + 14], 110
    mov byte [rax + 15], 100
    call print_str
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 46
    mov byte [rax + 9], 101
    mov byte [rax + 10], 108
    mov byte [rax + 11], 115
    mov byte [rax + 12], 101
    mov byte [rax + 13], 58
    call print_str
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
    mov rax, [vars + 24]
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
    mov rdi, 13
    call arena_alloc
    mov qword [rax], 5
    mov byte [rax + 8], 46
    mov byte [rax + 9], 101
    mov byte [rax + 10], 110
    mov byte [rax + 11], 100
    mov byte [rax + 12], 58
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
