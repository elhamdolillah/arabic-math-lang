from pathlib import Path
from math import isqrt
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
COMPILER = ROOT / 'math_complete.py'
CASES = [
    ('صفر', 0),
    ('واحد', 1 << 32),
    ('اثنان', 2 << 32),
    ('أربعة', 4 << 32),
    ('تسعة', 9 << 32),
    ('ربع', 1 << 30),
    ('ثمن', 1 << 29),
    ('كسر_غير_تام', 3 << 32),
    ('أقصى_موجب', (1 << 63) - 1),
]

with tempfile.TemporaryDirectory(prefix='uori_sqrt_') as td:
    work = Path(td)
    for name, inp in CASES:
        expected = isqrt(inp << 32)
        source = work / f'{name}.ar'
        source.write_text(f'⎕ جذر({inp})\n', encoding='utf-8')
        build = subprocess.run([sys.executable, str(COMPILER), str(source)], cwd=work, capture_output=True, text=True)
        if build.returncode != 0:
            raise SystemExit(f'build failed for {name}:\n{build.stdout}\n{build.stderr}')
        run = subprocess.run([str(work / name)], cwd=work, capture_output=True, text=True)
        actual = int(run.stdout.strip().splitlines()[-1])
        diff = actual - expected
        print(('OK' if abs(diff) <= 16 else 'FAIL'), name, f'ref={expected}', f'actual={actual}', f'diff={diff}')
        if abs(diff) > 16 or run.returncode != 0:
            raise SystemExit(1)

    negative = work / 'سالب.ar'
    negative.write_text('⎕ جذر(-1)\n', encoding='utf-8')
    build = subprocess.run([sys.executable, str(COMPILER), str(negative)], cwd=work, capture_output=True, text=True)
    if build.returncode != 0:
        raise SystemExit(f'negative case unexpectedly failed at compile time:\n{build.stderr}')
    run = subprocess.run([str(work / 'سالب')], cwd=work, capture_output=True, text=True)
    if run.returncode == 0:
        raise SystemExit('negative sqrt was not rejected at runtime')
    print(f'OK سالب rejected at runtime rc={run.returncode}')

print('RESULT=10/10')
