; Generated directly by generate_sha256_asm.py; self-contained runtime.
section .text
global sha256_text_routine
sha256_text_routine:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 1032
    test rdi, rdi
    jz sha_null_fail
    mov rsi, [rdi]
    cmp rsi, 65536
    ja sha_long_fail
    mov [rbp-8], rdi
    mov [rbp-16], rsi
    mov rax, rsi
    add rax, 9
    add rax, 63
    and rax, -64
    add rax, 0
    mov [rbp-24], rax
    shr rax, 6
    mov [rbp-32], rax
    mov dword [rbp-64], 0x6a09e667
    mov dword [rbp-60], 0xbb67ae85
    mov dword [rbp-56], 0x3c6ef372
    mov dword [rbp-52], 0xa54ff53a
    mov dword [rbp-48], 0x510e527f
    mov dword [rbp-44], 0x9b05688c
    mov dword [rbp-40], 0x1f83d9ab
    mov dword [rbp-36], 0x5be0cd19
    xor r14d, r14d
.sha_block_loop:
    cmp r14, [rbp-32]
    jae .sha_finish
    mov qword [rbp-384], 0
    mov qword [rbp-376], 0
    mov qword [rbp-368], 0
    mov qword [rbp-360], 0
    mov qword [rbp-352], 0
    mov qword [rbp-344], 0
    mov qword [rbp-336], 0
    mov qword [rbp-328], 0
    mov r10, r14
    shl r10, 6
    add r10, 0
    cmp r10, [rbp-16]
    jb .sha_data_0
    jne .sha_not_data_0
    mov byte [rbp-384], 0x80
    jmp .sha_byte_done_0
.sha_not_data_0:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_0
    jne .sha_byte_done_0
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 56
    shr r11, cl
    mov byte [rbp-384], r11b
    jmp .sha_byte_done_0
.sha_data_0:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-384], r11b
.sha_byte_done_0:
    mov r10, r14
    shl r10, 6
    add r10, 1
    cmp r10, [rbp-16]
    jb .sha_data_1
    jne .sha_not_data_1
    mov byte [rbp-383], 0x80
    jmp .sha_byte_done_1
.sha_not_data_1:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_1
    jne .sha_byte_done_1
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 48
    shr r11, cl
    mov byte [rbp-383], r11b
    jmp .sha_byte_done_1
.sha_data_1:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-383], r11b
.sha_byte_done_1:
    mov r10, r14
    shl r10, 6
    add r10, 2
    cmp r10, [rbp-16]
    jb .sha_data_2
    jne .sha_not_data_2
    mov byte [rbp-382], 0x80
    jmp .sha_byte_done_2
.sha_not_data_2:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_2
    jne .sha_byte_done_2
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 40
    shr r11, cl
    mov byte [rbp-382], r11b
    jmp .sha_byte_done_2
.sha_data_2:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-382], r11b
.sha_byte_done_2:
    mov r10, r14
    shl r10, 6
    add r10, 3
    cmp r10, [rbp-16]
    jb .sha_data_3
    jne .sha_not_data_3
    mov byte [rbp-381], 0x80
    jmp .sha_byte_done_3
.sha_not_data_3:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_3
    jne .sha_byte_done_3
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 32
    shr r11, cl
    mov byte [rbp-381], r11b
    jmp .sha_byte_done_3
.sha_data_3:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-381], r11b
.sha_byte_done_3:
    mov r10, r14
    shl r10, 6
    add r10, 4
    cmp r10, [rbp-16]
    jb .sha_data_4
    jne .sha_not_data_4
    mov byte [rbp-380], 0x80
    jmp .sha_byte_done_4
.sha_not_data_4:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_4
    jne .sha_byte_done_4
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 24
    shr r11, cl
    mov byte [rbp-380], r11b
    jmp .sha_byte_done_4
.sha_data_4:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-380], r11b
.sha_byte_done_4:
    mov r10, r14
    shl r10, 6
    add r10, 5
    cmp r10, [rbp-16]
    jb .sha_data_5
    jne .sha_not_data_5
    mov byte [rbp-379], 0x80
    jmp .sha_byte_done_5
.sha_not_data_5:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_5
    jne .sha_byte_done_5
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 16
    shr r11, cl
    mov byte [rbp-379], r11b
    jmp .sha_byte_done_5
.sha_data_5:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-379], r11b
.sha_byte_done_5:
    mov r10, r14
    shl r10, 6
    add r10, 6
    cmp r10, [rbp-16]
    jb .sha_data_6
    jne .sha_not_data_6
    mov byte [rbp-378], 0x80
    jmp .sha_byte_done_6
.sha_not_data_6:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_6
    jne .sha_byte_done_6
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 8
    shr r11, cl
    mov byte [rbp-378], r11b
    jmp .sha_byte_done_6
.sha_data_6:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-378], r11b
.sha_byte_done_6:
    mov r10, r14
    shl r10, 6
    add r10, 7
    cmp r10, [rbp-16]
    jb .sha_data_7
    jne .sha_not_data_7
    mov byte [rbp-377], 0x80
    jmp .sha_byte_done_7
.sha_not_data_7:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_7
    jne .sha_byte_done_7
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 0
    shr r11, cl
    mov byte [rbp-377], r11b
    jmp .sha_byte_done_7
.sha_data_7:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-377], r11b
.sha_byte_done_7:
    mov r10, r14
    shl r10, 6
    add r10, 8
    cmp r10, [rbp-16]
    jb .sha_data_8
    jne .sha_not_data_8
    mov byte [rbp-376], 0x80
    jmp .sha_byte_done_8
.sha_not_data_8:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_8
    jne .sha_byte_done_8
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 56
    shr r11, cl
    mov byte [rbp-376], r11b
    jmp .sha_byte_done_8
.sha_data_8:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-376], r11b
.sha_byte_done_8:
    mov r10, r14
    shl r10, 6
    add r10, 9
    cmp r10, [rbp-16]
    jb .sha_data_9
    jne .sha_not_data_9
    mov byte [rbp-375], 0x80
    jmp .sha_byte_done_9
.sha_not_data_9:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_9
    jne .sha_byte_done_9
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 48
    shr r11, cl
    mov byte [rbp-375], r11b
    jmp .sha_byte_done_9
.sha_data_9:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-375], r11b
.sha_byte_done_9:
    mov r10, r14
    shl r10, 6
    add r10, 10
    cmp r10, [rbp-16]
    jb .sha_data_10
    jne .sha_not_data_10
    mov byte [rbp-374], 0x80
    jmp .sha_byte_done_10
.sha_not_data_10:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_10
    jne .sha_byte_done_10
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 40
    shr r11, cl
    mov byte [rbp-374], r11b
    jmp .sha_byte_done_10
.sha_data_10:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-374], r11b
.sha_byte_done_10:
    mov r10, r14
    shl r10, 6
    add r10, 11
    cmp r10, [rbp-16]
    jb .sha_data_11
    jne .sha_not_data_11
    mov byte [rbp-373], 0x80
    jmp .sha_byte_done_11
.sha_not_data_11:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_11
    jne .sha_byte_done_11
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 32
    shr r11, cl
    mov byte [rbp-373], r11b
    jmp .sha_byte_done_11
.sha_data_11:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-373], r11b
.sha_byte_done_11:
    mov r10, r14
    shl r10, 6
    add r10, 12
    cmp r10, [rbp-16]
    jb .sha_data_12
    jne .sha_not_data_12
    mov byte [rbp-372], 0x80
    jmp .sha_byte_done_12
.sha_not_data_12:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_12
    jne .sha_byte_done_12
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 24
    shr r11, cl
    mov byte [rbp-372], r11b
    jmp .sha_byte_done_12
.sha_data_12:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-372], r11b
.sha_byte_done_12:
    mov r10, r14
    shl r10, 6
    add r10, 13
    cmp r10, [rbp-16]
    jb .sha_data_13
    jne .sha_not_data_13
    mov byte [rbp-371], 0x80
    jmp .sha_byte_done_13
.sha_not_data_13:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_13
    jne .sha_byte_done_13
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 16
    shr r11, cl
    mov byte [rbp-371], r11b
    jmp .sha_byte_done_13
.sha_data_13:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-371], r11b
.sha_byte_done_13:
    mov r10, r14
    shl r10, 6
    add r10, 14
    cmp r10, [rbp-16]
    jb .sha_data_14
    jne .sha_not_data_14
    mov byte [rbp-370], 0x80
    jmp .sha_byte_done_14
.sha_not_data_14:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_14
    jne .sha_byte_done_14
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 8
    shr r11, cl
    mov byte [rbp-370], r11b
    jmp .sha_byte_done_14
.sha_data_14:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-370], r11b
.sha_byte_done_14:
    mov r10, r14
    shl r10, 6
    add r10, 15
    cmp r10, [rbp-16]
    jb .sha_data_15
    jne .sha_not_data_15
    mov byte [rbp-369], 0x80
    jmp .sha_byte_done_15
.sha_not_data_15:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_15
    jne .sha_byte_done_15
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 0
    shr r11, cl
    mov byte [rbp-369], r11b
    jmp .sha_byte_done_15
.sha_data_15:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-369], r11b
.sha_byte_done_15:
    mov r10, r14
    shl r10, 6
    add r10, 16
    cmp r10, [rbp-16]
    jb .sha_data_16
    jne .sha_not_data_16
    mov byte [rbp-368], 0x80
    jmp .sha_byte_done_16
.sha_not_data_16:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_16
    jne .sha_byte_done_16
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 56
    shr r11, cl
    mov byte [rbp-368], r11b
    jmp .sha_byte_done_16
.sha_data_16:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-368], r11b
.sha_byte_done_16:
    mov r10, r14
    shl r10, 6
    add r10, 17
    cmp r10, [rbp-16]
    jb .sha_data_17
    jne .sha_not_data_17
    mov byte [rbp-367], 0x80
    jmp .sha_byte_done_17
.sha_not_data_17:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_17
    jne .sha_byte_done_17
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 48
    shr r11, cl
    mov byte [rbp-367], r11b
    jmp .sha_byte_done_17
.sha_data_17:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-367], r11b
.sha_byte_done_17:
    mov r10, r14
    shl r10, 6
    add r10, 18
    cmp r10, [rbp-16]
    jb .sha_data_18
    jne .sha_not_data_18
    mov byte [rbp-366], 0x80
    jmp .sha_byte_done_18
.sha_not_data_18:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_18
    jne .sha_byte_done_18
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 40
    shr r11, cl
    mov byte [rbp-366], r11b
    jmp .sha_byte_done_18
.sha_data_18:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-366], r11b
.sha_byte_done_18:
    mov r10, r14
    shl r10, 6
    add r10, 19
    cmp r10, [rbp-16]
    jb .sha_data_19
    jne .sha_not_data_19
    mov byte [rbp-365], 0x80
    jmp .sha_byte_done_19
.sha_not_data_19:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_19
    jne .sha_byte_done_19
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 32
    shr r11, cl
    mov byte [rbp-365], r11b
    jmp .sha_byte_done_19
.sha_data_19:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-365], r11b
.sha_byte_done_19:
    mov r10, r14
    shl r10, 6
    add r10, 20
    cmp r10, [rbp-16]
    jb .sha_data_20
    jne .sha_not_data_20
    mov byte [rbp-364], 0x80
    jmp .sha_byte_done_20
.sha_not_data_20:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_20
    jne .sha_byte_done_20
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 24
    shr r11, cl
    mov byte [rbp-364], r11b
    jmp .sha_byte_done_20
.sha_data_20:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-364], r11b
.sha_byte_done_20:
    mov r10, r14
    shl r10, 6
    add r10, 21
    cmp r10, [rbp-16]
    jb .sha_data_21
    jne .sha_not_data_21
    mov byte [rbp-363], 0x80
    jmp .sha_byte_done_21
.sha_not_data_21:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_21
    jne .sha_byte_done_21
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 16
    shr r11, cl
    mov byte [rbp-363], r11b
    jmp .sha_byte_done_21
.sha_data_21:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-363], r11b
.sha_byte_done_21:
    mov r10, r14
    shl r10, 6
    add r10, 22
    cmp r10, [rbp-16]
    jb .sha_data_22
    jne .sha_not_data_22
    mov byte [rbp-362], 0x80
    jmp .sha_byte_done_22
.sha_not_data_22:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_22
    jne .sha_byte_done_22
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 8
    shr r11, cl
    mov byte [rbp-362], r11b
    jmp .sha_byte_done_22
.sha_data_22:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-362], r11b
.sha_byte_done_22:
    mov r10, r14
    shl r10, 6
    add r10, 23
    cmp r10, [rbp-16]
    jb .sha_data_23
    jne .sha_not_data_23
    mov byte [rbp-361], 0x80
    jmp .sha_byte_done_23
.sha_not_data_23:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_23
    jne .sha_byte_done_23
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 0
    shr r11, cl
    mov byte [rbp-361], r11b
    jmp .sha_byte_done_23
.sha_data_23:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-361], r11b
.sha_byte_done_23:
    mov r10, r14
    shl r10, 6
    add r10, 24
    cmp r10, [rbp-16]
    jb .sha_data_24
    jne .sha_not_data_24
    mov byte [rbp-360], 0x80
    jmp .sha_byte_done_24
.sha_not_data_24:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_24
    jne .sha_byte_done_24
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 56
    shr r11, cl
    mov byte [rbp-360], r11b
    jmp .sha_byte_done_24
.sha_data_24:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-360], r11b
.sha_byte_done_24:
    mov r10, r14
    shl r10, 6
    add r10, 25
    cmp r10, [rbp-16]
    jb .sha_data_25
    jne .sha_not_data_25
    mov byte [rbp-359], 0x80
    jmp .sha_byte_done_25
.sha_not_data_25:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_25
    jne .sha_byte_done_25
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 48
    shr r11, cl
    mov byte [rbp-359], r11b
    jmp .sha_byte_done_25
.sha_data_25:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-359], r11b
.sha_byte_done_25:
    mov r10, r14
    shl r10, 6
    add r10, 26
    cmp r10, [rbp-16]
    jb .sha_data_26
    jne .sha_not_data_26
    mov byte [rbp-358], 0x80
    jmp .sha_byte_done_26
.sha_not_data_26:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_26
    jne .sha_byte_done_26
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 40
    shr r11, cl
    mov byte [rbp-358], r11b
    jmp .sha_byte_done_26
.sha_data_26:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-358], r11b
.sha_byte_done_26:
    mov r10, r14
    shl r10, 6
    add r10, 27
    cmp r10, [rbp-16]
    jb .sha_data_27
    jne .sha_not_data_27
    mov byte [rbp-357], 0x80
    jmp .sha_byte_done_27
.sha_not_data_27:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_27
    jne .sha_byte_done_27
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 32
    shr r11, cl
    mov byte [rbp-357], r11b
    jmp .sha_byte_done_27
.sha_data_27:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-357], r11b
.sha_byte_done_27:
    mov r10, r14
    shl r10, 6
    add r10, 28
    cmp r10, [rbp-16]
    jb .sha_data_28
    jne .sha_not_data_28
    mov byte [rbp-356], 0x80
    jmp .sha_byte_done_28
.sha_not_data_28:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_28
    jne .sha_byte_done_28
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 24
    shr r11, cl
    mov byte [rbp-356], r11b
    jmp .sha_byte_done_28
.sha_data_28:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-356], r11b
.sha_byte_done_28:
    mov r10, r14
    shl r10, 6
    add r10, 29
    cmp r10, [rbp-16]
    jb .sha_data_29
    jne .sha_not_data_29
    mov byte [rbp-355], 0x80
    jmp .sha_byte_done_29
.sha_not_data_29:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_29
    jne .sha_byte_done_29
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 16
    shr r11, cl
    mov byte [rbp-355], r11b
    jmp .sha_byte_done_29
.sha_data_29:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-355], r11b
.sha_byte_done_29:
    mov r10, r14
    shl r10, 6
    add r10, 30
    cmp r10, [rbp-16]
    jb .sha_data_30
    jne .sha_not_data_30
    mov byte [rbp-354], 0x80
    jmp .sha_byte_done_30
.sha_not_data_30:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_30
    jne .sha_byte_done_30
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 8
    shr r11, cl
    mov byte [rbp-354], r11b
    jmp .sha_byte_done_30
.sha_data_30:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-354], r11b
.sha_byte_done_30:
    mov r10, r14
    shl r10, 6
    add r10, 31
    cmp r10, [rbp-16]
    jb .sha_data_31
    jne .sha_not_data_31
    mov byte [rbp-353], 0x80
    jmp .sha_byte_done_31
.sha_not_data_31:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_31
    jne .sha_byte_done_31
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 0
    shr r11, cl
    mov byte [rbp-353], r11b
    jmp .sha_byte_done_31
.sha_data_31:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-353], r11b
.sha_byte_done_31:
    mov r10, r14
    shl r10, 6
    add r10, 32
    cmp r10, [rbp-16]
    jb .sha_data_32
    jne .sha_not_data_32
    mov byte [rbp-352], 0x80
    jmp .sha_byte_done_32
.sha_not_data_32:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_32
    jne .sha_byte_done_32
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 56
    shr r11, cl
    mov byte [rbp-352], r11b
    jmp .sha_byte_done_32
.sha_data_32:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-352], r11b
.sha_byte_done_32:
    mov r10, r14
    shl r10, 6
    add r10, 33
    cmp r10, [rbp-16]
    jb .sha_data_33
    jne .sha_not_data_33
    mov byte [rbp-351], 0x80
    jmp .sha_byte_done_33
.sha_not_data_33:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_33
    jne .sha_byte_done_33
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 48
    shr r11, cl
    mov byte [rbp-351], r11b
    jmp .sha_byte_done_33
.sha_data_33:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-351], r11b
.sha_byte_done_33:
    mov r10, r14
    shl r10, 6
    add r10, 34
    cmp r10, [rbp-16]
    jb .sha_data_34
    jne .sha_not_data_34
    mov byte [rbp-350], 0x80
    jmp .sha_byte_done_34
.sha_not_data_34:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_34
    jne .sha_byte_done_34
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 40
    shr r11, cl
    mov byte [rbp-350], r11b
    jmp .sha_byte_done_34
.sha_data_34:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-350], r11b
.sha_byte_done_34:
    mov r10, r14
    shl r10, 6
    add r10, 35
    cmp r10, [rbp-16]
    jb .sha_data_35
    jne .sha_not_data_35
    mov byte [rbp-349], 0x80
    jmp .sha_byte_done_35
.sha_not_data_35:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_35
    jne .sha_byte_done_35
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 32
    shr r11, cl
    mov byte [rbp-349], r11b
    jmp .sha_byte_done_35
.sha_data_35:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-349], r11b
.sha_byte_done_35:
    mov r10, r14
    shl r10, 6
    add r10, 36
    cmp r10, [rbp-16]
    jb .sha_data_36
    jne .sha_not_data_36
    mov byte [rbp-348], 0x80
    jmp .sha_byte_done_36
.sha_not_data_36:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_36
    jne .sha_byte_done_36
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 24
    shr r11, cl
    mov byte [rbp-348], r11b
    jmp .sha_byte_done_36
.sha_data_36:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-348], r11b
.sha_byte_done_36:
    mov r10, r14
    shl r10, 6
    add r10, 37
    cmp r10, [rbp-16]
    jb .sha_data_37
    jne .sha_not_data_37
    mov byte [rbp-347], 0x80
    jmp .sha_byte_done_37
.sha_not_data_37:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_37
    jne .sha_byte_done_37
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 16
    shr r11, cl
    mov byte [rbp-347], r11b
    jmp .sha_byte_done_37
.sha_data_37:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-347], r11b
.sha_byte_done_37:
    mov r10, r14
    shl r10, 6
    add r10, 38
    cmp r10, [rbp-16]
    jb .sha_data_38
    jne .sha_not_data_38
    mov byte [rbp-346], 0x80
    jmp .sha_byte_done_38
.sha_not_data_38:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_38
    jne .sha_byte_done_38
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 8
    shr r11, cl
    mov byte [rbp-346], r11b
    jmp .sha_byte_done_38
.sha_data_38:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-346], r11b
.sha_byte_done_38:
    mov r10, r14
    shl r10, 6
    add r10, 39
    cmp r10, [rbp-16]
    jb .sha_data_39
    jne .sha_not_data_39
    mov byte [rbp-345], 0x80
    jmp .sha_byte_done_39
.sha_not_data_39:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_39
    jne .sha_byte_done_39
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 0
    shr r11, cl
    mov byte [rbp-345], r11b
    jmp .sha_byte_done_39
.sha_data_39:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-345], r11b
.sha_byte_done_39:
    mov r10, r14
    shl r10, 6
    add r10, 40
    cmp r10, [rbp-16]
    jb .sha_data_40
    jne .sha_not_data_40
    mov byte [rbp-344], 0x80
    jmp .sha_byte_done_40
.sha_not_data_40:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_40
    jne .sha_byte_done_40
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 56
    shr r11, cl
    mov byte [rbp-344], r11b
    jmp .sha_byte_done_40
.sha_data_40:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-344], r11b
.sha_byte_done_40:
    mov r10, r14
    shl r10, 6
    add r10, 41
    cmp r10, [rbp-16]
    jb .sha_data_41
    jne .sha_not_data_41
    mov byte [rbp-343], 0x80
    jmp .sha_byte_done_41
.sha_not_data_41:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_41
    jne .sha_byte_done_41
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 48
    shr r11, cl
    mov byte [rbp-343], r11b
    jmp .sha_byte_done_41
.sha_data_41:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-343], r11b
.sha_byte_done_41:
    mov r10, r14
    shl r10, 6
    add r10, 42
    cmp r10, [rbp-16]
    jb .sha_data_42
    jne .sha_not_data_42
    mov byte [rbp-342], 0x80
    jmp .sha_byte_done_42
.sha_not_data_42:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_42
    jne .sha_byte_done_42
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 40
    shr r11, cl
    mov byte [rbp-342], r11b
    jmp .sha_byte_done_42
.sha_data_42:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-342], r11b
.sha_byte_done_42:
    mov r10, r14
    shl r10, 6
    add r10, 43
    cmp r10, [rbp-16]
    jb .sha_data_43
    jne .sha_not_data_43
    mov byte [rbp-341], 0x80
    jmp .sha_byte_done_43
.sha_not_data_43:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_43
    jne .sha_byte_done_43
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 32
    shr r11, cl
    mov byte [rbp-341], r11b
    jmp .sha_byte_done_43
.sha_data_43:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-341], r11b
.sha_byte_done_43:
    mov r10, r14
    shl r10, 6
    add r10, 44
    cmp r10, [rbp-16]
    jb .sha_data_44
    jne .sha_not_data_44
    mov byte [rbp-340], 0x80
    jmp .sha_byte_done_44
.sha_not_data_44:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_44
    jne .sha_byte_done_44
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 24
    shr r11, cl
    mov byte [rbp-340], r11b
    jmp .sha_byte_done_44
.sha_data_44:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-340], r11b
.sha_byte_done_44:
    mov r10, r14
    shl r10, 6
    add r10, 45
    cmp r10, [rbp-16]
    jb .sha_data_45
    jne .sha_not_data_45
    mov byte [rbp-339], 0x80
    jmp .sha_byte_done_45
.sha_not_data_45:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_45
    jne .sha_byte_done_45
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 16
    shr r11, cl
    mov byte [rbp-339], r11b
    jmp .sha_byte_done_45
.sha_data_45:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-339], r11b
.sha_byte_done_45:
    mov r10, r14
    shl r10, 6
    add r10, 46
    cmp r10, [rbp-16]
    jb .sha_data_46
    jne .sha_not_data_46
    mov byte [rbp-338], 0x80
    jmp .sha_byte_done_46
.sha_not_data_46:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_46
    jne .sha_byte_done_46
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 8
    shr r11, cl
    mov byte [rbp-338], r11b
    jmp .sha_byte_done_46
.sha_data_46:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-338], r11b
.sha_byte_done_46:
    mov r10, r14
    shl r10, 6
    add r10, 47
    cmp r10, [rbp-16]
    jb .sha_data_47
    jne .sha_not_data_47
    mov byte [rbp-337], 0x80
    jmp .sha_byte_done_47
.sha_not_data_47:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_47
    jne .sha_byte_done_47
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 0
    shr r11, cl
    mov byte [rbp-337], r11b
    jmp .sha_byte_done_47
.sha_data_47:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-337], r11b
.sha_byte_done_47:
    mov r10, r14
    shl r10, 6
    add r10, 48
    cmp r10, [rbp-16]
    jb .sha_data_48
    jne .sha_not_data_48
    mov byte [rbp-336], 0x80
    jmp .sha_byte_done_48
.sha_not_data_48:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_48
    jne .sha_byte_done_48
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 56
    shr r11, cl
    mov byte [rbp-336], r11b
    jmp .sha_byte_done_48
.sha_data_48:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-336], r11b
.sha_byte_done_48:
    mov r10, r14
    shl r10, 6
    add r10, 49
    cmp r10, [rbp-16]
    jb .sha_data_49
    jne .sha_not_data_49
    mov byte [rbp-335], 0x80
    jmp .sha_byte_done_49
.sha_not_data_49:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_49
    jne .sha_byte_done_49
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 48
    shr r11, cl
    mov byte [rbp-335], r11b
    jmp .sha_byte_done_49
.sha_data_49:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-335], r11b
.sha_byte_done_49:
    mov r10, r14
    shl r10, 6
    add r10, 50
    cmp r10, [rbp-16]
    jb .sha_data_50
    jne .sha_not_data_50
    mov byte [rbp-334], 0x80
    jmp .sha_byte_done_50
.sha_not_data_50:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_50
    jne .sha_byte_done_50
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 40
    shr r11, cl
    mov byte [rbp-334], r11b
    jmp .sha_byte_done_50
.sha_data_50:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-334], r11b
.sha_byte_done_50:
    mov r10, r14
    shl r10, 6
    add r10, 51
    cmp r10, [rbp-16]
    jb .sha_data_51
    jne .sha_not_data_51
    mov byte [rbp-333], 0x80
    jmp .sha_byte_done_51
.sha_not_data_51:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_51
    jne .sha_byte_done_51
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 32
    shr r11, cl
    mov byte [rbp-333], r11b
    jmp .sha_byte_done_51
.sha_data_51:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-333], r11b
.sha_byte_done_51:
    mov r10, r14
    shl r10, 6
    add r10, 52
    cmp r10, [rbp-16]
    jb .sha_data_52
    jne .sha_not_data_52
    mov byte [rbp-332], 0x80
    jmp .sha_byte_done_52
.sha_not_data_52:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_52
    jne .sha_byte_done_52
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 24
    shr r11, cl
    mov byte [rbp-332], r11b
    jmp .sha_byte_done_52
.sha_data_52:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-332], r11b
.sha_byte_done_52:
    mov r10, r14
    shl r10, 6
    add r10, 53
    cmp r10, [rbp-16]
    jb .sha_data_53
    jne .sha_not_data_53
    mov byte [rbp-331], 0x80
    jmp .sha_byte_done_53
.sha_not_data_53:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_53
    jne .sha_byte_done_53
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 16
    shr r11, cl
    mov byte [rbp-331], r11b
    jmp .sha_byte_done_53
.sha_data_53:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-331], r11b
.sha_byte_done_53:
    mov r10, r14
    shl r10, 6
    add r10, 54
    cmp r10, [rbp-16]
    jb .sha_data_54
    jne .sha_not_data_54
    mov byte [rbp-330], 0x80
    jmp .sha_byte_done_54
.sha_not_data_54:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_54
    jne .sha_byte_done_54
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 8
    shr r11, cl
    mov byte [rbp-330], r11b
    jmp .sha_byte_done_54
.sha_data_54:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-330], r11b
.sha_byte_done_54:
    mov r10, r14
    shl r10, 6
    add r10, 55
    cmp r10, [rbp-16]
    jb .sha_data_55
    jne .sha_not_data_55
    mov byte [rbp-329], 0x80
    jmp .sha_byte_done_55
.sha_not_data_55:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_55
    jne .sha_byte_done_55
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 0
    shr r11, cl
    mov byte [rbp-329], r11b
    jmp .sha_byte_done_55
.sha_data_55:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-329], r11b
.sha_byte_done_55:
    mov r10, r14
    shl r10, 6
    add r10, 56
    cmp r10, [rbp-16]
    jb .sha_data_56
    jne .sha_not_data_56
    mov byte [rbp-328], 0x80
    jmp .sha_byte_done_56
.sha_not_data_56:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_56
    jne .sha_byte_done_56
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 56
    shr r11, cl
    mov byte [rbp-328], r11b
    jmp .sha_byte_done_56
.sha_data_56:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-328], r11b
.sha_byte_done_56:
    mov r10, r14
    shl r10, 6
    add r10, 57
    cmp r10, [rbp-16]
    jb .sha_data_57
    jne .sha_not_data_57
    mov byte [rbp-327], 0x80
    jmp .sha_byte_done_57
.sha_not_data_57:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_57
    jne .sha_byte_done_57
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 48
    shr r11, cl
    mov byte [rbp-327], r11b
    jmp .sha_byte_done_57
.sha_data_57:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-327], r11b
.sha_byte_done_57:
    mov r10, r14
    shl r10, 6
    add r10, 58
    cmp r10, [rbp-16]
    jb .sha_data_58
    jne .sha_not_data_58
    mov byte [rbp-326], 0x80
    jmp .sha_byte_done_58
.sha_not_data_58:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_58
    jne .sha_byte_done_58
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 40
    shr r11, cl
    mov byte [rbp-326], r11b
    jmp .sha_byte_done_58
.sha_data_58:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-326], r11b
.sha_byte_done_58:
    mov r10, r14
    shl r10, 6
    add r10, 59
    cmp r10, [rbp-16]
    jb .sha_data_59
    jne .sha_not_data_59
    mov byte [rbp-325], 0x80
    jmp .sha_byte_done_59
.sha_not_data_59:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_59
    jne .sha_byte_done_59
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 32
    shr r11, cl
    mov byte [rbp-325], r11b
    jmp .sha_byte_done_59
.sha_data_59:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-325], r11b
.sha_byte_done_59:
    mov r10, r14
    shl r10, 6
    add r10, 60
    cmp r10, [rbp-16]
    jb .sha_data_60
    jne .sha_not_data_60
    mov byte [rbp-324], 0x80
    jmp .sha_byte_done_60
.sha_not_data_60:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_60
    jne .sha_byte_done_60
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 24
    shr r11, cl
    mov byte [rbp-324], r11b
    jmp .sha_byte_done_60
.sha_data_60:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-324], r11b
.sha_byte_done_60:
    mov r10, r14
    shl r10, 6
    add r10, 61
    cmp r10, [rbp-16]
    jb .sha_data_61
    jne .sha_not_data_61
    mov byte [rbp-323], 0x80
    jmp .sha_byte_done_61
.sha_not_data_61:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_61
    jne .sha_byte_done_61
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 16
    shr r11, cl
    mov byte [rbp-323], r11b
    jmp .sha_byte_done_61
.sha_data_61:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-323], r11b
.sha_byte_done_61:
    mov r10, r14
    shl r10, 6
    add r10, 62
    cmp r10, [rbp-16]
    jb .sha_data_62
    jne .sha_not_data_62
    mov byte [rbp-322], 0x80
    jmp .sha_byte_done_62
.sha_not_data_62:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_62
    jne .sha_byte_done_62
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 8
    shr r11, cl
    mov byte [rbp-322], r11b
    jmp .sha_byte_done_62
.sha_data_62:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-322], r11b
.sha_byte_done_62:
    mov r10, r14
    shl r10, 6
    add r10, 63
    cmp r10, [rbp-16]
    jb .sha_data_63
    jne .sha_not_data_63
    mov byte [rbp-321], 0x80
    jmp .sha_byte_done_63
.sha_not_data_63:
    mov r11, [rbp-24]
    sub r11, 8
    cmp r10, r11
    jb .sha_byte_done_63
    jne .sha_byte_done_63
    mov r11, [rbp-16]
    shl r11, 3
    mov ecx, 0
    shr r11, cl
    mov byte [rbp-321], r11b
    jmp .sha_byte_done_63
.sha_data_63:
    mov r11, [rbp-8]
    add r11, 8
    add r11, r10
    movzx r11d, byte [r11]
    mov byte [rbp-321], r11b
.sha_byte_done_63:
    mov r10, [rbp-32]
    dec r10
    cmp r14, r10
    jne .sha_no_length_override
    mov r11, [rbp-16]
    shl r11, 3
    mov r12, r11
    mov ecx, 56
    shr r12, cl
    mov byte [rbp-328], r12b
    mov r12, r11
    mov ecx, 48
    shr r12, cl
    mov byte [rbp-327], r12b
    mov r12, r11
    mov ecx, 40
    shr r12, cl
    mov byte [rbp-326], r12b
    mov r12, r11
    mov ecx, 32
    shr r12, cl
    mov byte [rbp-325], r12b
    mov r12, r11
    mov ecx, 24
    shr r12, cl
    mov byte [rbp-324], r12b
    mov r12, r11
    mov ecx, 16
    shr r12, cl
    mov byte [rbp-323], r12b
    mov r12, r11
    mov ecx, 8
    shr r12, cl
    mov byte [rbp-322], r12b
    mov r12, r11
    mov ecx, 0
    shr r12, cl
    mov byte [rbp-321], r12b
.sha_no_length_override:
    movzx eax, byte [rbp-384]
    shl eax, 24
    movzx edx, byte [rbp-383]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-382]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-381]
    or eax, edx
    mov [rbp-320], eax
    movzx eax, byte [rbp-380]
    shl eax, 24
    movzx edx, byte [rbp-379]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-378]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-377]
    or eax, edx
    mov [rbp-316], eax
    movzx eax, byte [rbp-376]
    shl eax, 24
    movzx edx, byte [rbp-375]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-374]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-373]
    or eax, edx
    mov [rbp-312], eax
    movzx eax, byte [rbp-372]
    shl eax, 24
    movzx edx, byte [rbp-371]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-370]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-369]
    or eax, edx
    mov [rbp-308], eax
    movzx eax, byte [rbp-368]
    shl eax, 24
    movzx edx, byte [rbp-367]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-366]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-365]
    or eax, edx
    mov [rbp-304], eax
    movzx eax, byte [rbp-364]
    shl eax, 24
    movzx edx, byte [rbp-363]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-362]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-361]
    or eax, edx
    mov [rbp-300], eax
    movzx eax, byte [rbp-360]
    shl eax, 24
    movzx edx, byte [rbp-359]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-358]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-357]
    or eax, edx
    mov [rbp-296], eax
    movzx eax, byte [rbp-356]
    shl eax, 24
    movzx edx, byte [rbp-355]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-354]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-353]
    or eax, edx
    mov [rbp-292], eax
    movzx eax, byte [rbp-352]
    shl eax, 24
    movzx edx, byte [rbp-351]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-350]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-349]
    or eax, edx
    mov [rbp-288], eax
    movzx eax, byte [rbp-348]
    shl eax, 24
    movzx edx, byte [rbp-347]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-346]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-345]
    or eax, edx
    mov [rbp-284], eax
    movzx eax, byte [rbp-344]
    shl eax, 24
    movzx edx, byte [rbp-343]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-342]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-341]
    or eax, edx
    mov [rbp-280], eax
    movzx eax, byte [rbp-340]
    shl eax, 24
    movzx edx, byte [rbp-339]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-338]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-337]
    or eax, edx
    mov [rbp-276], eax
    movzx eax, byte [rbp-336]
    shl eax, 24
    movzx edx, byte [rbp-335]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-334]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-333]
    or eax, edx
    mov [rbp-272], eax
    movzx eax, byte [rbp-332]
    shl eax, 24
    movzx edx, byte [rbp-331]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-330]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-329]
    or eax, edx
    mov [rbp-268], eax
    movzx eax, byte [rbp-328]
    shl eax, 24
    movzx edx, byte [rbp-327]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-326]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-325]
    or eax, edx
    mov [rbp-264], eax
    movzx eax, byte [rbp-324]
    shl eax, 24
    movzx edx, byte [rbp-323]
    shl edx, 16
    or eax, edx
    movzx edx, byte [rbp-322]
    shl edx, 8
    or eax, edx
    movzx edx, byte [rbp-321]
    or eax, edx
    mov [rbp-260], eax
    mov eax, [rbp-316]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-264]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-320]
    add r10d, [rbp-284]
    add r10d, r11d
    mov [rbp-256], r10d
    mov eax, [rbp-312]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-260]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-316]
    add r10d, [rbp-280]
    add r10d, r11d
    mov [rbp-252], r10d
    mov eax, [rbp-308]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-256]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-312]
    add r10d, [rbp-276]
    add r10d, r11d
    mov [rbp-248], r10d
    mov eax, [rbp-304]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-252]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-308]
    add r10d, [rbp-272]
    add r10d, r11d
    mov [rbp-244], r10d
    mov eax, [rbp-300]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-248]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-304]
    add r10d, [rbp-268]
    add r10d, r11d
    mov [rbp-240], r10d
    mov eax, [rbp-296]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-244]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-300]
    add r10d, [rbp-264]
    add r10d, r11d
    mov [rbp-236], r10d
    mov eax, [rbp-292]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-240]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-296]
    add r10d, [rbp-260]
    add r10d, r11d
    mov [rbp-232], r10d
    mov eax, [rbp-288]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-236]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-292]
    add r10d, [rbp-256]
    add r10d, r11d
    mov [rbp-228], r10d
    mov eax, [rbp-284]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-232]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-288]
    add r10d, [rbp-252]
    add r10d, r11d
    mov [rbp-224], r10d
    mov eax, [rbp-280]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-228]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-284]
    add r10d, [rbp-248]
    add r10d, r11d
    mov [rbp-220], r10d
    mov eax, [rbp-276]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-224]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-280]
    add r10d, [rbp-244]
    add r10d, r11d
    mov [rbp-216], r10d
    mov eax, [rbp-272]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-220]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-276]
    add r10d, [rbp-240]
    add r10d, r11d
    mov [rbp-212], r10d
    mov eax, [rbp-268]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-216]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-272]
    add r10d, [rbp-236]
    add r10d, r11d
    mov [rbp-208], r10d
    mov eax, [rbp-264]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-212]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-268]
    add r10d, [rbp-232]
    add r10d, r11d
    mov [rbp-204], r10d
    mov eax, [rbp-260]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-208]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-264]
    add r10d, [rbp-228]
    add r10d, r11d
    mov [rbp-200], r10d
    mov eax, [rbp-256]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-204]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-260]
    add r10d, [rbp-224]
    add r10d, r11d
    mov [rbp-196], r10d
    mov eax, [rbp-252]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-200]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-256]
    add r10d, [rbp-220]
    add r10d, r11d
    mov [rbp-192], r10d
    mov eax, [rbp-248]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-196]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-252]
    add r10d, [rbp-216]
    add r10d, r11d
    mov [rbp-188], r10d
    mov eax, [rbp-244]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-192]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-248]
    add r10d, [rbp-212]
    add r10d, r11d
    mov [rbp-184], r10d
    mov eax, [rbp-240]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-188]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-244]
    add r10d, [rbp-208]
    add r10d, r11d
    mov [rbp-180], r10d
    mov eax, [rbp-236]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-184]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-240]
    add r10d, [rbp-204]
    add r10d, r11d
    mov [rbp-176], r10d
    mov eax, [rbp-232]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-180]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-236]
    add r10d, [rbp-200]
    add r10d, r11d
    mov [rbp-172], r10d
    mov eax, [rbp-228]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-176]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-232]
    add r10d, [rbp-196]
    add r10d, r11d
    mov [rbp-168], r10d
    mov eax, [rbp-224]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-172]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-228]
    add r10d, [rbp-192]
    add r10d, r11d
    mov [rbp-164], r10d
    mov eax, [rbp-220]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-168]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-224]
    add r10d, [rbp-188]
    add r10d, r11d
    mov [rbp-160], r10d
    mov eax, [rbp-216]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-164]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-220]
    add r10d, [rbp-184]
    add r10d, r11d
    mov [rbp-156], r10d
    mov eax, [rbp-212]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-160]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-216]
    add r10d, [rbp-180]
    add r10d, r11d
    mov [rbp-152], r10d
    mov eax, [rbp-208]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-156]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-212]
    add r10d, [rbp-176]
    add r10d, r11d
    mov [rbp-148], r10d
    mov eax, [rbp-204]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-152]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-208]
    add r10d, [rbp-172]
    add r10d, r11d
    mov [rbp-144], r10d
    mov eax, [rbp-200]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-148]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-204]
    add r10d, [rbp-168]
    add r10d, r11d
    mov [rbp-140], r10d
    mov eax, [rbp-196]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-144]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-200]
    add r10d, [rbp-164]
    add r10d, r11d
    mov [rbp-136], r10d
    mov eax, [rbp-192]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-140]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-196]
    add r10d, [rbp-160]
    add r10d, r11d
    mov [rbp-132], r10d
    mov eax, [rbp-188]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-136]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-192]
    add r10d, [rbp-156]
    add r10d, r11d
    mov [rbp-128], r10d
    mov eax, [rbp-184]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-132]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-188]
    add r10d, [rbp-152]
    add r10d, r11d
    mov [rbp-124], r10d
    mov eax, [rbp-180]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-128]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-184]
    add r10d, [rbp-148]
    add r10d, r11d
    mov [rbp-120], r10d
    mov eax, [rbp-176]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-124]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-180]
    add r10d, [rbp-144]
    add r10d, r11d
    mov [rbp-116], r10d
    mov eax, [rbp-172]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-120]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-176]
    add r10d, [rbp-140]
    add r10d, r11d
    mov [rbp-112], r10d
    mov eax, [rbp-168]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-116]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-172]
    add r10d, [rbp-136]
    add r10d, r11d
    mov [rbp-108], r10d
    mov eax, [rbp-164]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-112]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-168]
    add r10d, [rbp-132]
    add r10d, r11d
    mov [rbp-104], r10d
    mov eax, [rbp-160]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-108]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-164]
    add r10d, [rbp-128]
    add r10d, r11d
    mov [rbp-100], r10d
    mov eax, [rbp-156]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-104]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-160]
    add r10d, [rbp-124]
    add r10d, r11d
    mov [rbp-96], r10d
    mov eax, [rbp-152]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-100]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-156]
    add r10d, [rbp-120]
    add r10d, r11d
    mov [rbp-92], r10d
    mov eax, [rbp-148]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-96]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-152]
    add r10d, [rbp-116]
    add r10d, r11d
    mov [rbp-88], r10d
    mov eax, [rbp-144]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-92]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-148]
    add r10d, [rbp-112]
    add r10d, r11d
    mov [rbp-84], r10d
    mov eax, [rbp-140]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-88]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-144]
    add r10d, [rbp-108]
    add r10d, r11d
    mov [rbp-80], r10d
    mov eax, [rbp-136]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-84]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-140]
    add r10d, [rbp-104]
    add r10d, r11d
    mov [rbp-76], r10d
    mov eax, [rbp-132]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-80]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-136]
    add r10d, [rbp-100]
    add r10d, r11d
    mov [rbp-72], r10d
    mov eax, [rbp-128]
    mov r10d, eax
    ror r10d, 7
    mov r12d, eax
    ror r12d, 18
    xor r10d, r12d
    mov r12d, eax
    shr r12d, 3
    xor r10d, r12d
    mov eax, [rbp-76]
    mov r11d, eax
    ror r11d, 17
    mov r12d, eax
    ror r12d, 19
    xor r11d, r12d
    mov r12d, eax
    shr r12d, 10
    xor r11d, r12d
    add r10d, [rbp-132]
    add r10d, [rbp-96]
    add r10d, r11d
    mov [rbp-68], r10d
    mov eax, [rbp-64]
    mov ebx, [rbp-60]
    mov ecx, [rbp-56]
    mov edx, [rbp-52]
    mov esi, [rbp-48]
    mov edi, [rbp-44]
    mov r8d, [rbp-40]
    mov r9d, [rbp-36]
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1116352408
    add r10d, [rbp-320]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1899447441
    add r10d, [rbp-316]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3049323471
    add r10d, [rbp-312]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3921009573
    add r10d, [rbp-308]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 961987163
    add r10d, [rbp-304]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1508970993
    add r10d, [rbp-300]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2453635748
    add r10d, [rbp-296]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2870763221
    add r10d, [rbp-292]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3624381080
    add r10d, [rbp-288]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 310598401
    add r10d, [rbp-284]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 607225278
    add r10d, [rbp-280]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1426881987
    add r10d, [rbp-276]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1925078388
    add r10d, [rbp-272]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2162078206
    add r10d, [rbp-268]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2614888103
    add r10d, [rbp-264]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3248222580
    add r10d, [rbp-260]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3835390401
    add r10d, [rbp-256]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 4022224774
    add r10d, [rbp-252]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 264347078
    add r10d, [rbp-248]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 604807628
    add r10d, [rbp-244]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 770255983
    add r10d, [rbp-240]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1249150122
    add r10d, [rbp-236]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1555081692
    add r10d, [rbp-232]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1996064986
    add r10d, [rbp-228]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2554220882
    add r10d, [rbp-224]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2821834349
    add r10d, [rbp-220]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2952996808
    add r10d, [rbp-216]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3210313671
    add r10d, [rbp-212]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3336571891
    add r10d, [rbp-208]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3584528711
    add r10d, [rbp-204]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 113926993
    add r10d, [rbp-200]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 338241895
    add r10d, [rbp-196]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 666307205
    add r10d, [rbp-192]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 773529912
    add r10d, [rbp-188]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1294757372
    add r10d, [rbp-184]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1396182291
    add r10d, [rbp-180]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1695183700
    add r10d, [rbp-176]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1986661051
    add r10d, [rbp-172]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2177026350
    add r10d, [rbp-168]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2456956037
    add r10d, [rbp-164]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2730485921
    add r10d, [rbp-160]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2820302411
    add r10d, [rbp-156]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3259730800
    add r10d, [rbp-152]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3345764771
    add r10d, [rbp-148]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3516065817
    add r10d, [rbp-144]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3600352804
    add r10d, [rbp-140]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 4094571909
    add r10d, [rbp-136]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 275423344
    add r10d, [rbp-132]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 430227734
    add r10d, [rbp-128]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 506948616
    add r10d, [rbp-124]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 659060556
    add r10d, [rbp-120]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 883997877
    add r10d, [rbp-116]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 958139571
    add r10d, [rbp-112]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1322822218
    add r10d, [rbp-108]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1537002063
    add r10d, [rbp-104]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1747873779
    add r10d, [rbp-100]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 1955562222
    add r10d, [rbp-96]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2024104815
    add r10d, [rbp-92]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2227730452
    add r10d, [rbp-88]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2361852424
    add r10d, [rbp-84]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2428436474
    add r10d, [rbp-80]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 2756734187
    add r10d, [rbp-76]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3204031479
    add r10d, [rbp-72]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    mov r15d, r9d
    mov r10d, esi
    ror r10d, 6
    mov r11d, esi
    ror r11d, 11
    xor r10d, r11d
    mov r11d, esi
    ror r11d, 25
    xor r10d, r11d
    mov r11d, esi
    and r11d, edi
    mov r12d, esi
    not r12d
    and r12d, r8d
    xor r11d, r12d
    add r10d, r11d
    add r10d, r15d
    add r10d, 3329325298
    add r10d, [rbp-68]
    mov r11d, eax
    ror r11d, 2
    mov r12d, eax
    ror r12d, 13
    xor r11d, r12d
    mov r12d, eax
    ror r12d, 22
    xor r11d, r12d
    mov r12d, eax
    and r12d, ebx
    mov r13d, eax
    and r13d, ecx
    xor r12d, r13d
    mov r13d, ebx
    and r13d, ecx
    xor r12d, r13d
    add r11d, r12d
    mov r9d, r8d
    mov r8d, edi
    mov edi, esi
    mov esi, edx
    add esi, r10d
    mov edx, ecx
    mov ecx, ebx
    mov ebx, eax
    mov eax, r10d
    add eax, r11d
    add dword [rbp-64], eax
    add dword [rbp-60], ebx
    add dword [rbp-56], ecx
    add dword [rbp-52], edx
    add dword [rbp-48], esi
    add dword [rbp-44], edi
    add dword [rbp-40], r8d
    add dword [rbp-36], r9d
    inc r14
    jmp .sha_block_loop
.sha_finish:
    mov rdi, 72
    call arena_alloc
    test rax, rax
    jz sha_alloc_fail
    mov r12, rax
    mov qword [r12], 64
    lea r13, [rel sha_hex_digits]
    mov r10d, [rbp-64]
    mov ecx, 28
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+8], bl
    mov r10d, [rbp-64]
    mov ecx, 24
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+9], bl
    mov r10d, [rbp-64]
    mov ecx, 20
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+10], bl
    mov r10d, [rbp-64]
    mov ecx, 16
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+11], bl
    mov r10d, [rbp-64]
    mov ecx, 12
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+12], bl
    mov r10d, [rbp-64]
    mov ecx, 8
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+13], bl
    mov r10d, [rbp-64]
    mov ecx, 4
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+14], bl
    mov r10d, [rbp-64]
    mov ecx, 0
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+15], bl
    mov r10d, [rbp-60]
    mov ecx, 28
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+16], bl
    mov r10d, [rbp-60]
    mov ecx, 24
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+17], bl
    mov r10d, [rbp-60]
    mov ecx, 20
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+18], bl
    mov r10d, [rbp-60]
    mov ecx, 16
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+19], bl
    mov r10d, [rbp-60]
    mov ecx, 12
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+20], bl
    mov r10d, [rbp-60]
    mov ecx, 8
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+21], bl
    mov r10d, [rbp-60]
    mov ecx, 4
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+22], bl
    mov r10d, [rbp-60]
    mov ecx, 0
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+23], bl
    mov r10d, [rbp-56]
    mov ecx, 28
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+24], bl
    mov r10d, [rbp-56]
    mov ecx, 24
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+25], bl
    mov r10d, [rbp-56]
    mov ecx, 20
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+26], bl
    mov r10d, [rbp-56]
    mov ecx, 16
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+27], bl
    mov r10d, [rbp-56]
    mov ecx, 12
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+28], bl
    mov r10d, [rbp-56]
    mov ecx, 8
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+29], bl
    mov r10d, [rbp-56]
    mov ecx, 4
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+30], bl
    mov r10d, [rbp-56]
    mov ecx, 0
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+31], bl
    mov r10d, [rbp-52]
    mov ecx, 28
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+32], bl
    mov r10d, [rbp-52]
    mov ecx, 24
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+33], bl
    mov r10d, [rbp-52]
    mov ecx, 20
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+34], bl
    mov r10d, [rbp-52]
    mov ecx, 16
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+35], bl
    mov r10d, [rbp-52]
    mov ecx, 12
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+36], bl
    mov r10d, [rbp-52]
    mov ecx, 8
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+37], bl
    mov r10d, [rbp-52]
    mov ecx, 4
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+38], bl
    mov r10d, [rbp-52]
    mov ecx, 0
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+39], bl
    mov r10d, [rbp-48]
    mov ecx, 28
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+40], bl
    mov r10d, [rbp-48]
    mov ecx, 24
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+41], bl
    mov r10d, [rbp-48]
    mov ecx, 20
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+42], bl
    mov r10d, [rbp-48]
    mov ecx, 16
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+43], bl
    mov r10d, [rbp-48]
    mov ecx, 12
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+44], bl
    mov r10d, [rbp-48]
    mov ecx, 8
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+45], bl
    mov r10d, [rbp-48]
    mov ecx, 4
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+46], bl
    mov r10d, [rbp-48]
    mov ecx, 0
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+47], bl
    mov r10d, [rbp-44]
    mov ecx, 28
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+48], bl
    mov r10d, [rbp-44]
    mov ecx, 24
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+49], bl
    mov r10d, [rbp-44]
    mov ecx, 20
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+50], bl
    mov r10d, [rbp-44]
    mov ecx, 16
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+51], bl
    mov r10d, [rbp-44]
    mov ecx, 12
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+52], bl
    mov r10d, [rbp-44]
    mov ecx, 8
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+53], bl
    mov r10d, [rbp-44]
    mov ecx, 4
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+54], bl
    mov r10d, [rbp-44]
    mov ecx, 0
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+55], bl
    mov r10d, [rbp-40]
    mov ecx, 28
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+56], bl
    mov r10d, [rbp-40]
    mov ecx, 24
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+57], bl
    mov r10d, [rbp-40]
    mov ecx, 20
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+58], bl
    mov r10d, [rbp-40]
    mov ecx, 16
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+59], bl
    mov r10d, [rbp-40]
    mov ecx, 12
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+60], bl
    mov r10d, [rbp-40]
    mov ecx, 8
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+61], bl
    mov r10d, [rbp-40]
    mov ecx, 4
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+62], bl
    mov r10d, [rbp-40]
    mov ecx, 0
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+63], bl
    mov r10d, [rbp-36]
    mov ecx, 28
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+64], bl
    mov r10d, [rbp-36]
    mov ecx, 24
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+65], bl
    mov r10d, [rbp-36]
    mov ecx, 20
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+66], bl
    mov r10d, [rbp-36]
    mov ecx, 16
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+67], bl
    mov r10d, [rbp-36]
    mov ecx, 12
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+68], bl
    mov r10d, [rbp-36]
    mov ecx, 8
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+69], bl
    mov r10d, [rbp-36]
    mov ecx, 4
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+70], bl
    mov r10d, [rbp-36]
    mov ecx, 0
    shr r10d, cl
    and r10d, 15
    mov bl, [r13+r10]
    mov byte [r12+71], bl
    mov rax, r12
    jmp sha_done
sha_null_fail:
    mov rdi, 26
    call arena_alloc
    test rax, rax
    jz sha_zero_fail
    mov qword [rax], 18
    mov byte [rax + 8], 65
    mov byte [rax + 9], 66
    mov byte [rax + 10], 83
    mov byte [rax + 11], 84
    mov byte [rax + 12], 65
    mov byte [rax + 13], 73
    mov byte [rax + 14], 78
    mov byte [rax + 15], 58
    mov byte [rax + 16], 32
    mov byte [rax + 17], 78
    mov byte [rax + 18], 85
    mov byte [rax + 19], 76
    mov byte [rax + 20], 76
    mov byte [rax + 21], 95
    mov byte [rax + 22], 84
    mov byte [rax + 23], 69
    mov byte [rax + 24], 88
    mov byte [rax + 25], 84
    jmp sha_done
sha_long_fail:
    mov rdi, 39
    call arena_alloc
    test rax, rax
    jz sha_zero_fail
    mov qword [rax], 31
    mov byte [rax + 8], 65
    mov byte [rax + 9], 66
    mov byte [rax + 10], 83
    mov byte [rax + 11], 84
    mov byte [rax + 12], 65
    mov byte [rax + 13], 73
    mov byte [rax + 14], 78
    mov byte [rax + 15], 58
    mov byte [rax + 16], 32
    mov byte [rax + 17], 69
    mov byte [rax + 18], 88
    mov byte [rax + 19], 67
    mov byte [rax + 20], 69
    mov byte [rax + 21], 69
    mov byte [rax + 22], 68
    mov byte [rax + 23], 83
    mov byte [rax + 24], 95
    mov byte [rax + 25], 77
    mov byte [rax + 26], 65
    mov byte [rax + 27], 88
    mov byte [rax + 28], 95
    mov byte [rax + 29], 84
    mov byte [rax + 30], 69
    mov byte [rax + 31], 88
    mov byte [rax + 32], 84
    mov byte [rax + 33], 95
    mov byte [rax + 34], 66
    mov byte [rax + 35], 89
    mov byte [rax + 36], 84
    mov byte [rax + 37], 69
    mov byte [rax + 38], 83
    jmp sha_done
sha_alloc_fail:
    mov rdi, 35
    call arena_alloc
    test rax, rax
    jz sha_zero_fail
    mov qword [rax], 27
    mov byte [rax + 8], 65
    mov byte [rax + 9], 66
    mov byte [rax + 10], 83
    mov byte [rax + 11], 84
    mov byte [rax + 12], 65
    mov byte [rax + 13], 73
    mov byte [rax + 14], 78
    mov byte [rax + 15], 58
    mov byte [rax + 16], 32
    mov byte [rax + 17], 65
    mov byte [rax + 18], 82
    mov byte [rax + 19], 69
    mov byte [rax + 20], 78
    mov byte [rax + 21], 65
    mov byte [rax + 22], 95
    mov byte [rax + 23], 65
    mov byte [rax + 24], 76
    mov byte [rax + 25], 76
    mov byte [rax + 26], 79
    mov byte [rax + 27], 67
    mov byte [rax + 28], 95
    mov byte [rax + 29], 70
    mov byte [rax + 30], 65
    mov byte [rax + 31], 73
    mov byte [rax + 32], 76
    mov byte [rax + 33], 69
    mov byte [rax + 34], 68
    jmp sha_done
sha_zero_fail:
    xor eax, eax
    jmp sha_done
sha_done:
    add rsp, 1032
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
section .rodata
sha_hex_digits: db '0123456789abcdef'
section .text

