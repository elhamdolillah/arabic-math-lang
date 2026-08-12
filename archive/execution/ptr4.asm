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
    mov rax, 42
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 10
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 25
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 0], rax
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_7
    mov rax, [rax + 8]
    jmp .hdne_7
.hemp_7:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_7:
    mov [vars + 8], rax
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 112
    mov byte [rax + 9], 116
    mov byte [rax + 10], 114
    mov byte [rax + 11], 95
    mov byte [rax + 12], 116
    mov byte [rax + 13], 101
    mov byte [rax + 14], 115
    mov byte [rax + 15], 116
    mov byte [rax + 16], 46
    mov byte [rax + 17], 116
    mov byte [rax + 18], 120
    mov byte [rax + 19], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_19:
    test rcx, rcx
    jz .fp_d_19
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_19
.fp_d_19:
    mov byte [rdi], 0
    lea rdi, [file_path_buf]
    mov rsi, 66
    mov rdx, 420
    mov rax, 2
    push rcx
    syscall
    pop rcx
    mov [vars + 16], rax
    mov rax, [vars + 16]
    push rax
    mov rax, [vars + 8]
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
    mov rax, [vars + 16]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 112
    mov byte [rax + 9], 116
    mov byte [rax + 10], 114
    mov byte [rax + 11], 95
    mov byte [rax + 12], 116
    mov byte [rax + 13], 101
    mov byte [rax + 14], 115
    mov byte [rax + 15], 116
    mov byte [rax + 16], 46
    mov byte [rax + 17], 116
    mov byte [rax + 18], 120
    mov byte [rax + 19], 116
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
    mov [vars + 16], rax
    mov rax, [vars + 16]
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
    mov [vars + 24], rax
    mov rax, [vars + 16]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rdi, 39
    call arena_alloc
    mov qword [rax], 31
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 130
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 32
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 217
    mov byte [rax + 26], 133
    mov byte [rax + 27], 216
    mov byte [rax + 28], 173
    mov byte [rax + 29], 217
    mov byte [rax + 30], 129
    mov byte [rax + 31], 217
    mov byte [rax + 32], 136
    mov byte [rax + 33], 216
    mov byte [rax + 34], 184
    mov byte [rax + 35], 216
    mov byte [rax + 36], 169
    mov byte [rax + 37], 58
    mov byte [rax + 38], 32
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
.cpy1_24:
    test rax, rax
    jz .c1d_24
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_24
.c1d_24:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_24:
    test rax, rax
    jz .c2d_24
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_24
.c2d_24:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
