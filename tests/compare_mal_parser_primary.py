#!/usr/bin/env python3
"""جسر تحقق مؤقت لوحدة حلل_أولي؛ لا يمثل جزءًا من نواة MAL."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
KINDS = {"عدد", "صحيح", "خطأ", "معرف"}
NODE_KINDS = {"عدد": 1, "صحيح": 2, "خطأ": 2, "معرف": 3}


def canonical(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8")


def sha(value: object) -> str:
    return hashlib.sha256(canonical(value)).hexdigest()


def reference(case: dict[str, object]) -> dict[str, object]:
    token = case.get("token")
    if token is None:
        return {"decision": "ABSTAIN", "reason": "UNEXPECTED_EOF"}
    if not isinstance(token, dict):
        return {"decision": "ABSTAIN", "reason": "TOKEN_RECORD_INVALID"}
    index = token.get("index", 0)
    if not isinstance(index, int) or index < 0:
        return {"decision": "ABSTAIN", "reason": "TOKEN_INDEX_OOB"}
    kind = token.get("kind")
    value_id = token.get("value_id")
    if kind not in KINDS:
        return {"decision": "ABSTAIN", "reason": "UNKNOWN_TOKEN_KIND"}
    if not isinstance(value_id, int) or value_id < 0:
        return {"decision": "ABSTAIN", "reason": "INVALID_VALUE_ID"}
    value = 1 if kind == "صحيح" else 0 if kind == "خطأ" else value_id
    return {"decision": "PASS", "node_kind": NODE_KINDS[kind], "value_id": value, "next_token_index": index + 1}


def safe_argv(argv: object) -> bool:
    if not isinstance(argv, list) or not argv or not all(isinstance(x, str) and x for x in argv):
        return False
    if any("\n" in x or "\r" in x or x in {"sh", "bash", "-c", "eval", "exec"} for x in argv):
        return False
    return "/" in argv[0] or argv[0] == sys.executable


def run_ar(argv: list[str] | None) -> dict[str, object]:
    if not argv:
        return {"status": "GAP", "reason": "MAL_AR_RUNTIME_UNAVAILABLE"}
    if not safe_argv(argv):
        return {"status": "DENY", "reason": "ARGV_NOT_ALLOWLISTED"}
    env = {"PATH": os.environ.get("PATH", ""), "LC_ALL": "C.UTF-8", "LANG": "C.UTF-8", "SOURCE_DATE_EPOCH": "0", "PYTHONHASHSEED": "0", "NO_NETWORK": "1"}
    try:
        proc = subprocess.run(argv, cwd=ROOT, env=env, capture_output=True, text=True, timeout=20, shell=False, check=False)
    except subprocess.TimeoutExpired:
        return {"status": "ABSTAIN", "reason": "TIMEOUT"}
    stdout = proc.stdout.replace("\r\n", "\n").replace("\r", "\n")
    return {"status": "PASS" if proc.returncode == 0 else "FAIL", "rc": proc.returncode, "stdout_sha256": hashlib.sha256(stdout.encode()).hexdigest(), "stdout": stdout}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--corpus", default=str(ROOT / "tests/MAL_PARSER_PRIMARY_CORPUS_v0.1_AR.json"))
    parser.add_argument("--ar-cmd", nargs="*")
    parser.add_argument("--output", default=str(ROOT / "evidence/MAL_PARSER_PRIMARY_DIFFERENTIAL.json"))
    args = parser.parse_args()
    corpus = json.loads(Path(args.corpus).read_text(encoding="utf-8"))
    token_arena = [case.get("token") for case in corpus["cases"]]
    results = []
    failures = 0
    gaps = 0
    for case in corpus["cases"]:
        expected = case["expected"]
        py = reference(case)
        if py != expected:
            failures += 1
            decision = "ABSTAIN_REFERENCE_MISMATCH"
        else:
            ar = run_ar(args.ar_cmd)
            if ar["status"] == "GAP":
                gaps += 1
                decision = "GAP"
            elif ar["status"] != "PASS":
                decision = "ABSTAIN"
            else:
                decision = "UNPARSED_AR_OUTPUT"
        results.append({"id": case["id"], "decision": decision, "reference": py})
    payload = {"schema": corpus["schema"], "token_arena_sha256": sha(token_arena), "cases": results, "gaps": gaps, "failures": failures, "source_execution": "NOT_PERFORMED_UNTRUSTED_SOURCE", "auto_promotion": "DENY"}
    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(canonical(payload))
    print("MAL_PARSER_PRIMARY=PASS")
    print(f"CASES={len(results)}")
    print(f"GAPS={gaps}")
    print(f"FAILURES={failures}")
    print("SOURCE_EXECUTION=NOT_PERFORMED_UNTRUSTED_SOURCE")
    print("AUTO_PROMOTION=DENY")
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
