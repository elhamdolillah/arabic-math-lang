from pathlib import Path
from math import isqrt
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
COMPILER = ROOT / 'math_complete.py'
MAX = (1 << 63) - 1
CASES = [
    ('صفر', 0, 0),
    ('محور_س', 1 << 32, 0),
    ('محور_ص', 0, 1 << 32),
    ('ثلاثة_أربعة', 3 << 32, 4 << 32),
    ('سالب_ثلاثة_أربعة', -(3 << 32), 4 << 32),
    ('ثلاثة_سالب_أربعة', 3 << 32, -(4 << 32)),
    ('سالبان', -(3 << 32), -(4 << 32)),
    ('واحد_واحد', 1 << 32, 1 << 32),
    ('كسر_موجب', 1 << 31, 1 << 31),
    ('كسر_سالب', -(1 << 31), 1 << 31),
    ('قريب_الصفر', 1, 1),
    ('قريب_الصفر_سالب', -1, 1),
    ('اثنان_صفر', 2 << 32, 0),
    ('ستة_ثمانية', 6 << 32, 8 << 32),
    ('مربع_صغير', 7 << 32, 24 << 32),
    ('غير_تام', 1 << 32, 2 << 32),
    ('حد_سالب', -MAX, 0),
    ('حد_موجب', MAX, 0),
    ('حد_موجب_صغير', MAX - 1, 1),
    ('فيض_متناظر', MAX, MAX),
    ('فيض_سالب_متناظر', -MAX, -MAX),
]

with tempfile.TemporaryDirectory(prefix='uori_hypot_') as td:
    work = Path(td)
    passed = 0
    rejected = 0
    for name, x, y in CASES:
        expected = isqrt(x * x + y * y)
        source = work / f'{name}.ar'
        source.write_text(f'⎕ وتر({x}، {y})\n', encoding='utf-8')
        build = subprocess.run([sys.executable, str(COMPILER), str(source)], cwd=work, capture_output=True, text=True)
        if build.returncode != 0:
            raise SystemExit(f'build failed for {name}:\n{build.stdout}\n{build.stderr}')
        run = subprocess.run([str(work / name)], cwd=work, capture_output=True, text=True)
        if expected > MAX:
            if run.returncode == 0:
                raise SystemExit(f'overflow was not rejected for {name}: {run.stdout!r}')
            rejected += 1
            print('OK', name, 'overflow rejected', f'rc={run.returncode}')
            continue
        if run.returncode != 0:
            raise SystemExit(f'runtime failed for {name}: rc={run.returncode}\n{run.stdout}\n{run.stderr}')
        actual = int(run.stdout.strip().splitlines()[-1])
        diff = actual - expected
        print(('OK' if abs(diff) <= 16 else 'FAIL'), name, f'ref={expected}', f'actual={actual}', f'diff={diff}')
        if abs(diff) > 16:
            raise SystemExit(1)
        passed += 1

print(f'RESULT={passed}/{len(CASES)} accepted, OVERFLOW_REJECTED={rejected}')
