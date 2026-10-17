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
    t_task_1 resq 4
    t_status_1 resq 1
    t_task_2 resq 4
    t_status_2 resq 1
    t_task_3 resq 4
    t_status_3 resq 1
    t_task_4 resq 4
    t_status_4 resq 1
    t_task_5 resq 4
    t_status_5 resq 1
    t_task_6 resq 4
    t_status_6 resq 1
    t_task_7 resq 4
    t_status_7 resq 1
    t_task_8 resq 4
    t_status_8 resq 1
    t_task_9 resq 4
    t_status_9 resq 1
    t_task_10 resq 4
    t_status_10 resq 1
    t_task_11 resq 4
    t_status_11 resq 1
    t_task_12 resq 4
    t_status_12 resq 1
    t_task_13 resq 4
    t_status_13 resq 1
    t_task_14 resq 4
    t_status_14 resq 1
    t_task_15 resq 4
    t_status_15 resq 1
    t_task_16 resq 4
    t_status_16 resq 1

section .text
mmfail:
    mov rax, 60
    mov rdi, 2
    syscall

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
    test rax, rax
    jns .pi_pos
    neg rax
    mov byte [negflag], 1
.pi_pos:
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
    cmp byte [negflag], 1
    jne .pi_skip_neg
    dec rdi
    mov byte [rdi], 45
    inc rcx
.pi_skip_neg:
    mov byte [negflag], 0
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

    mov rdi, 28
    call arena_alloc
    mov qword [rax], 20
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 216
    mov byte [rax + 11], 175
    mov byte [rax + 12], 216
    mov byte [rax + 13], 174
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 32
    mov byte [rax + 17], 216
    mov byte [rax + 18], 185
    mov byte [rax + 19], 216
    mov byte [rax + 20], 175
    mov byte [rax + 21], 216
    mov byte [rax + 22], 175
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 139
    mov byte [rax + 27], 58
    call print_str
    xor rcx, rcx
.rd_loop_8:
    lea rsi, [read_buf + rcx]
    xor rdi, rdi
    mov rdx, 1
    xor rax, rax
    push rcx
    syscall
    pop rcx
    test rax, rax
    jz .rd_end_8
    mov al, [read_buf + rcx]
    cmp al, 10
    je .rd_end_8
    inc rcx
    jmp .rd_loop_8
.rd_end_8:
    mov rax, rcx
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov [rax], rcx
    push rax
    push rcx
    lea rsi, [read_buf]
    lea rdi, [rax + 8]
.rd_copy_8:
    test rcx, rcx
    jz .rd_cdone_8
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .rd_copy_8
.rd_cdone_8:
    pop rcx
    pop rax
    mov rcx, [rax]
    lea rsi, [rax + 8]
    mov rax, 0
    mov rbx, 10
.std_7:
    test rcx, rcx
    jz .sdd_7
    movzx rdx, byte [rsi]
    cmp dl, '0'
    jl .std_skip_7
    cmp dl, '9'
    jg .std_skip_7
    sub dl, '0'
    imul rax, rbx
    add rax, rdx
.std_skip_7:
    inc rsi
    dec rcx
    jmp .std_7
.sdd_7:
    mov [vars + 0], rax
    mov rdi, 41
    call arena_alloc
    mov qword [rax], 33
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 216
    mov byte [rax + 11], 175
    mov byte [rax + 12], 216
    mov byte [rax + 13], 174
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 32
    mov byte [rax + 17], 216
    mov byte [rax + 18], 185
    mov byte [rax + 19], 216
    mov byte [rax + 20], 175
    mov byte [rax + 21], 216
    mov byte [rax + 22], 175
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 139
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 171
    mov byte [rax + 30], 216
    mov byte [rax + 31], 167
    mov byte [rax + 32], 217
    mov byte [rax + 33], 134
    mov byte [rax + 34], 217
    mov byte [rax + 35], 138
    mov byte [rax + 36], 216
    mov byte [rax + 37], 167
    mov byte [rax + 38], 217
    mov byte [rax + 39], 139
    mov byte [rax + 40], 58
    call print_str
    xor rcx, rcx
.rd_loop_10:
    lea rsi, [read_buf + rcx]
    xor rdi, rdi
    mov rdx, 1
    xor rax, rax
    push rcx
    syscall
    pop rcx
    test rax, rax
    jz .rd_end_10
    mov al, [read_buf + rcx]
    cmp al, 10
    je .rd_end_10
    inc rcx
    jmp .rd_loop_10
.rd_end_10:
    mov rax, rcx
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov [rax], rcx
    push rax
    push rcx
    lea rsi, [read_buf]
    lea rdi, [rax + 8]
.rd_copy_10:
    test rcx, rcx
    jz .rd_cdone_10
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .rd_copy_10
.rd_cdone_10:
    pop rcx
    pop rax
    mov rcx, [rax]
    lea rsi, [rax + 8]
    mov rax, 0
    mov rbx, 10
.std_9:
    test rcx, rcx
    jz .sdd_9
    movzx rdx, byte [rsi]
    cmp dl, '0'
    jl .std_skip_9
    cmp dl, '9'
    jg .std_skip_9
    sub dl, '0'
    imul rax, rbx
    add rax, rdx
.std_skip_9:
    inc rsi
    dec rcx
    jmp .std_9
.sdd_9:
    mov [vars + 8], rax
    mov rdi, 23
    call arena_alloc
    mov qword [rax], 15
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 172
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 217
    mov byte [rax + 19], 136
    mov byte [rax + 20], 216
    mov byte [rax + 21], 185
    mov byte [rax + 22], 58
    call print_str
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 8]
    pop rbx
    add rax, rbx
    test rax, rax
    jns .npos_11
    neg rax
    mov byte [negflag], 1
.npos_11:
    mov rbx, 10
    mov rcx, 0
    mov byte [negflag], 0
    lea rdi, [num_buf + 31]
.nts_11:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_11
    cmp byte [negflag], 1
    jne .nskip2_11
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_11:
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
.ntc_11:
    test rcx, rcx
    jz .ntd_11
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_11
.ntd_11:
    mov byte [negflag], 0
    pop rax
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
