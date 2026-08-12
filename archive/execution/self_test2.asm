global _start
section .data
msg db "msg db test"
section .text
mov rax, 1
mov rdi, 1
lea rsi, [msg]
mov rdx, 11
syscall
mov rax, 60
xor rdi, rdi
syscall
