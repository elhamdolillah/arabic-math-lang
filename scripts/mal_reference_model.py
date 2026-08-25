"""نموذج Python مرجعي مستقل للنحو المحدود في MAL وامتداد Stage 2 الحسابي."""

from __future__ import annotations

import re
from pathlib import Path

_TOKEN = re.compile(r"[^\s=+*/()\-]+|[=+*/()\-]", re.UNICODE)
_FORBIDDEN = ("eval", "exec", "unsafe")
_MAX_U64 = 18_446_744_073_709_551_615


class ReferenceError(Exception):
    pass


class ReferenceParser:
    def __init__(self, source: str) -> None:
        self.tokens = _TOKEN.findall(source)
        self.index = 0
        self.ast_count = 0

    def take(self) -> str:
        if self.index >= len(self.tokens):
            raise ReferenceError
        token = self.tokens[self.index]
        self.index += 1
        return token

    def peek(self) -> str | None:
        if self.index >= len(self.tokens):
            return None
        return self.tokens[self.index]

    def parse(self) -> tuple[int, int]:
        declaration = self.take()
        if not declaration.startswith("بنية_"):
            raise ReferenceError
        if self.take() != "=":
            raise ReferenceError
        expression, root_id = self.parse_additive()
        if self.peek() is not None:
            raise ReferenceError
        self.ast_count += 1  # عقدة التصريح
        return root_id, expression

    def parse_additive(self) -> tuple[int, int]:
        value, node_id = self.parse_multiplicative()
        while self.peek() in ("+", "-"):
            operator = self.take()
            right_value, right_id = self.parse_multiplicative()
            if operator == "+":
                value = value + right_value
                if value > _MAX_U64:
                    raise ReferenceError
            else:
                value -= right_value
                if value < 0:
                    raise ReferenceError
            node_id = self.ast_count
            self.ast_count += 1
        return value, node_id

    def parse_multiplicative(self) -> tuple[int, int]:
        value, node_id = self.parse_factor()
        while self.peek() in ("*", "/"):
            operator = self.take()
            right_value, right_id = self.parse_factor()
            if operator == "*":
                value *= right_value
                if value > _MAX_U64:
                    raise ReferenceError
            else:
                if right_value == 0:
                    raise ReferenceError
                value //= right_value
            node_id = self.ast_count
            self.ast_count += 1
        return value, node_id

    def parse_factor(self) -> tuple[int, int]:
        token = self.take()
        if token == "(":
            result = self.parse_additive()
            if self.take() != ")":
                raise ReferenceError
            return result
        if not token.isascii() or not token.isdigit():
            raise ReferenceError
        value = int(token, 10)
        if value > _MAX_U64:
            raise ReferenceError
        node_id = self.ast_count
        self.ast_count += 1
        return value, node_id


def abstain() -> dict[str, object]:
    return {
        "status": "ABSTAIN",
        "stdout": "STATUS=ABSTAIN\nERROR=UNSUPPORTED_OR_INVALID_SYNTAX\n",
    }


def reference_case(path: Path) -> dict[str, object]:
    source = path.read_text(encoding="utf-8")
    if any(word in source for word in _FORBIDDEN):
        return abstain()
    try:
        parser = ReferenceParser(source)
        root_id, _value = parser.parse()
    except (ReferenceError, ValueError, RecursionError):
        return abstain()

    token_count = len(parser.tokens)
    return {
        "status": "PARSED_EXTENSION_SCOPED",
        "stdout": (
            "STATUS=PARSED\n"
            "ROOT_NODE_ID={root}\n"
            "ROOT_OPCODE=DECLARE_NODE\n"
            "ROOT_RIGHT_NODE_ID={root_expr}\n"
            "TOKEN_COUNT={tokens}\n"
            "AST_COUNT={ast}\n"
        ).format(root=parser.ast_count - 1, root_expr=root_id, tokens=token_count, ast=parser.ast_count),
    }


if __name__ == "__main__":
    raise SystemExit("REFERENCE_MODEL_LIBRARY_ONLY")
