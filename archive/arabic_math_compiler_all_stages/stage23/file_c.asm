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

    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 116
    mov byte [rax + 9], 101
    mov byte [rax + 10], 115
    mov byte [rax + 11], 116
    mov byte [rax + 12], 95
    mov byte [rax + 13], 99
    mov byte [rax + 14], 121
    mov byte [rax + 15], 99
    mov byte [rax + 16], 108
    mov byte [rax + 17], 101
    mov byte [rax + 18], 46
    mov byte [rax + 19], 116
    mov byte [rax + 20], 120
    mov byte [rax + 21], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_4:
    test rcx, rcx
    jz .fp_d_4
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_4
.fp_d_4:
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
    mov rdi, 51
    call arena_alloc
    mov qword [rax], 43
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 179
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 216
    mov byte [rax + 17], 167
    mov byte [rax + 18], 217
    mov byte [rax + 19], 133
    mov byte [rax + 20], 32
    mov byte [rax + 21], 216
    mov byte [rax + 22], 185
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 217
    mov byte [rax + 26], 138
    mov byte [rax + 27], 217
    mov byte [rax + 28], 131
    mov byte [rax + 29], 217
    mov byte [rax + 30], 133
    mov byte [rax + 31], 32
    mov byte [rax + 32], 217
    mov byte [rax + 33], 136
    mov byte [rax + 34], 216
    mov byte [rax + 35], 177
    mov byte [rax + 36], 216
    mov byte [rax + 37], 173
    mov byte [rax + 38], 217
    mov byte [rax + 39], 133
    mov byte [rax + 40], 216
    mov byte [rax + 41], 169
    mov byte [rax + 42], 32
    mov byte [rax + 43], 216
    mov byte [rax + 44], 167
    mov byte [rax + 45], 217
    mov byte [rax + 46], 132
    mov byte [rax + 47], 217
    mov byte [rax + 48], 132
    mov byte [rax + 49], 217
    mov byte [rax + 50], 135
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
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 116
    mov byte [rax + 9], 101
    mov byte [rax + 10], 115
    mov byte [rax + 11], 116
    mov byte [rax + 12], 95
    mov byte [rax + 13], 99
    mov byte [rax + 14], 121
    mov byte [rax + 15], 99
    mov byte [rax + 16], 108
    mov byte [rax + 17], 101
    mov byte [rax + 18], 46
    mov byte [rax + 19], 116
    mov byte [rax + 20], 120
    mov byte [rax + 21], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_5:
    test rcx, rcx
    jz .fp_d_5
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_5
.fp_d_5:
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
.fr_c_6:
    test rdx, rdx
    jz .fr_d_6
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_6
.fr_d_6:
    pop rax
    mov [vars + 8], rax
    mov rax, [vars + 0]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rax, [vars + 8]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
