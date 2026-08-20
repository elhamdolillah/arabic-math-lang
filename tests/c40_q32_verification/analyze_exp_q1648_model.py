import math
S32 = 1 << 32
S48 = 1 << 48
LN2_Q48 = round(math.log(2.0) * S48)
INV_LN2_Q48 = round((1.0 / math.log(2.0)) * S48)

def round_signed_shift(value, bits):
    half = 1 << (bits - 1)
    return (value + half) >> bits if value >= 0 else -(((-value) + half) >> bits)

def mul_q48(a, b):
    return (a * b) >> 48

def round_shift16(a):
    return (a + (1 << 15)) >> 16 if a >= 0 else -(((-a) + (1 << 15)) >> 16)

# Taylor exp(r), degree 12, coefficients quantized directly to Q16.48.
C48 = [round(S48 / math.factorial(n)) for n in range(12, -1, -1)]

def approx(xq32):
    x48 = xq32 << 16
    product = x48 * INV_LN2_Q48
    k = round_signed_shift(product, 96)
    r48 = x48 - k * LN2_Q48
    acc = C48[0]
    for c in C48[1:]:
        acc = mul_q48(r48, acc) + c
    y32 = round_shift16(acc)
    return y32 << k, k, r48, y32

for x in [0, 1, 4, 8, 16, 21.4]:
    xq = round(x * S32)
    out, k, r48, y = approx(xq)
    ref = round(math.exp(x) * S32)
    err = out - ref
    rel = abs(err) / ref if ref else 0
    print(f'x={x:g}, k={k}, r48={r48}, residual_q32={y}, ref={ref}, out={out}, err={err}, rel={rel:.12e}')
print('LN2_Q48=', LN2_Q48)
print('INV_LN2_Q48=', INV_LN2_Q48)
print('C48=', C48)
print('NOTE=Model only; no VPS files modified.')
