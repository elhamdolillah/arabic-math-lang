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

    mov rdi, 23
    call arena_alloc
    mov qword [rax], 15
    mov byte [rax + 8], 105
    mov byte [rax + 9], 110
    mov byte [rax + 10], 116
    mov byte [rax + 11], 101
    mov byte [rax + 12], 103
    mov byte [rax + 13], 114
    mov byte [rax + 14], 97
    mov byte [rax + 15], 116
    mov byte [rax + 16], 105
    mov byte [rax + 17], 111
    mov byte [rax + 18], 110
    mov byte [rax + 19], 46
    mov byte [rax + 20], 116
    mov byte [rax + 21], 120
    mov byte [rax + 22], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_43:
    test rcx, rcx
    jz .fp_d_43
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_43
.fp_d_43:
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
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 102
    mov byte [rax + 9], 40
    mov byte [rax + 10], 120
    mov byte [rax + 11], 41
    mov byte [rax + 12], 61
    mov byte [rax + 13], 54
    mov byte [rax + 14], 120
    mov byte [rax + 15], 94
    mov byte [rax + 16], 50
    mov byte [rax + 17], 43
    mov byte [rax + 18], 52
    mov byte [rax + 19], 120
    mov byte [rax + 20], 43
    mov byte [rax + 21], 50
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
    mov byte [rax + 9], 105
    mov byte [rax + 10], 110
    mov byte [rax + 11], 116
    mov byte [rax + 12], 61
    mov byte [rax + 13], 50
    mov byte [rax + 14], 120
    mov byte [rax + 15], 94
    mov byte [rax + 16], 51
    mov byte [rax + 17], 43
    mov byte [rax + 18], 50
    mov byte [rax + 19], 120
    mov byte [rax + 20], 94
    mov byte [rax + 21], 50
    mov byte [rax + 22], 43
    mov byte [rax + 23], 50
    mov byte [rax + 24], 120
    mov byte [rax + 25], 43
    mov byte [rax + 26], 67
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
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 32
    mov byte [rax + 9], 105
    mov byte [rax + 10], 110
    mov byte [rax + 11], 116
    mov byte [rax + 12], 95
    mov byte [rax + 13], 48
    mov byte [rax + 14], 95
    mov byte [rax + 15], 50
    mov byte [rax + 16], 61
    mov byte [rax + 17], 50
    mov byte [rax + 18], 56
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
    mov rdi, 29
    call arena_alloc
    mov qword [rax], 21
    mov byte [rax + 8], 32
    mov byte [rax + 9], 118
    mov byte [rax + 10], 40
    mov byte [rax + 11], 116
    mov byte [rax + 12], 41
    mov byte [rax + 13], 61
    mov byte [rax + 14], 51
    mov byte [rax + 15], 116
    mov byte [rax + 16], 94
    mov byte [rax + 17], 50
    mov byte [rax + 18], 43
    mov byte [rax + 19], 50
    mov byte [rax + 20], 116
    mov byte [rax + 21], 32
    mov byte [rax + 22], 115
    mov byte [rax + 23], 40
    mov byte [rax + 24], 50
    mov byte [rax + 25], 41
    mov byte [rax + 26], 61
    mov byte [rax + 27], 49
    mov byte [rax + 28], 50
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
    mov rdi, 23
    call arena_alloc
    mov qword [rax], 15
    mov byte [rax + 8], 105
    mov byte [rax + 9], 110
    mov byte [rax + 10], 116
    mov byte [rax + 11], 101
    mov byte [rax + 12], 103
    mov byte [rax + 13], 114
    mov byte [rax + 14], 97
    mov byte [rax + 15], 116
    mov byte [rax + 16], 105
    mov byte [rax + 17], 111
    mov byte [rax + 18], 110
    mov byte [rax + 19], 46
    mov byte [rax + 20], 116
    mov byte [rax + 21], 120
    mov byte [rax + 22], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_44:
    test rcx, rcx
    jz .fp_d_44
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_44
.fp_d_44:
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
.fr_c_45:
    test rdx, rdx
    jz .fr_d_45
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_45
.fr_d_45:
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
