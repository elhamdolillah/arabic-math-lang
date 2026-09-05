import math
import sympy as sp

def numerical_integral(f, a, b, n=100):
    """حساب التكامل العددي بطريقة سيمبسون المركبة"""
    h = (b - a) / n
    x = [a + i*h for i in range(n+1)]
    fx = [f(xi) for xi in x]
    s = fx[0] + fx[-1]
    for i in range(1, n):
        s += (4 if i % 2 == 1 else 2) * fx[i]
    return s * h / 3

def numerical_derivative(f, x, h=1e-5):
    """حساب المشتقة العددية بطريقة الفروق المركزية"""
    return (f(x + h) - f(x - h)) / (2*h)

def gamma_function(z):
    """دالة غاما باستخدام sympy"""
    return sp.gamma(z)

def beta_function(a, b):
    """دالة بيتا باستخدام sympy"""
    return sp.beta(a, b)
