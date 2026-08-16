global _start
section .bss
    vars resq 256
    num_buf resb 32
    negflag resb 1
    read_buf resb 256
    match_val resq 1
    match_tmp resq 1
    file_path_buf resb 256
    file_buf resb 4096
    arena_base resq 1
    arena_ptr resq 1
    arena_limit resq 1
    arena_chunk_size resq 1
    fds_tmp resq 2
    chan_tmp resq 1
    future_registry resq 1
    epoll_events_buf resq 1
    future_wake_buf resq 1
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
_start_init:
    jmp _start
mmfail:
    mov rax, 60
    mov rdi, 2
    syscall

arena_alloc:
    add rdi, 15
    and rdi, -16
    mov rax, [arena_ptr]
    mov rdx, rax
    add rdx, rdi
    cmp rdx, [arena_limit]
    jbe .aa_fits
    push rdi
    push r10
    push r11
    mov rsi, [arena_chunk_size]
    cmp rsi, rdi
    jae .aa_sz_ok
    mov rsi, rdi
.aa_sz_ok:
    push rsi
    xor rdi, rdi
    mov rdx, 3
    mov r10, 0x22
    mov r8, -1
    xor r9, r9
    mov rax, 9
    syscall
    pop rsi
    cmp rax, 0
    js mmfail
    mov rdx, rax
    add rdx, rsi
    mov [arena_limit], rdx
    mov rdx, [arena_chunk_size]
    shl rdx, 1
    mov [arena_chunk_size], rdx
    mov [arena_ptr], rax
    mov [arena_base], rax
    pop r11
    pop r10
    pop rdi
.aa_fits:
    mov rdx, rax
    add rdx, rdi
    mov [arena_ptr], rdx
    ret

print_int:
    sub rsp, 8
    mov byte [rsp], 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    test rax, rax
    jns .pi_pos
    neg rax
    mov byte [rsp + 48], 1
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
    cmp byte [rsp + 48], 1
    jne .pi_skip_neg
    dec rdi
    mov byte [rdi], 45
    inc rcx
.pi_skip_neg:
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
    add rsp, 8
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
    xor rdi, rdi
    mov rsi, 1048576
    mov rdx, 3
    mov r10, 0x22
    mov r8, -1
    xor r9, r9
    mov rax, 9
    syscall
    cmp rax, 0
    js mmfail
    mov [arena_base], rax
    mov [arena_ptr], rax
    mov rdx, rax
    add rdx, 1048576
    mov [arena_limit], rdx
    mov qword [arena_chunk_size], 2097152

    mov rax, 0
    mov [vars + 0], rax
    mov rax, 1
    mov [vars + 8], rax
    mov rax, 2
    mov [vars + 16], rax
    mov rax, 3
    mov [vars + 24], rax
    mov rdi, 8
    call arena_alloc
    push rax
    mov rcx, func_0
    mov [rax], rcx
    pop rax
    mov [vars + 32], rax
    mov rdi, 8
    call arena_alloc
    push rax
    mov rcx, func_1
    mov [rax], rcx
    pop rax
    mov [vars + 40], rax
    mov rdi, 8
    call arena_alloc
    push rax
    mov rcx, func_2
    mov [rax], rcx
    pop rax
    mov [vars + 48], rax
    mov rdi, 8
    call arena_alloc
    push rax
    mov rcx, func_3
    mov [rax], rcx
    pop rax
    mov [vars + 72], rax
    mov rdi, 8
    call arena_alloc
    push rax
    mov rcx, func_5
    mov [rax], rcx
    pop rax
    mov [vars + 80], rax
    mov rdi, 8
    call arena_alloc
    push rax
    mov rcx, func_7
    mov [rax], rcx
    pop rax
    mov [vars + 88], rax
    mov rdi, 19
    call arena_alloc
    mov qword [rax], 11
    mov byte [rax + 8], 97
    mov byte [rax + 9], 32
    mov byte [rax + 10], 61
    mov byte [rax + 11], 32
    mov byte [rax + 12], 52
    mov byte [rax + 13], 50
    mov byte [rax + 14], 32
    mov byte [rax + 15], 43
    mov byte [rax + 16], 32
    mov byte [rax + 17], 49
    mov byte [rax + 18], 48
    mov [vars + 104], rax
    mov rax, [vars + 104]
    push rax
    pop rdi
    mov r10, [vars + 88]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    mov [vars + 112], rax
    mov rax, [vars + 112]
    mov rax, [rax]
    push r12
    test rax, rax
    jns .npos_13
    neg rax
    mov r12, 1
    jmp .psign_13
.npos_13:
    mov r12, 0
.psign_13:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_13:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_13
    test r12, r12
    jz .nskip2_13
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_13:
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
.ntc_13:
    test rcx, rcx
    jz .ntd_13
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_13
.ntd_13:
    pop rax
    pop r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall

func_0:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rax, [rbp - 8]
    push rax
    mov rax, 48
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setge al
    cmp rax, 0
    je .sa0_1
    mov rax, [rbp - 8]
    push rax
    mov rax, 57
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setle al
    cmp rax, 0
    setne al
    jmp .sa1_1
.sa0_1:
    mov rax, 0
.sa1_1:
    leave
    ret
func_1:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rax, [rbp - 8]
    push rax
    mov rax, 65
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setge al
    cmp rax, 0
    je .sa0_2
    mov rax, [rbp - 8]
    push rax
    mov rax, 90
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setle al
    cmp rax, 0
    setne al
    jmp .sa1_2
.sa0_2:
    mov rax, 0
.sa1_2:
    cmp rax, 0
    jne .so1_1
    mov rax, [rbp - 8]
    push rax
    mov rax, 97
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setge al
    cmp rax, 0
    je .sa0_3
    mov rax, [rbp - 8]
    push rax
    mov rax, 122
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setle al
    cmp rax, 0
    setne al
    jmp .sa1_3
.sa0_3:
    mov rax, 0
.sa1_3:
    cmp rax, 0
    jne .so1_2
    mov rax, [rbp - 8]
    push rax
    mov rax, 95
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    setne al
    jmp .so0_2
.so1_2:
    mov rax, 1
.so0_2:
    cmp rax, 0
    setne al
    jmp .so0_1
.so1_1:
    mov rax, 1
.so0_1:
    leave
    ret
func_2:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rax, [rbp - 8]
    push rax
    mov rax, 32
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    jne .so1_3
    mov rax, [rbp - 8]
    push rax
    mov rax, 9
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    jne .so1_4
    mov rax, [rbp - 8]
    push rax
    mov rax, 10
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    setne al
    jmp .so0_4
.so1_4:
    mov rax, 1
.so0_4:
    cmp rax, 0
    setne al
    jmp .so0_3
.so1_3:
    mov rax, 1
.so0_3:
    leave
    ret
func_4:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov [rbp - 8], rdi
    mov rax, 0
    mov [rbp - 16], rax
    mov rax, [rbp - 8]
    mov [rbp - 24], rax
.while_1:
    mov rax, [rbp - 24]
    push rax
    mov rax, [r15 + 8]
    mov rax, [rax]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setl al
    cmp rax, 0
    je .sa0_4
    mov rax, [r15 + 8]
    push rax
    mov rax, [rbp - 24]
    pop rbx
    mov rcx, rax
    test rcx, rcx
    jns .rc_pos_6
    mov rdx, [rbx]
    add rcx, rdx
.rc_pos_6:
    mov rax, [rbx]
    test rcx, rcx
    jl .ch_err_idx_6
    cmp rcx, rax
    jge .ch_err_6
    movzx rax, byte [rbx + rcx + 8]
    test al, 0x80
    jz .ch_ok_6
    movzx rsi, al
    and esi, 0xE0
    cmp esi, 0xC0
    jl .ch_invalid_6
    cmp esi, 0xE0
    je .ch_two_6
    cmp esi, 0xF0
    jb .ch_three_6
    movzx rax, byte [rbx + rcx + 8]
    and al, 0x07
    shl eax, 12
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 10]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 11]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_6
.ch_three_6:
    movzx rax, al
    and al, 0x0F
    shl eax, 6
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 10]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_6
.ch_two_6:
    movzx rax, al
    and al, 0x1F
    shl eax, 6
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_6
.ch_invalid_6:
    mov rax, 0xFFFD
    jmp .ch_ok_6
.ch_err_idx_6:
.ch_err_6:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_6:
    push rax
    pop rdi
    mov r10, [vars + 32]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    cmp rax, 0
    setne al
    jmp .sa1_4
.sa0_4:
    mov rax, 0
.sa1_4:
    cmp rax, 0
    je .wend_1
    mov rax, [rbp - 16]
    push rax
    mov rax, 10
    pop rbx
    imul rax, rbx
    push rax
    mov rax, [r15 + 8]
    push rax
    mov rax, [rbp - 24]
    pop rbx
    mov rcx, rax
    test rcx, rcx
    jns .rc_pos_7
    mov rdx, [rbx]
    add rcx, rdx
.rc_pos_7:
    mov rax, [rbx]
    test rcx, rcx
    jl .ch_err_idx_7
    cmp rcx, rax
    jge .ch_err_7
    movzx rax, byte [rbx + rcx + 8]
    test al, 0x80
    jz .ch_ok_7
    movzx rsi, al
    and esi, 0xE0
    cmp esi, 0xC0
    jl .ch_invalid_7
    cmp esi, 0xE0
    je .ch_two_7
    cmp esi, 0xF0
    jb .ch_three_7
    movzx rax, byte [rbx + rcx + 8]
    and al, 0x07
    shl eax, 12
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 10]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 11]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_7
.ch_three_7:
    movzx rax, al
    and al, 0x0F
    shl eax, 6
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 10]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_7
.ch_two_7:
    movzx rax, al
    and al, 0x1F
    shl eax, 6
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_7
.ch_invalid_7:
    mov rax, 0xFFFD
    jmp .ch_ok_7
.ch_err_idx_7:
.ch_err_7:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_7:
    push rax
    mov rax, 48
    pop rbx
    sub rbx, rax
    mov rax, rbx
    pop rbx
    add rax, rbx
    mov [rbp - 16], rax
    mov rax, [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov [rbp - 24], rax
    xor rax, rax
    jmp .while_1
.wend_1:
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov qword [rax + 8], 0
    mov rax, [rbp - 24]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, [rbp - 16]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    leave
    ret
func_3:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rdi, 16
    call arena_alloc
    push rax
    mov rcx, func_4
    mov [rax], rcx
    mov rcx, [rbp - 8]
    mov [rax + 8], rcx
    pop rax
    leave
    ret
func_6:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov [rbp - 8], rdi
    mov rax, [rbp - 8]
    mov [rbp - 16], rax
    mov rax, [rbp - 8]
    mov [rbp - 24], rax
.while_2:
    mov rax, [rbp - 24]
    push rax
    mov rax, [r15 + 8]
    mov rax, [rax]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setl al
    cmp rax, 0
    je .sa0_5
    mov rax, [r15 + 8]
    push rax
    mov rax, [rbp - 24]
    pop rbx
    mov rcx, rax
    test rcx, rcx
    jns .rc_pos_8
    mov rdx, [rbx]
    add rcx, rdx
.rc_pos_8:
    mov rax, [rbx]
    test rcx, rcx
    jl .ch_err_idx_8
    cmp rcx, rax
    jge .ch_err_8
    movzx rax, byte [rbx + rcx + 8]
    test al, 0x80
    jz .ch_ok_8
    movzx rsi, al
    and esi, 0xE0
    cmp esi, 0xC0
    jl .ch_invalid_8
    cmp esi, 0xE0
    je .ch_two_8
    cmp esi, 0xF0
    jb .ch_three_8
    movzx rax, byte [rbx + rcx + 8]
    and al, 0x07
    shl eax, 12
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 10]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 11]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_8
.ch_three_8:
    movzx rax, al
    and al, 0x0F
    shl eax, 6
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 10]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_8
.ch_two_8:
    movzx rax, al
    and al, 0x1F
    shl eax, 6
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_8
.ch_invalid_8:
    mov rax, 0xFFFD
    jmp .ch_ok_8
.ch_err_idx_8:
.ch_err_8:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_8:
    push rax
    pop rdi
    mov r10, [vars + 40]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    cmp rax, 0
    setne al
    jmp .sa1_5
.sa0_5:
    mov rax, 0
.sa1_5:
    cmp rax, 0
    je .wend_2
    mov rax, [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov [rbp - 24], rax
    xor rax, rax
    jmp .while_2
.wend_2:
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov qword [rax + 8], 0
    mov rax, [rbp - 24]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, [rbp - 16]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    leave
    ret
func_5:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rdi, 16
    call arena_alloc
    push rax
    mov rcx, func_6
    mov [rax], rcx
    mov rcx, [rbp - 8]
    mov [rax + 8], rcx
    pop rax
    leave
    ret
func_7:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov [rbp - 8], rdi
    mov rdi, 16
    call arena_alloc
    push rax
    mov qword [rax], 0
    mov qword [rax + 8], 0
    pop rax
    mov [rbp - 16], rax
    mov rax, 0
    mov [rbp - 24], rax
.while_3:
    mov rax, [rbp - 24]
    push rax
    mov rax, [rbp - 8]
    mov rax, [rax]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    setl al
    cmp rax, 0
    je .wend_3
    mov rax, [rbp - 8]
    push rax
    mov rax, [rbp - 24]
    pop rbx
    mov rcx, rax
    test rcx, rcx
    jns .rc_pos_9
    mov rdx, [rbx]
    add rcx, rdx
.rc_pos_9:
    mov rax, [rbx]
    test rcx, rcx
    jl .ch_err_idx_9
    cmp rcx, rax
    jge .ch_err_9
    movzx rax, byte [rbx + rcx + 8]
    test al, 0x80
    jz .ch_ok_9
    movzx rsi, al
    and esi, 0xE0
    cmp esi, 0xC0
    jl .ch_invalid_9
    cmp esi, 0xE0
    je .ch_two_9
    cmp esi, 0xF0
    jb .ch_three_9
    movzx rax, byte [rbx + rcx + 8]
    and al, 0x07
    shl eax, 12
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 10]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 11]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_9
.ch_three_9:
    movzx rax, al
    and al, 0x0F
    shl eax, 6
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    shl esi, 6
    or eax, esi
    movzx rsi, byte [rbx + rcx + 10]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_9
.ch_two_9:
    movzx rax, al
    and al, 0x1F
    shl eax, 6
    movzx rsi, byte [rbx + rcx + 9]
    and esi, 0x3F
    or eax, esi
    jmp .ch_ok_9
.ch_invalid_9:
    mov rax, 0xFFFD
    jmp .ch_ok_9
.ch_err_idx_9:
.ch_err_9:
    mov rax, 60
    mov rdi, 1
    syscall
.ch_ok_9:
    mov [rbp - 32], rax
    mov rax, [rbp - 32]
    push rax
    pop rdi
    mov r10, [vars + 48]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    mov [match_val], rax
    mov rax, [match_val]
    cmp rax, 1
    je .m10_0
    jmp .m10_1
    mov rax, [match_val]
    call print_int
    mov rax, 60
    mov rdi, 0
    syscall
.m10_0:
    mov rax, [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov [rbp - 24], rax
    mov rdi, 16
    call arena_alloc
    mov r11, rax
    mov qword [r11], 0
    mov qword [r11 + 8], 3
    mov rax, r11
    jmp .mend10
.m10_1:
    mov rax, [rbp - 32]
    push rax
    pop rdi
    mov r10, [vars + 32]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    mov [match_val], rax
    mov rax, [match_val]
    cmp rax, 1
    je .m11_0
    jmp .m11_1
    mov rax, [match_val]
    call print_int
    mov rax, 60
    mov rdi, 0
    syscall
.m11_0:
    mov rax, [rbp - 24]
    push rax
    mov rax, [rbp - 8]
    push rax
    pop rdi
    mov r10, [vars + 72]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    pop rdi
    push rbx
    mov rbx, rax
    mov r15, rbx
    mov r10, [rbx]
    call r10
    pop rbx
    mov [vars + 96], rax
    mov rax, [vars + 96]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_12
    mov rax, [rax + 16]
    jmp .hdne_12
.hemp_12:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_12:
    mov [rbp - 24], rax
    mov rax, [rbp - 16]
    push rax
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov qword [rax + 8], 0
    mov rax, [vars + 0]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, [vars + 96]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_9
    push rax
    dec rcx
    mov rdi, rcx
    shl rdi, 3
    add rdi, 16
    call arena_alloc
    mov r12, rax
    mov [rax], rcx
    mov qword [rax + 8], 0
    pop rsi
    add rsi, 24
    lea rdi, [r12 + 16]
.tcopy_9:
    test rcx, rcx
    jz .tcd_9
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_9
.tcd_9:
    mov rax, r12
    jmp .taine_9
.taihemp_9:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_9:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_13
    mov rax, [rax + 16]
    jmp .hdne_13
.hemp_13:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_13:
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov r11, rax
    pop r10
    push r10
    push r11
    mov rax, [r10]
    add rax, 1
    mov rdi, rax
    shl rdi, 3
    add rdi, 16
    call arena_alloc
    mov r12, rax
    mov rax, [r10]
    add rax, 1
    mov [r12], rax
    mov qword [r12 + 8], 0
    mov rax, [r10]
    lea rsi, [r10 + 16]
    lea rdi, [r12 + 16]
.lcpy_8:
    test rax, rax
    jz .lcd_8
    mov rcx, [rsi]
    mov [rdi], rcx
    add rsi, 8
    add rdi, 8
    dec rax
    jmp .lcpy_8
.lcd_8:
    mov [rdi], r11
    pop r11
    pop r10
    mov rax, r12
    mov [rbp - 16], rax
    xor rax, rax
    jmp .mend11
.m11_1:
    mov rax, [rbp - 32]
    push rax
    pop rdi
    mov r10, [vars + 40]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    mov [match_val], rax
    mov rax, [match_val]
    cmp rax, 1
    je .m14_0
    jmp .m14_1
    mov rax, [match_val]
    call print_int
    mov rax, 60
    mov rdi, 0
    syscall
.m14_0:
    mov rax, [rbp - 24]
    push rax
    mov rax, [rbp - 8]
    push rax
    pop rdi
    mov r10, [vars + 80]
    push r15
    mov r15, r10
    mov r10, [r10]
    call r10
    pop r15
    pop rdi
    push rbx
    mov rbx, rax
    mov r15, rbx
    mov r10, [rbx]
    call r10
    pop rbx
    mov [vars + 96], rax
    mov rax, [vars + 96]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_15
    mov rax, [rax + 16]
    jmp .hdne_15
.hemp_15:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_15:
    mov [rbp - 24], rax
    mov rax, [rbp - 16]
    push rax
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov qword [rax + 8], 0
    mov rax, [vars + 16]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, [vars + 96]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_11
    push rax
    dec rcx
    mov rdi, rcx
    shl rdi, 3
    add rdi, 16
    call arena_alloc
    mov r12, rax
    mov [rax], rcx
    mov qword [rax + 8], 0
    pop rsi
    add rsi, 24
    lea rdi, [r12 + 16]
.tcopy_11:
    test rcx, rcx
    jz .tcd_11
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_11
.tcd_11:
    mov rax, r12
    jmp .taine_11
.taihemp_11:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_11:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_16
    mov rax, [rax + 16]
    jmp .hdne_16
.hemp_16:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_16:
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov r11, rax
    pop r10
    push r10
    push r11
    mov rax, [r10]
    add rax, 1
    mov rdi, rax
    shl rdi, 3
    add rdi, 16
    call arena_alloc
    mov r12, rax
    mov rax, [r10]
    add rax, 1
    mov [r12], rax
    mov qword [r12 + 8], 0
    mov rax, [r10]
    lea rsi, [r10 + 16]
    lea rdi, [r12 + 16]
.lcpy_10:
    test rax, rax
    jz .lcd_10
    mov rcx, [rsi]
    mov [rdi], rcx
    add rsi, 8
    add rdi, 8
    dec rax
    jmp .lcpy_10
.lcd_10:
    mov [rdi], r11
    pop r11
    pop r10
    mov rax, r12
    mov [rbp - 16], rax
    xor rax, rax
    jmp .mend14
.m14_1:
    mov rax, [rbp - 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    mov [rbp - 24], rax
    mov rax, [rbp - 16]
    push rax
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 2
    mov qword [rax + 8], 0
    mov rax, [vars + 24]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, [rbp - 32]
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov r11, rax
    pop r10
    push r10
    push r11
    mov rax, [r10]
    add rax, 1
    mov rdi, rax
    shl rdi, 3
    add rdi, 16
    call arena_alloc
    mov r12, rax
    mov rax, [r10]
    add rax, 1
    mov [r12], rax
    mov qword [r12 + 8], 0
    mov rax, [r10]
    lea rsi, [r10 + 16]
    lea rdi, [r12 + 16]
.lcpy_12:
    test rax, rax
    jz .lcd_12
    mov rcx, [rsi]
    mov [rdi], rcx
    add rsi, 8
    add rdi, 8
    dec rax
    jmp .lcpy_12
.lcd_12:
    mov [rdi], r11
    pop r11
    pop r10
    mov rax, r12
    mov [rbp - 16], rax
    xor rax, rax
    jmp .mend14
.mend14:
    xor rax, rax
    jmp .mend11
.mend11:
    xor rax, rax
    jmp .mend10
.mend10:
    xor rax, rax
    jmp .while_3
.wend_3:
    mov rax, [rbp - 16]
    leave
    ret

; ═══════════════════════════════════════════════════════════
; Event Loop Runtime — المرحلة 47
; ═══════════════════════════════════════════════════════════

; إنشاء epoll instance
create_event_loop:
    push rbx
    push r12
    xor rdi, rdi                ; flags = 0
    mov rax, 291
    syscall
    test rax, rax
    js .epoll_fail
    mov r12, rax                ; حفظ epfd

; تخصيص Future registry (8 futures كحد أقصى)
    mov rdi, 512                ; 8 * 64 bytes
    call arena_alloc
    mov [future_registry], rax

; تخصيص epoll_events buffer
    mov rdi, 256                ; 16 events * 16 bytes
    call arena_alloc
    mov [epoll_events_buf], rax

    mov rax, r12
    pop r12
    pop rbx
    ret

.epoll_fail:
    mov rax, 60
    mov rdi, 9
    syscall

; إنشاء Future جديد — يُرجع مؤشر Future
; Future layout: [state:8][value:8][eventfd:8][callback:8][padding:32]
create_future:
    push rbx
    push r12
    mov rdi, 64
    call arena_alloc
    mov r12, rax                ; future ptr

; إنشاء eventfd للـ future
    xor rdi, rdi                ; initval = 0
    xor rsi, rsi                ; flags = 0
    mov rax, 290
    syscall
    test rax, rax
    js .future_fd_fail

; تهيئة Future
    mov qword [r12 + 0], 0   ; state
    mov qword [r12 + 8], 0              ; value
    mov [r12 + 16], rax               ; eventfd
    mov qword [r12 + 24], 0           ; callback

    mov rax, r12
    pop r12
    pop rbx
    ret

.future_fd_fail:
    mov rax, 60
    mov rdi, 10
    syscall

; حل Future بقيمة — resolve_future(future, value)
resolve_future:
    push rbx
    mov rbx, rdi                ; future ptr
    mov qword [rbx + 0], 1
    mov [rbx + 8], rsi            ; value

; كتابة إلى eventfd لإيقاظ الـ event loop
    lea rsi, [rel future_wake_buf]
    mov qword [rsi], 1
    mov rdi, [rbx + 16]           ; eventfd
    mov rdx, 8
    mov rax, 1
    syscall
    pop rbx
    ret

; انتظار Future — await_future(future) → value
await_future:
    push rbx
    push r12
    mov rbx, rdi                ; future ptr

.await_loop:
    cmp qword [rbx + 0], 0
    jne .await_done

; قراءة من eventfd (blocking)
    mov rdi, [rbx + 16]           ; eventfd
    lea rsi, [rel future_wake_buf]
    mov rdx, 8
    mov rax, 0
    syscall
    jmp .await_loop

.await_done:
    cmp qword [rbx + 0], 2
    je .await_failed
    mov rax, [rbx + 8]            ; value
    pop r12
    pop rbx
    ret

.await_failed:
    mov rax, 60
    mov rdi, 11
    syscall

; تشغيل Event Loop — run_event_loop(epfd, timeout_ms)
run_event_loop:
    push rbx
    push r12
    push r13
    mov r12, rdi                ; epfd
    mov r13d, esi               ; timeout_ms

.loop:
    mov rdi, r12
    mov rsi, [epoll_events_buf]
    mov rdx, 16                 ; max events
    mov r10d, r13d
    mov rax, 232
    syscall
    test rax, rax
    jle .loop_end

; معالجة الأحداث
    mov rcx, rax
    mov rbx, [epoll_events_buf]
.process_events:
    ; TODO: dispatch to callbacks
    add rbx, 16
    dec rcx
    jnz .process_events
    jmp .loop

.loop_end:
    pop r13
    pop r12
    pop rbx
    ret