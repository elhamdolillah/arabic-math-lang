from decimal import Decimal, getcontext
getcontext().prec = 220
F = 48
S = 1 << F
S32 = 1 << 32
D2 = Decimal(2)
LN2_D = D2.ln()
INV_D = Decimal(1) / LN2_D

def qround(v, scale):
    return int((v * Decimal(scale)).to_integral_value(rounding='ROUND_HALF_EVEN'))

def signed_round_shift(v, bits):
    half = 1 << (bits - 1)
    return (v + half) >> bits if v >= 0 else -(((-v) + half) >> bits)

def mul_q48(a, b):
    return (a * b) >> F

LN2 = qround(LN2_D, S)
INV = qround(INV_D, S)
C = [qround(Decimal(1) / Decimal(__import__('math').factorial(n)), S) for n in range(12, -1, -1)]

def exp_q32(x32):
    x48 = x32 << (F - 32)
    k = signed_round_shift(x48 * INV, 2 * F)
    r48 = x48 - k * LN2
    acc = C[0]
    for c in C[1:]:
        acc = mul_q48(r48, acc) + c
    scaled = acc << k if k >= 0 else signed_round_shift(acc, -k)
    return signed_round_shift(scaled, F - 32), k

for text in ['0','1','4','8','16','21.4','-1','-4','-8','-16','-21.4']:
    x32 = qround(Decimal(text), S32)
    out, k = exp_q32(x32)
    x_domain = Decimal(x32) / Decimal(S32)
    ref = qround(x_domain.exp(), S32)
    err = out - ref
    print(f'x={text}, quantized={x_domain}, k={k}, out={out}, ref={ref}, err={err}')
print('LN2_Q48=', LN2)
print('INV_LN2_Q48=', INV)
print('C_Q48=', C)
print('NOTE=Model only; no VPS files modified.')
