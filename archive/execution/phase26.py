#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 26: الشبكة (عروة)
الدستور: ﴿فمن يكفر بالطاغوت ويؤمن بالله فقد استمسك بالعروة الوثقى﴾
"""
import sys, subprocess, os
sys.path.insert(0, '.')

# ═══════════════════════════════════════════════════════════
# الخطوة 1: تحديث math_complete.py — إضافة عروة()
# ═══════════════════════════════════════════════════════════
print("=" * 70)
print("المرحلة 26: الشبكة (عروة)")
print("الدستور: ﴿فقد استمسك بالعروة الوثقى﴾")
print("=" * 70)

print("\n🔧 الخطوة 1: تحديث math_complete.py...")

with open('math_complete.py', 'r', encoding='utf-8') as f:
    lines = f.readlines()

content = ''.join(lines)
if 'عروة' in content:
    print("⚠️ عروة موجودة بالفعل")
else:
    new_lines = []
    added_type = False
    added_func = False
    in_open_func = False

    for i, line in enumerate(lines):
        new_lines.append(line)

        # إضافة نوع عروة في استنتاج_نوع
        if not added_type and 'if اسم=="فتح": return "عدد"' in line:
            new_lines.append('        if اسم=="عروة": return "عدد"\n')
            added_type = True
            print("  ✅ تم إضافة نوع عروة")

        # إضافة كود عروة بعد قسم فتح
        if 'if اسم=="فتح":' in line:
            in_open_func = True

        if in_open_func and 'return code' in line and not added_func:
            in_open_func = False
            added_func = True

            new_lines.append('        if اسم=="عروة":\n')
            new_lines.append('            code = [\n')
            new_lines.append('                "    mov rdi, 2",\n')
            new_lines.append('                "    mov rsi, 1",\n')
            new_lines.append('                "    mov rdx, 0",\n')
            new_lines.append('                "    mov rax, 41",\n')
            new_lines.append('                "    syscall",\n')
            new_lines.append('            ]\n')
            new_lines.append('            return code\n')
            print("  ✅ تم إضافة كود عروة (sys_socket)")

    with open('math_complete.py', 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    print("✅ تم تحديث math_complete.py")

# ═══════════════════════════════════════════════════════════
# الخطوة 2: اختبارات الشبكة
# ═══════════════════════════════════════════════════════════
print("\n🧪 الخطوة 2: اختبارات الشبكة...")

from math_complete import *

failed = 0

# ─────────────────────────────────────────────────────────
# اختبار 1: إنشاء عروة (socket)
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 1: إنشاء عروة (﴿استمسك بالعروة الوثقى﴾)")
برنامج_عروة = """ع ≔ عروة()
⎕ "Socket fd: " ⊕ نص(ع)
"""

ر = حلل_رموز(برنامج_عروة)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('net1.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'net1.asm', '-o', 'net1.o'], check=True)
subprocess.run(['ld', 'net1.o', '-o', 'net1'], check=True)
result = subprocess.run(['./net1'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

# fd يجب أن يكون ≥ 3 (0=stdin, 1=stdout, 2=stderr)
if "Socket fd:" in out:
    try:
        fd = int(out.split("Socket fd:")[1].strip())
        if fd >= 3:
            print(f"  ✅ عروة أُنشئت بنجاح! fd={fd}")
        else:
            print(f"  ⚠️ fd={fd} (قد يكون خطأ)")
            failed += 1
    except:
        print("  ⚠️ لم يمكن تحليل fd")
        failed += 1
else:
    print("  ❌ فشل إنشاء العروة")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 2: إنشاء عروة + إغلاقها
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 2: عروة + اختم (﴿واعتصموا بحبل الله﴾)")
برنامج_إغلاق = """ع ≔ عروة()
⎕ "Socket fd: " ⊕ نص(ع)
اختم(ع)
⎕ "تم إغلاق العروة"
"""

ر = حلل_رموز(برنامج_إغلاق)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('net2.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'net2.asm', '-o', 'net2.o'], check=True)
subprocess.run(['ld', 'net2.o', '-o', 'net2'], check=True)
result = subprocess.run(['./net2'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "تم إغلاق العروة" in out:
    print("  ✅ عروة + اختم تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 3: إنشاء عدة عرى
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 3: عدة عرى (﴿واعتصموا بحبل الله جميعاً﴾)")
برنامج_متعدد = """ع١ ≔ عروة()
ع٢ ≔ عروة()
ع٣ ≔ عروة()
⎕ "العروة 1: " ⊕ نص(ع١)
⎕ "العروة 2: " ⊕ نص(ع٢)
⎕ "العروة 3: " ⊕ نص(ع٣)
اختم(ع١)
اختم(ع٢)
اختم(ع٣)
⎕ "تم إغلاق جميع العرى"
"""

ر = حلل_رموز(برنامج_متعدد)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('net3.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'net3.asm', '-o', 'net3.o'], check=True)
subprocess.run(['ld', 'net3.o', '-o', 'net3'], check=True)
result = subprocess.run(['./net3'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج:\n{out}")

if "تم إغلاق جميع العرى" in out:
    print("  ✅ عدة عرى تعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ─────────────────────────────────────────────────────────
# اختبار 4: عروة + ملفات (تكامل المراحل)
# ─────────────────────────────────────────────────────────
print("\n🧪 اختبار 4: تكامل المراحل 23-26 (﴿وكل شيء أحصيناه كتاباً﴾)")
برنامج_تكامل = """ع ≔ عروة()
ملف ≔ فتح("network_log.txt")
اكتب_ملف(ملف، "Socket fd: ")
اكتب_ملف(ملف، نص(ع))
اكتب_ملف(ملف، " ")
اكتب_ملف(ملف، "Status: created")
اختم(ملف)
اختم(ع)
ملف ≔ فتح("network_log.txt")
محتوى ≔ اقرأ_ملف(ملف، 4096)
اختم(ملف)
⎕ محتوى
"""

ر = حلل_رموز(برنامج_تكامل)
ب = حلل_برنامج(ر)
asm = compile_program(ب)
with open('net4.asm', 'w') as f:
    f.write(asm)
subprocess.run(['nasm', '-f', 'elf64', 'net4.asm', '-o', 'net4.o'], check=True)
subprocess.run(['ld', 'net4.o', '-o', 'net4'], check=True)
result = subprocess.run(['./net4'], capture_output=True, text=True)
out = result.stdout.strip()
print(f"  الخرج: {out}")

if "Socket fd:" in out and "Status: created" in out:
    print("  ✅ تكامل المراحل يعمل!")
else:
    print("  ❌ فشل")
    failed += 1

# ═══════════════════════════════════════════════════════════
# الملخص
# ═══════════════════════════════════════════════════════════
print("\n" + "=" * 70)
print("📖 الدستور القرآني المطبق:")
print("   ﴿فقد استمسك بالعروة الوثقى﴾ — إنشاء socket")
print("   ﴿واعتصموا بحبل الله جميعاً﴾ — عدة عرى")
print("   ﴿ختم الله على قلوبهم﴾ — إغلاق socket")
print("   ﴿وكل شيء أحصيناه كتاباً﴾ — تسجيل في ملفات")

print("\n" + "=" * 70)
if failed == 0:
    print(f"🎉 المرحلة 26 نجحت!")
    print(f"   لغتنا العربية تدعم الشبكة (عروة):")
    print(f"   - عروة() → socket(AF_INET, SOCK_STREAM)")
    print(f"   - اختم(fd) → close(fd)")
    print(f"   - تكامل مع الملفات (المرحلة 23)")
    print(f"\n   الخطوة التالية: المرحلة 27 — عمليات القوائم (اختر، رتب، صنف)")
else:
    print(f"❌ فشل {failed} اختبار")
    sys.exit(1)