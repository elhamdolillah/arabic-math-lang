#!/usr/bin/env python3
from __future__ import annotations
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "extensions"))
from mal_grammar_gate_comparator import compare_all

CORPUS = ROOT / "corpus/MAL_GRAMMAR_FREEZE_CORPUS_v0.1.json"
PARSER = ROOT / "evidence/MAL_GRAMMAR_CORPUS_PARSER.stdout"
OUT = ROOT / "evidence/MAL_GRAMMAR_GATE_COMPARATOR.stdout"

def main() -> int:
    corpus = json.loads(CORPUS.read_text(encoding="utf-8"))
    parser_payload = json.loads(PARSER.read_text(encoding="utf-8"))
    result = compare_all(corpus, parser_payload)
    if result["summary"]["mismatched"] != 0:
        raise SystemExit("COMPARATOR_MISMATCH")
    if any(item["execution"] != "NOT_PERFORMED" or item["source_executed"] != "NO" for item in result["results"]):
        raise SystemExit("EXECUTION_GUARD_FAIL")
    print("MAL_GATE_COMPARATOR=PASS")
    print(f"TOTAL={result['summary']['total']}")
    print(f"MATCHED={result['summary']['matched']}")
    print(f"MISMATCHED={result['summary']['mismatched']}")
    for item in result["results"]:
        print(f"CASE_ID={item['id']} DECISION={item['observed_decision']} REASON_CODE={item['observed_reason_code']} MATCH={'PASS' if item['match'] else 'FAIL'}")
    print("EXECUTION=NOT_PERFORMED")
    print("SOURCE_EXECUTED=NO")
    print("NETWORK=DISABLED_BY_CONTRACT")
    OUT.write_text(json.dumps(result, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n", encoding="utf-8")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
