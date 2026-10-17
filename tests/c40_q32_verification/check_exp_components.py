from decimal import Decimal, getcontext
getcontext().prec=160
D2=Decimal(2); ln2=D2.ln(); inv=Decimal(1)/ln2
for xs in ['4','8','16','21.4']:
    x=Decimal(xs); k=int((x*inv).to_integral_value(rounding='ROUND_HALF_UP')); r=x-Decimal(k)*ln2
    p=sum((r**n)/Decimal(__import__('math').factorial(n)) for n in range(13))
    exact=r.exp()
    print(xs,'k',k,'r',r,'poly_abs',p-exact,'scaled_q32',((p*(D2**k))*(1<<32)).to_integral_value(rounding='ROUND_HALF_EVEN'))
