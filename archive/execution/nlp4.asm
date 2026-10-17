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
    mov rdi, 20
    call arena_alloc
    mov qword [rax], 12
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 183
    mov byte [rax + 14], 216
    mov byte [rax + 15], 167
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov byte [rax + 18], 216
    mov byte [rax + 19], 168
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 16
    call arena_alloc
    mov qword [rax], 8
    mov byte [rax + 8], 217
    mov byte [rax + 9], 138
    mov byte [rax + 10], 217
    mov byte [rax + 11], 131
    mov byte [rax + 12], 216
    mov byte [rax + 13], 170
    mov byte [rax + 14], 216
    mov byte [rax + 15], 168
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 133
    mov byte [rax + 14], 216
    mov byte [rax + 15], 175
    mov byte [rax + 16], 216
    mov byte [rax + 17], 177
    mov byte [rax + 18], 216
    mov byte [rax + 19], 179
    mov byte [rax + 20], 216
    mov byte [rax + 21], 169
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
    mov byte [rax + 8], 216
    mov byte [rax + 9], 183
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 168
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 217
    mov byte [rax + 9], 131
    mov byte [rax + 10], 216
    mov byte [rax + 11], 170
    mov byte [rax + 12], 216
    mov byte [rax + 13], 168
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rdi, 14
    call arena_alloc
    mov qword [rax], 6
    mov byte [rax + 8], 216
    mov byte [rax + 9], 175
    mov byte [rax + 10], 216
    mov byte [rax + 11], 177
    mov byte [rax + 12], 216
    mov byte [rax + 13], 179
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    pop rax
    mov [vars + 8], rax
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 131
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    push rax
    mov rax, [vars + 0]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_11
    mov rax, [rax + 8]
    jmp .hdne_11
.hemp_11:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_11:
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
.cpy1_32:
    test rax, rax
    jz .c1d_32
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_32
.c1d_32:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_32:
    test rax, rax
    jz .c2d_32
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_32
.c2d_32:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 25
    call arena_alloc
    mov qword [rax], 17
    mov byte [rax + 8], 32
    mov byte [rax + 9], 226
    mov byte [rax + 10], 134
    mov byte [rax + 11], 144
    mov byte [rax + 12], 32
    mov byte [rax + 13], 216
    mov byte [rax + 14], 167
    mov byte [rax + 15], 217
    mov byte [rax + 16], 132
    mov byte [rax + 17], 216
    mov byte [rax + 18], 172
    mov byte [rax + 19], 216
    mov byte [rax + 20], 176
    mov byte [rax + 21], 216
    mov byte [rax + 22], 177
    mov byte [rax + 23], 58
    mov byte [rax + 24], 32
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
.cpy1_33:
    test rax, rax
    jz .c1d_33
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_33
.c1d_33:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_33:
    test rax, rax
    jz .c2d_33
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_33
.c2d_33:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 8]
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_12
    mov rax, [rax + 8]
    jmp .hdne_12
.hemp_12:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_12:
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
.cpy1_34:
    test rax, rax
    jz .c1d_34
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_34
.c1d_34:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_34:
    test rax, rax
    jz .c2d_34
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_34
.c2d_34:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 131
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    push rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_35
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
.tcopy_35:
    test rcx, rcx
    jz .tcd_35
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_35
.tcd_35:
    mov rax, r12
    jmp .taine_35
.taihemp_35:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_35:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_13
    mov rax, [rax + 8]
    jmp .hdne_13
.hemp_13:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_13:
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
.cpy1_36:
    test rax, rax
    jz .c1d_36
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_36
.c1d_36:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_36:
    test rax, rax
    jz .c2d_36
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_36
.c2d_36:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 25
    call arena_alloc
    mov qword [rax], 17
    mov byte [rax + 8], 32
    mov byte [rax + 9], 226
    mov byte [rax + 10], 134
    mov byte [rax + 11], 144
    mov byte [rax + 12], 32
    mov byte [rax + 13], 216
    mov byte [rax + 14], 167
    mov byte [rax + 15], 217
    mov byte [rax + 16], 132
    mov byte [rax + 17], 216
    mov byte [rax + 18], 172
    mov byte [rax + 19], 216
    mov byte [rax + 20], 176
    mov byte [rax + 21], 216
    mov byte [rax + 22], 177
    mov byte [rax + 23], 58
    mov byte [rax + 24], 32
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
.cpy1_37:
    test rax, rax
    jz .c1d_37
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_37
.c1d_37:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_37:
    test rax, rax
    jz .c2d_37
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_37
.c2d_37:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_38
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
.tcopy_38:
    test rcx, rcx
    jz .tcd_38
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_38
.tcd_38:
    mov rax, r12
    jmp .taine_38
.taihemp_38:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_38:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_14
    mov rax, [rax + 8]
    jmp .hdne_14
.hemp_14:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_14:
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
.cpy1_39:
    test rax, rax
    jz .c1d_39
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_39
.c1d_39:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_39:
    test rax, rax
    jz .c2d_39
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_39
.c2d_39:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 22
    call arena_alloc
    mov qword [rax], 14
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 217
    mov byte [rax + 13], 131
    mov byte [rax + 14], 217
    mov byte [rax + 15], 132
    mov byte [rax + 16], 217
    mov byte [rax + 17], 133
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    push rax
    mov rax, [vars + 0]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_41
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
.tcopy_41:
    test rcx, rcx
    jz .tcd_41
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_41
.tcd_41:
    mov rax, r12
    jmp .taine_41
.taihemp_41:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_41:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_40
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
.tcopy_40:
    test rcx, rcx
    jz .tcd_40
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_40
.tcd_40:
    mov rax, r12
    jmp .taine_40
.taihemp_40:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_40:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_15
    mov rax, [rax + 8]
    jmp .hdne_15
.hemp_15:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_15:
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
.cpy1_42:
    test rax, rax
    jz .c1d_42
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_42
.c1d_42:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_42:
    test rax, rax
    jz .c2d_42
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_42
.c2d_42:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rdi, 25
    call arena_alloc
    mov qword [rax], 17
    mov byte [rax + 8], 32
    mov byte [rax + 9], 226
    mov byte [rax + 10], 134
    mov byte [rax + 11], 144
    mov byte [rax + 12], 32
    mov byte [rax + 13], 216
    mov byte [rax + 14], 167
    mov byte [rax + 15], 217
    mov byte [rax + 16], 132
    mov byte [rax + 17], 216
    mov byte [rax + 18], 172
    mov byte [rax + 19], 216
    mov byte [rax + 20], 176
    mov byte [rax + 21], 216
    mov byte [rax + 22], 177
    mov byte [rax + 23], 58
    mov byte [rax + 24], 32
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
.cpy1_43:
    test rax, rax
    jz .c1d_43
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_43
.c1d_43:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_43:
    test rax, rax
    jz .c2d_43
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_43
.c2d_43:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_45
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
.tcopy_45:
    test rcx, rcx
    jz .tcd_45
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_45
.tcd_45:
    mov rax, r12
    jmp .taine_45
.taihemp_45:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_45:
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_44
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
.tcopy_44:
    test rcx, rcx
    jz .tcd_44
    mov rdx, [rsi]
    mov [rdi], rdx
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .tcopy_44
.tcd_44:
    mov rax, r12
    jmp .taine_44
.taihemp_44:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_44:
    mov rbx, [rax]
    test rbx, rbx
    jz .hemp_16
    mov rax, [rax + 8]
    jmp .hdne_16
.hemp_16:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_16:
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
.cpy1_46:
    test rax, rax
    jz .c1d_46
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_46
.c1d_46:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_46:
    test rax, rax
    jz .c2d_46
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_46
.c2d_46:
    pop r11
    pop r10
    mov rax, r12
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
