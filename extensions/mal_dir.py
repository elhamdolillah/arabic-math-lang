#!/usr/bin/env python3
"""MAL-DIR v0.1: deterministic, non-pointer lowering from MAL AST.
This module is structural only; it never executes source or generated IR.
"""
from __future__ import annotations

import hashlib
import json
from dataclasses import asdict, is_dataclass
from typing import Any


class MALDIRAbstain(ValueError):
    """Raised when the AST contains a node outside the frozen DIR subset."""


def _plain(node: Any) -> Any:
    if is_dataclass(node):
        return {k: _plain(v) for k, v in asdict(node).items()}
    if isinstance(node, list):
        return [_plain(v) for v in node]
    return node


class Builder:
    def __init__(self) -> None:
        self.nodes: list[dict[str, Any]] = []

    def add(self, kind: str, **fields: Any) -> int:
        node_id = len(self.nodes) + 1
        record = {"id": node_id, "kind": kind}
        record.update(fields)
        self.nodes.append(record)
        return node_id

    def lower(self, node: Any) -> int:
        n = _plain(node)
        if not isinstance(n, dict) or "النوع" not in n:
            raise MALDIRAbstain("AST_NODE_INVALID")
        t = n["النوع"]
        if t == "برنامج":
            return self.add("program", children=[self.lower(x) for x in n["عناصر"]])
        if t == "نوع":
            return self.add("type", name=n["الاسم"])
        if t == "عدد":
            return self.add("literal_real" if n["حقيقي"] else "literal_int", value=n["القيمة"])
        if t == "نص":
            return self.add("literal_text", value=n["القيمة"])
        if t == "اسم":
            return self.add("name", value=n["القيمة"])
        if t == "منطقي":
            return self.add("literal_bool", value=n["القيمة"])
        if t == "ثنائي":
            return self.add("binary", op=n["عامل"], children=[self.lower(n["أ"]), self.lower(n["ب"])])
        if t == "استدعاء":
            return self.add("call", name=n["اسم_الدالة"], children=[self.lower(x) for x in n["معاملات"]])
        if t == "تصريح":
            children = [self.lower(n["النوع_المعلن"])]
            if n["قيمة"] is not None:
                children.append(self.lower(n["قيمة"]))
            return self.add("decl", name=n["الاسم"], const=bool(n["ثابت"]), children=children)
        if t == "إرجاع":
            return self.add("return", children=[] if n["قيمة"] is None else [self.lower(n["قيمة"])])
        if t == "كتلة":
            return self.add("block", children=[self.lower(x) for x in n["أوامر"]])
        if t == "شرط":
            children = [self.lower(n["اختبار"]), self.lower(n["عند_الصحيح"])]
            if n["عند_الخطأ"] is not None:
                children.append(self.lower(n["عند_الخطأ"]))
            return self.add("if", children=children)
        if t == "تكرار":
            children = []
            for key in ("تهيئة", "اختبار", "تحديث", "جسم"):
                if n[key] is not None:
                    children.append(self.lower(n[key]))
            return self.add("loop", children=children)
        if t == "دالة":
            children = [*(self.lower(x) for x in n["معاملات"]), self.lower(n["الناتج"]), self.lower(n["الجسم"])]
            return self.add("function", name=n["الاسم"], children=children)
        if t == "بنية":
            return self.add("struct", name=n["الاسم"], children=[self.lower(x) for x in n["حقول"]])
        raise MALDIRAbstain(f"UNKNOWN_AST_KIND:{t}")


def build(ast: Any, source_sha256: str | None = None) -> dict[str, Any]:
    builder = Builder()
    root = builder.lower(ast)
    result: dict[str, Any] = {
        "dir": "MAL-DIR",
        "version": "0.1.0",
        "root": root,
        "nodes": builder.nodes,
        "source_ref_executed": False,
    }
    if source_sha256 is not None:
        result["source_sha256"] = source_sha256
    return result


def canonical_json(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n"


def sha256(value: Any) -> str:
    return hashlib.sha256(canonical_json(value).encode("utf-8")).hexdigest()
