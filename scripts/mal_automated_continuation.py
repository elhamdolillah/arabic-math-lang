#!/usr/bin/env python3
"""Run only governed, local verification tasks from the continuation queue."""
from __future__ import annotations

import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
QUEUE = ROOT / "protocol/MAL_AUTOMATED_CONTINUATION_QUEUE_AR.json"
ALLOWED = {
    ("tests/run_mal_grammar_corpus.py",),
    ("tests/test_mal_extensions_v0_2.py",),
    ("research/test_gadt_rank_checker.py",),
    ("tests/test_attached_mechanisms_31_39.py",),
    ("tests/test_mal_arabic_coverage_audit.py",),
}


def main() -> int:
    queue = json.loads(QUEUE.read_text(encoding="utf-8"))
    results = []
    for task in sorted(queue.get("tasks", []), key=lambda item: item["id"]):
        argv = tuple(task.get("argv", []))
        if task.get("status") not in {"pending", "blocked", "retry"}:
            results.append({"id": task["id"], "status": "SKIPPED_POLICY"})
            continue
        if argv not in ALLOWED or len(argv) != 1:
            results.append({"id": task["id"], "status": "ABSTAIN", "reason": "argv_not_allowlisted"})
            continue
        proc = subprocess.run(
            [sys.executable, *argv], cwd=ROOT, text=True, capture_output=True,
            env={**os.environ, "PYTHONHASHSEED": "0", "SOURCE_DATE_EPOCH": "0", "LC_ALL": "C.UTF-8", "LANG": "C.UTF-8"},
            check=False,
        )
        results.append({"id": task["id"], "status": "PASS" if proc.returncode == 0 else "FAIL", "rc": proc.returncode, "stdout": proc.stdout, "stderr": proc.stderr})
    payload = {
        "schema": "MAL_AUTOMATED_CONTINUATION_RESULT_v0.1",
        "source_execution": "NOT_PERFORMED",
        "network": "DISABLED_BY_CONTRACT",
        "automatic_merge": "DENY",
        "baseline_mutated": False,
        "feature_promotion": "DENY",
        "results": results,
    }
    print(json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(",", ":")))
    failed = [item for item in results if item["status"] in {"FAIL", "ABSTAIN"}]
    print(f"CONTINUATION_TASKS={len(results)}")
    print(f"CONTINUATION_FAILURES={len(failed)}")
    print("SOURCE_EXECUTION=NOT_PERFORMED")
    print("NETWORK=DISABLED_BY_CONTRACT")
    print("AUTO_MERGE=DENY")
    print("BASELINE_MUTATED=NO")
    print("STATUS=0" if not failed else "STATUS=ABSTAIN")
    return 0 if not failed else 2


if __name__ == "__main__":
    raise SystemExit(main())
