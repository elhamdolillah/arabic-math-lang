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

    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 99
    mov byte [rax + 9], 97
    mov byte [rax + 10], 108
    mov byte [rax + 11], 99
    mov byte [rax + 12], 117
    mov byte [rax + 13], 108
    mov byte [rax + 14], 117
    mov byte [rax + 15], 115
    mov byte [rax + 16], 46
    mov byte [rax + 17], 116
    mov byte [rax + 18], 120
    mov byte [rax + 19], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_39:
    test rcx, rcx
    jz .fp_d_39
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_39
.fp_d_39:
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
    mov byte [rax + 13], 51
    mov byte [rax + 14], 120
    mov byte [rax + 15], 94
    mov byte [rax + 16], 50
    mov byte [rax + 17], 43
    mov byte [rax + 18], 50
    mov byte [rax + 19], 120
    mov byte [rax + 20], 43
    mov byte [rax + 21], 49
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
    mov byte [rax + 9], 102
    mov byte [rax + 10], 39
    mov byte [rax + 11], 40
    mov byte [rax + 12], 120
    mov byte [rax + 13], 41
    mov byte [rax + 14], 61
    mov byte [rax + 15], 54
    mov byte [rax + 16], 120
    mov byte [rax + 17], 43
    mov byte [rax + 18], 50
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
    mov rdi, 17
    call arena_alloc
    mov qword [rax], 9
    mov byte [rax + 8], 32
    mov byte [rax + 9], 102
    mov byte [rax + 10], 39
    mov byte [rax + 11], 39
    mov byte [rax + 12], 40
    mov byte [rax + 13], 120
    mov byte [rax + 14], 41
    mov byte [rax + 15], 61
    mov byte [rax + 16], 54
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
    mov rdi, 25
    call arena_alloc
    mov qword [rax], 17
    mov byte [rax + 8], 32
    mov byte [rax + 9], 102
    mov byte [rax + 10], 39
    mov byte [rax + 11], 40
    mov byte [rax + 12], 49
    mov byte [rax + 13], 41
    mov byte [rax + 14], 61
    mov byte [rax + 15], 56
    mov byte [rax + 16], 32
    mov byte [rax + 17], 102
    mov byte [rax + 18], 39
    mov byte [rax + 19], 40
    mov byte [rax + 20], 50
    mov byte [rax + 21], 41
    mov byte [rax + 22], 61
    mov byte [rax + 23], 49
    mov byte [rax + 24], 52
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
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 99
    mov byte [rax + 9], 97
    mov byte [rax + 10], 108
    mov byte [rax + 11], 99
    mov byte [rax + 12], 117
    mov byte [rax + 13], 108
    mov byte [rax + 14], 117
    mov byte [rax + 15], 115
    mov byte [rax + 16], 46
    mov byte [rax + 17], 116
    mov byte [rax + 18], 120
    mov byte [rax + 19], 116
    mov rcx, [rax]
    lea rsi, [rax + 8]
    lea rdi, [file_path_buf]
.fp_c_40:
    test rcx, rcx
    jz .fp_d_40
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .fp_c_40
.fp_d_40:
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
.fr_c_41:
    test rdx, rdx
    jz .fr_d_41
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rdx
    jmp .fr_c_41
.fr_d_41:
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
