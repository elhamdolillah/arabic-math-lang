#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
اختبارات الفهرسة المركبة — المرحلة الجديدة
- فهرسة أساسية: ق[0]، ق[2]، ق[4]
- فهرسة بتعبير: ق[ع]
- تجاوز حدود: exit(7)
- فهرسة مركبة: د(س)[ك]
- التوافق العكسي: test_all_phases + test_phases + test_engine_uas
"""
import os, subprocess, sys, json

PASS = 0; FAIL = 0

def run(source, expect_out=None, expect_rc=None, label=""):
    global PASS, FAIL
    src = (
        "import subprocess\n"
        "from math_complete import *\n"
        f"source = {source!r}\n"
        "ر = حلل_رموز(source)\n"
        "ب = حلل_برنامج(ر)\n"
        "asm = compile_program(ب)\n"
        "with open('t_idx_tmp.asm','w') as f: f.write(asm)\n"
        "subprocess.run(['nasm','-f','elf64','t_idx_tmp.asm','-o','t_idx_tmp.o'], check=True, capture_output=True)\n"
        "subprocess.run(['ld','t_idx_tmp.o','-o','t_idx_tmp'], check=True, capture_output=True)\n"
        "r = subprocess.run(['./t_idx_tmp'], capture_output=True, text=True)\n"
        "import json\n"
        "print('OUTDELIM')\n"
        "print(json.dumps(r.stdout.strip()))\n"
        "print('RCDELIM')\n"
        "print(str(r.returncode))\n"
    )
    p = subprocess.run(['python3','-c',src], capture_output=True, text=True, cwd='/home/ubuntu/work/math_aot_stage44_test')
    out, rc = None, None
    lines = p.stdout.splitlines()
    try:
        i_out = lines.index('OUTDELIM'); i_rc = lines.index('RCDELIM')
        out = json.loads(lines[i_out+1])
        rc = int(lines[i_rc+1])
    except (ValueError, IndexError):
        out, rc = '', None
    ok = True
    if expect_out is not None and out != expect_out: ok = False
    if expect_rc is not None and rc != expect_rc: ok = False
    status = "✅ نجح" if ok else "❌ فشل"
    if ok: PASS += 1
    else: FAIL += 1
    print(f"  {label}: {status}")
    if not ok:
        print(f"    المتوقع: out={expect_out!r} rc={expect_rc}")
        print(f"    الفعلي: out={out!r} rc={rc}")
        if p.stderr: print(f"    خطأ: {p.stderr[:500]}")
    return ok

print("=" * 56)
print("  اختبارات الفهرسة المركبة — ق[ع] ود(س)[ك]")
print("=" * 56)

# اختبار 1: فهرسة أساسية
print("\n[1] فهرسة أساسية")
run('ق ≔ ⟨10، 20، 30، 40، 50⟩\n⎕ ق[0]\n⎕ ق[2]\n⎕ ق[4]',
    expect_out='10\n30\n50', label='ق[0]، ق[2]، ق[4]')

# اختبار 2: فهرسة بتعبير متغير
print("[2] فهرسة بتعبير متغير")
run('ق ≔ ⟨10، 20، 30⟩\nع ≔ 1\n⎕ نص(ق[ع])',
    expect_out='20', label='ق[ع] حيث ع = 1')

# اختبار 3: تجاوز حدود → exit(7)
print("[3] تجاوز حدود (فشل آمن)")
run('ق ≔ ⟨10، 20، 30⟩\n⎕ نص(ق[5])',
    expect_rc=7, label='ق[5] مع طول 3 → exit(7)')

# اختبار 4: فهرسة مركبة على نتيجة استدعاء: د(س)[ك]
print("[4] فهرسة مركبة د(س)[ك]")
run('ج ≔ λس. ⟨س، س · 2، س · 3⟩\n⎕ نص(ج(5)[1])',
    expect_out='10', label='ج(5)[1] → 10')

# اختبار 5: فهرسة معقدة — قيمة فهرس من دالة
print("[5] فهرس ناتج عن دالة")
run('ق ≔ ⟨100، 200، 300⟩\nم ≔ λس. س + 1\n⎕ نص(ق[م(0)])',
    expect_out='200', label='ق[م(0)] → 200')

# اختبار 6: فهرسة سالبة غير صالحة → exit(7)
print("[6] فهرس سالب")
run('ق ≔ ⟨10، 20⟩\n⎕ نص(ق[-1])',
    expect_rc=7, label='ق[-1] → exit(7) (singed cmp)')

# اختبار 7: مؤشر صفر على قائمة فارغة → exit(7)
print("[7] قائمة فارغة")
run('ق ≔ ⟨⟩\n⎕ نص(ق[0])',
    expect_rc=7, label='⟨⟩[0] → exit(7)')

# اختبار 8: سلسلة فهرسات
print("[8] سلسلة فهرسات ⟨⟨1،2⟩،⟨3،4⟩⟩")
run('ق ≔ ⟨⟨1، 2⟩، ⟨3، 4⟩⟩\n⎕ نص(ق[1][0])',
    expect_out='3', label='ق[1][0] → 3')

# اختبار 9: فهرسة داخل طابق
print("[9] فهرسة داخل طابق")
run('ق ≔ ⟨10، 20، 30⟩\n⎕ نص(طابق ق : ﴿ ⟨⟩ ⇒ -1 ⋄ _ ⇒ ق[0] ﴾)',
    expect_out='10', label='طابق: قائمة ⇒ ق[0]')

print("\n" + "=" * 56)
print(f"  النتيجة: {PASS}/{PASS+FAIL}")
print("=" * 56)

if FAIL > 0:
    sys.exit(1)

# التوافق العكسي
print("\n🧪 التوافق العكسي...")
for suite in ['test_all_phases.py', 'test_phases.py', 'test_engine_uas.py']:
    p = subprocess.run(['python3', suite], capture_output=True, text=True, cwd='/home/ubuntu/work/math_aot_stage44_test')
    last = [l for l in (p.stdout + p.stderr).splitlines() if l.strip()]
    print(f"  {suite}: {'✅ ' if p.returncode == 0 else '❌ '}" + (last[-1] if last else ''))
    if p.returncode != 0:
        print('\n'.join(last[-15:]))
        sys.exit(1)

# self-hosting: use the isolated corrected harness explicitly.
print("\n🧪 Self-hosting...")
selfhost_path = '/home/ubuntu/work/t_read_size_unicode_fix/math_aot_selfhost.py'
selfhost_cwd = '/home/ubuntu/work/math_aot_stage44_test'
if not os.path.isfile(selfhost_path):
    print(f"  math_aot_selfhost: ❌ missing corrected harness: {selfhost_path}")
    sys.exit(1)
if not os.path.isfile(os.path.join(selfhost_cwd, 'utf8_next_codepoint.asm')):
    print(f"  math_aot_selfhost: ❌ missing UTF-8 runtime in {selfhost_cwd}")
    sys.exit(1)
p = subprocess.run(['python3', selfhost_path], capture_output=True, text=True, cwd=selfhost_cwd, timeout=120)
summary = (p.stdout + p.stderr).strip()
print(f"  math_aot_selfhost: {'✅ ' if p.returncode == 0 else '❌ '}RC={p.returncode}")
print(summary[-1200:])
if p.returncode != 0:
    sys.exit(1)

print("\n🎉 الفهرسة المركبة وself-hosting يعملان بنجاح!")
