#!/usr/bin/env python3
"""محلل صغير حتمي لمسار الإخراج في UORI v9."""
from __future__ import annotations

from dataclasses import dataclass


class ParseError(ValueError):
    pass


@dataclass(frozen=True)
class PrintString:
    value: str
    line: int


@dataclass(frozen=True)
class Program:
    statements: tuple[PrintString, ...]


def parse(source: str) -> Program:
    statements: list[PrintString] = []
    for line_number, raw_line in enumerate(source.splitlines(), start=1):
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if not line.startswith("⎕"):
            raise ParseError(f"السطر {line_number}: التعليمة الوحيدة المدعومة في المسار الأول هي ⎕")
        payload = line[1:].strip()
        if len(payload) < 2 or payload[0] != '"' or payload[-1] != '"':
            raise ParseError(f"السطر {line_number}: ⎕ تتطلب نصاً محاطاً بعلامتي اقتباس")
        value = payload[1:-1]
        if '"' in value:
            raise ParseError(f"السطر {line_number}: الاقتباس الداخلي غير مدعوم في الإصدار الأول")
        statements.append(PrintString(value=value, line=line_number))
    return Program(statements=tuple(statements))


def lower(program: Program) -> tuple[dict[str, object], ...]:
    """تحويل AST إلى تمثيل حتمي بسيط قبل مولد الإخراج."""
    return tuple({"op": "print", "value": node.value, "line": node.line} for node in program.statements)


if __name__ == "__main__":
    import json
    import sys

    parsed = parse(sys.stdin.read())
    print(json.dumps({"ast": lower(parsed)}, ensure_ascii=False, indent=2))
