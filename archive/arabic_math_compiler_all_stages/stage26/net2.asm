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

    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    mov rax, 41
    syscall
    mov [vars + 0], rax
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 83
    mov byte [rax + 9], 111
    mov byte [rax + 10], 99
    mov byte [rax + 11], 107
    mov byte [rax + 12], 101
    mov byte [rax + 13], 116
    mov byte [rax + 14], 32
    mov byte [rax + 15], 102
    mov byte [rax + 16], 100
    mov byte [rax + 17], 58
    mov byte [rax + 18], 32
    push rax
    mov rax, [vars + 0]
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
    mov rax, [vars + 0]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rdi, 36
    call arena_alloc
    mov qword [rax], 28
    mov byte [rax + 8], 216
    mov byte [rax + 9], 170
    mov byte [rax + 10], 217
    mov byte [rax + 11], 133
    mov byte [rax + 12], 32
    mov byte [rax + 13], 216
    mov byte [rax + 14], 165
    mov byte [rax + 15], 216
    mov byte [rax + 16], 186
    mov byte [rax + 17], 217
    mov byte [rax + 18], 132
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 130
    mov byte [rax + 23], 32
    mov byte [rax + 24], 216
    mov byte [rax + 25], 167
    mov byte [rax + 26], 217
    mov byte [rax + 27], 132
    mov byte [rax + 28], 216
    mov byte [rax + 29], 185
    mov byte [rax + 30], 216
    mov byte [rax + 31], 177
    mov byte [rax + 32], 217
    mov byte [rax + 33], 136
    mov byte [rax + 34], 216
    mov byte [rax + 35], 169
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
