"""Validated, deterministic math primitives for the UORI extension boundary.

This module is intentionally independent from the frozen wheel. It uses exact
Fraction endpoints, never reads the clock, opens the network, or executes
source. It is a proof-oriented boundary, not a replacement kernel backend.
"""
from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from typing import Iterable, Sequence


class MathBoundaryError(ValueError):
    pass


def _fraction(value: int | str | Fraction) -> Fraction:
    if isinstance(value, bool):
        raise MathBoundaryError("NON_CANONICAL_NUMBER")
    try:
        return Fraction(value)
    except (TypeError, ValueError, ZeroDivisionError) as exc:
        raise MathBoundaryError("NON_CANONICAL_NUMBER") from exc


@dataclass(frozen=True, slots=True)
class Interval:
    lower: Fraction
    upper: Fraction

    def __post_init__(self) -> None:
        lo = _fraction(self.lower)
        hi = _fraction(self.upper)
        if lo > hi:
            raise MathBoundaryError("INTERVAL_ORDER_INVALID")
        object.__setattr__(self, "lower", lo)
        object.__setattr__(self, "upper", hi)

    @classmethod
    def point(cls, value: int | str | Fraction) -> "Interval":
        value = _fraction(value)
        return cls(value, value)

    def add(self, other: "Interval") -> "Interval":
        return Interval(self.lower + other.lower, self.upper + other.upper)

    def sub(self, other: "Interval") -> "Interval":
        return Interval(self.lower - other.upper, self.upper - other.lower)

    def mul(self, other: "Interval") -> "Interval":
        products = [
            self.lower * other.lower,
            self.lower * other.upper,
            self.upper * other.lower,
            self.upper * other.upper,
        ]
        return Interval(min(products), max(products))

    def div(self, other: "Interval") -> "Interval":
        if other.lower <= 0 <= other.upper:
            raise MathBoundaryError("DIVISOR_CONTAINS_ZERO")
        return self.mul(Interval(1 / other.upper, 1 / other.lower))

    def canonical(self) -> tuple[str, str]:
        return (str(self.lower), str(self.upper))


def require_same_shape(*vectors: Sequence[object]) -> tuple[int, ...]:
    shapes = {len(vector) for vector in vectors}
    if len(shapes) != 1:
        raise MathBoundaryError("SHAPE_MISMATCH")
    return (next(iter(shapes)),)


def interval_sum(values: Iterable[Interval]) -> Interval:
    result = Interval.point(0)
    for value in values:
        result = result.add(value)
    return result


def convergence_guard(error: Fraction, tolerance: Fraction, fuel_left: int) -> str:
    error = _fraction(error)
    tolerance = _fraction(tolerance)
    if fuel_left < 0:
        raise MathBoundaryError("FUEL_INVALID")
    if error <= tolerance:
        return "ALLOW"
    if fuel_left == 0:
        return "ABSTAIN"
    return "ABSTAIN"
