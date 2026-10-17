global _start
section .bss
    vars resq 256
    num_buf resb 32
    read_buf resb 256
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

    xor rcx, rcx
.rd_loop_1:
    lea rsi, [read_buf + rcx]
    xor rdi, rdi
    mov rdx, 1
    xor rax, rax
    push rcx
    syscall
    pop rcx
    test rax, rax
    jz .rd_end_1
    mov al, [read_buf + rcx]
    cmp al, 10
    je .rd_end_1
    inc rcx
    jmp .rd_loop_1
.rd_end_1:
    mov rax, rcx
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov [rax], rcx
    push rax
    push rcx
    lea rsi, [read_buf]
    lea rdi, [rax + 8]
.rd_copy_1:
    test rcx, rcx
    jz .rd_cdone_1
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .rd_copy_1
.rd_cdone_1:
    pop rcx
    pop rax
    mov [vars + 0], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 4
    pop rbx
    mov rcx, rax
    mov rax, [rbx]
    cmp rcx, rax
    jge .ch_err_1
    movzx rax, byte [rbx + rcx + 8]
    jmp .ch_ok_1
.ch_err_1:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_1:
    mov [vars + 8], rax
    mov rdi, 21
    call arena_alloc
    mov qword [rax], 13
    mov byte [rax + 8], 103
    mov byte [rax + 9], 108
    mov byte [rax + 10], 111
    mov byte [rax + 11], 98
    mov byte [rax + 12], 97
    mov byte [rax + 13], 108
    mov byte [rax + 14], 32
    mov byte [rax + 15], 95
    mov byte [rax + 16], 115
    mov byte [rax + 17], 116
    mov byte [rax + 18], 97
    mov byte [rax + 19], 114
    mov byte [rax + 20], 116
    call print_str
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 115
    mov byte [rax + 9], 101
    mov byte [rax + 10], 99
    mov byte [rax + 11], 116
    mov byte [rax + 12], 105
    mov byte [rax + 13], 111
    mov byte [rax + 14], 110
    mov byte [rax + 15], 32
    mov byte [rax + 16], 46
    mov byte [rax + 17], 98
    mov byte [rax + 18], 115
    mov byte [rax + 19], 115
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 98
    mov byte [rax + 13], 117
    mov byte [rax + 14], 102
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 101
    mov byte [rax + 18], 115
    mov byte [rax + 19], 98
    mov byte [rax + 20], 32
    mov byte [rax + 21], 50
    mov byte [rax + 22], 53
    mov byte [rax + 23], 54
    call print_str
    mov rdi, 21
    call arena_alloc
    mov qword [rax], 13
    mov byte [rax + 8], 115
    mov byte [rax + 9], 101
    mov byte [rax + 10], 99
    mov byte [rax + 11], 116
    mov byte [rax + 12], 105
    mov byte [rax + 13], 111
    mov byte [rax + 14], 110
    mov byte [rax + 15], 32
    mov byte [rax + 16], 46
    mov byte [rax + 17], 116
    mov byte [rax + 18], 101
    mov byte [rax + 19], 120
    mov byte [rax + 20], 116
    call print_str
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 95
    mov byte [rax + 9], 115
    mov byte [rax + 10], 116
    mov byte [rax + 11], 97
    mov byte [rax + 12], 114
    mov byte [rax + 13], 116
    mov byte [rax + 14], 58
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 100
    mov byte [rax + 18], 105
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 48
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 115
    mov byte [rax + 18], 105
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 98
    mov byte [rax + 22], 117
    mov byte [rax + 23], 102
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 100
    mov byte [rax + 18], 120
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 50
    mov byte [rax + 22], 53
    mov byte [rax + 23], 54
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 97
    mov byte [rax + 18], 120
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 48
    call print_str
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 115
    mov byte [rax + 13], 121
    mov byte [rax + 14], 115
    mov byte [rax + 15], 99
    mov byte [rax + 16], 97
    mov byte [rax + 17], 108
    mov byte [rax + 18], 108
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 100
    mov byte [rax + 18], 105
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 49
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 115
    mov byte [rax + 18], 105
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 98
    mov byte [rax + 22], 117
    mov byte [rax + 23], 102
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 100
    mov byte [rax + 18], 120
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 114
    mov byte [rax + 22], 97
    mov byte [rax + 23], 120
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 97
    mov byte [rax + 18], 120
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 49
    call print_str
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 115
    mov byte [rax + 13], 121
    mov byte [rax + 14], 115
    mov byte [rax + 15], 99
    mov byte [rax + 16], 97
    mov byte [rax + 17], 108
    mov byte [rax + 18], 108
    call print_str
    mov rdi, 23
    call arena_alloc
    mov qword [rax], 15
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 109
    mov byte [rax + 13], 111
    mov byte [rax + 14], 118
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 97
    mov byte [rax + 18], 120
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 54
    mov byte [rax + 22], 48
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 120
    mov byte [rax + 13], 111
    mov byte [rax + 14], 114
    mov byte [rax + 15], 32
    mov byte [rax + 16], 114
    mov byte [rax + 17], 100
    mov byte [rax + 18], 105
    mov byte [rax + 19], 44
    mov byte [rax + 20], 32
    mov byte [rax + 21], 114
    mov byte [rax + 22], 100
    mov byte [rax + 23], 105
    call print_str
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 32
    mov byte [rax + 9], 32
    mov byte [rax + 10], 32
    mov byte [rax + 11], 32
    mov byte [rax + 12], 115
    mov byte [rax + 13], 121
    mov byte [rax + 14], 115
    mov byte [rax + 15], 99
    mov byte [rax + 16], 97
    mov byte [rax + 17], 108
    mov byte [rax + 18], 108
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
