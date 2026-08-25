#!/usr/bin/env python3
"""حزام تفاضلي محكوم: لا يعلن التكافؤ دون Corpus ونظير مرجعي مستقل."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RUNNER = ROOT / "rust" / "mal_ownership_arena" / "target" / "release" / "mal_runner"
CORPUS_DIRS = (
    ROOT / "corpus" / "stage0_18_files",
    ROOT / "corpus" / "stage1_9_files",
)
OUT = ROOT / "evidence" / "MAL_DIFFERENTIAL_EXECUTION_2026-08-25.json"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def run_one(path: Path) -> dict[str, object]:
    source = path.read_bytes()
    process = subprocess.run(
        [str(RUNNER), str(path)],
        cwd=ROOT,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    stdout = process.stdout.decode("utf-8", errors="strict")
    stderr = process.stderr.decode("utf-8", errors="strict")
    if process.returncode == 0 and "STATUS=PARSED" in stdout:
        status = "PARSED_EXTENSION_SCOPED"
    elif "STATUS=ABSTAIN" in stdout:
        status = "ABSTAIN"
    else:
        status = "FAIL"
    return {
        "file": path.relative_to(ROOT).as_posix(),
        "file_sha256": sha256_bytes(source),
        "exit_code": process.returncode,
        "status": status,
        "stdout": stdout,
        "stderr": stderr,
    }


def main() -> int:
    cases: list[dict[str, object]] = []
    missing: list[str] = []
    for directory in CORPUS_DIRS:
        if not directory.is_dir():
            missing.append(directory.relative_to(ROOT).as_posix())
            continue
        for path in sorted(directory.glob("*.ar"), key=lambda item: item.name.encode("utf-8")):
            cases.append(run_one(path))

    counts = {"parsed": 0, "abstain": 0, "fail": 0}
    for case in cases:
        status = case["status"]
        if status == "PARSED_EXTENSION_SCOPED":
            counts["parsed"] += 1
        elif status == "ABSTAIN":
            counts["abstain"] += 1
        else:
            counts["fail"] += 1

    report = {
        "schema": "MAL_DIFFERENTIAL_EXECUTION_v0.1",
        "runner": RUNNER.relative_to(ROOT).as_posix(),
        "corpus_dirs": [directory.relative_to(ROOT).as_posix() for directory in CORPUS_DIRS],
        "missing_corpus_dirs": missing,
        "summary": {
            "total_files": len(cases),
            "parsed_extension_scoped": counts["parsed"],
            "abstained": counts["abstain"],
            "failed": counts["fail"],
        },
        "reference_comparison": "NOT_PERFORMED",
        "differential_status": "ABSTAIN",
        "details": cases,
    }
    OUT.write_text(
        json.dumps(report, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n",
        encoding="utf-8",
    )
    print(
        "DIFFERENTIAL_STATUS=ABSTAIN "
        f"FILES={len(cases)} PARSED={counts['parsed']} "
        f"ABSTAIN={counts['abstain']} FAIL={counts['fail']} "
        f"MISSING_DIRS={len(missing)}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
