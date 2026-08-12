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
    mov rdi, 12
    call arena_alloc
    mov qword [rax], 4
    mov byte [rax + 8], 217
    mov byte [rax + 9], 129
    mov byte [rax + 10], 217
    mov byte [rax + 11], 138
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
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
    mov [rbx + 32], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 63
    call arena_alloc
    mov qword [rax], 55
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 172
    mov byte [rax + 14], 217
    mov byte [rax + 15], 133
    mov byte [rax + 16], 217
    mov byte [rax + 17], 132
    mov byte [rax + 18], 216
    mov byte [rax + 19], 169
    mov byte [rax + 20], 58
    mov byte [rax + 21], 32
    mov byte [rax + 22], 216
    mov byte [rax + 23], 167
    mov byte [rax + 24], 217
    mov byte [rax + 25], 132
    mov byte [rax + 26], 216
    mov byte [rax + 27], 183
    mov byte [rax + 28], 216
    mov byte [rax + 29], 167
    mov byte [rax + 30], 217
    mov byte [rax + 31], 132
    mov byte [rax + 32], 216
    mov byte [rax + 33], 168
    mov byte [rax + 34], 32
    mov byte [rax + 35], 217
    mov byte [rax + 36], 138
    mov byte [rax + 37], 217
    mov byte [rax + 38], 131
    mov byte [rax + 39], 216
    mov byte [rax + 40], 170
    mov byte [rax + 41], 216
    mov byte [rax + 42], 168
    mov byte [rax + 43], 32
    mov byte [rax + 44], 217
    mov byte [rax + 45], 129
    mov byte [rax + 46], 217
    mov byte [rax + 47], 138
    mov byte [rax + 48], 32
    mov byte [rax + 49], 216
    mov byte [rax + 50], 167
    mov byte [rax + 51], 217
    mov byte [rax + 52], 132
    mov byte [rax + 53], 217
    mov byte [rax + 54], 133
    mov byte [rax + 55], 216
    mov byte [rax + 56], 175
    mov byte [rax + 57], 216
    mov byte [rax + 58], 177
    mov byte [rax + 59], 216
    mov byte [rax + 60], 179
    mov byte [rax + 61], 216
    mov byte [rax + 62], 169
    call print_str
    mov rdi, 31
    call arena_alloc
    mov qword [rax], 23
    mov byte [rax + 8], 216
    mov byte [rax + 9], 185
    mov byte [rax + 10], 216
    mov byte [rax + 11], 175
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 32
    mov byte [rax + 15], 216
    mov byte [rax + 16], 167
    mov byte [rax + 17], 217
    mov byte [rax + 18], 132
    mov byte [rax + 19], 217
    mov byte [rax + 20], 131
    mov byte [rax + 21], 217
    mov byte [rax + 22], 132
    mov byte [rax + 23], 217
    mov byte [rax + 24], 133
    mov byte [rax + 25], 216
    mov byte [rax + 26], 167
    mov byte [rax + 27], 216
    mov byte [rax + 28], 170
    mov byte [rax + 29], 58
    mov byte [rax + 30], 32
    push rax
    mov rax, [vars + 0]
    mov rax, [rax]
    test rax, rax
    jns .npos_1
    neg rax
    mov byte [negflag], 1
.npos_1:
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.nts_1:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .nts_1
    cmp byte [negflag], 1
    jne .nskip2_1
    dec rdi
    mov byte [rdi], 45
    inc rcx
.nskip2_1:
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
.ntc_1:
    test rcx, rcx
    jz .ntd_1
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jmp .ntc_1
.ntd_1:
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
.cpy1_2:
    test rax, rax
    jz .c1d_2
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_2
.c1d_2:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_2:
    test rax, rax
    jz .c2d_2
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_2
.c2d_2:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 35
    call arena_alloc
    mov qword [rax], 27
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
    mov byte [rax + 20], 32
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 216
    mov byte [rax + 26], 163
    mov byte [rax + 27], 217
    mov byte [rax + 28], 136
    mov byte [rax + 29], 217
    mov byte [rax + 30], 132
    mov byte [rax + 31], 217
    mov byte [rax + 32], 137
    mov byte [rax + 33], 58
    mov byte [rax + 34], 32
    push rax
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
.cpy1_3:
    test rax, rax
    jz .c1d_3
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_3
.c1d_3:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_3:
    test rax, rax
    jz .c2d_3
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_3
.c2d_3:
    pop r11
    pop r10
    mov rax, r12
    call print_str
    mov rdi, 37
    call arena_alloc
    mov qword [rax], 29
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
    mov byte [rax + 20], 32
    mov byte [rax + 21], 216
    mov byte [rax + 22], 167
    mov byte [rax + 23], 217
    mov byte [rax + 24], 132
    mov byte [rax + 25], 216
    mov byte [rax + 26], 163
    mov byte [rax + 27], 216
    mov byte [rax + 28], 174
    mov byte [rax + 29], 217
    mov byte [rax + 30], 138
    mov byte [rax + 31], 216
    mov byte [rax + 32], 177
    mov byte [rax + 33], 216
    mov byte [rax + 34], 169
    mov byte [rax + 35], 58
    mov byte [rax + 36], 32
    push rax
    mov rax, [vars + 0]
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
    jz .hemp_2
    mov rax, [rax + 8]
    jmp .hdne_2
.hemp_2:
    mov rax, 60
    mov rdi, 1
    syscall
.hdne_2:
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

    mov rax, 60
    xor rdi, rdi
    syscall
