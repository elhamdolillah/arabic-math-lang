#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Harness التكامل الشامل للاختبارات المرحلية المتاحة.

FAIL_CLOSED: أي ملف مفقود أو RC غير صفري يمنع إعلان PASS.
لا ينفذ git ولا يغير baseline، ولا يعيد استدعاء نفسه.
"""
from __future__ import annotations
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.abspath(__file__))
SUITES = [
    ("phase_harness", "test_phases.py"),
    ("engine_uas", "test_engine_uas.py"),
    ("runtime_cache", "test_runtime_cache_fingerprint.py"),
    ("compound_indexing", "test_compound_indexing.py"),
]


def run_one(label: str, filename: str) -> bool:
    path = os.path.join(ROOT, filename)
    if not os.path.isfile(path):
        print(f"ABSTAIN: missing {filename}")
        return False
    print(f"--- {label}: {filename} ---")
    try:
        proc = subprocess.run(
            [sys.executable, path], cwd=ROOT, capture_output=True,
            text=True, timeout=300,
        )
    except Exception as exc:
        print(f"FAIL: {filename}: {exc}")
        return False
    if proc.stdout:
        print(proc.stdout.rstrip())
    if proc.stderr:
        print(proc.stderr.rstrip(), file=sys.stderr)
    print(f"RC={proc.returncode}")
    return proc.returncode == 0


def main() -> int:
    print("=== MAL/UORI all-phases integration harness ===")
    failures = []
    for label, filename in SUITES:
        if not run_one(label, filename):
            failures.append(filename)
    if failures:
        print("STATUS=FAIL_CLOSED")
        print("FAILURES=" + ",".join(failures))
        return 1
    print("STATUS=PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
