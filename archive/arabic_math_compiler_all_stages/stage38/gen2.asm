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
    mov [vars + 0], rax
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
    mov [vars + 8], rax
    mov rdi, 18
    call arena_alloc
    mov qword [rax], 10
    mov byte [rax + 8], 216
    mov byte [rax + 9], 167
    mov byte [rax + 10], 217
    mov byte [rax + 11], 132
    mov byte [rax + 12], 216
    mov byte [rax + 13], 175
    mov byte [rax + 14], 216
    mov byte [rax + 15], 177
    mov byte [rax + 16], 216
    mov byte [rax + 17], 179
    mov [vars + 16], rax
    mov rax, [vars + 0]
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
.cpy1_4:
    test rax, rax
    jz .c1d_4
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_4
.c1d_4:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_4:
    test rax, rax
    jz .c2d_4
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_4
.c2d_4:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 8]
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
.cpy1_6:
    test rax, rax
    jz .c1d_6
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy1_6
.c1d_6:
    mov rax, [r11]
    lea rsi, [r11 + 8]
.cpy2_6:
    test rax, rax
    jz .c2d_6
    mov cl, [rsi]
    mov [rdi], cl
    inc rsi
    inc rdi
    dec rax
    jmp .cpy2_6
.c2d_6:
    pop r11
    pop r10
    mov rax, r12
    push rax
    mov rax, [vars + 16]
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
    mov [vars + 24], rax
    mov rax, [vars + 24]
    call print_str

    mov rax, 60
    xor rdi, rdi
    syscall
