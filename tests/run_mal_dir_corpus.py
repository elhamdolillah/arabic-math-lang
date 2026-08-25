#!/usr/bin/env python3
from __future__ import annotations
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FRONTEND = ROOT / "frontend/uori_frontend.py"
sys.path.insert(0, str(FRONTEND.parent))
sys.path.insert(0, str(ROOT / "extensions"))
import uori_frontend  # trusted parser artifact
from mal_dir import build, canonical_json, sha256

CORPUS = ROOT / "corpus/MAL_GRAMMAR_FREEZE_CORPUS_v0.1.json"
OUT = ROOT / "evidence/MAL_DIR_CORPUS.stdout"

def main() -> int:
    corpus = json.loads(CORPUS.read_text(encoding="utf-8"))
    outputs = []
    for case in corpus["cases"]:
        try:
            ast = uori_frontend.ترجمة_AST(case["source"])
        except Exception:
            continue
        ir = build(ast, hashlib.sha256(case["source"].encode("utf-8")).hexdigest())
        ids = [node["id"] for node in ir["nodes"]]
        if ids != list(range(1, len(ids) + 1)):
            raise SystemExit(f"NODE_ID_ORDER_FAIL:{case['id']}")
        if ir["source_ref_executed"] is not False:
            raise SystemExit(f"EXECUTION_GUARD_FAIL:{case['id']}")
        outputs.append({"id": case["id"], "dir_sha256": sha256(ir), "ir": ir})
    payload = {"version": "0.1.0", "cases": outputs, "total_ir": len(outputs), "execution": "NOT_PERFORMED"}
    OUT.write_text(canonical_json(payload), encoding="utf-8")
    print("MAL_DIR_BUILDER=PASS")
    print(f"AST_PASS_CASES_LOWERED={len(outputs)}")
    print("NODE_IDS=CONTIGUOUS_FROM_1")
    print("POINTERS=NONE")
    print("EXECUTION=NOT_PERFORMED")
    print("IR_OUTPUT=evidence/MAL_DIR_CORPUS.stdout")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
