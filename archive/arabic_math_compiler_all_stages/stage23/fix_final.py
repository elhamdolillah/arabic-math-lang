#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""إصلاح نهائي: إزالة الكود الميت لدوال الملفات وإدخالها في المكان الصحيح"""

with open('math_complete.py', 'r', encoding='utf-8') as f:
    c = f.read()

# 1) إزالة الكود الميت: كل شيء من أول "if اسم=="اكتب_ملف":" الميت (بعد نص return)
#    حتى نهاية كتلة اختم الميتة
dead_start = c.find('        if اسم=="اكتب_ملف":\n            if len(args)!=2: raise Exception("اكتب_ملف تأخذ وسيطين")\n            code=compile_expr(args[0],env,funcs,env_layout)')
dead_end = c.find('    if ن=="استدعاء" and expr[1]=="نص_رمز":', dead_start)
if dead_start < 0 or dead_end < 0:
    raise SystemExit('لم أجد الكود الميت لإزالته')
dead = c[dead_start:dead_end]
c = c[:dead_start] + c[dead_end:]
print(f'✅ أُزيل كود ميت بطول {len(dead)} حرف')

# 2) إزالة كتلة فتح الميتة إن بقيت (قبل args loop) — ابحث عنها في موقع args loop
# أولاً: أزل أي كتل دوال ملفات موجودة الآن (فتح/اكتب/اقرأ/اختم) ثم أدخلها نظيفة
import re
funcs_patterns = [
    ('فتح', '        if اسم=="فتح":\n'),
    ('اكتب_ملف', '        if اسم=="اكتب_ملف":\n'),
    ('اقرأ_ملف', '        if اسم=="اقرأ_ملف":\n'),
    ('اختم', '        if اسم=="اختم":\n'),
]
removed_any = False
for name, marker in funcs_patterns:
    while marker in c:
        idx = c.find(marker)
        # تأكد أنها داخل compile_expr (بعد def compile_expr وقبل def compile_stmt)
        if c.rfind('def compile_expr', 0, idx) > c.rfind('def compile_stmt', 0, idx):
            # ابحث عن نهاية الكتلة: "            ]\n            return code\n"
            e = c.find('            ]\n            return code\n', idx)
            if e >= 0:
                e += len('            ]\n            return code\n')
                c = c[:idx] + c[e:]
                removed_any = True
            else:
                break
        else:
            break
print(f'✅ أُزيلت الكتل الموجودة سابقاً: {removed_any}')

# 3) الإدخال الصحيح: قبل حلقة args في استدعاء الدوال المعرفة
anchor = '''        for j in range(len(args)-1,-1,-1):
            if j<len(ARG_REGS): code.append(f"    pop {ARG_REGS[j]}")
'''
if anchor not in c:
    raise SystemExit('لم أجد مرساة الإدراج')

funcs_block = '''        # ═══ دوال الملفات (syscalls خام: فتح/اكتب_ملف/اقرأ_ملف/اختم) ═══
        if اسم=="فتح":
            if len(args)!=1: raise Exception("فتح تأخذ وسيطاً واحداً")
            _counters["copy"]+=1; k=_counters["copy"]
            code=compile_expr(args[0],env,funcs,env_layout)
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
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs,env_layout))
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
            code=compile_expr(args[0],env,funcs,env_layout)
            code.append("    push rax")
            code.extend(compile_expr(args[1],env,funcs,env_layout))
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
            code=compile_expr(args[0],env,funcs,env_layout)
            code += [
                "    push rcx",
                "    mov rax, 3",
                "    syscall",
                "    pop rcx",
            ]
            return code
'''
c = c.replace(anchor, funcs_block + anchor, 1)
print('✅ تم إدخال دوال الملفات في المكان الصحيح (قبل حلقة args)')

with open('math_complete.py', 'w', encoding='utf-8') as f:
    f.write(c)

# تحقق سريع من البنية: عددOccurrences
import re as _re
for name in ['فتح','اكتب_ملف','اقرأ_ملف','اختم']:
    cnt = c.count(f'if اسم=="{name}":')
    print(f'  {name}: {cnt} ظهور')
