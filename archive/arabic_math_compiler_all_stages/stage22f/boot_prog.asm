global _start
section .data
msg db "بسم الله الرحمن الرحيم"
section .text
_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg]
    mov rdx, 41
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
