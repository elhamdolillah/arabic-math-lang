import pytest
import sympy as sp
from src.interpreter import MALInterpreter

def test_ode_solver(tmp_path):
    d = tmp_path / "test"
    d.mkdir()
    file = d / "ode.ar"
    file.write_text("حل_معادلة_تفاضلية ( معادلة: مشتقة(ص، س) + 2*ص = 4*س, شرط_ابتدائي: [س0: 0, ص0: 1] )", encoding='utf-8')
    interp = MALInterpreter(str(file))
    result = interp.parse_and_execute()
    assert isinstance(result, sp.Equality)

def test_derivative():
    interp = MALInterpreter()
    result = interp.parse_and_execute("تفاضل(س^2 + 5*س, س)")
    expected = 2*sp.symbols('س') + 5
    assert result == expected

def test_integral():
    interp = MALInterpreter()
    result = interp.parse_and_execute("تكامل(س^2, س, 0, 1)")
    expected = sp.Rational(1, 3)
    assert result == expected

def test_matrix():
    interp = MALInterpreter()
    result = interp.parse_and_execute("مصفوفة([[1,2],[3,4]])")
    assert result == sp.Matrix([[1,2],[3,4]])

def test_solve():
    interp = MALInterpreter()
    result = interp.parse_and_execute("حل_معادلة(س^2 - 4, س)")
    expected = [-2, 2]
    assert set(result) == set(expected)

def test_integral_numeric():
    interp = MALInterpreter()
    result = interp.parse_and_execute("تكامل_عددي(س^2, س, 0, 1)")
    # القيمة التقريبية 1/3 ~ 0.3333
    assert abs(result - 0.333333) < 1e-4

def test_derivative_numeric():
    interp = MALInterpreter()
    result = interp.parse_and_execute("اشتقاق_عددي(س^2, س, 2)")
    # المشتقة 2س عند س=2 هي 4
    assert abs(result - 4) < 1e-4

def test_matrix_inverse():
    interp = MALInterpreter()
    result = interp.parse_and_execute("معكوس_مصفوفة([[1,2],[3,4]])")
    expected = sp.Matrix([[-2, 1], [1.5, -0.5]])
    assert result == expected

def test_determinant():
    interp = MALInterpreter()
    result = interp.parse_and_execute("محدد([[1,2],[3,4]])")
    assert result == -2

def test_linsolve():
    interp = MALInterpreter()
    result = interp.parse_and_execute("حل_نظام([[1,2],[3,4]], [5,6])")
    expected = sp.Matrix([-4, 4.5])
    # تسامح رقمي
    assert (result - expected).norm() < 1e-4

def test_gamma():
    interp = MALInterpreter()
    result = interp.parse_and_execute("غاما(5)")
    assert result == 24

def test_beta():
    interp = MALInterpreter()
    result = interp.parse_and_execute("بيتا(2,3)")
    assert result == sp.Rational(1, 12)
