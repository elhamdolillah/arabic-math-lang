"""حارس موارد مرجعي للعودية.

الحارس لا ينفذ خوارزمية غير موثوقة؛ بل يوفر عدادات وحدوداً يجب أن يلتزم بها
المشغل المعزول. حد الزمن اختياري ويستعمل ساعة monotonic خارجية.
"""
from __future__ import annotations
from dataclasses import dataclass
from time import monotonic

@dataclass(frozen=True)
class GuardLimits:
    fuel: int
    max_depth: int
    memory_units: int
    timeout_seconds: float

@dataclass
class GuardState:
    limits: GuardLimits
    fuel_used: int = 0
    depth: int = 0
    memory_used: int = 0
    started_at: float | None = None

class GuardAbort(RuntimeError):
    pass


def start(limits: GuardLimits) -> GuardState:
    if min(limits.fuel, limits.max_depth, limits.memory_units) < 0 or limits.timeout_seconds < 0:
        raise ValueError("invalid_limits")
    return GuardState(limits=limits, started_at=monotonic())


def tick(state: GuardState, *, memory_delta: int = 0) -> None:
    state.fuel_used += 1
    state.memory_used += memory_delta
    elapsed = monotonic() - (state.started_at or monotonic())
    if state.fuel_used > state.limits.fuel:
        raise GuardAbort("fuel_exhausted")
    if state.memory_used > state.limits.memory_units:
        raise GuardAbort("memory_limit_exceeded")
    if elapsed > state.limits.timeout_seconds:
        raise GuardAbort("timeout_exceeded")


def enter(state: GuardState) -> None:
    state.depth += 1
    if state.depth > state.limits.max_depth:
        raise GuardAbort("stack_depth_exceeded")


def leave(state: GuardState) -> None:
    if state.depth <= 0:
        raise GuardAbort("unbalanced_leave")
    state.depth -= 1
