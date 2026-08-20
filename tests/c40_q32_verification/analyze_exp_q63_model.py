from decimal import Decimal, getcontext
getcontext().prec=180
F=63; S=1<<F; S32=1<<32
D2=Decimal(2); ln2=D2.ln(); inv=Decimal(1)/ln2

def rs(v,b):
    h=1<<(b-1); return (v+h)>>b if v>=0 else -(((-v)+h)>>b)
def qf(v, scale): return int((v*Decimal(scale)).to_integral_value(rounding='ROUND_HALF_EVEN'))
def mul(a,b): return (a*b)>>F
LN2=qf(ln2,S); INV=qf(inv,S)
C=[qf(Decimal(1)/Decimal(__import__('math').factorial(n)),S) for n in range(12,-1,-1)]
def app(xq32):
    x=xq32<<(F-32); k=rs(x*INV,2*F); r=x-k*LN2; a=C[0]
    for c in C[1:]: a=mul(r,a)+c
    scaled=a<<k if k>=0 else rs(a,-k)
    return rs(scaled,F-32),k
for text in ['0','1','4','8','16','21.4','-1','-4','-8','-16','-21.4']:
    xq=qf(Decimal(text),S32); out,k=app(xq); x_domain=Decimal(xq)/Decimal(S32); ref=qf(x_domain.exp(),S32); e=out-ref
    print(text,'quantized=',x_domain,'k=',k,'err=',e,'out=',out,'ref=',ref)
print('LN2_Q63=',LN2); print('INV_LN2_Q63=',INV); print('fits_unsigned64=',0<=INV<2**64)
