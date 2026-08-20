#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "specs/functions/catalog.json"


def main() -> None:
    catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
    functions = catalog["الدوال"]
    assert {item["المعرّف"] for item in functions} == {"exp", "sqrt", "watar", "pow_integer"}
    for item in functions:
        assert item["حد_الخطأ"] == 16
        for key in ("التنفيذ", "oracle", "Coq"):
            path = ROOT / item[key]
            assert path.exists(), f"missing {key}: {path}"
        assert item["حالة_الإثبات"].startswith("حدود") or item["حالة_الإثبات"].startswith("احتواء")
        assert "Assembly" in item["حالة_الإثبات"] and ("ربط" in item["حالة_الإثبات"] or "مراجعة" in item["حالة_الإثبات"])
    print("UORI_FUNCTION_CATALOG=PASS")


if __name__ == "__main__":
    main()
