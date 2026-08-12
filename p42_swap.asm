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
    mov rax, 10
    push rax
    mov rax, 20
    push rax
    pop rsi
    pop rdi
    mov r10, [vars + 0]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    mov [vars + 8], rax
    mov rax, [vars + 8]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_1
    mov rax, [rax + 8]
    jmp .hdne_1
.hemp_1:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_1:
    test rax, rax
    jns .npos_6
    neg rax
    mov byte [negflag], 1
.npos_6:
    mov rbx, 10
    mov rcx, 0
    mov byte [negflag], 0
    lea rdi, [num_buf + 31]
.nts_6:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_6
    cmp byte [negflag], 1
    jne .nskip2_6
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_6:
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
.ntc_6:
    test rcx, rcx
    jz .ntd_6
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_6
.ntd_6:
    mov byte [negflag], 0
    pop rax
    call print_str
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_8
    push rax
    dec rcx
    mov rdi, rcx
    shl rdi, 3
    add rdi, 8
    call arena_alloc
    mov r12, rax
    mov [rax], rcx
    pop rsi
    add rsi, 16
    lea rdi, [r12 + 8]
.tcopy_8:
    test rcx, rcx
    jz .tcd_8
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_8
.tcd_8:
    mov rax, r12
    jmp .taine_8
.taihemp_8:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_8:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_2
    mov rax, [rax + 8]
    jmp .hdne_2
.hemp_2:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_2:
    test rax, rax
    jns .npos_7
    neg rax
    mov byte [negflag], 1
.npos_7:
    mov rbx, 10
    mov rcx, 0
    mov byte [negflag], 0
    lea rdi, [num_buf + 31]
.nts_7:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_7
    cmp byte [negflag], 1
    jne .nskip2_7
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_7:
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
.ntc_7:
    test rcx, rcx
    jz .ntd_7
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_7
.ntd_7:
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
    mov [rbp - 16], rsi
    sub rsp, 16
    mov [rbp - 8], rdi
    mov [rbp - 16], rsi
    mov rdi, 24
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov rax, [rbp - 16]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, [rbp - 8]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    pop rax
    leave
    ret