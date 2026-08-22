"""تحقق حتمي من سلسلة أدلة UORI بصيغة JSON Lines."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path


class EvidenceChainError(ValueError):
    """خطأ في سلامة سلسلة الدليل."""


def _digest(payload: dict) -> str:
    encoded = json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hashlib.sha256(encoded).hexdigest()


def verify_records(records: list[dict]) -> dict:
    previous = "0" * 64
    for index, record in enumerate(records):
        if not isinstance(record, dict):
            raise EvidenceChainError(f"السجل {index} ليس كائناً")
        required = {"step", "mode", "result", "previous_hash", "hash"}
        if set(record) != required:
            raise EvidenceChainError(f"حقول غير صحيحة في السجل {index}")
        if record["step"] != index:
            raise EvidenceChainError(f"ترتيب خطوة غير صحيح عند {index}")
        if record["previous_hash"] != previous:
            raise EvidenceChainError(f"انقطاع السلسلة عند {index}")
        unsigned = {key: record[key] for key in record if key != "hash"}
        expected = _digest(unsigned)
        if record["hash"] != expected:
            raise EvidenceChainError(f"بصمة غير صحيحة عند {index}")
        previous = record["hash"]
    return {"valid": True, "length": len(records), "head": previous}


def load_and_verify(path: str | Path) -> dict:
    records = [json.loads(line) for line in Path(path).read_text(encoding="utf-8").splitlines() if line.strip()]
    return verify_records(records)


def make_record(step: int, mode: str, result: str, previous_hash: str) -> dict:
    unsigned = {"step": step, "mode": mode, "result": result, "previous_hash": previous_hash}
    return {**unsigned, "hash": _digest(unsigned)}
