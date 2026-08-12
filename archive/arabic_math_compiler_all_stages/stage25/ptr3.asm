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
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 216
    mov byte [rax + 11], 173
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 175
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 129
    mov byte [rax + 10], 216
    mov byte [rax + 11], 167
    mov byte [rax + 12], 216
    mov byte [rax + 13], 183
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 216
    mov byte [rax + 17], 169
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 138
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 0], rax
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_5
    mov rax, [rax + 8]
    jmp .hdne_5
.hemp_5:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_5:
    mov [vars + 8], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_16
    push rax
    dec rcx
    mov rdi, rcx
    shl rdi, 3
    add rdi, 8
    call arena_alloc
    mov r12, rax
    mov [rax], rcx
    pop rsi
    add rsi, 16
    lea rdi, [r12 + 8]
.tcopy_16:
    test rcx, rcx
    jz .tcd_16
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_16
.tcd_16:
    mov rax, r12
    jmp .taine_16
.taihemp_16:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_16:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_6
    mov rax, [rax + 8]
    jmp .hdne_6
.hemp_6:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_6:
    mov [vars + 16], rax
    mov rdi, 31
    call arena_alloc
    mov qword [rax], 23
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 167
    mov byte [rax + 14], 216
    mov byte [rax + 15], 179
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 216
    mov byte [rax + 24], 163
    mov byte [rax + 25], 217
    mov byte [rax + 26], 136
    mov byte [rax + 27], 217
    mov byte [rax + 28], 132
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
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
    mov rdi, 33
    call arena_alloc
    mov qword [rax], 25
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 167
    mov byte [rax + 14], 216
    mov byte [rax + 15], 179
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 216
    mov byte [rax + 24], 171
    mov byte [rax + 25], 216
    mov byte [rax + 26], 167
    mov byte [rax + 27], 217
    mov byte [rax + 28], 134
    mov byte [rax + 29], 217
    mov byte [rax + 30], 138
    mov byte [rax + 31], 58
    mov byte [rax + 32], 32
    push rax
    mov rax, [vars + 16]
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

    mov rax, 60
    xor rdi, rdi
    syscall
