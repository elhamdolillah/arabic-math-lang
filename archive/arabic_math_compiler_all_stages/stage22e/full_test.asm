global _start
section .data
msg db "*"
section .text
_start:
    mov rcx, 5
.loop:
    push rcx
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg]
    mov rdx, 1
    syscall
    pop rcx
    dec rcx
    jnz .loop
    mov rax, 60
    xor rdi, rdi
    syscall
