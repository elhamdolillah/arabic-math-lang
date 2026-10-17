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

str_eq:
    mov rcx, [rdi]
    mov rdx, [rsi]
    cmp rcx, rdx
    jne str_eq_ne
    add rdi, 8
    add rsi, 8
str_eq_loop:
    test rcx, rcx
    jz str_eq_eq
    mov al, [rdi]
    cmp al, [rsi]
    jne str_eq_ne
    inc rdi
    inc rsi
    dec rcx
    jmp str_eq_loop
str_eq_eq:
    mov rax, 1
    ret
str_eq_ne:
    mov rax, 0
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

    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 110
    mov byte [rax + 9], 108
    mov byte [rax + 10], 112
    mov byte [rax + 11], 95
    mov byte [rax + 12], 97
    mov byte [rax + 13], 110
    mov byte [rax + 14], 97
    mov byte [rax + 15], 108
    mov byte [rax + 16], 121
    mov byte [rax + 17], 115
    mov byte [rax + 18], 105
    mov byte [rax + 19], 115
    mov byte [rax + 20], 46
    mov byte [rax + 21], 116
    mov byte [rax + 22], 120
    mov byte [rax + 23], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_55:
    test rcx, rcx
    jz .fp_d_55
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_55
.fp_d_55:
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
    mov rdi, 63
    call arena_alloc
    mov qword [rax], 55
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 172
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    mov byte [rax + 22], 216
    mov byte [rax + 23], 167
    mov byte [rax + 24], 217
    mov byte [rax + 25], 132
    mov byte [rax + 26], 216
    mov byte [rax + 27], 183
    mov byte [rax + 28], 216
    mov byte [rax + 29], 167
    mov byte [rax + 30], 217
    mov byte [rax + 31], 132
    mov byte [rax + 32], 216
    mov byte [rax + 33], 168
    mov byte [rax + 34], 32
    mov byte [rax + 35], 217
    mov byte [rax + 36], 138
    mov byte [rax + 37], 217
    mov byte [rax + 38], 131
    mov byte [rax + 39], 216
    mov byte [rax + 40], 170
    mov byte [rax + 41], 216
    mov byte [rax + 42], 168
    mov byte [rax + 43], 32
    mov byte [rax + 44], 217
    mov byte [rax + 45], 129
    mov byte [rax + 46], 217
    mov byte [rax + 47], 138
    mov byte [rax + 48], 32
    mov byte [rax + 49], 216
    mov byte [rax + 50], 167
    mov byte [rax + 51], 217
    mov byte [rax + 52], 132
    mov byte [rax + 53], 217
    mov byte [rax + 54], 133
    mov byte [rax + 55], 216
    mov byte [rax + 56], 175
    mov byte [rax + 57], 216
    mov byte [rax + 58], 177
    mov byte [rax + 59], 216
    mov byte [rax + 60], 179
    mov byte [rax + 61], 216
    mov byte [rax + 62], 169
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
    mov rdi, 35
    call arena_alloc
    mov qword [rax], 27
    mov byte [rax + 8], 32
    mov byte [rax + 9], 216
    mov byte [rax + 10], 167
    mov byte [rax + 11], 216
    mov byte [rax + 12], 179
    mov byte [rax + 13], 217
    mov byte [rax + 14], 133
    mov byte [rax + 15], 58
    mov byte [rax + 16], 50
    mov byte [rax + 17], 32
    mov byte [rax + 18], 217
    mov byte [rax + 19], 129
    mov byte [rax + 20], 216
    mov byte [rax + 21], 185
    mov byte [rax + 22], 217
    mov byte [rax + 23], 132
    mov byte [rax + 24], 58
    mov byte [rax + 25], 49
    mov byte [rax + 26], 32
    mov byte [rax + 27], 216
    mov byte [rax + 28], 173
    mov byte [rax + 29], 216
    mov byte [rax + 30], 177
    mov byte [rax + 31], 217
    mov byte [rax + 32], 129
    mov byte [rax + 33], 58
    mov byte [rax + 34], 49
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
    mov rdi, 45
    call arena_alloc
    mov qword [rax], 37
    mov byte [rax + 8], 32
    mov byte [rax + 9], 217
    mov byte [rax + 10], 133
    mov byte [rax + 11], 216
    mov byte [rax + 12], 177
    mov byte [rax + 13], 217
    mov byte [rax + 14], 129
    mov byte [rax + 15], 217
    mov byte [rax + 16], 136
    mov byte [rax + 17], 216
    mov byte [rax + 18], 185
    mov byte [rax + 19], 58
    mov byte [rax + 20], 50
    mov byte [rax + 21], 32
    mov byte [rax + 22], 217
    mov byte [rax + 23], 133
    mov byte [rax + 24], 216
    mov byte [rax + 25], 172
    mov byte [rax + 26], 216
    mov byte [rax + 27], 177
    mov byte [rax + 28], 217
    mov byte [rax + 29], 136
    mov byte [rax + 30], 216
    mov byte [rax + 31], 177
    mov byte [rax + 32], 58
    mov byte [rax + 33], 49
    mov byte [rax + 34], 32
    mov byte [rax + 35], 217
    mov byte [rax + 36], 133
    mov byte [rax + 37], 216
    mov byte [rax + 38], 168
    mov byte [rax + 39], 217
    mov byte [rax + 40], 134
    mov byte [rax + 41], 217
    mov byte [rax + 42], 138
    mov byte [rax + 43], 58
    mov byte [rax + 44], 49
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
    mov rdi, 39
    call arena_alloc
    mov qword [rax], 31
    mov byte [rax + 8], 32
    mov byte [rax + 9], 216
    mov byte [rax + 10], 172
    mov byte [rax + 11], 216
    mov byte [rax + 12], 176
    mov byte [rax + 13], 217
    mov byte [rax + 14], 136
    mov byte [rax + 15], 216
    mov byte [rax + 16], 177
    mov byte [rax + 17], 58
    mov byte [rax + 18], 32
    mov byte [rax + 19], 216
    mov byte [rax + 20], 183
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 216
    mov byte [rax + 24], 168
    mov byte [rax + 25], 32
    mov byte [rax + 26], 217
    mov byte [rax + 27], 131
    mov byte [rax + 28], 216
    mov byte [rax + 29], 170
    mov byte [rax + 30], 216
    mov byte [rax + 31], 168
    mov byte [rax + 32], 32
    mov byte [rax + 33], 216
    mov byte [rax + 34], 175
    mov byte [rax + 35], 216
    mov byte [rax + 36], 177
    mov byte [rax + 37], 216
    mov byte [rax + 38], 179
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
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 110
    mov byte [rax + 9], 108
    mov byte [rax + 10], 112
    mov byte [rax + 11], 95
    mov byte [rax + 12], 97
    mov byte [rax + 13], 110
    mov byte [rax + 14], 97
    mov byte [rax + 15], 108
    mov byte [rax + 16], 121
    mov byte [rax + 17], 115
    mov byte [rax + 18], 105
    mov byte [rax + 19], 115
    mov byte [rax + 20], 46
    mov byte [rax + 21], 116
    mov byte [rax + 22], 120
    mov byte [rax + 23], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_56:
    test rcx, rcx
    jz .fp_d_56
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_56
.fp_d_56:
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
.fr_c_57:
    test rdx, rdx
    jz .fr_d_57
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_57
.fr_d_57:
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
