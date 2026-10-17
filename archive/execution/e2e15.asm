global _start
section .bss
    buf resb 256
section .text
_start:
    mov rdi, 0
    mov rsi, buf
    mov rdx, 256
    mov rax, 0
    syscall
    mov rdi, 1
    mov rsi, buf
    mov rdx, rax
    mov rax, 1
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
