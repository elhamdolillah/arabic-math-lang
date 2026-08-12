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

    mov rdi, 40
    call arena_alloc
    push rax
    mov qword [rax], 4
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 217
    mov byte [rax + 13], 129
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 217
    mov byte [rax + 13], 129
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 216
    mov byte [rax + 13], 177
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 177
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 168
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 32], rcx
    pop rax
    mov [vars + 0], rax
    mov rax, 0
    mov [vars + 8], rax
    mov rax, 0
    mov [vars + 16], rax
    mov rax, 0
    mov [vars + 24], rax
    mov rax, 0
    mov [vars + 32], rax
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_7
    mov rax, [rax + 8]
    jmp .hdne_7
.hemp_7:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_7:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 217
    mov byte [rax + 13], 129
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_9
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_9
    mov rax, 0
    jmp .seq_end_9
.seq_eq_9:
    mov rax, 1
.seq_end_9:
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_9
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_9
.else_9:
    mov rax, [vars + 8]
.end_9:
    mov [vars + 8], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_20
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
.tcopy_20:
    test rcx, rcx
    jz .tcd_20
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_20
.tcd_20:
    mov rax, r12
    jmp .taine_20
.taihemp_20:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_20:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_8
    mov rax, [rax + 8]
    jmp .hdne_8
.hemp_8:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_8:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 217
    mov byte [rax + 13], 129
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_10
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_10
    mov rax, 0
    jmp .seq_end_10
.seq_eq_10:
    mov rax, 1
.seq_end_10:
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_10
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_10
.else_10:
    mov rax, [vars + 8]
.end_10:
    mov [vars + 8], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_22
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
.tcopy_22:
    test rcx, rcx
    jz .tcd_22
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_22
.tcd_22:
    mov rax, r12
    jmp .taine_22
.taihemp_22:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_22:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_21
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
.tcopy_21:
    test rcx, rcx
    jz .tcd_21
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_21
.tcd_21:
    mov rax, r12
    jmp .taine_21
.taihemp_21:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_21:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_9
    mov rax, [rax + 8]
    jmp .hdne_9
.hemp_9:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_9:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 216
    mov byte [rax + 13], 177
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 177
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_11
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_11
    mov rax, 0
    jmp .seq_end_11
.seq_eq_11:
    mov rax, 1
.seq_end_11:
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_11
    mov rax, [vars + 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_11
.else_11:
    mov rax, [vars + 24]
.end_11:
    mov [vars + 24], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_25
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
.tcopy_25:
    test rcx, rcx
    jz .tcd_25
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_25
.tcd_25:
    mov rax, r12
    jmp .taine_25
.taihemp_25:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_25:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_24
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
.tcopy_24:
    test rcx, rcx
    jz .tcd_24
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_24
.tcd_24:
    mov rax, r12
    jmp .taine_24
.taihemp_24:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_24:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_23
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
.tcopy_23:
    test rcx, rcx
    jz .tcd_23
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_23
.tcd_23:
    mov rax, r12
    jmp .taine_23
.taihemp_23:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_23:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_10
    mov rax, [rax + 8]
    jmp .hdne_10
.hemp_10:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_10:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    push rax
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 168
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_12
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_12
    mov rax, 0
    jmp .seq_end_12
.seq_eq_12:
    mov rax, 1
.seq_end_12:
    mov [vars + 48], rax
    mov rax, [vars + 48]
    cmp rax, 0
    je .else_12
    mov rax, [vars + 32]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_12
.else_12:
    mov rax, [vars + 32]
.end_12:
    mov [vars + 32], rax
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 217
    mov byte [rax + 13], 129
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 58
    mov byte [rax + 19], 32
    push rax
    mov rax, [vars + 8]
    test rax, rax
    jns .npos_26
    neg rax
    mov byte [negflag], 1
.npos_26:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_26:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_26
    cmp byte [negflag], 1
    jne .nskip2_26
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_26:
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
.ntc_26:
    test rcx, rcx
    jz .ntd_26
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_26
.ntd_26:
    mov byte [negflag], 0
    pop rax
    mov r11, rax
    pop r10
    push r10
    push r11
    mov rax, [r10]
    add rax, [r11]
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov r12, rax
    mov rax, [r10]
    add rax, [r11]
    mov [r12], rax
    mov rax, [r10]
    lea rsi, [r10 + 8]
    lea rdi, [r12 + 8]
.cpy1_27:
    test rax, rax
    jz .c1d_27
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_27
.c1d_27:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_27:
    test rax, rax
    jz .c2d_27
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_27
.c2d_27:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 172
    mov byte [rax + 12], 216
    mov byte [rax + 13], 177
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 216
    mov byte [rax + 17], 177
    mov byte [rax + 18], 58
    mov byte [rax + 19], 32
    push rax
    mov rax, [vars + 24]
    test rax, rax
    jns .npos_28
    neg rax
    mov byte [negflag], 1
.npos_28:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_28:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_28
    cmp byte [negflag], 1
    jne .nskip2_28
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_28:
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
.ntc_28:
    test rcx, rcx
    jz .ntd_28
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_28
.ntd_28:
    mov byte [negflag], 0
    pop rax
    mov r11, rax
    pop r10
    push r10
    push r11
    mov rax, [r10]
    add rax, [r11]
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov r12, rax
    mov rax, [r10]
    add rax, [r11]
    mov [r12], rax
    mov rax, [r10]
    lea rsi, [r10 + 8]
    lea rdi, [r12 + 8]
.cpy1_29:
    test rax, rax
    jz .c1d_29
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_29
.c1d_29:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_29:
    test rax, rax
    jz .c2d_29
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_29
.c2d_29:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 216
    mov byte [rax + 11], 168
    mov byte [rax + 12], 217
    mov byte [rax + 13], 134
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 58
    mov byte [rax + 17], 32
    push rax
    mov rax, [vars + 32]
    test rax, rax
    jns .npos_30
    neg rax
    mov byte [negflag], 1
.npos_30:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_30:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_30
    cmp byte [negflag], 1
    jne .nskip2_30
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_30:
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
.ntc_30:
    test rcx, rcx
    jz .ntd_30
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_30
.ntd_30:
    mov byte [negflag], 0
    pop rax
    mov r11, rax
    pop r10
    push r10
    push r11
    mov rax, [r10]
    add rax, [r11]
    add rax, 8
    mov rdi, rax
    call arena_alloc
    mov r12, rax
    mov rax, [r10]
    add rax, [r11]
    mov [r12], rax
    mov rax, [r10]
    lea rsi, [r10 + 8]
    lea rdi, [r12 + 8]
.cpy1_31:
    test rax, rax
    jz .c1d_31
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_31
.c1d_31:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_31:
    test rax, rax
    jz .c2d_31
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_31
.c2d_31:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
