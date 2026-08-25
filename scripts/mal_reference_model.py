"""نموذج Python مرجعي مستقل للنحو المحدود المثبت في MAL.

هذا الملف لا ينفذ مصدرًا ديناميكيًا؛ بل يطابق بنية التعريف العددية المحدودة
ويعيد تمثيلًا canonical للمقارنة مع mal_runner.
"""

from __future__ import annotations

import re
from pathlib import Path

_DECLARATION = re.compile(r"\A(بنية_[\w\u0600-\u06ff]*) = ([0-9]+)\n\Z", re.UNICODE)
_FORBIDDEN = ("eval", "exec", "unsafe")
_MAX_U64 = 18_446_744_073_709_551_615


def reference_case(path: Path) -> dict[str, object]:
    source = path.read_text(encoding="utf-8")
    if any(word in source for word in _FORBIDDEN):
        return {
            "status": "ABSTAIN",
            "stdout": "STATUS=ABSTAIN\nERROR=UNSUPPORTED_OR_INVALID_SYNTAX\n",
        }

    match = _DECLARATION.fullmatch(source)
    if match is None:
        return {
            "status": "ABSTAIN",
            "stdout": "STATUS=ABSTAIN\nERROR=UNSUPPORTED_OR_INVALID_SYNTAX\n",
        }

    value_text = match.group(2)
    value = int(value_text, 10)
    if value > _MAX_U64:
        return {
            "status": "ABSTAIN",
            "stdout": "STATUS=ABSTAIN\nERROR=UNSUPPORTED_OR_INVALID_SYNTAX\n",
        }

    return {
        "status": "PARSED_EXTENSION_SCOPED",
        "stdout": (
            "STATUS=PARSED\n"
            "ROOT_NODE_ID=1\n"
            "ROOT_OPCODE=DECLARE_NODE\n"
            "ROOT_RIGHT_NODE_ID=0\n"
            "TOKEN_COUNT=3\n"
            "AST_COUNT=2\n"
        ),
    }


if __name__ == "__main__":
    raise SystemExit("REFERENCE_MODEL_LIBRARY_ONLY")
