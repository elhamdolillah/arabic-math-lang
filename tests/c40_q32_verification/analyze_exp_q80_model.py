from decimal import Decimal, getcontext
getcontext().prec=220
S32 = 1 << 32
F = 80
S = 1 << F
D2 = Decimal(2)
LN2_D = D2.ln()
INV_D = Decimal(1) / LN2_D

def round_decimal_scaled(value, scale):
    return int((value * Decimal(scale)).to_integral_value(rounding='ROUND_HALF_EVEN'))

def round_signed_shift(value, bits):
    half = 1 << (bits - 1)
    return (value + half) >> bits if value >= 0 else -(((-value) + half) >> bits)

def mul_q(a, b):
    return (a * b) >> F

def to_q(value):
    return round_decimal_scaled(value, S)

LN2 = to_q(LN2_D)
INV = to_q(INV_D)
C = [round_decimal_scaled(Decimal(1) / Decimal(__import__('math').factorial(n)), S) for n in range(12, -1, -1)]

def approx(xq32):
    xq = xq32 << (F - 32)
    k = round_signed_shift(xq * INV, 2 * F)
    r = xq - k * LN2
    acc = C[0]
    for c in C[1:]:
        acc = mul_q(r, acc) + c
    # Critical: scale at Q16.80, then convert once to Q32.32.
    scaled_q80 = acc << k if k >= 0 else round_signed_shift(acc, -k)
    out = round_signed_shift(scaled_q80, F - 32)
    return out, k, r

for x_text in ['0', '1', '4', '8', '16', '21.4']:
    x = Decimal(x_text)
    xq = round_decimal_scaled(x, 1 << 32)
    out, k, r = approx(xq)
    ref = round_decimal_scaled(x.exp(), 1 << 32)
    err = out - ref
    rel = (Decimal(abs(err)) / Decimal(ref)) if ref else Decimal(0)
    print(f'x={x_text}, k={k}, ref={ref}, out={out}, err={err}, rel={rel:.12e}')
print('F=', F, 'LN2=', LN2, 'INV=', INV)
print('NOTE=Model only; no VPS files modified.')
