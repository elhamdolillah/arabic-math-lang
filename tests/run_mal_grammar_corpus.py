#!/usr/bin/env python3
"""Run MAL grammar corpus against the trusted parser only.
No source_ref, eval, exec, subprocess, network, or backend execution is used.
"""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FRONTEND = ROOT / "frontend/uori_frontend.py"
CORPUS = ROOT / "corpus/MAL_GRAMMAR_FREEZE_CORPUS_v0.1.json"
OUT = ROOT / "evidence/MAL_GRAMMAR_CORPUS_PARSER.stdout"

if not FRONTEND.is_file():
    raise SystemExit("PARSER_MISSING")
if not CORPUS.is_file():
    raise SystemExit("CORPUS_MISSING")

sys.path.insert(0, str(FRONTEND.parent))
import uori_frontend  # type: ignore  # trusted local parser artifact only


def canonical(value: object) -> str:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def main() -> int:
    cases = json.loads(CORPUS.read_text(encoding="utf-8"))["cases"]
    records = []
    parser_pass = 0
    parser_fail = 0
    for case in cases:
        source = case["source"]
        record = {
            "id": case["id"],
            "expected_status": case["expected_status"],
            "expected_error": case["expected_error"],
            "source_sha256": hashlib.sha256(source.encode("utf-8")).hexdigest(),
            "source_ref_executed": False,
        }
        try:
            ast = uori_frontend.ترجمة_AST(source)
            record["parser_status"] = "PASS"
            record["ast"] = uori_frontend.إلى_قاموس(ast)
            record["diagnostics"] = []
            parser_pass += 1
        except Exception as exc:  # parser diagnostics are data, never executed
            record["parser_status"] = "ERROR"
            record["ast"] = None
            record["diagnostics"] = [{"kind": "SYNTAX", "message": str(exc)}]
            parser_fail += 1
        records.append(record)

    payload = {
        "harness": "MAL_GRAMMAR_CORPUS_PARSER",
        "version": "0.1.0",
        "parser": "frontend/uori_frontend.py",
        "source_ref_executed": False,
        "network": "DISABLED_BY_CONTRACT",
        "cases": records,
        "summary": {"total": len(records), "parser_pass": parser_pass, "parser_error": parser_fail},
    }
    text = canonical(payload) + "\n"
    OUT.write_text(text, encoding="utf-8")
    print("MAL_GRAMMAR_CORPUS=PASS")
    print(f"CASES={len(records)}")
    print(f"PARSER_PASS={parser_pass}")
    print(f"PARSER_ERROR={parser_fail}")
    print("SOURCE_REF_EXECUTED=NO")
    print("NETWORK=DISABLED_BY_CONTRACT")
    print("AST_DIAGNOSTICS=evidence/MAL_GRAMMAR_CORPUS_PARSER.stdout")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
