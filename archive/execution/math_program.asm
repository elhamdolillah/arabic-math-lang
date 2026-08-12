global _start
section .bss
    vars resq 256
    num_buf resb 32

section .text
print_int:
    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    mov rbx, 10
    mov rcx, 0
    lea rdi, [num_buf + 31]
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .loop
    mov byte [rdi], 10 ; append newline
    inc rcx
    mov rsi, rdi       ; ✅ rsi = buffer pointer (start of string)
    mov rdi, 1         ; ✅ rdi = stdout (fd 1)
    mov rax, 1         ; ✅ rax = sys_write
    mov rdx, rcx       ; ✅ rdx = length
    syscall
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rax
    ret

_start:
    mov rax, 2
    push rax
    mov rax, 3
    pop rbx
    add rax, rbx
    mov [vars + 0], rax
    mov rax, 10
    push rax
    mov rax, 4
    pop rbx
    sub rbx, rax
    mov rax, rbx
    mov [vars + 8], rax
    mov rax, [vars + 0]
    push rax
    mov rax, [vars + 8]
    pop rbx
    imul rax, rbx
    mov [vars + 16], rax
    mov rax, [vars + 16]
    call print_int

    mov rax, 60        ; sys_exit
    xor rdi, rdi       ; status 0
    syscall