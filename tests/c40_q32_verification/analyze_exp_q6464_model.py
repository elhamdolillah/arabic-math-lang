from decimal import Decimal, getcontext
getcontext().prec = 240
F = 64
S = 1 << F
S32 = 1 << 32
D2 = Decimal(2)
ln2 = D2.ln(); inv = Decimal(1) / ln2

def qround(v, scale): return int((v * Decimal(scale)).to_integral_value(rounding='ROUND_HALF_EVEN'))
def rs(v,b):
    h=1<<(b-1); return (v+h)>>b if v>=0 else -(((-v)+h)>>b)
def mul(a,b): return (a*b)>>F
LN2=qround(ln2,S); INV=qround(inv,S)
C=[qround(Decimal(1)/Decimal(__import__('math').factorial(n)),S) for n in range(12,-1,-1)]
def app(x32):
    x=x32<<(F-32); k=rs(x*INV,2*F); r=x-k*LN2; a=C[0]
    for c in C[1:]: a=mul(r,a)+c
    scaled=a<<k if k>=0 else rs(a,-k)
    return rs(scaled,F-32),k
for text in ['0','1','4','8','16','21.4','-1','-4','-8','-16','-21.4']:
    x32=qround(Decimal(text),S32); out,k=app(x32); xd=Decimal(x32)/Decimal(S32); ref=qround(xd.exp(),S32)
    print(f'x={text}, quantized={xd}, k={k}, out={out}, ref={ref}, err={out-ref}')
print('LN2_Q64=',LN2); print('INV_LN2_Q64=',INV); print('NOTE=Model only; no VPS files modified.')
