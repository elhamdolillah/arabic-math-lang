global _start
section .bss
    vars resq 256
    num_buf resb 32
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

    mov rdi, 8
    call arena_alloc
    push rax
    mov rcx, func_0
    mov [rax], rcx
    pop rax
    mov [vars + 0], rax
    mov rdi, 40
    call arena_alloc
    push rax
    mov qword [rax], 4
    mov rax, 1
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 8], rcx
    mov rax, 2
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 16], rcx
    mov rax, 3
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 24], rcx
    mov rax, 4
    mov rcx, rax
    mov rbx, [rsp]
    mov [rbx + 32], rcx
    pop rax
    mov [vars + 8], rax
    mov rax, [vars + 8]
    mov rax, [rax]
    call print_int

    mov rax, 60
    xor rdi, rdi
    syscall

func_0:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov rax, [rbp - 8]
    mov rax, [rax]
    push rax
    mov rax, 0
    pop rbx
    cmp rbx, rax
    mov rax, 0
    sete al
    cmp rax, 0
    je .else_2
    mov rax, 0
    jmp .end_2
.else_2:
    mov rax, [rbp - 8]
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
    push rax
    mov rax, [rbp - 8]
    mov rcx, [rax]
    test rcx, rcx
    jz .taihemp_1
    push rax
    dec rcx
    mov rdi, rcx
    shl rdi, 3
    add rdi, 8
    call arena_alloc
    mov rbx, rax
    mov [rax], rcx
    pop rsi
    add rsi, 16
    add rbx, 8
.tcopy_1:
    test rcx, rcx
    jz .tcd_1
    mov rdx, [rsi]
    mov [rbx], rdx
    add rsi, 8
    add rbx, 8
    dec rcx
    jmp .tcopy_1
.tcd_1:
    jmp .taine_1
.taihemp_1:
    mov rax, 60
    mov rdi, 1
    syscall
.taine_1:
    mov rax, [rax]
    pop rbx
    add rax, rbx
.end_2:
    leave
    ret