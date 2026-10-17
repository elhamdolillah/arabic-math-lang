#!/usr/bin/env python3
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from gadt_rank_checker import check


def main() -> int:
    cases = [
        ({"kind": "gadt", "constructors": [{"id": 1, "index": "ن"}, {"id": 2, "index": "ص"}], "branches": [{"constructor_id": 1}, {"constructor_id": 2}], "fuel": 2, "type_level_steps": 1}, "RESEARCH"),
        ({"kind": "gadt", "constructors": [{"id": 1, "index": "ن"}, {"id": 2, "index": "ص"}], "branches": [{"constructor_id": 1}], "fuel": 2, "type_level_steps": 1}, "ABSTAIN"),
        ({"kind": "gadt", "constructors": [{"id": 1, "index": "ن"}], "branches": [{"constructor_id": 1}], "construct": "reflection", "fuel": 1}, "DENY"),
        ({"kind": "gadt", "constructors": [{"id": 1, "index": "ن"}], "branches": [{"constructor_id": 1}], "fuel": 0, "type_level_steps": 1}, "ABSTAIN"),
        ({"kind": "rank_type", "rank": 2, "explicit_forall": True, "binders": [1, 2]}, "RESEARCH"),
        ({"kind": "rank_type", "rank": 3, "explicit_forall": True, "binders": [1]}, "ABSTAIN"),
        ({"kind": "rank_type", "rank": 2, "explicit_forall": False, "binders": [1]}, "ABSTAIN"),
        ({"kind": "rank_type", "rank": 2, "explicit_forall": True, "binders": [1], "impredicative": True}, "DENY"),
        ({"kind": "rank_type", "rank": 2, "explicit_forall": True, "binders": [2, 1]}, "ABSTAIN"),
    ]
    for node, expected in cases:
        actual = check(node).decision
        assert actual == expected, (node, actual, expected)
    print("GADT_RANK_CHECKER=PASS")
    print("CASES=9")
    print("GADT_BOUNDED_EXHAUSTIVE=RESEARCH")
    print("RANK2_EXPLICIT_FORALL=RESEARCH")
    print("REFLECTION=DENY")
    print("IMPREDICATIVE=DENY")
    print("AMBIGUITY=ABSTAIN")
    print("SOURCE_EXECUTION=NOT_PERFORMED")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
