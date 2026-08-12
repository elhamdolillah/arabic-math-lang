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

    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 110
    mov byte [rax + 9], 101
    mov byte [rax + 10], 117
    mov byte [rax + 11], 114
    mov byte [rax + 12], 97
    mov byte [rax + 13], 108
    mov byte [rax + 14], 95
    mov byte [rax + 15], 110
    mov byte [rax + 16], 101
    mov byte [rax + 17], 116
    mov byte [rax + 18], 46
    mov byte [rax + 19], 116
    mov byte [rax + 20], 120
    mov byte [rax + 21], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_36:
    test rcx, rcx
    jz .fp_d_36
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_36
.fp_d_36:
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
    mov rdi, 27
    call arena_alloc
    mov qword [rax], 19
    mov byte [rax + 8], 65
    mov byte [rax + 9], 78
    mov byte [rax + 10], 68
    mov byte [rax + 11], 58
    mov byte [rax + 12], 32
    mov byte [rax + 13], 119
    mov byte [rax + 14], 49
    mov byte [rax + 15], 61
    mov byte [rax + 16], 49
    mov byte [rax + 17], 32
    mov byte [rax + 18], 119
    mov byte [rax + 19], 50
    mov byte [rax + 20], 61
    mov byte [rax + 21], 49
    mov byte [rax + 22], 32
    mov byte [rax + 23], 98
    mov byte [rax + 24], 61
    mov byte [rax + 25], 45
    mov byte [rax + 26], 49
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
    mov rdi, 26
    call arena_alloc
    mov qword [rax], 18
    mov byte [rax + 8], 32
    mov byte [rax + 9], 79
    mov byte [rax + 10], 82
    mov byte [rax + 11], 58
    mov byte [rax + 12], 32
    mov byte [rax + 13], 119
    mov byte [rax + 14], 49
    mov byte [rax + 15], 61
    mov byte [rax + 16], 49
    mov byte [rax + 17], 32
    mov byte [rax + 18], 119
    mov byte [rax + 19], 50
    mov byte [rax + 20], 61
    mov byte [rax + 21], 49
    mov byte [rax + 22], 32
    mov byte [rax + 23], 98
    mov byte [rax + 24], 61
    mov byte [rax + 25], 48
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
    mov rdi, 23
    call arena_alloc
    mov qword [rax], 15
    mov byte [rax + 8], 32
    mov byte [rax + 9], 78
    mov byte [rax + 10], 79
    mov byte [rax + 11], 84
    mov byte [rax + 12], 58
    mov byte [rax + 13], 32
    mov byte [rax + 14], 119
    mov byte [rax + 15], 49
    mov byte [rax + 16], 61
    mov byte [rax + 17], 45
    mov byte [rax + 18], 50
    mov byte [rax + 19], 32
    mov byte [rax + 20], 98
    mov byte [rax + 21], 61
    mov byte [rax + 22], 49
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
    mov rdi, 27
    call arena_alloc
    mov qword [rax], 19
    mov byte [rax + 8], 32
    mov byte [rax + 9], 88
    mov byte [rax + 10], 79
    mov byte [rax + 11], 82
    mov byte [rax + 12], 58
    mov byte [rax + 13], 32
    mov byte [rax + 14], 51
    mov byte [rax + 15], 32
    mov byte [rax + 16], 112
    mov byte [rax + 17], 101
    mov byte [rax + 18], 114
    mov byte [rax + 19], 99
    mov byte [rax + 20], 101
    mov byte [rax + 21], 112
    mov byte [rax + 22], 116
    mov byte [rax + 23], 114
    mov byte [rax + 24], 111
    mov byte [rax + 25], 110
    mov byte [rax + 26], 115
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
    mov byte [rax + 8], 110
    mov byte [rax + 9], 101
    mov byte [rax + 10], 117
    mov byte [rax + 11], 114
    mov byte [rax + 12], 97
    mov byte [rax + 13], 108
    mov byte [rax + 14], 95
    mov byte [rax + 15], 110
    mov byte [rax + 16], 101
    mov byte [rax + 17], 116
    mov byte [rax + 18], 46
    mov byte [rax + 19], 116
    mov byte [rax + 20], 120
    mov byte [rax + 21], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_37:
    test rcx, rcx
    jz .fp_d_37
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_37
.fp_d_37:
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
.fr_c_38:
    test rdx, rdx
    jz .fr_d_38
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_38
.fr_d_38:
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
