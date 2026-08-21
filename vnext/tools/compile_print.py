#!/usr/bin/env python3
"""مسار UORI v9 المرجعي: تحليل ⎕ ثم فحص النوع والملكية وإنتاج عقد نتيجة."""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from parser import ParseError, lower, parse
from abi_contract import chain_step, lower_to_abi


class ContractError(ValueError):
    pass


def compile_source(source: str, source_name: str = "<stdin>") -> dict[str, object]:
    program = parse(source)
    ast = lower(program)
    for node in ast:
        if node["op"] != "print" or not isinstance(node["value"], str):
            raise ContractError("نوع عقد الطباعة غير صالح")
        if "ownership" in node:
            raise ContractError("تعليمة الإخراج لا تملك قيمة قابلة للنقل في هذا المسار")
    digest = hashlib.sha256(source.encode("utf-8")).hexdigest()
    abi = lower_to_abi(ast)
    evidence_step = chain_step(digest, abi)
    output = "\n".join(str(node["value"]) for node in ast)
    if ast:
        output += "\n"
    return {
        "version": "uori-v9",
        "source": {"name": source_name, "sha256": digest},
        "ast": ast,
        "abi": abi,
        "evidence_chain": evidence_step,
        "result": {
            "status": "success",
            "inference_mode": "deterministic",
            "evidence_label": "DETERMINISTIC",
            "evidence_state": "sufficient",
            "error_bound": 0,
            "backend": "reference-only",
            "output": output,
        },
    }


def main() -> int:
    try:
        source_name = sys.argv[1] if len(sys.argv) > 1 else "<stdin>"
        source = sys.stdin.read()
        print(json.dumps(compile_source(source, source_name), ensure_ascii=False, indent=2))
        return 0
    except (ParseError, ContractError) as exc:
        print(json.dumps({
            "version": "uori-v9",
            "result": {
                "status": "abstain",
                "inference_mode": "abstention",
                "evidence_label": "INSUFFICIENT-EVIDENCE",
                "evidence_state": "insufficient",
                "reason": str(exc),
            },
        }, ensure_ascii=False, indent=2), file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
