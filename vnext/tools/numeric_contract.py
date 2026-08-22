"""عمليات عددية محدودة وحتمية لـ Q32.32 مع فتريات مغلقة."""
from __future__ import annotations

SCALE = 1 << 32
MAX_INT = (1 << 63) - 1
MIN_INT = -(1 << 63)


class NumericAbstention(ValueError):
    """امتناع عند تجاوز تمثيل Q32.32 أو سوء الفترية."""


def check_q32(value: int) -> int:
    if not isinstance(value, int) or not MIN_INT <= value <= MAX_INT:
        raise NumericAbstention("قيمة Q32.32 خارج المجال")
    return value


def add_q32(left: int, right: int) -> int:
    return check_q32(check_q32(left) + check_q32(right))


def interval_add(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    lo, hi = left
    rlo, rhi = right
    if lo > hi or rlo > rhi:
        raise NumericAbstention("فترية غير مرتبة")
    return add_q32(lo, rlo), add_q32(hi, rhi)


def _ceil_div(value: int, divisor: int) -> int:
    return -((-value) // divisor)


def interval_mul(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    lo, hi = left
    rlo, rhi = right
    if lo > hi or rlo > rhi:
        raise NumericAbstention("فترية غير مرتبة")
    for value in (lo, hi, rlo, rhi):
        check_q32(value)
    products = [lo * rlo, lo * rhi, hi * rlo, hi * rhi]
    lower = min(products) // SCALE
    upper = _ceil_div(max(products), SCALE)
    return check_q32(lower), check_q32(upper)
