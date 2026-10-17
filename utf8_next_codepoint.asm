; utf8_next_codepoint
; ABI:
;   RDI = pointer to next UTF-8 sequence (may be NULL only when R14=0)
;   RSI = remaining byte count
; Returns:
;   RAX = status: 0=valid, 1=end, 2=invalid
;   RDX = decoded Unicode scalar value when valid, otherwise 0
;   RCX = consumed width in bytes when valid, otherwise 0
; Clobbers: R8-R11. Preserves all SysV callee-saved registers.
; No memory is read before remaining-byte checks.

global utf8_next_codepoint
section .text
utf8_next_codepoint:
    xor eax, eax
    xor edx, edx
    xor ecx, ecx
    test rsi, rsi
    jz .end
    test rdi, rdi
    jz .invalid

    movzx r8d, byte [rdi]
    cmp r8d, 0x80
    jb .ascii
    cmp r8d, 0xC2
    jb .invalid
    cmp r8d, 0xE0
    jb .two
    cmp r8d, 0xF0
    jb .three
    cmp r8d, 0xF5
    jb .four
    jmp .invalid

.ascii:
    mov edx, r8d
    mov ecx, 1
    ret

.two:
    cmp rsi, 2
    jb .invalid
    movzx r9d, byte [rdi+1]
    cmp r9d, 0x80
    jb .invalid
    cmp r9d, 0xBF
    ja .invalid
    mov edx, r8d
    and edx, 0x1F
    shl edx, 6
    and r9d, 0x3F
    or edx, r9d
    mov ecx, 2
    ret

.three:
    cmp rsi, 3
    jb .invalid
    movzx r9d, byte [rdi+1]
    movzx r10d, byte [rdi+2]
    cmp r9d, 0x80
    jb .invalid
    cmp r9d, 0xBF
    ja .invalid
    cmp r10d, 0x80
    jb .invalid
    cmp r10d, 0xBF
    ja .invalid
    cmp r8d, 0xE0
    jne .three_not_e0
    cmp r9d, 0xA0
    jb .invalid
.three_not_e0:
    cmp r8d, 0xED
    jne .three_decode
    cmp r9d, 0x9F
    ja .invalid
.three_decode:
    mov edx, r8d
    and edx, 0x0F
    shl edx, 12
    and r9d, 0x3F
    shl r9d, 6
    or edx, r9d
    and r10d, 0x3F
    or edx, r10d
    mov ecx, 3
    ret

.four:
    cmp rsi, 4
    jb .invalid
    movzx r9d, byte [rdi+1]
    movzx r10d, byte [rdi+2]
    movzx r11d, byte [rdi+3]
    cmp r9d, 0x80
    jb .invalid
    cmp r9d, 0xBF
    ja .invalid
    cmp r10d, 0x80
    jb .invalid
    cmp r10d, 0xBF
    ja .invalid
    cmp r11d, 0x80
    jb .invalid
    cmp r11d, 0xBF
    ja .invalid
    cmp r8d, 0xF0
    jne .four_not_f0
    cmp r9d, 0x90
    jb .invalid
.four_not_f0:
    cmp r8d, 0xF4
    jne .four_decode
    cmp r9d, 0x8F
    ja .invalid
.four_decode:
    mov edx, r8d
    and edx, 0x07
    shl edx, 18
    and r9d, 0x3F
    shl r9d, 12
    or edx, r9d
    and r10d, 0x3F
    shl r10d, 6
    or edx, r10d
    and r11d, 0x3F
    or edx, r11d
    mov ecx, 4
    ret

.end:
    mov eax, 1
    ret
.invalid:
    mov eax, 2
    xor edx, edx
    xor ecx, ecx
    ret
