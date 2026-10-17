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
    mov rdi, 13
    call arena_alloc
    mov qword [rax], 5
    mov byte [rax + 8], 50
    mov byte [rax + 9], 43
    mov byte [rax + 10], 50
    mov byte [rax + 11], 61
    mov byte [rax + 12], 52
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 13
    call arena_alloc
    mov qword [rax], 5
    mov byte [rax + 8], 51
    mov byte [rax + 9], 43
    mov byte [rax + 10], 51
    mov byte [rax + 11], 61
    mov byte [rax + 12], 54
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 53
    mov byte [rax + 9], 43
    mov byte [rax + 10], 53
    mov byte [rax + 11], 61
    mov byte [rax + 12], 49
    mov byte [rax + 13], 48
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 13
    call arena_alloc
    mov qword [rax], 5
    mov byte [rax + 8], 51
    mov byte [rax + 9], 43
    mov byte [rax + 10], 51
    mov byte [rax + 11], 61
    mov byte [rax + 12], 54
    mov [vars + 8], rax
    mov rax, 0
    mov [vars + 16], rax
    mov rax, [vars + 0]
    mov r14, [rax]
    lea rbx, [rax + 8]
.fe_3:
    test r14, r14
    jz .feend_3
    mov rax, [rbx]
    mov [vars + 24], rax
    push rbx
    push r14
    mov rax, [vars + 24]
    push rax
    mov rax, 0
    pop rbx
    mov rcx, rax
    test rcx, rcx
    jns .rc_pos_5
    mov rdx, [rbx]
    add rcx, rdx
.rc_pos_5:
    mov rax, [rbx]
    test rcx, rcx
    jl .ch_err_idx_5
    cmp rcx, rax
    jge .ch_err_5
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_5
.ch_err_idx_5:
.ch_err_5:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_5:
    push rax
    mov rax, 51
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 32], rax
    mov rax, [vars + 32]
    cmp rax, 0
    je .else_6
    mov rax, 1
    jmp .end_6
.else_6:
    mov rax, [vars + 16]
.end_6:
    mov [vars + 16], rax
    pop r14
    pop rbx
    add rbx, 8
    dec r14
    jmp .fe_3
.feend_3:
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
    mov byte [rax + 15], 175
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 216
    mov byte [rax + 19], 167
    mov byte [rax + 20], 216
    mov byte [rax + 21], 161
    mov byte [rax + 22], 58
    mov byte [rax + 23], 32
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
.cpy1_17:
    test rax, rax
    jz .c1d_17
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_17
.c1d_17:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_17:
    test rax, rax
    jz .c2d_17
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_17
.c2d_17:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 217
    mov byte [rax + 9], 138
    mov byte [rax + 10], 217
    mov byte [rax + 11], 130
    mov byte [rax + 12], 217
    mov byte [rax + 13], 138
    mov byte [rax + 14], 217
    mov byte [rax + 15], 134
    mov byte [rax + 16], 216
    mov byte [rax + 17], 159
    mov byte [rax + 18], 32
    push rax
    mov rax, [vars + 16]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_18:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_18
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
.ntc_18:
    test rcx, rcx
    jz .ntd_18
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_18
.ntd_18:
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
.cpy1_19:
    test rax, rax
    jz .c1d_19
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_19
.c1d_19:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_19:
    test rax, rax
    jz .c2d_19
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_19
.c2d_19:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
