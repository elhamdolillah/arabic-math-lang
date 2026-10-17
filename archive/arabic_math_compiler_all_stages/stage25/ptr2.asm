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
    push rax
    mov rax, 100
    mov r11, rax
    pop r10
    push r10
    push r11
    mov rax, [r10]
    add rax, 1
    mov rdi, rax
    shl rdi, 3
    add rdi, 8
    call arena_alloc
    mov r12, rax
    mov rax, [r10]
    add rax, 1
    mov [r12], rax
    mov rax, [r10]
    lea rsi, [r10 + 8]
    lea rdi, [r12 + 8]
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
    mov [vars + 0], rax
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
    mov [vars + 8], rax
    mov rdi, 44
    call arena_alloc
    mov qword [rax], 36
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 130
    mov byte [rax + 14], 217
    mov byte [rax + 15], 138
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 32
    mov byte [rax + 21], 216
    mov byte [rax + 22], 168
    mov byte [rax + 23], 216
    mov byte [rax + 24], 185
    mov byte [rax + 25], 216
    mov byte [rax + 26], 175
    mov byte [rax + 27], 32
    mov byte [rax + 28], 216
    mov byte [rax + 29], 167
    mov byte [rax + 30], 217
    mov byte [rax + 31], 132
    mov byte [rax + 32], 217
    mov byte [rax + 33], 131
    mov byte [rax + 34], 216
    mov byte [rax + 35], 170
    mov byte [rax + 36], 216
    mov byte [rax + 37], 167
    mov byte [rax + 38], 216
    mov byte [rax + 39], 168
    mov byte [rax + 40], 216
    mov byte [rax + 41], 169
    mov byte [rax + 42], 58
    mov byte [rax + 43], 32
    push rax
    mov rax, [vars + 8]
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

    mov rax, 60
    xor rdi, rdi
    syscall
