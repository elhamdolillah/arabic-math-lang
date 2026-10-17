global _start
section .bss
    vars resq 256
    num_buf resb 32
    negflag resb 1
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

    mov rdi, 25
    call arena_alloc
    mov qword [rax], 17
    mov byte [rax + 8], 108
    mov byte [rax + 9], 101
    mov byte [rax + 10], 97
    mov byte [rax + 11], 114
    mov byte [rax + 12], 110
    mov byte [rax + 13], 101
    mov byte [rax + 14], 100
    mov byte [rax + 15], 95
    mov byte [rax + 16], 114
    mov byte [rax + 17], 117
    mov byte [rax + 18], 108
    mov byte [rax + 19], 101
    mov byte [rax + 20], 115
    mov byte [rax + 21], 46
    mov byte [rax + 22], 116
    mov byte [rax + 23], 120
    mov byte [rax + 24], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_49:
    test rcx, rcx
    jz .fp_d_49
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_49
.fp_d_49:
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
    mov rdi, 54
    call arena_alloc
    mov qword [rax], 46
    mov byte [rax + 8], 217
    mov byte [rax + 9], 130
    mov byte [rax + 10], 216
    mov byte [rax + 11], 167
    mov byte [rax + 12], 216
    mov byte [rax + 13], 185
    mov byte [rax + 14], 216
    mov byte [rax + 15], 175
    mov byte [rax + 16], 216
    mov byte [rax + 17], 169
    mov byte [rax + 18], 32
    mov byte [rax + 19], 49
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    mov byte [rax + 22], 216
    mov byte [rax + 23], 172
    mov byte [rax + 24], 217
    mov byte [rax + 25], 133
    mov byte [rax + 26], 216
    mov byte [rax + 27], 185
    mov byte [rax + 28], 40
    mov byte [rax + 29], 216
    mov byte [rax + 30], 163
    mov byte [rax + 31], 216
    mov byte [rax + 32], 140
    mov byte [rax + 33], 216
    mov byte [rax + 34], 168
    mov byte [rax + 35], 41
    mov byte [rax + 36], 61
    mov byte [rax + 37], 216
    mov byte [rax + 38], 163
    mov byte [rax + 39], 43
    mov byte [rax + 40], 216
    mov byte [rax + 41], 168
    mov byte [rax + 42], 32
    mov byte [rax + 43], 216
    mov byte [rax + 44], 175
    mov byte [rax + 45], 217
    mov byte [rax + 46], 130
    mov byte [rax + 47], 216
    mov byte [rax + 48], 169
    mov byte [rax + 49], 61
    mov byte [rax + 50], 49
    mov byte [rax + 51], 48
    mov byte [rax + 52], 48
    mov byte [rax + 53], 37
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
    mov rdi, 49
    call arena_alloc
    mov qword [rax], 41
    mov byte [rax + 8], 32
    mov byte [rax + 9], 217
    mov byte [rax + 10], 130
    mov byte [rax + 11], 216
    mov byte [rax + 12], 167
    mov byte [rax + 13], 216
    mov byte [rax + 14], 185
    mov byte [rax + 15], 216
    mov byte [rax + 16], 175
    mov byte [rax + 17], 216
    mov byte [rax + 18], 169
    mov byte [rax + 19], 32
    mov byte [rax + 20], 50
    mov byte [rax + 21], 58
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 178
    mov byte [rax + 25], 217
    mov byte [rax + 26], 136
    mov byte [rax + 27], 216
    mov byte [rax + 28], 172
    mov byte [rax + 29], 217
    mov byte [rax + 30], 138
    mov byte [rax + 31], 40
    mov byte [rax + 32], 216
    mov byte [rax + 33], 179
    mov byte [rax + 34], 41
    mov byte [rax + 35], 61
    mov byte [rax + 36], 40
    mov byte [rax + 37], 216
    mov byte [rax + 38], 179
    mov byte [rax + 39], 195
    mov byte [rax + 40], 183
    mov byte [rax + 41], 50
    mov byte [rax + 42], 41
    mov byte [rax + 43], 194
    mov byte [rax + 44], 183
    mov byte [rax + 45], 50
    mov byte [rax + 46], 61
    mov byte [rax + 47], 216
    mov byte [rax + 48], 179
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
    mov rdi, 44
    call arena_alloc
    mov qword [rax], 36
    mov byte [rax + 8], 32
    mov byte [rax + 9], 217
    mov byte [rax + 10], 130
    mov byte [rax + 11], 216
    mov byte [rax + 12], 167
    mov byte [rax + 13], 216
    mov byte [rax + 14], 185
    mov byte [rax + 15], 216
    mov byte [rax + 16], 175
    mov byte [rax + 17], 216
    mov byte [rax + 18], 169
    mov byte [rax + 19], 32
    mov byte [rax + 20], 51
    mov byte [rax + 21], 58
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 182
    mov byte [rax + 25], 216
    mov byte [rax + 26], 177
    mov byte [rax + 27], 216
    mov byte [rax + 28], 168
    mov byte [rax + 29], 40
    mov byte [rax + 30], 216
    mov byte [rax + 31], 163
    mov byte [rax + 32], 216
    mov byte [rax + 33], 140
    mov byte [rax + 34], 216
    mov byte [rax + 35], 168
    mov byte [rax + 36], 41
    mov byte [rax + 37], 61
    mov byte [rax + 38], 216
    mov byte [rax + 39], 163
    mov byte [rax + 40], 194
    mov byte [rax + 41], 183
    mov byte [rax + 42], 216
    mov byte [rax + 43], 168
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
    mov rdi, 25
    call arena_alloc
    mov qword [rax], 17
    mov byte [rax + 8], 108
    mov byte [rax + 9], 101
    mov byte [rax + 10], 97
    mov byte [rax + 11], 114
    mov byte [rax + 12], 110
    mov byte [rax + 13], 101
    mov byte [rax + 14], 100
    mov byte [rax + 15], 95
    mov byte [rax + 16], 114
    mov byte [rax + 17], 117
    mov byte [rax + 18], 108
    mov byte [rax + 19], 101
    mov byte [rax + 20], 115
    mov byte [rax + 21], 46
    mov byte [rax + 22], 116
    mov byte [rax + 23], 120
    mov byte [rax + 24], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_50:
    test rcx, rcx
    jz .fp_d_50
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_50
.fp_d_50:
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
.fr_c_51:
    test rdx, rdx
    jz .fr_d_51
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_51
.fr_d_51:
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
