#!/usr/bin/env python3
from __future__ import annotations
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "extensions"))
from mal_dir_validator import validate

IR_PATH = ROOT / "evidence/MAL_DIR_CORPUS_RUN1.json"
OUT = ROOT / "evidence/MAL_DIR_VALIDATOR.stdout"

def main() -> int:
    payload = json.loads(IR_PATH.read_text(encoding="utf-8"))
    results = []
    for item in payload["cases"]:
        if not isinstance(item.get("ir"), dict):
            continue
        results.append({"id": item["id"], **validate(item["ir"])})
    if not results or any(not item["valid"] for item in results):
        raise SystemExit("DIR_VALIDATION_FAIL")
    print("MAL_DIR_VALIDATOR=PASS")
    print(f"CASES_VALIDATED={len(results)}")
    print(f"TOTAL_NODES={sum(item['node_count'] for item in results)}")
    for item in results:
        print(f"CASE_ID={item['id']} VALID=YES NODE_COUNT={item['node_count']} ROOT={item['root']} EXECUTION={item['execution']}")
    print("SOURCE_EXECUTED=NO")
    print("NETWORK=DISABLED_BY_CONTRACT")
    OUT.write_text("\n".join([
        "MAL_DIR_VALIDATOR=PASS",
        f"CASES_VALIDATED={len(results)}",
        f"TOTAL_NODES={sum(item['node_count'] for item in results)}",
        *[f"CASE_ID={item['id']} VALID=YES NODE_COUNT={item['node_count']} ROOT={item['root']} EXECUTION={item['execution']}" for item in results],
        "SOURCE_EXECUTED=NO",
        "NETWORK=DISABLED_BY_CONTRACT",
        "",
    ]), encoding="utf-8")

if __name__ == "__main__":
    raise SystemExit(main())
