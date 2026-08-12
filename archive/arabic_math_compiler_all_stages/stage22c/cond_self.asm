global _start
section .data
msg db ".end:"
section .text
_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg]
    mov rdx, 5
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
