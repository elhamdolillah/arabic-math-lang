global _start
section .data
    msg db 0xD8, 0xA7, 0xD9, 0x84, 0xD8, 0xB3, 0xD9, 0x84, 0xD8, 0xA7, 0xD9, 0x85
    len equ $ - msg
    msg2 db " ", 0xD8, 0xB9, 0xD9, 0x84, 0xD9, 0x8A, 0xD9, 0x83, 0xD9, 0x85
    len2 equ $ - msg2
section .text
_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg]
    mov rdx, len
    syscall
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg2]
    mov rdx, len2
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
