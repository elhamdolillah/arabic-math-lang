global _start
section .bss
    num_buf resb 32
section .text
_start:
mov rax, 200
mov rbx, 100
add rax, rbx

print_int:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    mov rbx, 10
    mov rcx, 0
    xor r8, r8
    test rax, rax
    jns .positive
    neg rax
    mov r8, 1
.positive:
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
    test r8, r8
    jz .no_sign
    dec rdi
    mov byte [rdi], '-'
    inc rcx
.no_sign:
    mov rsi, rdi
    mov byte [rsi + rcx], 10
    inc rcx
    mov rdi, 1
    mov rax, 1
    mov rdx, rcx
    syscall
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

    call print_int
    mov rax, 60
    xor rdi, rdi
    syscall
