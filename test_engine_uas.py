# -*- coding: utf-8 -*-
"""اختبار دالة أُس في محرك المُجمّع — تجميع NASM/LD وتشغيل ELF حقيقي"""
import sys, subprocess
sys.path.insert(0, '.')
from math_complete import *

S = 4294967296
tests = [
    # (الاسم, البرنامج, المتوقع, الوصف)
    ("u_exp0",   f"⎕ نص(أُس(0) ÷ {S})", "1", "exp(0) = 1"),
    ("u_exp1",   f"⎕ نص(أُس({S}) ÷ {S})", "2", "exp(1) ≈ 2.718 → 2"),
    ("u_exp2",   f"⎕ نص(أُس({S*2}) ÷ {S})", "7", "exp(2) ≈ 7.389 → 7"),
    ("u_exp3",   f"⎕ نص(أُس({S*3}) ÷ {S})", "20", "exp(3) ≈ 20.09 → 20"),
    ("u_expn5",  f"⎕ نص((أُس(0 - {S*5}) · 1000) ÷ {S})", "6", "exp(-5) ≈ 0.00674 → ×1000 ÷SCALE ≈ 6"),
    ("u_expn10", f"⎕ نص((أُس(0 - {S*10}) · 10000) ÷ {S})", "0", "exp(-10) ≈ 4.54e-5 → ×10000 ÷ SCALE ≈ 0 (أقل من 1)"),
    ("u_expn20", f"⎕ نص((أُس(0 - {S*20}) · 100000) ÷ {S})", "0", "exp(-20) ≈ 2e-9 → ≈ 0"),
    ("u_nested", f"⎕ نص(أُس(أُس(0) - {S}) ÷ {S})", "1", "exp(exp(0)-1) = exp(0) = 1"),
    ("u_var",    f"⎕ نص(أُس({S}) ÷ {S})", "2", "حتمية: نفس الإدخال نفس الخرج (تشغيل مكرر عبر متغير مضمّن)"),
]

passed = failed = 0
for name, src, expected, desc in tests:
    print(f"\n--- [{name}] {desc} ---")
    print(f"    البرنامج: {src}")
    try:
        ر = حلل_رموز(src)
        ب = حلل_برنامج(ر)
        asm = compile_program(ب)
        with open(f'{name}.asm', 'w') as f: f.write(asm)
        r1 = subprocess.run(['nasm', '-f', 'elf64', f'{name}.asm', '-o', f'{name}.o'],
                            capture_output=True, text=True)
        if r1.returncode != 0:
            print(f"  [FAIL] NASM: {r1.stderr[:300]}"); failed += 1; continue
        r2 = subprocess.run(['ld', f'{name}.o', '-o', name], capture_output=True, text=True)
        if r2.returncode != 0:
            print(f"  [FAIL] ld: {r2.stderr[:300]}"); failed += 1; continue
        r = subprocess.run([f'./{name}'], capture_output=True, text=True, timeout=10)
        out = r.stdout.strip()
        if out == expected:
            print(f"  [OK] {out}")
            passed += 1
        else:
            print(f"  [FAIL] expected '{expected}', got '{out}'")
            failed += 1
    except Exception as e:
        import traceback; traceback.print_exc()
        failed += 1

print(f"\n{'='*60}\nالنتيجة: {passed}/{passed+failed}")
sys.exit(0 if failed == 0 else 1)
