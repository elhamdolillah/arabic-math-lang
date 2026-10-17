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

    mov rdi, 11
    call arena_alloc
    mov qword [rax], 3
    mov byte [rax + 8], 49
    mov byte [rax + 9], 50
    mov byte [rax + 10], 51
    mov rcx, [rax]
    lea rsi, [rax + 8]
    mov rax, 0
    mov rbx, 10
.std_4:
    test rcx, rcx
    jz .sdd_4
    movzx rdx, byte [rsi]
    cmp dl, '0'
    jl .std_skip_4
    cmp dl, '9'
    jg .std_skip_4
    sub dl, '0'
    imul rax, rbx
    add rax, rdx
.std_skip_4:
    inc rsi
    dec rcx
    jmp .std_4
.sdd_4:
    call print_int

    mov rax, 60
    xor rdi, rdi
    syscall
