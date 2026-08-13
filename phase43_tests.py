#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
المرحلة 43: التطابق الأنماطي (Pattern Matching)
================================================
يعمل المُجمّع AOT على مبدأ الدستور الإصدار 8.0 — المبدأ الثامن: الشمولية التقنية.
الاختبارات العشرة: حرفي، متغير، قائمة فارغة، قائمة cons، شرطي (حيث)، شامل (_)،
بديل (|)، متداخل (دالة)، عودي (مضروب)، عودي عميق (فيبوناتشي).
النتائج المتوقعة: 0، 6، 0، 10، -1، 99، 1، 4، 120، 55
"""
import sys, subprocess, os, time
sys.path.insert(0, '.')
import math_complete as mc

EXAMPLES_DIR = 'examples'
EXPECTED = {
    'phase43_01_literal.ar':    '0',
    'phase43_02_variable.ar':   '6',
    'phase43_03_list_empty.ar': '0',
    'phase43_04_list_cons.ar':  '10',
    'phase43_05_conditional.ar':'-1',
    'phase43_06_wildcard.ar':   '99',
    'phase43_07_alternative.ar':'1',
    'phase43_08_nested.ar':     '4',
    'phase43_09_recursive.ar':  '120',
    'phase43_10_fibonacci.ar':  '55',
}

DESC = {
    'phase43_01_literal.ar':    'طابق حرفي: 0 ⇒ 0 ⋄ 1 ⇒ 1 ⋄ _ ⇒ 2  (س=0)',
    'phase43_02_variable.ar':   'ربط متغير: س ⇒ س + 1  (س=5)',
    'phase43_03_list_empty.ar': 'قائمة فارغة: ⟨⟩ ⇒ 0',
    'phase43_04_list_cons.ar':  'قائمة cons: ⟨أ، ..._⟩ ⇒ أ  (⟨10،20،30⟩)',
    'phase43_05_conditional.ar':'شرطي حيث: ن حيث ن < 0 ⇒ -1  (س=-5)',
    'phase43_06_wildcard.ar':   'شامل _: 42 ⇒ الفرع الشامل 99',
    'phase43_07_alternative.ar':'بديل |: 0 | 1 | 2 ⇒ 1  (س=1)',
    'phase43_08_nested.ar':     'متداخل: طابق داخل دالة λ',
    'phase43_09_recursive.ar':  'عودي: مضروب(5) = 120',
    'phase43_10_fibonacci.ar':  'عودي عميق: فيبو(10) = 55',
}

def compile_and_run(path):
    src = open(path, encoding='utf-8').read()
    tokens = mc.حلل_رموز(src)
    ast = mc.حلل_برنامج(tokens)
    asm = mc.compile_program(ast)
    base = path.rsplit('.', 1)[0]
    open(base + '.asm', 'w').write(asm)
    subprocess.run(['nasm', '-f', 'elf64', base + '.asm', '-o', base + '.o'], check=True)
    subprocess.run(['ld', base + '.o', '-o', base], check=True)
    t0 = time.time()
    r = subprocess.run(['./' + base], capture_output=True, text=True, timeout=30)
    elapsed = time.time() - t0
    return r.stdout.strip(), r.returncode, elapsed, base

print('=' * 60)
print('المرحلة 43: التطابق الأنماطي (Pattern Matching)')
print('المبدأ الثامن من الدستور: الشمولية التقنية')
print('=' * 60)
print()

passed = 0
rows = []
for fname, expected in EXPECTED.items():
    path = os.path.join(EXAMPLES_DIR, fname)
    try:
        out, rc, elapsed, base = compile_and_run(path)
        ok = (out == expected and rc == 0)
        if ok: passed += 1
        rows.append((fname, out, expected, rc, elapsed, 'نجح ✅' if ok else 'فشل ❌'))
        print(f"  {'✅' if ok else '❌'} {fname}")
        print(f"      الخرج: {out!r} | المتوقع: {expected!r} | rc={rc} | {elapsed*1000:.1f}ms")
    except Exception as e:
        rows.append((fname, 'خطأ', expected, -1, 0, 'خطأ ❌'))
        print(f"  ❌ {fname} — خطأ: {e}")

print()
print('=' * 60)
print(f'النتيجة: {passed}/{len(EXPECTED)}')
if passed == len(EXPECTED):
    print('🎉 المرحلة 43 نجحت بالكامل! التطابق الأنماطي يعمل في ELF حقيقي')
else:
    print(f'❌ فشل {len(EXPECTED)-passed} اختبار')
    sys.exit(1)
print()
print('جدول النتائج:')
print('┌──────────────────────────┬──────────┬──────────┬──────┐')
print('│ الاختبار                 │ الخرج    │ المتوقع  │ حالة │')
print('├──────────────────────────┼──────────┼──────────┼──────┤')
for fname, out, exp, rc, ms, status in rows:
    print(f'│ {fname:<24} │ {out:<8} │ {exp:<8} │ {status} │')
print('└──────────────────────────┴──────────┴──────────┴──────┘')
