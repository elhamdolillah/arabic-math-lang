#!/usr/bin/env python3
from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts/mal_arabic_coverage_audit.py"
OUT = ROOT / "/tmp/mal_arabic_coverage_audit_test.json"


def run() -> tuple[str, dict]:
    proc = subprocess.run([sys.executable, str(SCRIPT), "--output", str(OUT)], cwd=ROOT, text=True, capture_output=True, check=False)
    assert proc.returncode == 0, proc.stdout + proc.stderr
    return proc.stdout, json.loads(OUT.read_text(encoding="utf-8"))


def main() -> int:
    first_stdout, first = run()
    second_stdout, second = run()
    assert first_stdout == second_stdout
    assert first == second
    assert first["execution"] == "NOT_PERFORMED"
    assert first["network"] == "DISABLED_BY_CONTRACT"
    assert first["baseline_modified"] is False
    assert first["auto_merge"] == "DENY"
    assert first["decision"] == "ALLOW_MEASUREMENT"
    assert first["file_count"] > 0
    assert first["next_candidate"]["path"]
    assert 0.0 <= first["aggregate"]["arabic_coverage_ratio"] <= 1.0
    print("MAL_ARABIC_COVERAGE_TEST=PASS")
    print(f"FILES={first['file_count']}")
    print(f"NEXT_CANDIDATE={first['next_candidate']['path']}")
    print("BASELINE_MODIFIED=NO")
    print("AUTO_MERGE=DENY")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
