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

    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 3
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 185
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 185
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 181
    mov byte [rax + 14], 216
    mov byte [rax + 15], 168
    mov byte [rax + 16], 216
    mov byte [rax + 17], 177
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 32
    call arena_alloc
    push rax
    mov qword [rax], 3
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 217
    mov byte [rax + 9], 134
    mov byte [rax + 10], 217
    mov byte [rax + 11], 136
    mov byte [rax + 12], 216
    mov byte [rax + 13], 177
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 216
    mov byte [rax + 11], 168
    mov byte [rax + 12], 216
    mov byte [rax + 13], 167
    mov byte [rax + 14], 216
    mov byte [rax + 15], 175
    mov byte [rax + 16], 216
    mov byte [rax + 17], 169
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 217
    mov byte [rax + 9], 133
    mov byte [rax + 10], 217
    mov byte [rax + 11], 129
    mov byte [rax + 12], 216
    mov byte [rax + 13], 170
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 216
    mov byte [rax + 17], 173
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 8], rax
    mov rax, [vars + 0]
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
    mov [vars + 16], rax
    mov rax, [vars + 8]
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
    mov [vars + 24], rax
    mov rax, [vars + 16]
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 32
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
    push rax
    mov rax, [vars + 24]
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
.cpy1_20:
    test rax, rax
    jz .c1d_20
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_20
.c1d_20:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_20:
    test rax, rax
    jz .c2d_20
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_20
.c2d_20:
    pop r11
    pop r10
    mov rax, r12
    mov [vars + 32], rax
    mov rax, [vars + 32]
    call print_str
    mov rax, [vars + 0]
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
    jz .hemp_6
    mov rax, [rax + 8]
    jmp .hdne_6
.hemp_6:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_6:
    mov [vars + 16], rax
    mov rax, [vars + 8]
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
    mov [vars + 24], rax
    mov rax, [vars + 16]
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 32
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
.cpy1_23:
    test rax, rax
    jz .c1d_23
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_23
.c1d_23:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_23:
    test rax, rax
    jz .c2d_23
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_23
.c2d_23:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 24]
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
.cpy1_24:
    test rax, rax
    jz .c1d_24
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_24
.c1d_24:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_24:
    test rax, rax
    jz .c2d_24
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_24
.c2d_24:
    pop r11
    pop r10
    mov rax, r12
    mov [vars + 32], rax
    mov rax, [vars + 32]
    call print_str
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_26
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
.tcopy_26:
    test rcx, rcx
    jz .tcd_26
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_26
.tcd_26:
    mov rax, r12
    jmp .taine_26
.taihemp_26:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_26:
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
    mov [vars + 16], rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_28
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
.tcopy_28:
    test rcx, rcx
    jz .tcd_28
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_28
.tcd_28:
    mov rax, r12
    jmp .taine_28
.taihemp_28:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_28:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_27
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
.tcopy_27:
    test rcx, rcx
    jz .tcd_27
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_27
.tcd_27:
    mov rax, r12
    jmp .taine_27
.taihemp_27:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_27:
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
    mov [vars + 24], rax
    mov rax, [vars + 16]
    push rax
    mov rdi, 9
    call arena_alloc
    mov qword [rax], 1
    mov byte [rax + 8], 32
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
    push rax
    mov rax, [vars + 24]
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
.cpy1_30:
    test rax, rax
    jz .c1d_30
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_30
.c1d_30:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_30:
    test rax, rax
    jz .c2d_30
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_30
.c2d_30:
    pop r11
    pop r10
    mov rax, r12
    mov [vars + 32], rax
    mov rax, [vars + 32]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
