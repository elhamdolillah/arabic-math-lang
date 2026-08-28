#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORPUS = ROOT / "tests/MAL_DUAL_EXECUTION_CORPUS_AR.json"
CONTRACT = ROOT / "protocol/MAL_DUAL_EXECUTION_CONTRACT_AR.md"


def main() -> int:
    corpus = json.loads(CORPUS.read_text(encoding="utf-8"))
    assert corpus["execution"] == "NOT_PERFORMED_UNTRUSTED_SOURCE"
    assert corpus["cases"]
    for case in corpus["cases"]:
        assert case["py_source"].endswith(".py")
        assert case["ar_argv"] == [], "غياب منفذ MAL يجب أن يبقى GAP لا نجاحاً زائفاً"
        assert case["decision_if_missing_ar"] == "GAP"
        assert case["promotion"] == "RESEARCH"
    text = CONTRACT.read_text(encoding="utf-8")
    for marker in ("MISMATCH", "GAP", "ABSTAIN", "لا يغير harness المصدر أو baseline"):
        assert marker in text
    print("MAL_DUAL_STATIC_CHECK=PASS")
    print("NO_FALSE_AR_SUCCESS=PASS")
    print("MISMATCH_FAIL_CLOSED=PASS")
    print("GAP_REGISTRATION=PASS")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
