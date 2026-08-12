global _start
section .bss
    vars resq 256
    num_buf resb 32
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
    mov rax, 42
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 10
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 25
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 0], rax
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
    mov [vars + 8], rax
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
    jz .hemp_2
    mov rax, [rax + 8]
    jmp .hdne_2
.hemp_2:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_2:
    mov [vars + 16], rax
    mov rax, [vars + 0]
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
    jz .hemp_3
    mov rax, [rax + 8]
    jmp .hdne_3
.hemp_3:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_3:
    mov [vars + 24], rax
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 217
    mov byte [rax + 17], 130
    mov byte [rax + 18], 216
    mov byte [rax + 19], 185
    mov byte [rax + 20], 32
    mov byte [rax + 21], 48
    mov byte [rax + 22], 58
    mov byte [rax + 23], 32
    push rax
    mov rax, [vars + 8]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_4:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_4
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
.ntc_4:
    test rcx, rcx
    jz .ntd_4
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_4
.ntd_4:
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
.cpy1_5:
    test rax, rax
    jz .c1d_5
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_5
.c1d_5:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_5:
    test rax, rax
    jz .c2d_5
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_5
.c2d_5:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 217
    mov byte [rax + 17], 130
    mov byte [rax + 18], 216
    mov byte [rax + 19], 185
    mov byte [rax + 20], 32
    mov byte [rax + 21], 49
    mov byte [rax + 22], 58
    mov byte [rax + 23], 32
    push rax
    mov rax, [vars + 16]
    mov rbx, 10
    mov rcx, 0
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
.cpy1_7:
    test rax, rax
    jz .c1d_7
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_7
.c1d_7:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_7:
    test rax, rax
    jz .c2d_7
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_7
.c2d_7:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 24
    call arena_alloc
    mov qword [rax], 16
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 217
    mov byte [rax + 15], 136
    mov byte [rax + 16], 217
    mov byte [rax + 17], 130
    mov byte [rax + 18], 216
    mov byte [rax + 19], 185
    mov byte [rax + 20], 32
    mov byte [rax + 21], 50
    mov byte [rax + 22], 58
    mov byte [rax + 23], 32
    push rax
    mov rax, [vars + 24]
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_8:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_8
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
.ntc_8:
    test rcx, rcx
    jz .ntd_8
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_8
.ntd_8:
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
.cpy1_9:
    test rax, rax
    jz .c1d_9
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_9
.c1d_9:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_9:
    test rax, rax
    jz .c2d_9
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_9
.c2d_9:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
