global _start
section .data
msg db "mov rax, 3"
section .text
_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg]
    mov rdx, 10
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
