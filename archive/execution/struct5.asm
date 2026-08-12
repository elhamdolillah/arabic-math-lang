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
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 3
    mov rax, 30
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 25
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 35
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 8], rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 112
    mov byte [rax + 9], 101
    mov byte [rax + 10], 111
    mov byte [rax + 11], 112
    mov byte [rax + 12], 108
    mov byte [rax + 13], 101
    mov byte [rax + 14], 46
    mov byte [rax + 15], 116
    mov byte [rax + 16], 120
    mov byte [rax + 17], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_12:
    test rcx, rcx
    jz .fp_d_12
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_12
.fp_d_12:
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
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 216
    mov byte [rax + 11], 173
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 175
    mov byte [rax + 16], 44
    mov byte [rax + 17], 51
    mov byte [rax + 18], 48
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 16]
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
    mov rax, [vars + 16]
    push rax
    mov rdi, 21
    call arena_alloc
    mov qword [rax], 13
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
    mov byte [rax + 18], 44
    mov byte [rax + 19], 50
    mov byte [rax + 20], 53
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 16]
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
    mov rax, [vars + 16]
    push rax
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 138
    mov byte [rax + 14], 44
    mov byte [rax + 15], 51
    mov byte [rax + 16], 53
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
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 112
    mov byte [rax + 9], 101
    mov byte [rax + 10], 111
    mov byte [rax + 11], 112
    mov byte [rax + 12], 108
    mov byte [rax + 13], 101
    mov byte [rax + 14], 46
    mov byte [rax + 15], 116
    mov byte [rax + 16], 120
    mov byte [rax + 17], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_13:
    test rcx, rcx
    jz .fp_d_13
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_13
.fp_d_13:
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
.fr_c_14:
    test rdx, rdx
    jz .fr_d_14
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_14
.fr_d_14:
    pop rax
    mov [vars + 24], rax
    mov rax, [vars + 16]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rax, [vars + 24]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
