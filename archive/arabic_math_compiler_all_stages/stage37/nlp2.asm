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
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 216
    mov byte [rax + 11], 179
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 217
    mov byte [rax + 9], 129
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 173
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 217
    mov byte [rax + 13], 129
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 216
    mov byte [rax + 11], 179
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
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
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_3
    mov rax, [rax + 8]
    jmp .hdne_3
.hemp_3:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_3:
    mov [vars + 32], rax
    mov rax, [vars + 32]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 216
    mov byte [rax + 11], 179
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_1
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_1
    mov rax, 0
    jmp .seq_end_1
.seq_eq_1:
    mov rax, 1
.seq_end_1:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_1
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_1
.else_1:
    mov rax, [vars + 8]
.end_1:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 217
    mov byte [rax + 9], 129
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_2
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_2
    mov rax, 0
    jmp .seq_end_2
.seq_eq_2:
    mov rax, 1
.seq_end_2:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_2
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_2
.else_2:
    mov rax, [vars + 16]
.end_2:
    mov [vars + 16], rax
    mov rax, [vars + 0]
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
    jz .hemp_4
    mov rax, [rax + 8]
    jmp .hdne_4
.hemp_4:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_4:
    mov [vars + 32], rax
    mov rax, [vars + 32]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 216
    mov byte [rax + 11], 179
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_3
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_3
    mov rax, 0
    jmp .seq_end_3
.seq_eq_3:
    mov rax, 1
.seq_end_3:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_3
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_3
.else_3:
    mov rax, [vars + 8]
.end_3:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 217
    mov byte [rax + 9], 129
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_4
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_4
    mov rax, 0
    jmp .seq_end_4
.seq_eq_4:
    mov rax, 1
.seq_end_4:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_4
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_4
.else_4:
    mov rax, [vars + 16]
.end_4:
    mov [vars + 16], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_10
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
.tcopy_10:
    test rcx, rcx
    jz .tcd_10
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_10
.tcd_10:
    mov rax, r12
    jmp .taine_10
.taihemp_10:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_10:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_9
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
    jz .hemp_5
    mov rax, [rax + 8]
    jmp .hdne_5
.hemp_5:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_5:
    mov [vars + 32], rax
    mov rax, [vars + 32]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 216
    mov byte [rax + 11], 179
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_5
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_5
    mov rax, 0
    jmp .seq_end_5
.seq_eq_5:
    mov rax, 1
.seq_end_5:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_5
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_5
.else_5:
    mov rax, [vars + 8]
.end_5:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 173
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 217
    mov byte [rax + 13], 129
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_6
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_6
    mov rax, 0
    jmp .seq_end_6
.seq_eq_6:
    mov rax, 1
.seq_end_6:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_6
    mov rax, [vars + 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_6
.else_6:
    mov rax, [vars + 24]
.end_6:
    mov [vars + 24], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_13
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
.tcopy_13:
    test rcx, rcx
    jz .tcd_13
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_13
.tcd_13:
    mov rax, r12
    jmp .taine_13
.taihemp_13:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_13:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_12
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
.tcopy_12:
    test rcx, rcx
    jz .tcd_12
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_12
.tcd_12:
    mov rax, r12
    jmp .taine_12
.taihemp_12:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_12:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_11
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
    jz .hemp_6
    mov rax, [rax + 8]
    jmp .hdne_6
.hemp_6:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_6:
    mov [vars + 32], rax
    mov rax, [vars + 32]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 216
    mov byte [rax + 11], 179
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_7
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_7
    mov rax, 0
    jmp .seq_end_7
.seq_eq_7:
    mov rax, 1
.seq_end_7:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_7
    mov rax, [vars + 8]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_7
.else_7:
    mov rax, [vars + 8]
.end_7:
    mov [vars + 8], rax
    mov rax, [vars + 32]
    push rax
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 217
    mov byte [rax + 9], 129
    mov byte [rax + 10], 216
    mov byte [rax + 11], 185
    mov byte [rax + 12], 217
    mov byte [rax + 13], 132
    pop rbx
    mov r10, rbx
    mov r11, rax
    cmp r10, r11
    je .seq_eq_8
    mov rdi, r10
    mov rsi, r11
    call str_eq
    test rax, rax
    jnz .seq_eq_8
    mov rax, 0
    jmp .seq_end_8
.seq_eq_8:
    mov rax, 1
.seq_end_8:
    mov [vars + 40], rax
    mov rax, [vars + 40]
    cmp rax, 0
    je .else_8
    mov rax, [vars + 16]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_8
.else_8:
    mov rax, [vars + 16]
.end_8:
    mov [vars + 16], rax
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 216
    mov byte [rax + 11], 179
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 216
    mov byte [rax + 17], 161
    mov byte [rax + 18], 58
    mov byte [rax + 19], 32
    push rax
    mov rax, [vars + 8]
    test rax, rax
    jns .npos_14
    neg rax
    mov byte [negflag], 1
.npos_14:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_14:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_14
    cmp byte [negflag], 1
    jne .nskip2_14
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_14:
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
.ntc_14:
    test rcx, rcx
    jz .ntd_14
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_14
.ntd_14:
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
.cpy1_15:
    test rax, rax
    jz .c1d_15
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_15
.c1d_15:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_15:
    test rax, rax
    jz .c2d_15
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_15
.c2d_15:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 216
    mov byte [rax + 9], 163
    mov byte [rax + 10], 217
    mov byte [rax + 11], 129
    mov byte [rax + 12], 216
    mov byte [rax + 13], 185
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov byte [rax + 18], 58
    mov byte [rax + 19], 32
    push rax
    mov rax, [vars + 16]
    test rax, rax
    jns .npos_16
    neg rax
    mov byte [negflag], 1
.npos_16:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_16:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_16
    cmp byte [negflag], 1
    jne .nskip2_16
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_16:
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
.ntc_16:
    test rcx, rcx
    jz .ntd_16
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_16
.ntd_16:
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
.cpy1_17:
    test rax, rax
    jz .c1d_17
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_17
.c1d_17:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_17:
    test rax, rax
    jz .c2d_17
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_17
.c2d_17:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 173
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 217
    mov byte [rax + 13], 136
    mov byte [rax + 14], 217
    mov byte [rax + 15], 129
    mov byte [rax + 16], 58
    mov byte [rax + 17], 32
    push rax
    mov rax, [vars + 24]
    test rax, rax
    jns .npos_18
    neg rax
    mov byte [negflag], 1
.npos_18:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_18:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_18
    cmp byte [negflag], 1
    jne .nskip2_18
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_18:
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
.ntc_18:
    test rcx, rcx
    jz .ntd_18
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_18
.ntd_18:
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
.cpy1_19:
    test rax, rax
    jz .c1d_19
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_19
.c1d_19:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_19:
    test rax, rax
    jz .c2d_19
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_19
.c2d_19:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
