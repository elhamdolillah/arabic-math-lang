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
    mov rdi, 43
    call arena_alloc
    mov qword [rax], 35
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 180
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 216
    mov byte [rax + 17], 179
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 170
    mov byte [rax + 21], 216
    mov byte [rax + 22], 180
    mov byte [rax + 23], 216
    mov byte [rax + 24], 177
    mov byte [rax + 25], 217
    mov byte [rax + 26], 130
    mov byte [rax + 27], 32
    mov byte [rax + 28], 217
    mov byte [rax + 29], 133
    mov byte [rax + 30], 217
    mov byte [rax + 31], 134
    mov byte [rax + 32], 32
    mov byte [rax + 33], 216
    mov byte [rax + 34], 167
    mov byte [rax + 35], 217
    mov byte [rax + 36], 132
    mov byte [rax + 37], 216
    mov byte [rax + 38], 180
    mov byte [rax + 39], 216
    mov byte [rax + 40], 177
    mov byte [rax + 41], 217
    mov byte [rax + 42], 130
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 41
    call arena_alloc
    mov qword [rax], 33
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 216
    mov byte [rax + 17], 161
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 138
    mov byte [rax + 21], 216
    mov byte [rax + 22], 186
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 217
    mov byte [rax + 26], 138
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 185
    mov byte [rax + 30], 217
    mov byte [rax + 31], 134
    mov byte [rax + 32], 216
    mov byte [rax + 33], 175
    mov byte [rax + 34], 32
    mov byte [rax + 35], 217
    mov byte [rax + 36], 133
    mov byte [rax + 37], 216
    mov byte [rax + 38], 166
    mov byte [rax + 39], 216
    mov byte [rax + 40], 169
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 45
    call arena_alloc
    mov qword [rax], 37
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 163
    mov byte [rax + 14], 216
    mov byte [rax + 15], 177
    mov byte [rax + 16], 216
    mov byte [rax + 17], 182
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 170
    mov byte [rax + 21], 216
    mov byte [rax + 22], 175
    mov byte [rax + 23], 217
    mov byte [rax + 24], 136
    mov byte [rax + 25], 216
    mov byte [rax + 26], 177
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 173
    mov byte [rax + 30], 217
    mov byte [rax + 31], 136
    mov byte [rax + 32], 217
    mov byte [rax + 33], 132
    mov byte [rax + 34], 32
    mov byte [rax + 35], 216
    mov byte [rax + 36], 167
    mov byte [rax + 37], 217
    mov byte [rax + 38], 132
    mov byte [rax + 39], 216
    mov byte [rax + 40], 180
    mov byte [rax + 41], 217
    mov byte [rax + 42], 133
    mov byte [rax + 43], 216
    mov byte [rax + 44], 179
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rdi, 30
    call arena_alloc
    mov qword [rax], 22
    mov byte [rax + 8], 216
    mov byte [rax + 9], 172
    mov byte [rax + 10], 217
    mov byte [rax + 11], 133
    mov byte [rax + 12], 216
    mov byte [rax + 13], 185
    mov byte [rax + 14], 32
    mov byte [rax + 15], 217
    mov byte [rax + 16], 131
    mov byte [rax + 17], 216
    mov byte [rax + 18], 170
    mov byte [rax + 19], 216
    mov byte [rax + 20], 167
    mov byte [rax + 21], 216
    mov byte [rax + 22], 168
    mov byte [rax + 23], 32
    mov byte [rax + 24], 217
    mov byte [rax + 25], 131
    mov byte [rax + 26], 216
    mov byte [rax + 27], 170
    mov byte [rax + 28], 216
    mov byte [rax + 29], 168
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 32], rcx
    mov rdi, 40
    call arena_alloc
    mov qword [rax], 32
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 216
    mov byte [rax + 11], 167
    mov byte [rax + 12], 216
    mov byte [rax + 13], 181
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 216
    mov byte [rax + 17], 169
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 129
    mov byte [rax + 21], 216
    mov byte [rax + 22], 177
    mov byte [rax + 23], 217
    mov byte [rax + 24], 134
    mov byte [rax + 25], 216
    mov byte [rax + 26], 179
    mov byte [rax + 27], 216
    mov byte [rax + 28], 167
    mov byte [rax + 29], 32
    mov byte [rax + 30], 216
    mov byte [rax + 31], 168
    mov byte [rax + 32], 216
    mov byte [rax + 33], 167
    mov byte [rax + 34], 216
    mov byte [rax + 35], 177
    mov byte [rax + 36], 217
    mov byte [rax + 37], 138
    mov byte [rax + 38], 216
    mov byte [rax + 39], 179
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 40], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 31
    call arena_alloc
    mov qword [rax], 23
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 216
    mov byte [rax + 11], 175
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 32
    mov byte [rax + 15], 216
    mov byte [rax + 16], 167
    mov byte [rax + 17], 217
    mov byte [rax + 18], 132
    mov byte [rax + 19], 216
    mov byte [rax + 20], 173
    mov byte [rax + 21], 217
    mov byte [rax + 22], 130
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 216
    mov byte [rax + 26], 166
    mov byte [rax + 27], 217
    mov byte [rax + 28], 130
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
    push rax
    mov rax, [vars + 0]
    mov rax, [rax]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_1:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_1
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
.ntc_1:
    test rcx, rcx
    jz .ntd_1
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_1
.ntd_1:
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
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
