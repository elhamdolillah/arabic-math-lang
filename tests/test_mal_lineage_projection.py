"""اختبار حتمي لإسقاط آليات السلالات إلى MAL وتكامل UORI الساكن."""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.path.insert(0, "/home/ubuntu/uori-mediator-kit")

from frontend.uori_frontend import محلل_معجمي, محلل_نحوي  # noqa: E402
from extensions.uori_mal_lineage import evidence_mapping, inspect_mal_projection  # noqa: E402


SOURCE = ROOT / "examples" / "lineage_mechanisms_projection.mal"


def main() -> int:
    source = SOURCE.read_text(encoding="utf-8")
    tokens = محلل_معجمي().حلل(source)
    program = محلل_نحوي(tokens).حلل_البرنامج()
    assert len(program.عناصر) == 6
    assert not any(marker in source for marker in ("source_ref", "eval", "exec"))
    result = inspect_mal_projection(SOURCE)
    mapping = evidence_mapping(result)
    assert result.decision == "ALLOW"
    assert result.execution == "NOT_PERFORMED"
    assert result.source_executed == "NO"
    assert result.network == "DISABLED_BY_CONTRACT"
    assert mapping["evidence_sha256"]
    json.dumps(mapping, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    print("MAL_LINEAGE_PROJECTION_PARSE=PASS")
    print("UORI_STATIC_INSPECTION=PASS")
    print(f"DECISION={result.decision}")
    print("EXECUTION=NOT_PERFORMED")
    print("SOURCE_EXECUTED=NO")
    print("NETWORK=DISABLED_BY_CONTRACT")
    print("STATUS=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
