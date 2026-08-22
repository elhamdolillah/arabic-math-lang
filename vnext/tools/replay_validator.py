"""مدقق إعادة تشغيل حتمي لمسار UORI المرجعي."""
from __future__ import annotations
import hashlib
import json
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from kernel_runtime_bridge import execute


class ReplayAbstention(ValueError):
    """امتناع عند اختلاف تشغيلين أو عدم كفاية دليل الإعادة."""


def _canonical(value: Any) -> bytes:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")


def _sha(value: Any) -> str:
    return hashlib.sha256(_canonical(value)).hexdigest()


def replay(ast: tuple[dict[str, object], ...], capability: str = "uori.print.v1") -> dict[str, Any]:
    first = execute(ast, capability)
    second = execute(ast, capability)
    first_hash = _sha(first)
    second_hash = _sha(second)
    if first_hash != second_hash:
        raise ReplayAbstention("امتناع: اختلاف بين تشغيلين متطابقين")
    return {
        "status": "REPLAY_PASS",
        "replay_hash": first_hash,
        "runs": 2,
        "evidence_mode": "DETERMINISTIC",
        "constitutional_claim": "تشغيلان متطابقان فقط؛ لا يثبت ذلك خصائص العتاد أو الاكتمال الرسمي",
    }


if __name__ == "__main__":
    print(json.dumps(replay(({"op": "print", "value": "إعادة حتمية", "line": 1},)), ensure_ascii=False, indent=2, sort_keys=True))
