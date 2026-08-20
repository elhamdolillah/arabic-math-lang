#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    data = json.loads((ROOT / "specs/functions/builtin_readiness.json").read_text(encoding="utf-8"))
    items = data["الدوال"]
    assert len(items) >= 20
    verified = {x["الاسم"] for x in items if x["الحالة"] == "نموذج_مثبت_والتنفيذ_متحقق"}
    assert verified == {"أُس", "جذر", "وتر", "قوة"}
    for item in items:
        assert item["الحالة"]
        if item["الحالة"] != "نموذج_مثبت_والتنفيذ_متحقق":
            assert item.get("سبب"), item["الاسم"]
    print("UORI_BUILTIN_READINESS=PASS")


if __name__ == "__main__":
    main()
