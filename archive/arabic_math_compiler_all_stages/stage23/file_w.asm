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

    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 116
    mov byte [rax + 9], 101
    mov byte [rax + 10], 115
    mov byte [rax + 11], 116
    mov byte [rax + 12], 95
    mov byte [rax + 13], 50
    mov byte [rax + 14], 51
    mov byte [rax + 15], 46
    mov byte [rax + 16], 116
    mov byte [rax + 17], 120
    mov byte [rax + 18], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_1:
    test rcx, rcx
    jz .fp_d_1
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_1
.fp_d_1:
    mov byte [rdi], 0
    lea rdi, [file_path_buf]
    mov rsi, 66
    mov rdx, 420
    mov rax, 2
    push rcx
    syscall
    pop rcx
    mov [vars + 0], rax
    mov rax, [vars + 0]
    push rax
    mov rdi, 49
    call arena_alloc
    mov qword [rax], 41
    mov byte [rax + 8], 216
    mov byte [rax + 9], 168
    mov byte [rax + 10], 216
    mov byte [rax + 11], 179
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 32
    mov byte [rax + 15], 216
    mov byte [rax + 16], 167
    mov byte [rax + 17], 217
    mov byte [rax + 18], 132
    mov byte [rax + 19], 217
    mov byte [rax + 20], 132
    mov byte [rax + 21], 217
    mov byte [rax + 22], 135
    mov byte [rax + 23], 32
    mov byte [rax + 24], 216
    mov byte [rax + 25], 167
    mov byte [rax + 26], 217
    mov byte [rax + 27], 132
    mov byte [rax + 28], 216
    mov byte [rax + 29], 177
    mov byte [rax + 30], 216
    mov byte [rax + 31], 173
    mov byte [rax + 32], 217
    mov byte [rax + 33], 133
    mov byte [rax + 34], 217
    mov byte [rax + 35], 134
    mov byte [rax + 36], 32
    mov byte [rax + 37], 216
    mov byte [rax + 38], 167
    mov byte [rax + 39], 217
    mov byte [rax + 40], 132
    mov byte [rax + 41], 216
    mov byte [rax + 42], 177
    mov byte [rax + 43], 216
    mov byte [rax + 44], 173
    mov byte [rax + 45], 217
    mov byte [rax + 46], 138
    mov byte [rax + 47], 217
    mov byte [rax + 48], 133
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 0]
    push rax
    mov rdi, 47
    call arena_alloc
    mov qword [rax], 39
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 173
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 216
    mov byte [rax + 17], 175
    mov byte [rax + 18], 32
    mov byte [rax + 19], 217
    mov byte [rax + 20], 132
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 217
    mov byte [rax + 24], 135
    mov byte [rax + 25], 32
    mov byte [rax + 26], 216
    mov byte [rax + 27], 177
    mov byte [rax + 28], 216
    mov byte [rax + 29], 168
    mov byte [rax + 30], 32
    mov byte [rax + 31], 216
    mov byte [rax + 32], 167
    mov byte [rax + 33], 217
    mov byte [rax + 34], 132
    mov byte [rax + 35], 216
    mov byte [rax + 36], 185
    mov byte [rax + 37], 216
    mov byte [rax + 38], 167
    mov byte [rax + 39], 217
    mov byte [rax + 40], 132
    mov byte [rax + 41], 217
    mov byte [rax + 42], 133
    mov byte [rax + 43], 217
    mov byte [rax + 44], 138
    mov byte [rax + 45], 217
    mov byte [rax + 46], 134
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 0]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rdi, 27
    call arena_alloc
    mov qword [rax], 19
    mov byte [rax + 8], 216
    mov byte [rax + 9], 170
    mov byte [rax + 10], 217
    mov byte [rax + 11], 133
    mov byte [rax + 12], 32
    mov byte [rax + 13], 216
    mov byte [rax + 14], 167
    mov byte [rax + 15], 217
    mov byte [rax + 16], 132
    mov byte [rax + 17], 217
    mov byte [rax + 18], 131
    mov byte [rax + 19], 216
    mov byte [rax + 20], 170
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 216
    mov byte [rax + 24], 168
    mov byte [rax + 25], 216
    mov byte [rax + 26], 169
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
