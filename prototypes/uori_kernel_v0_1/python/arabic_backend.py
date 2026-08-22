"""بناء جدول الخلفية من مواصفات عربية مع دوال مضمّنة معروفة مسبقاً."""
from __future__ import annotations

from collections.abc import Callable, Iterable

from arabic_registry import ArabicAlgorithmSpec


class BackendSpecError(ValueError):
    pass


def bind_trusted_backend(
    specifications: Iterable[ArabicAlgorithmSpec],
    trusted: dict[str, Callable[[tuple[int, ...]], int]],
) -> dict[str, Callable[[tuple[int, ...]], int]]:
    """يربط العملية العربية بدالة مضمّنة؛ لا يقرأ أسماء وحدات ولا يقيّم نصاً."""
    result: dict[str, Callable[[tuple[int, ...]], int]] = {}
    for spec in specifications:
        implementation = trusted.get(spec.operation)
        if implementation is None:
            raise BackendSpecError(f"لا توجد خلفية موثوقة للعملية: {spec.operation}")
        if spec.operation in result:
            raise BackendSpecError(f"تكرار خلفية العملية: {spec.operation}")
        result[spec.operation] = implementation
    return result
