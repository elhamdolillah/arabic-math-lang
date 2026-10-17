from decimal import Decimal, getcontext
getcontext().prec=180
F=64; S=1<<F
D2=Decimal(2); ln2=D2.ln(); inv=Decimal(1)/ln2

def q(v): return int((v*Decimal(S)).to_integral_value(rounding='ROUND_HALF_EVEN'))
def bits(n): return abs(n).bit_length() + (1 if n < 0 else 0)
LN2=q(ln2); INV=q(inv)
C=[q(Decimal(1)/Decimal(__import__('math').factorial(n))) for n in range(12,-1,-1)]
print('constants bits:', 'LN2',bits(LN2), 'INV',bits(INV), 'maxC',max(map(bits,C)))
for text in ['-21.4','-16','-8','-4','0','4','8','16','21.4']:
    x=Decimal(text); xq=q(x); k=round(x*inv); rq=q(x-Decimal(k)*ln2)
    print('x',text,'xq_bits',bits(xq),'k',k,'r_bits',bits(rq),'r_abs',abs(x-Decimal(k)*ln2))
# Horner exact-ish bounds on |r| <= ln2/2.
r=q(ln2/2)
a=max(abs(c) for c in C)
max_prod=0
for c in C[1:]:
    max_prod=max(max_prod, r*a)
    a=(r*a)//S+abs(c)
print('r_bound_bits',bits(r),'max_product_bits',bits(max_prod),'acc_bound_bits',bits(a),'acc_bound_over_2^64',Decimal(a)/Decimal(S))
print('NOTE=Width analysis only; no VPS files modified.')
