#!/usr/bin/env python3
"""Structural validator for MAL-DIR v0.1; no source or IR execution."""
from __future__ import annotations
from typing import Any, Mapping

KNOWN = {"program", "type", "literal_real", "literal_int", "literal_text", "name", "literal_bool", "binary", "call", "decl", "return", "block", "if", "loop", "function", "struct"}
FORBIDDEN_KEYS = {"pointer", "ptr", "address", "callable", "execute", "eval", "exec"}

class MALDIRValidationError(ValueError):
    pass

def validate(ir: Mapping[str, Any]) -> dict[str, Any]:
    if not isinstance(ir, Mapping) or ir.get("dir") != "MAL-DIR" or ir.get("version") != "0.1.0":
        raise MALDIRValidationError("IR_HEADER_INVALID")
    nodes = ir.get("nodes")
    if not isinstance(nodes, list) or not nodes:
        raise MALDIRValidationError("NODES_INVALID")
    if ir.get("root") != len(nodes):
        raise MALDIRValidationError("ROOT_NOT_LAST")
    for expected_id, node in enumerate(nodes, 1):
        if not isinstance(node, Mapping) or node.get("id") != expected_id:
            raise MALDIRValidationError("NODE_ID_NONCONTIGUOUS")
        if node.get("kind") not in KNOWN:
            raise MALDIRValidationError("UNKNOWN_KIND")
        if any(key in FORBIDDEN_KEYS for key in node):
            raise MALDIRValidationError("POINTER_OR_EXECUTION_FIELD")
        children = node.get("children", [])
        if not isinstance(children, list) or any(not isinstance(child, int) or child >= expected_id or child < 1 for child in children):
            raise MALDIRValidationError("CHILD_REFERENCE_INVALID")
    if ir.get("source_ref_executed") is not False:
        raise MALDIRValidationError("EXECUTION_FLAG_INVALID")
    return {"valid": True, "node_count": len(nodes), "root": ir["root"], "execution": "NOT_PERFORMED"}
