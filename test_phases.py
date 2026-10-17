#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Harness حتمي لاختبارات مراحل MAL 47–51.

FAIL_CLOSED: الملف المفقود أو RC غير صفري يوقف السلسلة ويعيد RC=1.
لا يستدعي test_compound_indexing.py لمنع recursion؛ يختبره test_all_phases.py اختيارياً.
"""
from __future__ import annotations
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.abspath(__file__))
SUITES = [
    "test_phase47.py",
    "test_phase48.py",
    "test_phase49.py",
    "test_phase50.py",
    "test_phase51_wasm.py",
]


def main() -> int:
    failures = []
    print("=== MAL phase harness: 47..51 ===")
    for name in SUITES:
        path = os.path.join(ROOT, name)
        if not os.path.isfile(path):
            print(f"ABSTAIN: missing {name}")
            failures.append((name, "missing"))
            continue
        print(f"--- {name} ---")
        try:
            proc = subprocess.run(
                [sys.executable, path], cwd=ROOT, capture_output=True,
                text=True, timeout=180,
            )
        except Exception as exc:
            print(f"FAIL: {name}: {exc}")
            failures.append((name, "exception"))
            continue
        if proc.stdout:
            print(proc.stdout.rstrip())
        if proc.stderr:
            print(proc.stderr.rstrip(), file=sys.stderr)
        print(f"RC={proc.returncode}")
        if proc.returncode != 0:
            failures.append((name, f"RC={proc.returncode}"))
    if failures:
        print("STATUS=FAIL_CLOSED")
        for name, reason in failures:
            print(f"FAILURE={name}:{reason}")
        return 1
    print("STATUS=PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
