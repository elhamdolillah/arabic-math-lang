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
    mov rax, 90
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 85
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 95
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rax, 88
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 32], rcx
    mov rax, 92
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 40], rcx
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
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 114
    mov byte [rax + 9], 101
    mov byte [rax + 10], 112
    mov byte [rax + 11], 111
    mov byte [rax + 12], 114
    mov byte [rax + 13], 116
    mov byte [rax + 14], 46
    mov byte [rax + 15], 116
    mov byte [rax + 16], 120
    mov byte [rax + 17], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_13:
    test rcx, rcx
    jz .fp_d_13
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_13
.fp_d_13:
    mov byte [rdi], 0
    lea rdi, [file_path_buf]
    mov rsi, 66
    mov rdx, 420
    mov rax, 2
    push rcx
    syscall
    pop rcx
    mov [vars + 56], rax
    mov rax, [vars + 56]
    push rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 83
    mov byte [rax + 9], 81
    mov byte [rax + 10], 76
    mov byte [rax + 11], 32
    mov byte [rax + 12], 82
    mov byte [rax + 13], 101
    mov byte [rax + 14], 112
    mov byte [rax + 15], 111
    mov byte [rax + 16], 114
    mov byte [rax + 17], 116
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 56]
    push rax
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 32
    mov byte [rax + 9], 67
    mov byte [rax + 10], 79
    mov byte [rax + 11], 85
    mov byte [rax + 12], 78
    mov byte [rax + 13], 84
    mov byte [rax + 14], 58
    mov byte [rax + 15], 32
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 56]
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
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 56]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 32
    mov byte [rax + 9], 83
    mov byte [rax + 10], 85
    mov byte [rax + 11], 77
    mov byte [rax + 12], 58
    mov byte [rax + 13], 32
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 56]
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
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 56]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 32
    mov byte [rax + 9], 65
    mov byte [rax + 10], 86
    mov byte [rax + 11], 71
    mov byte [rax + 12], 58
    mov byte [rax + 13], 32
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 56]
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
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 56]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 32
    mov byte [rax + 9], 77
    mov byte [rax + 10], 65
    mov byte [rax + 11], 88
    mov byte [rax + 12], 58
    mov byte [rax + 13], 32
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 56]
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
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 56]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 114
    mov byte [rax + 9], 101
    mov byte [rax + 10], 112
    mov byte [rax + 11], 111
    mov byte [rax + 12], 114
    mov byte [rax + 13], 116
    mov byte [rax + 14], 46
    mov byte [rax + 15], 116
    mov byte [rax + 16], 120
    mov byte [rax + 17], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_22:
    test rcx, rcx
    jz .fp_d_22
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_22
.fp_d_22:
    mov byte [rdi], 0
    lea rdi, [file_path_buf]
    mov rsi, 66
    mov rdx, 420
    mov rax, 2
    push rcx
    syscall
    pop rcx
    mov [vars + 56], rax
    mov rax, [vars + 56]
    push rax
    mov rax, 4096
    mov rdx, rax
    pop rdi
    lea rsi, [file_buf]
    push rcx
    mov rax, 0
    syscall
    pop rcx
    mov rcx, rax
    mov rdi, rax
    add rdi, 8
    call arena_alloc
    mov [rax], rcx
    push rax
    lea rsi, [file_buf]
    lea rdi, [rax + 8]
    mov rdx, rcx
.fr_c_23:
    test rdx, rdx
    jz .fr_d_23
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_23
.fr_d_23:
    pop rax
    mov [vars + 64], rax
    mov rax, [vars + 56]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rax, [vars + 64]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
