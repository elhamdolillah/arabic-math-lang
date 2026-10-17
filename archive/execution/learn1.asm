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

    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 3
    mov rax, 2
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 4
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 3
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 3
    mov rax, 3
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 1
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 3
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 8], rax
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 3
    mov rax, 5
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 5
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 6
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 16], rax
    mov rax, 0
    mov [vars + 24], rax
    mov rax, [vars + 0]
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
    mov [vars + 32], rax
    mov rax, [vars + 8]
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
    mov [vars + 40], rax
    mov rax, [vars + 16]
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
    mov [vars + 48], rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 40]
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 48]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 56], rax
    mov rax, [vars + 56]
    cmp rax, 0
    je .else_1
    mov rax, [vars + 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_1
.else_1:
    mov rax, [vars + 24]
.end_1:
    mov [vars + 24], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_1
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
.tcopy_1:
    test rcx, rcx
    jz .tcd_1
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_1
.tcd_1:
    mov rax, r12
    jmp .taine_1
.taihemp_1:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_1:
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
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_2
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
.tcopy_2:
    test rcx, rcx
    jz .tcd_2
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_2
.tcd_2:
    mov rax, r12
    jmp .taine_2
.taihemp_2:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_2:
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
    mov [vars + 40], rax
    mov rax, [vars + 16]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_3
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
.tcopy_3:
    test rcx, rcx
    jz .tcd_3
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_3
.tcd_3:
    mov rax, r12
    jmp .taine_3
.taihemp_3:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_3:
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
    mov [vars + 48], rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 40]
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 48]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 56], rax
    mov rax, [vars + 56]
    cmp rax, 0
    je .else_2
    mov rax, [vars + 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_2
.else_2:
    mov rax, [vars + 24]
.end_2:
    mov [vars + 24], rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_5
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
.tcopy_5:
    test rcx, rcx
    jz .tcd_5
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_5
.tcd_5:
    mov rax, r12
    jmp .taine_5
.taihemp_5:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_5:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_4
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
.tcopy_4:
    test rcx, rcx
    jz .tcd_4
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_4
.tcd_4:
    mov rax, r12
    jmp .taine_4
.taihemp_4:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_4:
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
    mov [vars + 32], rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_7
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
.tcopy_7:
    test rcx, rcx
    jz .tcd_7
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_7
.tcd_7:
    mov rax, r12
    jmp .taine_7
.taihemp_7:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_7:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_6
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
.tcopy_6:
    test rcx, rcx
    jz .tcd_6
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_6
.tcd_6:
    mov rax, r12
    jmp .taine_6
.taihemp_6:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_6:
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
    mov rax, [vars + 16]
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
    jz .hemp_9
    mov rax, [rax + 8]
    jmp .hdne_9
.hemp_9:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_9:
    mov [vars + 48], rax
    mov rax, [vars + 32]
    push rax
    mov rax, [vars + 40]
    pop rbx
    add rax, rbx
    push rax
    mov rax, [vars + 48]
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    mov [vars + 56], rax
    mov rax, [vars + 56]
    cmp rax, 0
    je .else_3
    mov rax, [vars + 24]
    push rax
    mov rax, 1
    pop rbx
    add rax, rbx
    jmp .end_3
.else_3:
    mov rax, [vars + 24]
.end_3:
    mov [vars + 24], rax
    mov rdi, 39
    call arena_alloc
    mov qword [rax], 31
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 163
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 216
    mov byte [rax + 17], 171
    mov byte [rax + 18], 217
    mov byte [rax + 19], 132
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 216
    mov byte [rax + 28], 181
    mov byte [rax + 29], 216
    mov byte [rax + 30], 173
    mov byte [rax + 31], 217
    mov byte [rax + 32], 138
    mov byte [rax + 33], 216
    mov byte [rax + 34], 173
    mov byte [rax + 35], 216
    mov byte [rax + 36], 169
    mov byte [rax + 37], 58
    mov byte [rax + 38], 32
    push rax
    mov rax, [vars + 24]
    test rax, rax
    jns .npos_10
    neg rax
    mov byte [negflag], 1
.npos_10:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_10:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_10
    cmp byte [negflag], 1
    jne .nskip2_10
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_10:
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
.ntc_10:
    test rcx, rcx
    jz .ntd_10
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_10
.ntd_10:
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
.cpy1_11:
    test rax, rax
    jz .c1d_11
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_11
.c1d_11:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_11:
    test rax, rax
    jz .c2d_11
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_11
.c2d_11:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 15
    call arena_alloc
    mov qword [rax], 7
    mov byte [rax + 8], 32
    mov byte [rax + 9], 217
    mov byte [rax + 10], 133
    mov byte [rax + 11], 217
    mov byte [rax + 12], 134
    mov byte [rax + 13], 32
    mov byte [rax + 14], 51
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
.cpy1_12:
    test rax, rax
    jz .c1d_12
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_12
.c1d_12:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_12:
    test rax, rax
    jz .c2d_12
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_12
.c2d_12:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 68
    call arena_alloc
    mov qword [rax], 60
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 130
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 216
    mov byte [rax + 17], 185
    mov byte [rax + 18], 216
    mov byte [rax + 19], 175
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
    mov byte [rax + 22], 32
    mov byte [rax + 23], 216
    mov byte [rax + 24], 167
    mov byte [rax + 25], 217
    mov byte [rax + 26], 132
    mov byte [rax + 27], 217
    mov byte [rax + 28], 133
    mov byte [rax + 29], 216
    mov byte [rax + 30], 179
    mov byte [rax + 31], 216
    mov byte [rax + 32], 170
    mov byte [rax + 33], 217
    mov byte [rax + 34], 134
    mov byte [rax + 35], 216
    mov byte [rax + 36], 170
    mov byte [rax + 37], 216
    mov byte [rax + 38], 172
    mov byte [rax + 39], 216
    mov byte [rax + 40], 169
    mov byte [rax + 41], 58
    mov byte [rax + 42], 32
    mov byte [rax + 43], 216
    mov byte [rax + 44], 172
    mov byte [rax + 45], 217
    mov byte [rax + 46], 133
    mov byte [rax + 47], 216
    mov byte [rax + 48], 185
    mov byte [rax + 49], 40
    mov byte [rax + 50], 216
    mov byte [rax + 51], 163
    mov byte [rax + 52], 216
    mov byte [rax + 53], 140
    mov byte [rax + 54], 32
    mov byte [rax + 55], 216
    mov byte [rax + 56], 168
    mov byte [rax + 57], 41
    mov byte [rax + 58], 32
    mov byte [rax + 59], 61
    mov byte [rax + 60], 32
    mov byte [rax + 61], 216
    mov byte [rax + 62], 163
    mov byte [rax + 63], 32
    mov byte [rax + 64], 43
    mov byte [rax + 65], 32
    mov byte [rax + 66], 216
    mov byte [rax + 67], 168
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
