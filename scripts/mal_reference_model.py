"""نموذج Python مرجعي مستقل للنحو والتقييم المحدودين في MAL."""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path

_TOKEN = re.compile(r"\r\n|\n|==|!=|>|<|[=+*/()\-]|[^\s=+*/()\-<>!]+", re.UNICODE)
_FORBIDDEN = ("eval", "exec", "unsafe")
_MAX_U64 = 18_446_744_073_709_551_615


class ReferenceError(Exception):
    pass


@dataclass(frozen=True)
class Node:
    opcode: str
    name: str | None = None
    left: int | None = None
    right: int | None = None
    numeric_value: int = 0


class ReferenceParser:
    def __init__(self, source: str) -> None:
        self.tokens = _TOKEN.findall(source)
        self.index = 0
        self.nodes: list[Node] = []

    def take(self) -> str:
        if self.index >= len(self.tokens): raise ReferenceError
        token = self.tokens[self.index]; self.index += 1; return token

    def peek(self) -> str | None:
        return self.tokens[self.index] if self.index < len(self.tokens) else None

    def skip_separators(self) -> None:
        while self.peek() in ("\n", "\r\n"): self.take()

    def alloc(self, node: Node) -> int:
        node_id = len(self.nodes); self.nodes.append(node); return node_id

    def parse(self) -> int:
        self.skip_separators(); root = self.parse_statement()
        while True:
            self.skip_separators()
            if self.peek() is None: return root
            nxt = self.parse_statement()
            root = self.alloc(Node("SEQUENCE", left=root, right=nxt, numeric_value=self.nodes[nxt].numeric_value))

    def parse_statement(self) -> int:
        return self.parse_if() if self.peek() == "إذا" else self.parse_declaration()

    def parse_if(self) -> int:
        if self.take() != "إذا": raise ReferenceError
        condition = self.parse_comparison()
        if self.take() != "فإن": raise ReferenceError
        self.skip_separators(); body = self.parse_statement(); self.skip_separators()
        if self.take() != "نهاية": raise ReferenceError
        return self.alloc(Node("IF_STATEMENT", left=condition, right=body))

    def parse_declaration(self) -> int:
        name = self.take()
        if not name.startswith("بنية_") or self.take() != "=": raise ReferenceError
        expression = self.parse_comparison()
        value = self.nodes[expression].numeric_value if self.is_static(expression) else 0
        return self.alloc(Node("DECLARE_NODE", name=name, right=expression, numeric_value=value))

    def parse_comparison(self) -> int:
        left = self.parse_additive()
        while self.peek() in ("==", "!=", ">", "<"):
            op = {"==":"EQUAL", "!=":"NOT_EQUAL", ">":"GREATER_THAN", "<":"LESS_THAN"}[self.take()]
            right = self.parse_additive(); left = self.alloc(Node(op, left=left, right=right))
        return left

    def parse_additive(self) -> int:
        left = self.parse_multiplicative()
        while self.peek() in ("+", "-"):
            op = self.take(); right = self.parse_multiplicative(); value = 0
            if self.is_static(left) and self.is_static(right):
                value = self.nodes[left].numeric_value + self.nodes[right].numeric_value if op == "+" else self.nodes[left].numeric_value - self.nodes[right].numeric_value
                if value < 0 or value > _MAX_U64: raise ReferenceError
            left = self.alloc(Node("ADD" if op == "+" else "SUBTRACT", left=left, right=right, numeric_value=value))
        return left

    def parse_multiplicative(self) -> int:
        left = self.parse_factor()
        while self.peek() in ("*", "/"):
            op = self.take(); right = self.parse_factor(); value = 0
            if self.is_static(left) and self.is_static(right):
                rv = self.nodes[right].numeric_value
                if op == "/":
                    if rv == 0: raise ReferenceError
                    value = self.nodes[left].numeric_value // rv
                else: value = self.nodes[left].numeric_value * rv
                if value > _MAX_U64: raise ReferenceError
            left = self.alloc(Node("MULTIPLY" if op == "*" else "DIVIDE", left=left, right=right, numeric_value=value))
        return left

    def parse_factor(self) -> int:
        token = self.take()
        if token == "(":
            result = self.parse_additive()
            if self.take() != ")": raise ReferenceError
            return result
        if token.isascii() and token.isdigit():
            value = int(token, 10)
            if value > _MAX_U64: raise ReferenceError
            return self.alloc(Node("LITERAL_NUM", numeric_value=value))
        if not token or token in ("\n", "\r\n") or token in _FORBIDDEN: raise ReferenceError
        return self.alloc(Node("BIND_SYMBOL", name=token))

    def is_static(self, node_id: int) -> bool:
        node = self.nodes[node_id]
        if node.opcode == "LITERAL_NUM": return True
        if node.opcode == "BIND_SYMBOL": return False
        if node.opcode in {"ADD","SUBTRACT","MULTIPLY","DIVIDE","EQUAL","NOT_EQUAL","GREATER_THAN","LESS_THAN"}:
            return self.is_static(node.left) and self.is_static(node.right)
        return False


class ReferenceEvaluator:
    def __init__(self, nodes: list[Node]) -> None:
        self.nodes = nodes; self.symbols: dict[str, int] = {}

    def visit(self, node_id: int) -> int:
        node = self.nodes[node_id]; op = node.opcode
        if op == "LITERAL_NUM": return node.numeric_value
        if op == "BIND_SYMBOL":
            if node.name not in self.symbols: raise ReferenceError
            return self.symbols[node.name]
        if op == "DECLARE_NODE":
            value = self.visit(node.right); self.symbols[node.name] = value; return value
        if op == "SEQUENCE": self.visit(node.left); return self.visit(node.right)
        if op == "IF_STATEMENT": return self.visit(node.right) if self.visit(node.left) > 0 else 0
        if op in {"ADD","SUBTRACT","MULTIPLY","DIVIDE"}:
            left, right = self.visit(node.left), self.visit(node.right)
            if op == "ADD": value = left + right
            elif op == "SUBTRACT": value = left - right
            elif op == "MULTIPLY": value = left * right
            else:
                if right == 0: raise ReferenceError
                value = left // right
            if value < 0 or value > _MAX_U64: raise ReferenceError
            return value
        if op in {"EQUAL","NOT_EQUAL","GREATER_THAN","LESS_THAN"}:
            left, right = self.visit(node.left), self.visit(node.right)
            return int({"EQUAL":left==right,"NOT_EQUAL":left!=right,"GREATER_THAN":left>right,"LESS_THAN":left<right}[op])
        raise ReferenceError


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
        root_id = parser.parse()
        if parser.peek() is not None: raise ReferenceError
        value = ReferenceEvaluator(parser.nodes).visit(root_id)
        root = parser.nodes[root_id]
    except (ReferenceError, ValueError, RecursionError, IndexError, TypeError):
        return abstain()

    return {
        "status": "PARSED_EXTENSION_SCOPED",
        "stdout": (
            "STATUS=EVALUATED\n"
            "VALUE={value}\n"
            "ROOT_NODE_ID={root}\n"
            "ROOT_OPCODE={opcode}\n"
            "ROOT_RIGHT_NODE_ID={right}\n"
            "TOKEN_COUNT={tokens}\n"
            "AST_COUNT={ast}\n"
        ).format(
            value=value,
            root=root_id,
            opcode=root.opcode,
            right=root.right,
            tokens=len(parser.tokens),
            ast=len(parser.nodes),
        ),
    }


if __name__ == "__main__":
    raise SystemExit("REFERENCE_MODEL_LIBRARY_ONLY")
