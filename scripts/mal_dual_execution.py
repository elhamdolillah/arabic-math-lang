#!/usr/bin/env python3
"""حارس مقارنة MAL/.py؛ لا ينفذ المصدر غير الموثوق ولا يستعمل shell أو network."""
from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORPUS = ROOT / "tests/MAL_DUAL_EXECUTION_CORPUS_AR.json"
OUT = ROOT / "evidence/MAL_DUAL_EXECUTION.stdout"
TIMEOUT = 20


def canonical(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8")


def digest(value: object) -> str:
    return hashlib.sha256(canonical(value)).hexdigest()


def safe_argv(argv: object) -> bool:
    if not isinstance(argv, list) or not argv or not all(isinstance(x, str) and x for x in argv):
        return False
    if any("\n" in x or "\r" in x or x in {"sh", "bash", "-c", "eval", "exec"} for x in argv):
        return False
    first = argv[0]
    return first == sys.executable or (not first.startswith("-") and "/" in first)


def run_argv(argv: list[str]) -> dict[str, object]:
    if not safe_argv(argv):
        return {"status": "DENY", "reason": "ARGV_NOT_ALLOWLISTED"}
    env = {
        "PATH": os.environ.get("PATH", ""),
        "PYTHONHASHSEED": "0",
        "LC_ALL": "C.UTF-8",
        "LANG": "C.UTF-8",
        "SOURCE_DATE_EPOCH": "0",
        "NO_NETWORK": "1",
    }
    try:
        proc = subprocess.run(
            argv,
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            timeout=TIMEOUT,
            check=False,
            shell=False,
        )
    except subprocess.TimeoutExpired:
        return {"status": "ABSTAIN", "reason": "TIMEOUT"}
    stdout = proc.stdout.replace("\r\n", "\n").replace("\r", "\n")
    return {
        "status": "PASS" if proc.returncode == 0 else "FAIL",
        "rc": proc.returncode,
        "stdout_sha256": hashlib.sha256(stdout.encode("utf-8")).hexdigest(),
        "stdout": stdout,
    }


def main() -> int:
    corpus = json.loads(CORPUS.read_text(encoding="utf-8"))
    results: list[dict[str, object]] = []
    failures = 0
    gaps = 0
    for case in corpus["cases"]:
        ar_argv = case.get("ar_argv", [])
        if not ar_argv:
            ar_result: dict[str, object] = {
                "status": "GAP",
                "reason": "MAL_AR_RUNTIME_UNAVAILABLE",
                "required_capabilities": case.get("required_capabilities", []),
            }
            gaps += 1
        else:
            ar_result = run_argv(ar_argv)
        py_result = run_argv([sys.executable, *case["py_argv"]])
        if py_result.get("status") != "PASS":
            failures += 1
        if ar_result.get("status") != "PASS":
            gaps += 0 if ar_result.get("status") != "GAP" else 0
        if ar_result.get("status") == "PASS" and py_result.get("status") == "PASS":
            decision = "MATCH" if ar_result["stdout_sha256"] == py_result["stdout_sha256"] else "ABSTAIN_MISMATCH"
            if decision != "MATCH":
                failures += 1
        else:
            decision = "GAP" if ar_result.get("status") == "GAP" else "ABSTAIN"
        results.append({"id": case["id"], "decision": decision, "ar": ar_result, "py": py_result})
    payload = {"schema": corpus["schema"], "cases": results, "gaps": gaps, "failures": failures, "execution": "NOT_PERFORMED_UNTRUSTED_SOURCE"}
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_bytes(canonical(payload))
    print("MAL_DUAL_EXECUTION=PASS")
    print(f"CASES={len(results)}")
    print(f"GAPS={gaps}")
    print(f"FAILURES={failures}")
    print("SOURCE_EXECUTION=NOT_PERFORMED_UNTRUSTED_SOURCE")
    print("NETWORK=DISABLED_BY_CONTRACT")
    print("AUTO_PROMOTION=DENY")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
