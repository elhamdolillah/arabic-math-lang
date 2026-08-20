#!/usr/bin/env python3
"""اختبار تنفيذ فعلي لبرنامج قوة مولد ثم مجمع على x86_64.

هذا يثبت سلوك الثنائية في بيئة التشغيل الحالية فقط، ولا يساوي برهان Coq
للتعليمات على كل المعالجات.
"""
from pathlib import Path
import platform
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
COMPILER = ROOT / "math_complete.py"
SCALE = 1 << 32


def round_signed(num: int, den: int) -> int:
    if num >= 0:
        return (num + den // 2) // den
    return -((-num + den // 2) // den)


def mul_q32(a: int, b: int) -> int:
    return round_signed(a * b, SCALE)


def ref_pow(base: int, exponent: int) -> int:
    if exponent < 0 or exponent > 31 or (base == 0 and exponent == 0):
        raise ValueError
    result, factor, n = SCALE, base, exponent
    while n:
        if n & 1:
            result = mul_q32(result, factor)
        n >>= 1
        if n:
            factor = mul_q32(factor, factor)
    if not -(1 << 63) <= result <= (1 << 63) - 1:
        raise OverflowError
    return result


def build_run(work: Path, name: str, base: int, exponent: int):
    source = work / f"{name}.ar"
    source.write_text(f"⎕ قوة({base},{exponent})\n", encoding="utf-8")
    build = subprocess.run([sys.executable, str(COMPILER), str(source)], cwd=work,
                           capture_output=True, text=True, timeout=30)
    if build.returncode != 0:
        raise AssertionError(f"build failed {name}: {build.stderr}")
    return subprocess.run([str(work / name)], cwd=work, capture_output=True,
                          text=True, timeout=30)


def main() -> int:
    assert platform.machine() == "x86_64", platform.machine()
    with tempfile.TemporaryDirectory(prefix="uori_pow_x86_") as td:
        work = Path(td)
        cases = [("واحد_أس_ثلاثة", SCALE, 3), ("سالب_واحد_أس_ثلاثة", -SCALE, 3),
                 ("كسر_أس_خمسة", SCALE + SCALE // 3, 5)]
        for name, base, exponent in cases:
            run = build_run(work, name, base, exponent)
            assert run.returncode == 0, (name, run.returncode, run.stderr)
            actual = int(run.stdout.strip().splitlines()[-1])
            expected = ref_pow(base, exponent)
            assert abs(actual - expected) <= 16, (name, actual, expected)
        rejected = build_run(work, "أس_سالب", SCALE, -1)
        assert rejected.returncode != 0, rejected.returncode
    print("✅ تنفيذ x86_64 فعلي لقوة: ناجح")
    print("الحالات: 3 نتائج، سالبة، كسر، ورفض أس سالب")
    print("الحالة: hardware_runtime_evidence — ليست برهاناً رسمياً عاماً")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
