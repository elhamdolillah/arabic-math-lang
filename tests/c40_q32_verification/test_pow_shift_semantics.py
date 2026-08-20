#!/usr/bin/env python3
"""فحص محدود لدلالة imul ثم shrd/sar في مسار قوة Q32.32.

الفحص حسابي مستقل عن مولد اللغة. إنه يثبت التطابق على مجموعة حالات
محدودة ومختارة، ولا يثبت نموذجاً رسمياً لتعليمات المعالج.
"""
from itertools import product

MASK64 = (1 << 64) - 1
MASK128 = (1 << 128) - 1
SIGN64 = 1 << 63
SIGN128 = 1 << 127
SHIFT = 32


def signed(bits: int, width: int) -> int:
    mask = (1 << width) - 1
    bits &= mask
    sign = 1 << (width - 1)
    return bits - (1 << width) if bits & sign else bits


def asm_mul_shift(a: int, b: int):
    product = a * b
    assert -(1 << 127) <= product < (1 << 127)
    raw = product & MASK128
    low = raw & MASK64
    high = (raw >> 64) & MASK64
    new_low = ((low >> SHIFT) | ((high << (64 - SHIFT)) & MASK64)) & MASK64
    new_high = signed(high, 64) >> SHIFT
    return signed(new_low, 64), new_high


def reference(a: int, b: int):
    product = a * b
    q = product // (1 << SHIFT)
    low = signed(q & MASK64, 64)
    high = q >> 64
    return low, high


def main() -> int:
    values = [-(1 << 63), -(1 << 63) + 1, -(1 << 32), -1, 0, 1,
              (1 << 32) - 1, 1 << 32, (1 << 63) - 1]
    checked = 0
    for a, b in product(values, repeat=2):
        # Skip products outside signed-128, which imul cannot represent.
        if not (-(1 << 127) <= a * b < (1 << 127)):
            continue
        assert asm_mul_shift(a, b) == reference(a, b), (a, b, asm_mul_shift(a, b), reference(a, b))
        checked += 1
    # Additional small exhaustive region around sign and carry boundaries.
    small = range(-257, 258)
    for a, b in product(small, repeat=2):
        assert asm_mul_shift(a, b) == reference(a, b), (a, b)
        checked += 1
    # The generator accepts a scaled result iff the signed high half is the sign extension.
    accepted = [(0, 0), (-(1 << 63), -1), ((1 << 63) - 1, 0)]
    rejected = [(0, -1), (1, -1), (-(1 << 63), 0)]
    for low, high in accepted:
        assert (high == 0 and low >= 0) or (high == -1 and low < 0)
    for low, high in rejected:
        assert not ((high == 0 and low >= 0) or (high == -1 and low < 0))
    print(f"✅ دلالة imul/shrd/sar: ناجحة في {checked} حالة")
    print("الحالة: bounded_instruction_semantics — ليست لمّة Coq ولا تغطية كل CPU")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
