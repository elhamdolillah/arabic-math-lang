"""Bounded static checker for the MAL GADT/rank-2 research IR.

This is not a compiler and never executes MAL source. It checks canonical data
shapes only and returns RESEARCH, ABSTAIN, or DENY.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class Decision:
    decision: str
    reason: str


MAX_CONSTRUCTORS = 32
MAX_BRANCHES = 32
MAX_FORALL_DEPTH = 2


def _deny_if_forbidden(node: Any) -> Decision | None:
    if not isinstance(node, dict):
        return Decision("ABSTAIN", "malformed_node")
    forbidden = {"raw_pointer", "eval", "exec", "runtime_symbol_lookup", "reflection"}
    if node.get("construct") in forbidden or node.get("representation") in forbidden:
        return Decision("DENY", "forbidden_construct")
    return None


def check_gadt(node: Any) -> Decision:
    bad = _deny_if_forbidden(node)
    if bad:
        return bad
    if not isinstance(node, dict) or node.get("kind") != "gadt":
        return Decision("ABSTAIN", "expected_gadt_node")
    constructors = node.get("constructors")
    branches = node.get("branches")
    if not isinstance(constructors, list) or not isinstance(branches, list):
        return Decision("ABSTAIN", "missing_constructor_or_branch_list")
    if not constructors or len(constructors) > MAX_CONSTRUCTORS or len(branches) > MAX_BRANCHES:
        return Decision("ABSTAIN", "resource_bound")
    ids = [item.get("id") for item in constructors if isinstance(item, dict)]
    branch_ids = [item.get("constructor_id") for item in branches if isinstance(item, dict)]
    if len(ids) != len(constructors) or len(set(ids)) != len(ids):
        return Decision("ABSTAIN", "noncanonical_constructor_ids")
    if any(not isinstance(item, dict) or item.get("index") is None for item in constructors):
        return Decision("ABSTAIN", "missing_type_index")
    if sorted(ids) != ids or sorted(branch_ids) != branch_ids:
        return Decision("ABSTAIN", "noncanonical_order")
    if set(branch_ids) != set(ids) or len(branch_ids) != len(ids):
        return Decision("ABSTAIN", "nonexhaustive_or_duplicate_match")
    if node.get("existential_escape") is True:
        return Decision("ABSTAIN", "existential_escape")
    if node.get("type_level_steps", 0) > node.get("fuel", 0):
        return Decision("ABSTAIN", "fuel_exhausted")
    return Decision("RESEARCH", "bounded_closed_exhaustive_gadt")


def check_rank2(node: Any) -> Decision:
    bad = _deny_if_forbidden(node)
    if bad:
        return bad
    if not isinstance(node, dict) or node.get("kind") != "rank_type":
        return Decision("ABSTAIN", "expected_rank_type_node")
    if node.get("rank") != 2:
        return Decision("ABSTAIN", "rank_limit")
    if node.get("explicit_forall") is not True:
        return Decision("ABSTAIN", "missing_forall_annotation")
    if node.get("impredicative") is True:
        return Decision("DENY", "impredicative_instantiation")
    binders = node.get("binders")
    if not isinstance(binders, list) or not binders or binders != sorted(binders):
        return Decision("ABSTAIN", "noncanonical_binder_order")
    if node.get("unbounded_unification") is True:
        return Decision("ABSTAIN", "unbounded_unification")
    return Decision("RESEARCH", "bounded_explicit_rank2")


def check(node: Any) -> Decision:
    kind = node.get("kind") if isinstance(node, dict) else None
    if kind == "gadt":
        return check_gadt(node)
    if kind == "rank_type":
        return check_rank2(node)
    return Decision("ABSTAIN", "unknown_kind")
