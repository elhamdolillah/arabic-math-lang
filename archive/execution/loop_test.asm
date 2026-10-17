global _start
section .data
msg db "12"
section .text
_start:
    mov rcx, 4
.loop:
    push rcx
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg]
    mov rdx, 2
    syscall
    pop rcx
    dec rcx
    jnz .loop
    mov rax, 60
    xor rdi, rdi
    syscall
