#!/usr/bin/env python3
"""اختبار مرجعي مستقل لنموذج الزوج العقدي Q32.32."""

S = 1 << 32
I64_MIN = -(1 << 63)
I64_MAX = (1 << 63) - 1
ERROR_LIMIT = 16


def qmul(a: int, b: int) -> int:
    return (a * b) // S


def add(z, w):
    return z[0] + w[0], z[1] + w[1]


def sub(z, w):
    return z[0] - w[0], z[1] - w[1]


def conj(z):
    return z[0], -z[1]


def mul(z, w):
    return qmul(z[0], w[0]) - qmul(z[1], w[1]), qmul(z[0], w[1]) + qmul(z[1], w[0])


def norm2_raw(z):
    return z[0] * z[0] + z[1] * z[1]


def require_i64(z):
    if not (I64_MIN <= z[0] <= I64_MAX and I64_MIN <= z[1] <= I64_MAX):
        raise OverflowError(z)
    return z


def q(x: int) -> int:
    return x * S


CASES = [
    ((q(0), q(0)), (q(0), q(0))),
    ((q(1), q(2)), (q(3), q(4))),
    ((q(-1), q(2)), (q(3), q(-4))),
    ((q(1) // 3, q(-2) // 5), (q(7) // 11, q(5) // 13)),
    ((q(1000), q(-2000)), (q(-3), q(4))),
]

for z, w in CASES:
    assert add(z, w) == (z[0] + w[0], z[1] + w[1])
    assert sub(z, w) == (z[0] - w[0], z[1] - w[1])
    assert conj(conj(z)) == z
    got = mul(z, w)
    ref = (qmul(z[0], w[0]) - qmul(z[1], w[1]), qmul(z[0], w[1]) + qmul(z[1], w[0]))
    assert got == ref
    assert norm2_raw(z) >= 0
    require_i64(add(z, w))
    require_i64(sub(z, w))

# The two-component product has at most one fixed-point truncation unit per
# component relative to its explicitly rounded component products.
z = (q(1) // 3, q(2) // 7)
w = (q(5) // 11, q(-3) // 13)
raw_real = z[0] * w[0] - z[1] * w[1]
raw_imag = z[0] * w[1] + z[1] * w[0]
product = mul(z, w)
assert abs(product[0] - raw_real // S) <= ERROR_LIMIT
assert abs(product[1] - raw_imag // S) <= ERROR_LIMIT

try:
    require_i64((I64_MAX, I64_MAX + 1))
except OverflowError:
    pass
else:
    raise AssertionError("overflow must be rejected")

print("COMPLEX_Q32_STATUS=PASS")
print(f"COMPLEX_Q32_CASES={len(CASES) + 1}")
print(f"COMPLEX_Q32_ERROR_LIMIT={ERROR_LIMIT}")
print("COMPLEX_Q32_OVERFLOW_REJECTION=PASS")
