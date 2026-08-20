from decimal import Decimal, getcontext
import math

S = 1 << 32
INV_LN2 = 6196328019
LN2 = 2977044472
C = [9, 108, 1184, 106522, 852176, 5965232, 35791394, 178956971, 715827883, 2147483648, 4294967296, 4294967296]

def mul_q32(a, b):
    p = a * b
    if p >= 0:
        return p >> 32
    return -((-p) >> 32)

def approx(xq):
    product = xq * INV_LN2
    k = (product + (1 << 63)) >> 64 if product >= 0 else -(((-product) + (1 << 63)) >> 64)
    r = xq - k * LN2
    acc = C[0]
    for c in C[1:]:
        acc = mul_q32(r, acc) + c
    return acc << k, k, r, acc

cases = [0, 1 << 32, 4 << 32, 8 << 32, 16 << 32, int(21.4 * S)]
print('case,x,k,r,poly_q32,actual_q32,error,relative')
for xq in cases:
    out, k, r, poly = approx(xq)
    ref = round(math.exp(xq / S) * S)
    err = out - ref
    rel = abs(err) / ref if ref else 0
    print(f'{xq / S:.12g},{xq},{k},{r},{poly},{ref},{err},{rel:.12e}')
print('coefficients=', C)
print('ln2_q32_error=', LN2 - round(math.log(2) * S))
print('invln2_q32=', INV_LN2, 'reference=', round((1 / math.log(2)) * S))
print('NOTE=This models the current constants and Q32 Horner only; it does not modify VPS files.')
if __name__ == '__main__':
    pass

def test_syntax():
    assert len(C) == 12
    assert S == 4294967296

test_syntax()
