#!/usr/bin/env python3
"""Oracle مستقل لقوة ذات أس صحيح غير سالب.

هذا الاختبار مقصود به كشف الفجوة بين التنفيذ الحالي والمواصفة الجديدة.
لا يعتمد على math_complete.py في حساب المرجع.
"""
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
COMPILER = ROOT / "math_complete.py"
SCALE = 1 << 32
LIMIT = 16


def round_signed(num: int, den: int) -> int:
    if num >= 0:
        return (num + den // 2) // den
    return -((-num + den // 2) // den)


def mul_q32(a: int, b: int) -> int:
    return round_signed(a * b, SCALE)


def pow_q32(base: int, exponent: int) -> int:
    if exponent < 0 or exponent > 31:
        raise ValueError("أس خارج المجال")
    if base == 0 and exponent == 0:
        raise ValueError("0^0 مرفوض")
    result = SCALE
    factor = base
    n = exponent
    while n:
        if n & 1:
            result = mul_q32(result, factor)
        n >>= 1
        if n:
            factor = mul_q32(factor, factor)
    if not -(1 << 63) <= result <= (1 << 63) - 1:
        raise OverflowError("فيض Q32.32")
    return result


CASES = [
    ("صفر_أس_واحد", 0, 1),
    ("واحد_أس_صفر", SCALE, 0),
    ("واحد_أس_ثلاثة", SCALE, 3),
    ("اثنان_أس_ثلاثة", 2 * SCALE, 3),
    ("نصف_أس_ثلاثة", SCALE // 2, 3),
    ("سالب_واحد_أس_ثلاثة", -SCALE, 3),
    ("سالب_واحد_أس_اثنان", -SCALE, 2),
    ("كسر_صغير_أس_اثنان", SCALE + 1, 2),
    ("كسر_أس_خمسة", SCALE + SCALE // 3, 5),
]


def run_case(work: Path, name: str, base: int, exponent: int) -> bool:
    expected = pow_q32(base, exponent)
    source = work / f"{name}.ar"
    source.write_text(f"⎕ قوة({base},{exponent})\n", encoding="utf-8")
    build = subprocess.run(
        [sys.executable, str(COMPILER), str(source)],
        cwd=work, capture_output=True, text=True,
    )
    if build.returncode != 0:
        print(f"FAIL {name}: build\n{build.stdout}\n{build.stderr}")
        return False
    run = subprocess.run([str(work / name)], cwd=work, capture_output=True, text=True)
    if run.returncode != 0:
        print(f"FAIL {name}: runtime rc={run.returncode}")
        return False
    actual = int(run.stdout.strip().splitlines()[-1])
    diff = actual - expected
    ok = abs(diff) <= LIMIT
    print(("OK" if ok else "FAIL"), name, f"ref={expected}", f"actual={actual}", f"diff={diff}")
    return ok


def expect_rejection(work: Path, name: str, base: int, exponent: int) -> bool:
    source = work / f"{name}.ar"
    source.write_text(f"⎕ قوة({base},{exponent})\n", encoding="utf-8")
    build = subprocess.run(
        [sys.executable, str(COMPILER), str(source)],
        cwd=work, capture_output=True, text=True,
    )
    if build.returncode != 0:
        print(f"OK {name}: rejected at build")
        return True
    run = subprocess.run([str(work / name)], cwd=work, capture_output=True, text=True)
    ok = run.returncode != 0
    print(("OK" if ok else "FAIL"), name, "rejection", f"rc={run.returncode}")
    return ok


with tempfile.TemporaryDirectory(prefix="uori_quwa_") as td:
    work = Path(td)
    passed = sum(run_case(work, *case) for case in CASES)
    passed += expect_rejection(work, "أس_سالب", SCALE, -1)
    passed += expect_rejection(work, "صفر_أس_صفر", 0, 0)
    print(f"RESULT={passed}/{len(CASES) + 2}")
    if passed != len(CASES) + 2:
        raise SystemExit(1)
