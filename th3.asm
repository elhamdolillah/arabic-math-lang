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

    mov rdi, 8
    call arena_alloc
    push rax
    mov rcx, func_0
    mov [rax], rcx
    pop rax
    mov [vars + 0], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 3
    push rax
    lea rsi, [rel t_task_3]
    pop rax
    mov [rsi + 8], rax
    pop rax
    mov [rsi], rax
    xor rdi, rdi
    mov rsi, 65536
    mov rdx, 3
    mov r10, 34
    xor r8, r8
    xor r9, r9
    mov rax, 9
    syscall
    test rax, rax
    js mmfail
    mov [t_task_3 + 24], rax
    add rax, 65536
    sub rax, 16
    mov rsi, rax
    lea r14, [rel t_task_3]
    mov rdi, 1809
    xor rdx, rdx
    xor r10, r10
    xor r8, r8
    xor r9, r9
    mov rax, 56
    syscall
    test rax, rax
    jnz t_parent_3
    lea r12, [rel t_after_3]
    push r12
    mov r15, [r14]
    mov r10, [r15]
    mov rdi, [r14 + 8]
    call r10
t_after_3:
    mov [r14 + 16], rax
    mov rdi, [r14 + 24]
    mov rsi, 0
    xor rdx, rdx
    xor r10, r10
    mov rax, 231
    syscall
t_parent_3:
    mov [t_task_3 + 24], rax
    mov edi, [t_task_3 + 24]
    lea rsi, [rel t_status_3]
    xor rdx, rdx
    xor r10, r10
    mov rax, 61
    syscall
    mov rax, [t_task_3 + 16]
    mov [vars + 8], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 4
    push rax
    lea rsi, [rel t_task_4]
    pop rax
    mov [rsi + 8], rax
    pop rax
    mov [rsi], rax
    xor rdi, rdi
    mov rsi, 65536
    mov rdx, 3
    mov r10, 34
    xor r8, r8
    xor r9, r9
    mov rax, 9
    syscall
    test rax, rax
    js mmfail
    mov [t_task_4 + 24], rax
    add rax, 65536
    sub rax, 16
    mov rsi, rax
    lea r14, [rel t_task_4]
    mov rdi, 1809
    xor rdx, rdx
    xor r10, r10
    xor r8, r8
    xor r9, r9
    mov rax, 56
    syscall
    test rax, rax
    jnz t_parent_4
    lea r12, [rel t_after_4]
    push r12
    mov r15, [r14]
    mov r10, [r15]
    mov rdi, [r14 + 8]
    call r10
t_after_4:
    mov [r14 + 16], rax
    mov rdi, [r14 + 24]
    mov rsi, 0
    xor rdx, rdx
    xor r10, r10
    mov rax, 231
    syscall
t_parent_4:
    mov [t_task_4 + 24], rax
    mov edi, [t_task_4 + 24]
    lea rsi, [rel t_status_4]
    xor rdx, rdx
    xor r10, r10
    mov rax, 61
    syscall
    mov rax, [t_task_4 + 16]
    mov [vars + 16], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 5
    push rax
    lea rsi, [rel t_task_5]
    pop rax
    mov [rsi + 8], rax
    pop rax
    mov [rsi], rax
    xor rdi, rdi
    mov rsi, 65536
    mov rdx, 3
    mov r10, 34
    xor r8, r8
    xor r9, r9
    mov rax, 9
    syscall
    test rax, rax
    js mmfail
    mov [t_task_5 + 24], rax
    add rax, 65536
    sub rax, 16
    mov rsi, rax
    lea r14, [rel t_task_5]
    mov rdi, 1809
    xor rdx, rdx
    xor r10, r10
    xor r8, r8
    xor r9, r9
    mov rax, 56
    syscall
    test rax, rax
    jnz t_parent_5
    lea r12, [rel t_after_5]
    push r12
    mov r15, [r14]
    mov r10, [r15]
    mov rdi, [r14 + 8]
    call r10
t_after_5:
    mov [r14 + 16], rax
    mov rdi, [r14 + 24]
    mov rsi, 0
    xor rdx, rdx
    xor r10, r10
    mov rax, 231
    syscall
t_parent_5:
    mov [t_task_5 + 24], rax
    mov edi, [t_task_5 + 24]
    lea rsi, [rel t_status_5]
    xor rdx, rdx
    xor r10, r10
    mov rax, 61
    syscall
    mov rax, [t_task_5 + 16]
    mov [vars + 24], rax
    mov rax, [vars + 0]
    push rax
    mov rax, 6
    push rax
    lea rsi, [rel t_task_6]
    pop rax
    mov [rsi + 8], rax
    pop rax
    mov [rsi], rax
    xor rdi, rdi
    mov rsi, 65536
    mov rdx, 3
    mov r10, 34
    xor r8, r8
    xor r9, r9
    mov rax, 9
    syscall
    test rax, rax
    js mmfail
    mov [t_task_6 + 24], rax
    add rax, 65536
    sub rax, 16
    mov rsi, rax
    lea r14, [rel t_task_6]
    mov rdi, 1809
    xor rdx, rdx
    xor r10, r10
    xor r8, r8
    xor r9, r9
    mov rax, 56
    syscall
    test rax, rax
    jnz t_parent_6
    lea r12, [rel t_after_6]
    push r12
    mov r15, [r14]
    mov r10, [r15]
    mov rdi, [r14 + 8]
    call r10
t_after_6:
    mov [r14 + 16], rax
    mov rdi, [r14 + 24]
    mov rsi, 0
    xor rdx, rdx
    xor r10, r10
    mov rax, 231
    syscall
t_parent_6:
    mov [t_task_6 + 24], rax
    mov edi, [t_task_6 + 24]
    lea rsi, [rel t_status_6]
    xor rdx, rdx
    xor r10, r10
    mov rax, 61
    syscall
    mov rax, [t_task_6 + 16]
    mov [vars + 32], rax
    mov rax, [vars + 8]
    push rax
    mov rax, [vars + 16]
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 24]
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 32]
    pop rbx
    add rax, rbx
    mov [vars + 40], rax
    mov rax, [vars + 40]
    test rax, rax
    jns .npos_3
    neg rax
    mov byte [negflag], 1
.npos_3:
    mov rbx, 10
    mov rcx, 0
    mov byte [negflag], 0
    lea rdi, [num_buf + 31]
.nts_3:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_3
    cmp byte [negflag], 1
    jne .nskip2_3
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_3:
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
.ntc_3:
    test rcx, rcx
    jz .ntd_3
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_3
.ntd_3:
    mov byte [negflag], 0
    pop rax
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall

func_0:
    push rbp
    mov rbp, rsp
    mov [rbp - 8], rdi
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rax, [rbp - 8]
    push rax
    mov rax, [rbp - 8]
    pop rbx
    imul rax, rbx
    leave
    ret