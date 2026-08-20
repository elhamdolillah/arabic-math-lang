bits 64
default rel
global mixed_mul_q64

; int64_t mixed_mul_q64(int64_t r, int64_t acc_hi, uint64_t acc_lo)
; returns floor((r * (acc_hi*2^64 + acc_lo)) / 2^64).
mixed_mul_q64:
    push rbx
    mov r8, rdi              ; original signed r
    mov r9, rdx              ; acc_lo unsigned
    mov r10, rsi             ; acc_hi signed
    xor r11d, r11d           ; sign flag
    test r8, r8
    jns .abs_ready
    neg r8
    mov r11d, 1
.abs_ready:
    mov rax, r8
    mul r9                    ; unsigned abs(r)*lo -> RDX:RAX
    mov rbx, rdx              ; q = floor(P/2^64)
    test r11d, r11d
    jz .combine
    ; floor(-P/2^64) = -high - (low != 0)
    neg rbx
    test rax, rax
    jz .combine
    dec rbx
.combine:
    imul r10, rdi             ; low 64 bits of signed r*hi
    lea rax, [r10 + rbx]
    pop rbx
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
