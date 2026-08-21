#!/usr/bin/env python3
"""محقق مستقل لسجل UORI v9؛ لا يعتمد على مكتبات خارجية."""
from __future__ import annotations

import json
import sys
from pathlib import Path

MODES = {"DETERMINISTIC", "INTERVAL", "PROBABILISTIC", "AI-HYPOTHESIS", "INSUFFICIENT-EVIDENCE"}
STATUSES = {"specified", "implemented", "verified", "abstained"}
KINDS = {"instruction", "data", "file", "formal_proof", "runtime", "test"}
RULES = {
    "deterministic_if_domain_and_error_are_valid",
    "interval_if_bounds_are_guaranteed",
    "probabilistic_if_data_are_sufficient_and_calibrated",
    "generative_ai_for_hypotheses_or_explanation_only",
    "abstain_if_evidence_is_insufficient",
}


def fail(message: str) -> None:
    raise ValueError(message)


def validate(root: Path, manifest_path: Path) -> None:
    data = json.loads(manifest_path.read_text(encoding="utf-8"))
    if data.get("version") != "9.0.0-rebuild":
        fail("إصدار غير متوقع")
    constitution = data.get("constitution")
    if not isinstance(constitution, dict) or constitution.get("max_error") != 16:
        fail("حد الخطأ الدستوري يجب أن يساوي 16")
    if constitution.get("source") != "docs/CONSTITUTION.md":
        fail("مصدر الدستور غير صحيح")
    if set(constitution.get("rules", [])) != RULES:
        fail("قواعد الدستور الخمس غير مكتملة أو متعارضة")

    components = data.get("components")
    if not isinstance(components, list) or not components:
        fail("لا توجد مكونات في السجل")
    ids = set()
    for component in components:
        required = {"id", "kind", "path", "owner", "evidence_mode", "status"}
        missing = required - component.keys()
        if missing:
            fail(f"حقول مفقودة في مكوّن: {sorted(missing)}")
        if component["id"] in ids:
            fail(f"معرّف مكرر: {component['id']}")
        ids.add(component["id"])
        if component["kind"] not in KINDS:
            fail(f"نوع مكوّن غير معروف: {component['kind']}")
        if component["evidence_mode"] not in MODES:
            fail(f"نمط دليل غير معروف: {component['evidence_mode']}")
        if component["status"] not in STATUSES:
            fail(f"حالة غير معروفة: {component['status']}")
        if component.get("max_error", 0) > 16:
            fail(f"تجاوز حد الخطأ: {component['id']}")
        path = root / component["path"]
        if not path.exists():
            fail(f"مسار مكوّن غير موجود: {component['path']}")

    acceptance = data.get("acceptance")
    if not isinstance(acceptance, dict) or acceptance.get("no_destructive_replace") is not True:
        fail("يجب منع الاستبدال التدميري")
    print("UORI_V9_MANIFEST=VALID")
    print(f"UORI_V9_COMPONENTS={len(components)}")
    print("UORI_V9_DESTRUCTIVE_REPLACE=REJECTED")


if __name__ == "__main__":
    repository = Path(__file__).resolve().parents[2]
    manifest = repository / "vnext" / "manifest.json"
    try:
        validate(repository, manifest)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"UORI_V9_MANIFEST=INVALID: {error}", file=sys.stderr)
        raise SystemExit(1)
