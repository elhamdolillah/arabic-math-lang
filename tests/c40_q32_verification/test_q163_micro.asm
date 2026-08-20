; UORI C40 Q1.63 micro-tests
; Exit 0 only if every deterministic assertion passes.
bits 64
default rel
global _start

section .text
_start:
    ; Test 1: positive 64x64 -> 128: 2^63 * 2^63 = 2^126.
    mov rax, 0x8000000000000000
    mov rdx, 0x8000000000000000
    mul rdx                    ; RDX:RAX = unsigned product
    mov r8, 0
    mov r9, 0x4000000000000000
    cmp rax, r8
    jne .fail
    cmp rdx, r9
    jne .fail

    ; Test 2: signed -2^63 * 1 = -2^63, represented as high=-1, low=0x8000...
    mov rax, 0x8000000000000000
    mov rdx, 1
    imul rdx                   ; signed product in RDX:RAX
    mov r8, 0x8000000000000000
    mov r9, 0xffffffffffffffff
    cmp rax, r8
    jne .fail
    cmp rdx, r9
    jne .fail

    ; Test 3: Q1.63 value 1.0 multiplied by 1.0 remains 1.0 after >>63.
    mov rax, 0x8000000000000000
    mov rdx, 0x8000000000000000
    mul rdx
    ; Product is 2^126; arithmetic/logical extraction of >>63 gives 2^63.
    mov rcx, rax
    mov r8, rdx
    shld r8, rcx, 1            ; (RDX:RAX) >> 63, low 64 bits
    mov r9, 0x8000000000000000
    cmp r8, r9
    jne .fail

    ; Test 4: delayed scaling: accumulator 1.0 at Q1.63, k=31,
    ; then final >>31 must be 2^63 in Q32.32.
    mov rax, 0x8000000000000000
    mov rdx, 0                ; high half of positive accumulator
    mov rcx, 31
    shld rdx, rax, cl
    shl rax, cl
    ; scaled Q1.63 = 2^94; final >>31 = 2^63.
    mov rcx, 31
    shrd rax, rdx, cl
    sar rdx, cl
    mov r8, 0x8000000000000000
    cmp rax, r8
    jne .fail
    test rdx, rdx
    jne .fail

    ; Test 5: k=23 with a half-unit at the final Q32 boundary.
    ; Q1.63 accumulator = 2^62; scaled by 2^23 => 2^85; >>31 = 2^54.
    mov rax, 0x4000000000000000
    xor rdx, rdx
    mov rcx, 23
    shld rdx, rax, cl
    shl rax, cl
    mov rcx, 31
    shrd rax, rdx, cl
    sar rdx, cl
    mov r8, 0x0040000000000000
    cmp rax, r8
    jne .fail
    test rdx, rdx
    jne .fail

    mov eax, 60             ; exit
    xor edi, edi
    syscall

.fail:
    mov eax, 60
    mov edi, 1
    syscall
