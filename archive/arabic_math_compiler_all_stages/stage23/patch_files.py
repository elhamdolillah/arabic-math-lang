#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""إضافة دعم دوال الملفات إلى math_complete.py (فتح/اقرأ_ملف/اكتب_ملف/اختم)"""

funcs = '''
        # ═══ دوال الملفات (syscalls خام) ═══
        if اسم=="فتح":
            if len(args)!=1: raise Exception("فتح تأخذ وسيطاً واحداً")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs)
            code += [
                "    mov rcx, [rax]",
                "    lea rsi, [rax + 8]",
                "    lea rdi, [file_path_buf]",
                f".fp_c_{k}:",
                "    test rcx, rcx",
                f"    jz .fp_d_{k}",
                "    mov al, [rsi]",
                "    mov [rdi], al",
                "    inc rsi",
                "    inc rdi",
                "    dec rcx",
                f"    jmp .fp_c_{k}",
                f".fp_d_{k}:",
                "    mov byte [rdi], 0",
                "    lea rdi, [file_path_buf]",
                "    mov rsi, 577",
                "    mov rdx, 420",
                "    mov rax, 2",
                "    push rcx",
                "    syscall",
                "    pop rcx",
            ]
            return code
        if اسم=="اكتب_ملف":
            if len(args)!=2: raise Exception("اكتب_ملف تأخذ وسيطين")
            code=compile_expr(args[0],env,funcs)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs))
            code += [
                "    mov rdx, [rax]",
                "    lea rsi, [rax + 8]",
                "    pop rdi",
                "    push rcx",
                "    mov rax, 1",
                "    syscall",
                "    pop rcx",
                "    mov rax, rdx",
            ]
            return code
        if اسم=="اقرأ_ملف":
            if len(args)!=2: raise Exception("اقرأ_ملف تأخذ وسيطين")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs))
            code += [
                "    mov rdx, rax",
                "    pop rdi",
                "    lea rsi, [file_buf]",
                "    push rcx",
                "    mov rax, 0",
                "    syscall",
                "    pop rcx",
                "    mov rcx, rax",
                "    mov rdi, rax",
                "    add rdi, 8",
                "    call arena_alloc",
                "    mov [rax], rcx",
                "    push rax",
                "    lea rsi, [file_buf]",
                "    lea rdi, [rax + 8]",
                "    mov rdx, rcx",
                f".fr_c_{k}:",
                "    test rdx, rdx",
                f"    jz .fr_d_{k}",
                "    mov cl, [rsi]",
                "    mov [rdi], cl",
                "    inc rsi",
                "    inc rdi",
                "    dec rdx",
                f"    jmp .fr_c_{k}",
                f".fr_d_{k}:",
                "    pop rax",
            ]
            return code
        if اسم=="اختم":
            if len(args)!=1: raise Exception("اختم تأخذ وسيطاً واحداً")
            code=compile_expr(args[0],env,funcs)
            code += [
                "    push rcx",
                "    mov rax, 3",
                "    syscall",
                "    pop rcx",
            ]
            return code
'''

with open('math_complete.py', 'r', encoding='utf-8') as f:
    c = f.read()

if 'if اسم=="فتح":' in c and 'mov rax, 2' in c:
    print('✅ دوال الملفات موجودة بالفعل في math_complete.py')
else:
    # نقطة الإدراج: بعد كتلة نص_رمز في compile_call (البحث عبر return code)
    idx = c.find('if اسم=="نص_رمز":')
    if idx >= 0:
        end = c.find('return code', idx)
        if end >= 0:
            end += len('return code')
            c = c[:end] + funcs + c[end:]
            with open('math_complete.py', 'w', encoding='utf-8') as f:
                f.write(c)
            print('✅ تم إضافة دوال الملفات (فتح، اكتب_ملف، اقرأ_ملف، اختم) بعد كتلة نص_رمز')
        else:
            print('❌ لم أجد return code بعد نص_رمز')
    else:
        print('❌ لم أجد كتلة نص_رمز')
