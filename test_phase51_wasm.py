# -*- coding: utf-8 -*-
"""
المرحلة 51: اختبار WASM Backend
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
يختبر:
1. WASMBackend + WASMCompiler — توليد WAT
2. wat2wasm — تجميع WAT إلى .wasm حقيقي
3. تشغيل .wasm مع host functions (print_i64) والتحقق من الناتج
4. جذر/مطلق عبر الدوال المساعدة
بسم الله الرحمن الرحيم
﴿وقل رب زدني علماً﴾
"""
import os
import subprocess
import sys
import json

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), 'src'))
from wasm_backend import WASMBackend, WASMCompiler  # noqa: E402

TMP = '/tmp/wasm_test'
os.makedirs(TMP, exist_ok=True)
passed = failed = 0


def check(name, cond, detail=''):
    global passed, failed
    if cond:
        passed += 1
        print(f'  ✅ {name}')
    else:
        failed += 1
        print(f'  ❌ {name} — {detail}')


# ─── 1) WAT يُولَّد ويُجمَّع بـ wat2wasm ───
print('═══ المرحلة 51: WASM Backend ═══')
compiler = WASMCompiler()
stmts = [
    ('أسند', 'س', ('عدد', 5)),
    ('اطبع', ('ثنائية', '+', ('متغير', 'س'), ('عدد', 3))),
]
wat = compiler.compile_program(stmts, {})
with open(f'{TMP}/p1.wat', 'w') as f:
    f.write(wat)
r = subprocess.run(['wat2wasm', f'{TMP}/p1.wat', '-o', f'{TMP}/p1.wasm'],
                   capture_output=True, text=True)
check('WAT → WASM (برنامج س ≔ 5 ⋄ اطبع س + 3)', r.returncode == 0, r.stderr[:200])

# ─── 2) تشغيل WASM بجسور طباعة والتحقق من الناتج ───
JS = '''
const fs = require('fs');
const buf = fs.readFileSync(process.argv[2]);
let out = [];
(async () => {
  const res = await WebAssembly.instantiate(buf, {
    env: {
      print_i64: (n) => { out.push(Number(n)); },
      print_string: (p) => { out.push('S:'+p); }
    }
  });
  console.log(JSON.stringify(out));
})();
'''
with open(f'{TMP}/run.js', 'w') as f:
    f.write(JS)
r = subprocess.run(['node', f'{TMP}/run.js', f'{TMP}/p1.wasm'],
                   capture_output=True, text=True)
try:
    out = json.loads(r.stdout.strip())
    check('تشغيل WASM حقيقي — الناتج 8', out == [8], repr(out))
except Exception:
    failed += 1
    print(f'  ❌ تشغيل WASM — خروج: {r.stdout[:200]} {r.stderr[:200]}')

# ─── 3) WASMBackend: دوال العمليات ───
b = WASMBackend()
check('const_i64', b.const_i64(42) == ['    i64.const 42'])
check('add_i64', 'i64.add' in ''.join(b.add_i64()))
check('div_i64', 'i64.div_s' in ''.join(b.div_i64()))
check('compare_lt', 'i64.lt_s' in ''.join(b.compare_lt()))
check('if/else/end', all(k in ''.join(b.if_block() + b.else_block() + b.end_block()) for k in ('if', 'else', 'end')))

# ─── 4) متغيرات محلية وذاكرة ───
check('new_local', b.new_local('x') == 0)
check('local_get', 'local.get 0' in ''.join(b.local_get(0)))
check('local_set', 'local.set 0' in ''.join(b.local_set(0)))
check('memory_load', 'i64.load' in ''.join(b.memory_load()))
check('memory_store', 'i64.store' in ''.join(b.memory_store()))

# ─── 5) دوال مساعدة مدمجة في WAT ───
check('sqrt helper in WAT', '$sqrt_i64' in wat)
check('abs helper in WAT', '$abs_i64' in wat)
check('import print_i64', '(import "env" "print_i64"' in wat)
check('export main', '(export "main")' in wat)

# ─── 6) عبارات متنوعة تُجمَّع إلى WAT صحيح ───
for label, s in [
    ('نص', [('اطبع', ('نص', 'مرحبا'))]),
    ('مطلق', [('اطبع', ('استدعاء', 'مطلق', [('عدد', -5)]))]),
    ('جذر', [('اطبع', ('استدعاء', 'جذر', [('عدد', 144)]))]),
    ('أسند+اطبع', [('أسند', 'ص', ('عدد', 6)), ('اطبع', ('متغير', 'ص'))]),
]:
    c = WASMCompiler()
    w = c.compile_program(s, {})
    r = subprocess.run(['wat2wasm', '-', '-o', f'{TMP}/check.wasm'],
                       input=w, capture_output=True, text=True)
    check(f'WAT صالح: {label}', r.returncode == 0, w[:100] + ' || ' + r.stderr[:150])

# ─── 7) تنفيذ: WASM حقيقي يطبع مطلق(ناقص 5) = 5 ───
c = WASMCompiler()
wat2 = c.compile_program([('اطبع', ('استدعاء', 'مطلق', [('ثنائية', '-', ('عدد', 0), ('عدد', 5))]))], {})
with open(f'{TMP}/abs.wat', 'w') as f:
    f.write(wat2)
r = subprocess.run(['wat2wasm', f'{TMP}/abs.wat', '-o', f'{TMP}/abs.wasm'],
                   capture_output=True, text=True)
check('مطلق(0-5) WAT→WASM', r.returncode == 0, r.stderr[:150])
if r.returncode == 0:
    r = subprocess.run(['node', f'{TMP}/run.js', f'{TMP}/abs.wasm'],
                       capture_output=True, text=True)
    try:
        out = json.loads(r.stdout.strip())
        check('مطلق(0-5) = 5 على WASM حقيقي', out == [5], repr(out))
    except Exception:
        failed += 1
        print(f'  ❌ مطلق — خروج: {r.stdout[:200]} {r.stderr[:200]}')

print()
print(f'══════ النتيجة: {passed} ناجح / {failed} فاشل ══════')
sys.exit(1 if failed else 0)
