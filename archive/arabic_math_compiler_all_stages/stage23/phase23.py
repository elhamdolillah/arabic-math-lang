#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 23: الملفات — ﴿اقرأ باسم ربك الذي خلق﴾
الدستور القرآني:
  فتح   ← ﴿إنا فتحنا لك فتحاً مبيناً﴾
  اقرأ  ← ﴿اقرأ باسم ربك الذي خلق﴾
  اكتب  ← ﴿ن والقلم وما يسطرون﴾
  اختم  ← ﴿ختم الله على قلوبهم﴾
"""
import sys, subprocess, os
sys.path.insert(0, '.')

# ═══════════════════════════════════════════════════════════
# الخطوة 1: تحديث math_complete.py
# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 23: الملفات — ﴿اقرأ باسم ربك الذي خلق﴾")
print("=" * 70)

print("\n🔧 الخطوة 1: تحديث math_complete.py...")

with open('math_complete.py', 'r', encoding='utf-8') as f:
    lines = f.readlines()

content = ''.join(lines)
if 'if اسم=="فتح": return "عدد"' in content and 'if اسم=="اكتب_ملف":' in content:
    print("⚠️ الدوال موجودة بالفعل")
else:
    new_lines = []
    added_types = False
    added_funcs = False
    in_close_func = False

    for i, line in enumerate(lines):
        new_lines.append(line)

        # إضافة الأنواع في استنتاج_نوع
        if not added_types and 'if اسم=="نص_رمز": return "نص"' in line:
            new_lines.append('        if اسم=="فتح": return "عدد"\n')
            new_lines.append('        if اسم=="اقرأ_ملف": return "نص"\n')
            new_lines.append('        if اسم=="اكتب_ملف": return "عدد"\n')
            new_lines.append('        if اسم=="اختم": return "عدد"\n')
            added_types = True
            print("  ✅ تم إضافة أنواع الملفات")

        # إضافة file_buf في section .bss
        if '"    arena_ptr resq 1"' in line and 'file_buf' not in content:
            idx = len(new_lines) - 1
            new_lines.insert(idx, '         "    file_buf resb 4096",\n')
            new_lines.insert(idx, '         "    file_path_buf resb 256",\n')
            print("  ✅ تم إضافة file_buf و file_path_buf")

        # إضافة دوال الملفات بعد قسم اختم
        if 'if اسم=="اختم":' in line:
            in_close_func = True

        if in_close_func and 'return code' in line and not added_funcs:
            in_close_func = False
            added_funcs = True

            # فتح
            new_lines.append('        if اسم=="فتح":\n')
            new_lines.append('            if len(args)!=1: raise Exception("فتح تأخذ وسيطاً واحداً")\n')
            new_lines.append('            _counters["copy"]+=1; k=_counters["copy"]\n')
            new_lines.append('            code=compile_expr(args[0],env,funcs,env_layout)\n')
            new_lines.append('            code += [\n')
            new_lines.append('                "    mov rcx, [rax]",\n')
            new_lines.append('                "    lea rsi, [rax + 8]",\n')
            new_lines.append('                "    lea rdi, [file_path_buf]",\n')
            new_lines.append('                f".fp_c_{k}:",\n')
            new_lines.append('                "    test rcx, rcx",\n')
            new_lines.append('                f"    jz .fp_d_{k}",\n')
            new_lines.append('                "    mov al, [rsi]",\n')
            new_lines.append('                "    mov [rdi], al",\n')
            new_lines.append('                "    inc rsi",\n')
            new_lines.append('                "    inc rdi",\n')
            new_lines.append('                "    dec rcx",\n')
            new_lines.append('                f"    jmp .fp_c_{k}",\n')
            new_lines.append('                f".fp_d_{k}:",\n')
            new_lines.append('                "    mov byte [rdi], 0",\n')
            new_lines.append('                "    lea rdi, [file_path_buf]",\n')
            new_lines.append('                "    mov rsi, 577",\n')
            new_lines.append('                "    mov rdx, 420",\n')
            new_lines.append('                "    mov rax, 2",\n')
            new_lines.append('                "    syscall",\n')
            new_lines.append('            ]\n')
            new_lines.append('            return code\n')

            # اكتب_ملف
            new_lines.append('        if اسم=="اكتب_ملف":\n')
            new_lines.append('            if len(args)!=2: raise Exception("اكتب_ملف تأخذ وسيطين")\n')
            new_lines.append('            code=compile_expr(args[0],env,funcs,env_layout)\n')
            new_lines.append('            code.append("    push rax")\n')
            new_lines.append('            code.extend(compile_expr(args[1],env,funcs,env_layout))\n')
            new_lines.append('            code += [\n')
            new_lines.append('                "    mov rdx, [rax]",\n')
            new_lines.append('                "    lea rsi, [rax + 8]",\n')
            new_lines.append('                "    pop rdi",\n')
            new_lines.append('                "    mov rax, 1",\n')
            new_lines.append('                "    syscall",\n')
            new_lines.append('            ]\n')
            new_lines.append('            return code\n')

            # اقرأ_ملف
            new_lines.append('        if اسم=="اقرأ_ملف":\n')
            new_lines.append('            if len(args)!=2: raise Exception("اقرأ_ملف تأخذ وسيطين")\n')
            new_lines.append('            _counters["copy"]+=1; k=_counters["copy"]\n')
            new_lines.append('            code=compile_expr(args[0],env,funcs,env_layout)\n')
            new_lines.append('            code.append("    push rax")\n')
            new_lines.append('            code.extend(compile_expr(args[1],env,funcs,env_layout))\n')
            new_lines.append('            code += [\n')
            new_lines.append('                "    mov rdx, rax",\n')
            new_lines.append('                "    pop rdi",\n')
            new_lines.append('                "    lea rsi, [file_buf]",\n')
            new_lines.append('                "    mov rax, 0",\n')
            new_lines.append('                "    syscall",\n')
            new_lines.append('                "    mov rcx, rax",\n')
            new_lines.append('                "    mov rdi, rax",\n')
            new_lines.append('                "    add rdi, 8",\n')
            new_lines.append('                "    call arena_alloc",\n')
            new_lines.append('                "    mov [rax], rcx",\n')
            new_lines.append('                "    push rax",\n')
            new_lines.append('                "    lea rsi, [file_buf]",\n')
            new_lines.append('                "    lea rdi, [rax + 8]",\n')
            new_lines.append('                "    mov rdx, rcx",\n')
            new_lines.append('                f".fr_c_{k}:",\n')
            new_lines.append('                "    test rdx, rdx",\n')
            new_lines.append('                f"    jz .fr_d_{k}",\n')
            new_lines.append('                "    mov cl, [rsi]",\n')
            new_lines.append('                "    mov [rdi], cl",\n')
            new_lines.append('                "    inc rsi",\n')
            new_lines.append('                "    inc rdi",\n')
            new_lines.append('                "    dec rdx",\n')
            new_lines.append('                f"    jmp .fr_c_{k}",\n')
            new_lines.append('                f".fr_d_{k}:",\n')
            new_lines.append('                "    pop rax",\n')
            new_lines.append('            ]\n')
            new_lines.append('            return code\n')

            print("  ✅ تم إضافة دوال الملفات (فتح، اكتب_ملف، اقرأ_ملف)")

    with open('math_complete.py', 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    print("✅ تم تحديث math_complete.py")

# ═══════════════════════════════════════════════════════════
# الخطوة 2: اختبارات الملفات
# ═══════════════════════════════════════════════════════════
print("\n🧪 الخطوة 2: اختبارات الملفات...")

from math_complete import *

failed = 0

# اختبار 1: كتابة ملف
print("\n  اختبار 1: فتح + اكتب + اختم")
برنامج_كتابة = """ملف ≔ فتح("test_23.txt")
اكتب_ملف(ملف، "بسم الله الرحمن الرحيم")
اكتب_ملف(ملف، "الحمد لله رب العالمين")
اختم(ملف)
⎕ "تم الكتابة"
"""

ر = حلل_رموز(برنامج_كتابة)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('file_w.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'file_w.asm', '-o', 'file_w.o'], check=True)
subprocess.run(['ld', 'file_w.o', '-o', 'file_w'], check=True)
result = subprocess.run(['./file_w'], capture_output=True, text=True)
out = result.stdout.strip()

if os.path.exists('test_23.txt'):
    with open('test_23.txt', 'r') as f:
        content = f.read()
    if 'بسم الله الرحمن الرحيم' in content and 'الحمد لله رب العالمين' in content:
        print(f"  ✅ تم كتابة الملف بنجاح")
        print(f"     المحتوى: {content.strip()}")
    else:
        print(f"  ❌ المحتوى غير صحيح: {content}")
        failed += 1
else:
    print("  ❌ لم يتم إنشاء الملف")
    failed += 1

# اختبار 2: قراءة ملف
print("\n  اختبار 2: فتح + اقرأ + اختم")
برنامج_قراءة = """ملف ≔ فتح("test_23.txt")
محتوى ≔ اقرأ_ملف(ملف، 4096)
اختم(ملف)
⎕ محتوى
"""

ر = حلل_رموز(برنامج_قراءة)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('file_r.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'file_r.asm', '-o', 'file_r.o'], check=True)
subprocess.run(['ld', 'file_r.o', '-o', 'file_r'], check=True)
result = subprocess.run(['./file_r'], capture_output=True, text=True)
out = result.stdout.strip()

if 'بسم الله الرحمن الرحيم' in out:
    print(f"  ✅ تم قراءة الملف بنجاح")
    print(f"     المحتوى: {out[:50]}...")
else:
    print(f"  ❌ القراءة غير صحيحة: {out[:50]}")
    failed += 1

# اختبار 3: كتابة ثم قراءة
print("\n  اختبار 3: كتابة ثم قراءة (دورة كاملة)")
برنامج_دورة = """ملف ≔ فتح("test_cycle.txt")
اكتب_ملف(ملف، "السلام عليكم ورحمة الله")
اختم(ملف)
ملف ≔ فتح("test_cycle.txt")
محتوى ≔ اقرأ_ملف(ملف، 4096)
اختم(ملف)
⎕ محتوى
"""

ر = حلل_رموز(برنامج_دورة)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('file_c.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'file_c.asm', '-o', 'file_c.o'], check=True)
subprocess.run(['ld', 'file_c.o', '-o', 'file_c'], check=True)
result = subprocess.run(['./file_c'], capture_output=True, text=True)
out = result.stdout.strip()

if 'السلام عليكم ورحمة الله' in out:
    print(f"  ✅ الدورة الكاملة تعمل: {out}")
else:
    print(f"  ❌ الدورة الكاملة فشلت: {out}")
    failed += 1

# اختبار 4: كتابة أرقام
print("\n  اختبار 4: كتابة أرقام")
برنامج_أرقام = """ملف ≔ فتح("test_nums.txt")
اكتب_ملف(ملف، نص(42))
اكتب_ملف(ملف، " ")
اكتب_ملف(ملف، نص(123))
اختم(ملف)
ملف ≔ فتح("test_nums.txt")
محتوى ≔ اقرأ_ملف(ملف، 4096)
اختم(ملف)
⎕ محتوى
"""

ر = حلل_رموز(برنامج_أرقام)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('file_n.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'file_n.asm', '-o', 'file_n.o'], check=True)
subprocess.run(['ld', 'file_n.o', '-o', 'file_n'], check=True)
result = subprocess.run(['./file_n'], capture_output=True, text=True)
out = result.stdout.strip()

if '42' in out and '123' in out:
    print(f"  ✅ كتابة وقراءة الأرقام تعمل: {out}")
else:
    print(f"  ❌ الأرقام غير صحيحة: {out}")
    failed += 1

# ═══════════════════════════════════════════════════════════
# الملخص
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("📖 الدستور القرآني المطبق:")
print("   ﴿إنا فتحنا لك فتحاً مبيناً﴾ — فتح الملف")
print("   ﴿اقرأ باسم ربك الذي خلق﴾ — قراءة الملف")
print("   ﴿ن والقلم وما يسطرون﴾ — كتابة الملف")
print("   ﴿ختم الله على قلوبهم﴾ — إغلاق الملف")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 23 نجحت!")
    print(f"   لغتنا العربية تدعم الملفات:")
    print(f"   - فتح (fopen)")
    print(f"   - اقرأ_ملف (fread)")
    print(f"   - اكتب_ملف (fwrite)")
    print(f"   - اختم (fclose)")
    print(f"\n   الخطوة التالية: المرحلة 24 — هياكل البيانات (بنيان)")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)