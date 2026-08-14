#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 45 — أرض: المخصّص الديناميكي (mmap قابل للنمو)
==========================================================
مكيّف على النسخة الحالية من math_complete.py (الخط الأساس من GitHub).

التصحيحات الثلاثة:
  1. قسم .bss — إزالة arena_mem الثابتة، إضافة arena_base/limit/chunk_size
  2. _start — حجز أول قطعة 1MB عبر mmap بدل lea arena_mem
  3. arena_alloc — bump allocator بحد ثابت → نمو حقيقي عبر mmap عند الامتلاء

الإصلاح الحاسم (GDB): في slow path يجب ألّا يُستعاد المؤشر القديم إلى rax
قبل mov [arena_ptr],rax — بل يبقى rax = ناتج mmap مباشرة.

الاستعمال:
  python3 apply_stage45.py
يُنتج: math_complete_stage45.py + stage45_stress
المتوقع: طول=2000 ثم مجموع=2001000
"""
import sys
import subprocess
import pathlib

SRC = pathlib.Path("math_complete.py")
OUT = pathlib.Path("math_complete_stage45.py")

if not SRC.exists():
    print("❌ ضع هذا السكربت بجانب math_complete.py وشغّله من نفس المجلد")
    sys.exit(1)

content = SRC.read_text(encoding="utf-8")

# ── التصحيح 1: قسم .bss ──
OLD_BSS = '''         "    arena_ptr resq 1","    arena_mem resb 262144",
         "    fds_tmp resq 2",        # مؤقت للقنوات: [0]=read_fd [1]=write_fd
         "    chan_tmp resq 1",       # مؤقت للقيمة المرسلة/المستقبلة (8 بايت)'''

# احتياطي إذا لم يُوجد chan_tmp في BSS (إصدارات أقدم)
OLD_BSS_FALLBACK = '''         "    arena_ptr resq 1","    arena_mem resb 262144",
         "    fds_tmp resq 2",        # مؤقت للقنوات: [0]=read_fd [1]=write_fd'''

NEW_BSS = '''         "    arena_base resq 1","    arena_ptr resq 1","    arena_limit resq 1","    arena_chunk_size resq 1",
         "    fds_tmp resq 2",        # مؤقت للقنوات: [0]=read_fd [1]=write_fd
         "    chan_tmp resq 1",       # مؤقت للقيمة المرسلة/المستقبلة (8 بايت)
# المرحلة 45: أرض — لا حد ثابت 262144، الذاكرة تُحجز ديناميكياً عبر mmap (انظر _start وarena_alloc)'''

NEW_BSS_FALLBACK = '''         "    arena_base resq 1","    arena_ptr resq 1","    arena_limit resq 1","    arena_chunk_size resq 1",
         "    fds_tmp resq 2",        # مؤقت للقنوات: [0]=read_fd [1]=write_fd
# المرحلة 45: أرض — لا حد ثابت 262144، الذاكرة تُحجز ديناميكياً عبر mmap (انظر _start وarena_alloc)'''

# ── التصحيح 2: _start — أول قطعة 1MB عبر mmap ──
OLD_START = '''    asm += ["_start:","    lea rax, [arena_mem]","    add rax, 7","    and rax, -8","    mov [arena_ptr], rax",""]'''

NEW_START = '''    asm += ["_start:",
            "    xor rdi, rdi","    mov rsi, 1048576",        # قطعة أولى: 1 ميغابايت
            "    mov rdx, 3","    mov r10, 0x22",              # PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS
            "    mov r8, -1","    xor r9, r9",
            "    mov rax, 9","    syscall",
            "    cmp rax, 0","    js mmfail",
            "    mov [arena_base], rax",                       # بداية أول قطعة mmap
            "    mov [arena_ptr], rax",
            "    mov rdx, rax","    add rdx, 1048576",        # limit = base + 1MB
            "    mov [arena_limit], rdx",
            "    mov qword [arena_chunk_size], 2097152",       # القطعة القادمة: 2 ميغابايت (نمو مضاعف)
            ""]'''

# ── التصحيح 3: arena_alloc — نمو حقيقي عبر mmap ──
OLD_ALLOC = '''    asm += ["arena_alloc:","    mov rax, [arena_ptr]",
            "    add rdi, 15","    and rdi, -16",
            "    add [arena_ptr], rdi","    ret",""]'''

NEW_ALLOC = '    asm += ["arena_alloc:",\n            "    add rdi, 15","    and rdi, -16",           # rdi = الحجم المحاذى 16 بايت\n            "    mov rax, [arena_ptr]",                      # rax = المؤشر المرشّح للإرجاع\n            "    mov rdx, rax","    add rdx, rdi",           # rdx = الموضع بعد هذا التخصيص\n            "    cmp rdx, [arena_limit]",\n            "    jbe .aa_fits",                               # لا تُدرج تعليمات بين cmp وjbe\n            "    push rdi",                                  # احفظ الحجم (rdi يُمحى قبل syscall ثم يُستعاد عبر pop)\n            "    push r10",                                  # الكود المولّد يبقي r10 عبر نداءات arena_alloc\n            "    push r11",                                  # kernel يُمحي rcx/r11 عند syscall\n            "    mov rsi, [arena_chunk_size]",\n            "    cmp rsi, rdi","    jae .aa_sz_ok",\n            "    mov rsi, rdi",                               # القطعة تكفي هذا الطلب على الأقل\n            ".aa_sz_ok:",\n            "    push rsi",                                  # احفظ حجم القطعة — rsi يُمحى عند syscall (مثبت عبر gdb)\n            "    xor rdi, rdi",                               # addr=NULL\n            "    mov rdx, 3","    mov r10, 0x22",\n            "    mov r8, -1","    xor r9, r9",\n            "    mov rax, 9","    syscall",                  # sys_mmap — rax ← عنوان القطعة الجديدة\n            "    pop rsi",                                   # استعد حجم القطعة\n            "    cmp rax, 0","    js mmfail",\n            "    mov rdx, rax","    add rdx, rsi",\n            "    mov [arena_limit], rdx",                    # limit = base + chunk_size\n            "    mov rdx, [arena_chunk_size]","    shl rdx, 1",\n            "    mov [arena_chunk_size], rdx",               # مضاعفة القطعة القادمة (نمو هندسي)\n            "    mov [arena_ptr], rax",                      # rax = ناتج mmap مباشرة — بداية القطعة الجديدة\n            "    mov [arena_base], rax",                     # حدّث الحد الأدنى للمناطق الصالحة\n            "    pop r11",\n            "    pop r10",\n            "    pop rdi",\n            ".aa_fits:",\n            "    mov rdx, rax","    add rdx, rdi",\n            "    mov [arena_ptr], rdx",\n            "    ret",""]'

OLD_BMATCH = '''                code+=[f"    lea r10, [arena_mem]",
                       f"    cmp rax, r10", f"    jb .mskip{k}_{idx}",
                       f"    lea r10, [arena_mem + 262144]",
                       f"    cmp rax, r10", f"    jae .mskip{k}_{idx}",
                       f"    mov rbx, [rax + 8]"]'''

NEW_BMATCH = '''                code+=[f"    mov r10, [arena_base]",          # المؤشر يجب أن يكون داخل الساحة الديناميكية: [base, limit)
                       f"    cmp rax, r10", f"    jb .mskip{k}_{idx}",
                       f"    mov r10, [arena_limit]",
                       f"    cmp rax, r10", f"    jae .mskip{k}_{idx}",
                       f"    mov rbx, [rax + 8]"]'''

OLD_INIT = '''    asm += ["_start_init:",
            "    lea rax, [arena_mem]",
            "    add rax, 7",
            "    and rax, -8",
            "    mov [arena_ptr], rax",
            "    jmp _start",
            "mmfail:","    mov rax, 60","    mov rdi, 2","    syscall", ""]'''

NEW_INIT = '''    asm += ["_start_init:",
            "    jmp _start",                                   # التهيئة عبر mmap في _start
            "mmfail:","    mov rax, 60","    mov rdi, 2","    syscall", ""]'''

patches = [("قسم .bss", OLD_BSS if content.count(OLD_BSS)==1 else OLD_BSS_FALLBACK,
               NEW_BSS if content.count(OLD_BSS)==1 else NEW_BSS_FALLBACK),
           ("تهيئة نقطة الدخول _start", OLD_START, NEW_START),
           ("روتين arena_alloc", OLD_ALLOC, NEW_ALLOC),
           ("حدود arena في بناء المطابقات", OLD_BMATCH, NEW_BMATCH),
           ("تهيئة _start_init", OLD_INIT, NEW_INIT)]

for name, old, new in patches:
    n = content.count(old)
    if n != 1:
        print(f"❌ فشل تحديد موقع فريد لـ «{name}» (وُجد {n} تطابق، متوقع 1)")
        sys.exit(1)
    content = content.replace(old, new)
    print(f"✅ طُبِّق تصحيح: {name}")

OUT.write_text(content, encoding="utf-8")
print(f"\n✅ كُتب: {OUT}")

# ══════════════════════════════════════════════════════════════
# اختبار ضغط: تخصيص تراكمي ~16 ميغابايت
# ══════════════════════════════════════════════════════════════
sys.path.insert(0, '.')
import importlib.util
spec = importlib.util.spec_from_file_location("m45", OUT)
m45 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m45)

برنامج_ضغط = """ق ≔ ⟨⟩
ع ≔ 0
μ ع < 2000 : ﴿ ع ≔ ع + 1 ⋄ ق ≔ ألحق(ق, ع) ﴾
⎕ نص(طول(ق))
⎕ نص(مجموع_قائمة(ق))"""

print("\n" + "=" * 60)
print("اختبار الضغط: بناء قائمة 2000 عنصر عبر ألحق() تراكمية")
print("(تخصيص تراكمي متوقَّع ≈ 16 ميغابايت — يتجاوز 1MB+2MB+4MB+8MB)")
print("متوقع: طول=2000 ثم مجموع=2001000")
print("=" * 60)

try:
    ر = m45.حلل_رموز(برنامج_ضغط)
    ب = m45.حلل_برنامج(ر)
    asm = m45.compile_program(ب)
    pathlib.Path("stage45_stress.asm").write_text(asm, encoding="utf-8")
    subprocess.run(["nasm", "-f", "elf64", "stage45_stress.asm", "-o", "stage45_stress.o"], check=True)
    subprocess.run(["ld", "stage45_stress.o", "-o", "stage45_stress"], check=True)
    r = subprocess.run(["./stage45_stress"], capture_output=True, text=True, timeout=15)
    out = r.stdout.strip()
    expected = "2000\n2001000"
    print(f"\nstdout الخام:\n{out}")
    print(f"exit code: {r.returncode}")
    if out == expected:
        print("\n✅✅✅ المرحلة 45 نجحت — المخصّص الديناميكي يعمل ويتجاوز حد 256KB القديم")
    else:
        print(f"\n❌ الخرج لا يطابق المتوقع: {expected!r}")
        sys.exit(1)
except subprocess.CalledProcessError as e:
    print(f"⚠️ فشل البناء: {e}")
    sys.exit(1)
except Exception as e:
    print(f"⚠️ خطأ أثناء الاختبار: {e}")
    sys.exit(1)
print(f"\n(اكتمل — المخرج في {OUT})")
