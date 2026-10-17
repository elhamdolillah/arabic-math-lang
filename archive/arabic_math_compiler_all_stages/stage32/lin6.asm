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

    mov rax, 2
    mov [vars + 0], rax
    mov rax, 1
    mov [vars + 8], rax
    mov rax, 1
    mov [vars + 16], rax
    mov rax, 1
    mov [vars + 24], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 24]
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 16]
    pop rbx
    imul rax, rbx
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 32], rax
    mov rdi, 26
    call arena_alloc
    mov qword [rax], 18
    mov byte [rax + 8], 108
    mov byte [rax + 9], 105
    mov byte [rax + 10], 110
    mov byte [rax + 11], 101
    mov byte [rax + 12], 97
    mov byte [rax + 13], 114
    mov byte [rax + 14], 95
    mov byte [rax + 15], 97
    mov byte [rax + 16], 108
    mov byte [rax + 17], 103
    mov byte [rax + 18], 101
    mov byte [rax + 19], 98
    mov byte [rax + 20], 114
    mov byte [rax + 21], 97
    mov byte [rax + 22], 46
    mov byte [rax + 23], 116
    mov byte [rax + 24], 120
    mov byte [rax + 25], 116
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
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rdi, 25
    call arena_alloc
    mov qword [rax], 17
    mov byte [rax + 8], 77
    mov byte [rax + 9], 97
    mov byte [rax + 10], 116
    mov byte [rax + 11], 114
    mov byte [rax + 12], 105
    mov byte [rax + 13], 120
    mov byte [rax + 14], 58
    mov byte [rax + 15], 32
    mov byte [rax + 16], 91
    mov byte [rax + 17], 50
    mov byte [rax + 18], 44
    mov byte [rax + 19], 49
    mov byte [rax + 20], 59
    mov byte [rax + 21], 49
    mov byte [rax + 22], 44
    mov byte [rax + 23], 49
    mov byte [rax + 24], 93
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 40]
    push rax
    mov rdi, 13
    call arena_alloc
    mov qword [rax], 5
    mov byte [rax + 8], 32
    mov byte [rax + 9], 100
    mov byte [rax + 10], 101
    mov byte [rax + 11], 116
    mov byte [rax + 12], 61
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 40]
    push rax
    mov rax, [vars + 32]
    test rax, rax
    jns .npos_58
    neg rax
    mov byte [negflag], 1
.npos_58:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_58:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_58
    cmp byte [negflag], 1
    jne .nskip2_58
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_58:
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
.ntc_58:
    test rcx, rcx
    jz .ntd_58
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_58
.ntd_58:
    mov byte [negflag], 0
    pop rax
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 40]
    push rax
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 32
    mov byte [rax + 9], 105
    mov byte [rax + 10], 110
    mov byte [rax + 11], 118
    mov byte [rax + 12], 61
    mov byte [rax + 13], 91
    mov byte [rax + 14], 49
    mov byte [rax + 15], 44
    mov byte [rax + 16], 45
    mov byte [rax + 17], 49
    mov byte [rax + 18], 59
    mov byte [rax + 19], 45
    mov byte [rax + 20], 49
    mov byte [rax + 21], 44
    mov byte [rax + 22], 50
    mov byte [rax + 23], 93
    mov rdx, [rax]
    lea rsi, [rax + 8]
    pop rdi
    push rcx
    mov rax, 1
    syscall
    pop rcx
    mov rax, rdx
    mov rax, [vars + 40]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rdi, 26
    call arena_alloc
    mov qword [rax], 18
    mov byte [rax + 8], 108
    mov byte [rax + 9], 105
    mov byte [rax + 10], 110
    mov byte [rax + 11], 101
    mov byte [rax + 12], 97
    mov byte [rax + 13], 114
    mov byte [rax + 14], 95
    mov byte [rax + 15], 97
    mov byte [rax + 16], 108
    mov byte [rax + 17], 103
    mov byte [rax + 18], 101
    mov byte [rax + 19], 98
    mov byte [rax + 20], 114
    mov byte [rax + 21], 97
    mov byte [rax + 22], 46
    mov byte [rax + 23], 116
    mov byte [rax + 24], 120
    mov byte [rax + 25], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_59:
    test rcx, rcx
    jz .fp_d_59
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_59
.fp_d_59:
    mov byte [rdi], 0
    lea rdi, [file_path_buf]
    mov rsi, 66
    mov rdx, 420
    mov rax, 2
    push rcx
    syscall
    pop rcx
    mov [vars + 40], rax
    mov rax, [vars + 40]
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
.fr_c_60:
    test rdx, rdx
    jz .fr_d_60
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_60
.fr_d_60:
    pop rax
    mov [vars + 48], rax
    mov rax, [vars + 40]
    push rcx
    mov rax, 3
    syscall
    pop rcx
    mov rax, [vars + 48]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
