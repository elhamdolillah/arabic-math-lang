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
    pop rax
    mov [vars + 0], rax
    mov rdi, 26
    call arena_alloc
    mov qword [rax], 18
    mov byte [rax + 8], 107
    mov byte [rax + 9], 110
    mov byte [rax + 10], 111
    mov byte [rax + 11], 119
    mov byte [rax + 12], 108
    mov byte [rax + 13], 101
    mov byte [rax + 14], 100
    mov byte [rax + 15], 103
    mov byte [rax + 16], 101
    mov byte [rax + 17], 95
    mov byte [rax + 18], 98
    mov byte [rax + 19], 97
    mov byte [rax + 20], 115
    mov byte [rax + 21], 101
    mov byte [rax + 22], 46
    mov byte [rax + 23], 116
    mov byte [rax + 24], 120
    mov byte [rax + 25], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_20:
    test rcx, rcx
    jz .fp_d_20
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_20
.fp_d_20:
    mov byte [rdi], 0
    lea rdi, [file_path_buf]
    mov rsi, 66
    mov rdx, 420
    mov rax, 2
    push rcx
    syscall
    pop rcx
    mov [vars + 8], rax
    mov rax, [vars + 0]
    mov r14, [rax]
    lea rbx, [rax + 8]
.fe_4:
    test r14, r14
    jz .feend_4
    mov rax, [rbx]
    mov [vars + 16], rax
    push rbx
    push r14
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 16]
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 8]
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 32
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    pop r14
    pop rbx
    add rbx, 8
    dec r14
    jmp .fe_4
.feend_4:
    mov rax, [vars + 8]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rdi, 26
    call arena_alloc
    mov qword [rax], 18
    mov byte [rax + 8], 107
    mov byte [rax + 9], 110
    mov byte [rax + 10], 111
    mov byte [rax + 11], 119
    mov byte [rax + 12], 108
    mov byte [rax + 13], 101
    mov byte [rax + 14], 100
    mov byte [rax + 15], 103
    mov byte [rax + 16], 101
    mov byte [rax + 17], 95
    mov byte [rax + 18], 98
    mov byte [rax + 19], 97
    mov byte [rax + 20], 115
    mov byte [rax + 21], 101
    mov byte [rax + 22], 46
    mov byte [rax + 23], 116
    mov byte [rax + 24], 120
    mov byte [rax + 25], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_21:
    test rcx, rcx
    jz .fp_d_21
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_21
.fp_d_21:
    mov byte [rdi], 0
    lea rdi, [file_path_buf]
    mov rsi, 66
    mov rdx, 420
    mov rax, 2
    push rcx
    syscall
    pop rcx
    mov [vars + 8], rax
    mov rax, [vars + 8]
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
.fr_c_22:
    test rdx, rdx
    jz .fr_d_22
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_22
.fr_d_22:
    pop rax
    mov [vars + 24], rax
    mov rax, [vars + 8]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rax, [vars + 24]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
