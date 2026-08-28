#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""بوابة اعتماد uori_lookup_v5.ar كمصدر canonical للبحث العام.

FAIL_CLOSED=ACTIVE: أي ملف مفقود أو اختلاف بصمة أو RC غير صفري يعيد 1.
AUTO_PROMOTION=DENY: هذا الاختبار يثبت نطاق الاعتماد فقط ولا ينشئ tag أو push.
"""
from __future__ import annotations
import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent
CANONICAL = ROOT / "uori_lookup.ar"
V5 = ROOT / "uori_lookup_v5.ar"
REQUIRED = [
    ROOT / "math_complete.py",
    ROOT / "lexicon",
    ROOT / "sha256_runtime_generated.asm",
    ROOT / "utf8_next_codepoint.asm",
    CANONICAL,
    V5,
]
EXPECTED = "4\n7\n0\n-1\n2\n"

def fail(message: str) -> int:
    print(f"FAIL_CLOSED: {message}", file=sys.stderr)
    return 1

def digest(path: Path) -> str:
    if path.is_dir():
        h = hashlib.sha256()
        for child in sorted(path.rglob("*")):
            if child.is_file():
                h.update(str(child.relative_to(path)).encode("utf-8"))
                h.update(child.read_bytes())
        return h.hexdigest()
    return hashlib.sha256(path.read_bytes()).hexdigest()

def main() -> int:
    for path in REQUIRED:
        if not path.exists():
            return fail(f"missing required path: {path}")
    canonical_hash = digest(CANONICAL)
    v5_hash = digest(V5)
    print(f"CANONICAL_SHA256={canonical_hash}")
    print(f"V5_SHA256={v5_hash}")
    if canonical_hash != v5_hash:
        return fail("uori_lookup.ar differs from uori_lookup_v5.ar")

    with tempfile.TemporaryDirectory(prefix="uori_lookup_v5_adoption_") as raw:
        work = Path(raw)
        shutil.copy2(ROOT / "math_complete.py", work / "math_complete.py")
        shutil.copytree(ROOT / "lexicon", work / "lexicon")
        for name in ("sha256_runtime_generated.asm", "utf8_next_codepoint.asm"):
            shutil.copy2(ROOT / name, work / name)
        shutil.copy2(V5, work / "uori_lookup_v5.ar")
        outputs = []
        for index in range(1, 4):
            proc = subprocess.run(
                [sys.executable, "math_complete.py", "uori_lookup_v5.ar"],
                cwd=work, capture_output=True, text=True, timeout=180,
            )
            if proc.returncode != 0:
                print(proc.stdout, end="")
                print(proc.stderr, end="", file=sys.stderr)
                return fail(f"compile run {index} RC={proc.returncode}")
            binary = work / "uori_lookup_v5"
            if not binary.is_file():
                return fail(f"compile run {index} produced no executable")
            run = subprocess.run([str(binary)], cwd=work, capture_output=True, text=True, timeout=30)
            if run.returncode != 0:
                return fail(f"execution run {index} RC={run.returncode}")
            if run.stdout != EXPECTED or run.stderr:
                return fail(f"execution run {index} output mismatch")
            outputs.append(hashlib.sha256(run.stdout.encode()).hexdigest())
            print(f"RUN{index}_RC=0")
            print(f"RUN{index}_STDOUT_SHA256={outputs[-1]}")
        if len(set(outputs)) != 1:
            return fail("triple-run stdout hashes differ")

    print("TRIPLE_RUN=PASS")
    print("CANONICAL_LOOKUP_V5=PROVEN_FOR_TEST_MATRIX")
    print("STATUS=PASS")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
