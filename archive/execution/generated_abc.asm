section .data
msg db 
section .text
mov rax, 1
mov rdi, 1
lea rsi, [msg]
mov rdx, 9
syscall
