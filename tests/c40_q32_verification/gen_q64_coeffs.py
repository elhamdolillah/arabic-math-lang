from decimal import Decimal, getcontext
getcontext().prec=220
S=1<<64
for n in range(12,-1,-1):
    v=(Decimal(1)/Decimal(__import__('math').factorial(n))*Decimal(S)).to_integral_value(rounding='ROUND_HALF_EVEN')
    print(int(v), end=', ')
print()
