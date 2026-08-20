#!/usr/bin/env python3
"""محاكاة مرجعية محدودة لمسار قوة Assembly.

المحاكي يطابق الحساب الموقّع 128 بت والتحويل الحسابي >> 32، لكنه لا
يثبت أن CPU نفذ NASM الفعلي؛ لذلك يبقى دليلاً وسيطاً فقط.
"""
from dataclasses import dataclass

SCALE = 1 << 32
MIN_Q32 = -(1 << 63)
MAX_Q32 = (1 << 63) - 1


@dataclass(frozen=True)
class Reject:
    code: int = 1


def in_q32(x: int) -> bool:
    return MIN_Q32 <= x <= MAX_Q32


def signed_128(x: int) -> int:
    lo = -(1 << 127)
    hi = (1 << 127) - 1
    assert lo <= x <= hi
    return x


def qmul_assembly_model(x: int, y: int):
    """نموذج imul ثم shrd/sar: floor((x*y)/2^32) مع فحص Q32.32."""
    product = signed_128(x * y)
    scaled = product // SCALE
    return scaled if in_q32(scaled) else Reject()


def pow_assembly_model(base: int, exponent: int):
    if base == 0 and exponent == 0:
        return Reject()
    if exponent < 0 or exponent > 31 or not in_q32(base):
        return Reject()
    result = SCALE
    factor = base
    n = exponent
    while True:
        if n & 1:
            result = qmul_assembly_model(result, factor)
            if isinstance(result, Reject):
                return result
        n >>= 1
        if n == 0:
            return result
        factor = qmul_assembly_model(factor, factor)
        if isinstance(factor, Reject):
            return factor


def main():
    assert pow_assembly_model(SCALE, 0) == SCALE
    assert pow_assembly_model(SCALE, 1) == SCALE
    assert pow_assembly_model(-SCALE, 1) == -SCALE
    assert pow_assembly_model(-SCALE, 2) == SCALE
    assert pow_assembly_model(-1, 1) == -1
    assert pow_assembly_model(0, 0).__class__ is Reject
    assert pow_assembly_model(SCALE, -1).__class__ is Reject
    assert pow_assembly_model(SCALE, 32).__class__ is Reject

    # حالات فيض متوقعة لمسار الرفض قبل تسليم نتيجة غير ممثلة.
    assert pow_assembly_model(MAX_Q32, 2).__class__ is Reject
    assert pow_assembly_model(MIN_Q32, 2).__class__ is Reject

    # تحقق اتساق الضرب السالب مع الإزاحة الحسابية: -1/2^32 يُقرب أرضياً إلى -1.
    assert qmul_assembly_model(-1, SCALE // 2) == -1
    print("✅ محاكي الربط الموقّع لقوة: ناجح")
    print("الحالات: السالب، الزوجية، 0^0، الأس خارج المجال، والفيض")
    print("الحالة: intermediate_assembly_model — لا يثبت تنفيذ CPU الفعلي")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
