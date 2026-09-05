import os
import re
import sys
import ast
import sympy as sp
from sympy import symbols, Function, Eq, dsolve, Derivative, integrate, Matrix, solve, sqrt, log, exp, sin, cos, tan, pi, I, oo, Rational

# دوال مساعدة (مدمجة لتجنب استيراد خارجي)
def numerical_integral(f, a, b, n=100):
    h = (b - a) / n
    x = [a + i*h for i in range(n+1)]
    fx = [f(xi) for xi in x]
    s = fx[0] + fx[-1]
    for i in range(1, n):
        s += (4 if i % 2 == 1 else 2) * fx[i]
    return s * h / 3

def numerical_derivative(f, x, h=1e-5):
    return (f(x + h) - f(x - h)) / (2*h)

class MALInterpreter:
    def __init__(self, file_path=None):
        self.file_path = file_path
        self.s = symbols('س')
        self.y = Function('ص')(self.s)

    def read_ar_file(self, file_path=None):
        path = file_path or self.file_path
        if not os.path.exists(path):
            raise FileNotFoundError(f"الملف {path} غير موجود.")
        with open(path, 'r', encoding='utf-8') as f:
            return f.read()

    def parse_and_execute(self, code=None):
        if code is None:
            code = self.read_ar_file()
        cleaned = re.sub(r'\s+', ' ', code).strip()
        if "حل_معادلة_تفاضلية" in cleaned:
            return self._execute_ode(cleaned)
        elif "تكامل" in cleaned and "عددي" not in cleaned:
            return self._execute_integral(cleaned)
        elif "تفاضل" in cleaned and "عددي" not in cleaned:
            return self._execute_derivative(cleaned)
        elif "مصفوفة" in cleaned:
            return self._execute_matrix(cleaned)
        elif "حل_معادلة" in cleaned:
            return self._execute_solve(cleaned)
        elif "تكامل_عددي" in cleaned:
            return self._execute_integral_numeric(cleaned)
        elif "اشتقاق_عددي" in cleaned:
            return self._execute_derivative_numeric(cleaned)
        elif "معكوس_مصفوفة" in cleaned:
            return self._execute_matrix_inverse(cleaned)
        elif "محدد" in cleaned:
            return self._execute_determinant(cleaned)
        elif "حل_نظام" in cleaned:
            return self._execute_linsolve(cleaned)
        elif "غاما" in cleaned:
            return self._execute_gamma(cleaned)
        elif "بيتا" in cleaned:
            return self._execute_beta(cleaned)
        else:
            return self._execute_expression(cleaned)

    def _extract_equation_and_ics(self, text):
        eq_match = re.search(r'معادلة\s*:\s*(.*?),\s*شرط_ابتدائي', text)
        ic_match = re.search(r'شرط_ابتدائي\s*:\s*\[(.*?)\]', text)
        if not eq_match:
            return None, None
        raw_eq = eq_match.group(1).strip()
        ics = {}
        if ic_match:
            ic_content = ic_match.group(1)
            pairs = re.findall(r'(س0|ص0|مشتقة_ص0)\s*:\s*([-\d\.]+)', ic_content)
            for k, v in pairs:
                ics[k] = float(v)
        return raw_eq, ics

    def _parse_equation(self, raw_eq):
        eq_str = raw_eq.replace("مشتقة(ص، س)", "Derivative(y, s)")
        eq_str = eq_str.replace("ص", "y").replace("س", "s")
        if "=" in eq_str:
            left, right = eq_str.split("=", 1)
            left_expr = sp.sympify(left.strip(), locals={"y": self.y, "s": self.s})
            right_expr = sp.sympify(right.strip(), locals={"y": self.y, "s": self.s})
            return Eq(left_expr, right_expr)
        else:
            return sp.sympify(eq_str, locals={"y": self.y, "s": self.s})

    def _execute_ode(self, command_text):
        raw_eq, ics = self._extract_equation_and_ics(command_text)
        if not raw_eq:
            return "خطأ: لم يتم العثور على المعادلة."
        diff_eq = self._parse_equation(raw_eq)
        sol = dsolve(diff_eq, self.y)
        if ics and 'س0' in ics and 'ص0' in ics:
            constants = sol.free_symbols - {self.s, sp.Symbol('C1')}
            C1 = sp.Symbol('C1')
            if C1 in sol.free_symbols:
                subbed = sol.rhs.subs(self.s, ics['س0'])
                c1_val = solve(Eq(subbed, ics['ص0']), C1)
                if c1_val:
                    return sol.subs(C1, c1_val[0])
        return sol

    def _execute_integral(self, text):
        match = re.search(r'تكامل\s*\(\s*(.*?)\s*,\s*(.*?)\s*(?:,\s*(.*?)\s*,\s*(.*?)\s*)?\)', text)
        if not match:
            return "خطأ: صيغة التكامل غير صحيحة"
        expr_str, var_str, lower, upper = match.groups()
        expr = sp.sympify(expr_str)
        var = sp.Symbol(var_str)
        if upper and lower:
            return integrate(expr, (var, sp.sympify(lower), sp.sympify(upper)))
        return integrate(expr, var)

    def _execute_derivative(self, text):
        match = re.search(r'تفاضل\s*\(\s*(.*?)\s*,\s*(.*?)\s*\)', text)
        if not match:
            return "خطأ: صيغة التفاضل غير صحيحة"
        expr_str, var_str = match.groups()
        expr = sp.sympify(expr_str)
        var = sp.Symbol(var_str)
        return Derivative(expr, var).doit()

    def _execute_matrix(self, text):
        match = re.search(r'مصفوفة\s*\(\s*\[(.*?)\]\s*\)', text)
        if not match:
            return "خطأ: صيغة المصفوفة غير صحيحة"
        matrix_str = match.group(1)
        try:
            # استخدام ast.literal_eval مع تحقق إضافي
            parsed = ast.literal_eval(matrix_str)
            if not isinstance(parsed, list):
                return "خطأ: المصفوفة يجب أن تكون قائمة من القوائم"
            # تحويل إلى مصفوفة SymPy
            return Matrix(parsed)
        except (ValueError, SyntaxError, TypeError) as e:
            return f"خطأ في تحليل المصفوفة: {e}"

    def _execute_expression(self, text):
        try:
            return sp.sympify(text)
        except Exception as e:
            return f"خطأ في التعبير: {e}"

    # ===== الميزات الجديدة (مع إصلاحات) =====
    def _execute_solve(self, text):
        match = re.search(r'حل_معادلة\s*\(\s*(.*?)\s*,\s*(.*?)\s*\)', text)
        if not match:
            return "خطأ: صيغة حل_معادلة غير صحيحة"
        expr_str, var_str = match.groups()
        try:
            expr = sp.sympify(expr_str)
            var = sp.Symbol(var_str)
            solutions = sp.solve(expr, var)
            return solutions
        except Exception as e:
            return f"خطأ في حل المعادلة: {e}"

    def _execute_integral_numeric(self, text):
        match = re.search(r'تكامل_عددي\s*\(\s*(.*?)\s*,\s*(.*?)\s*,\s*(.*?)\s*,\s*(.*?)\s*\)', text)
        if not match:
            return "خطأ: صيغة تكامل_عددي غير صحيحة (دالة, متغير, من, إلى)"
        expr_str, var_str, lower, upper = match.groups()
        try:
            expr = sp.sympify(expr_str)
            var = sp.Symbol(var_str)
            f = sp.lambdify(var, expr, 'math')
            a = float(sp.sympify(lower))
            b = float(sp.sympify(upper))
            return numerical_integral(f, a, b)
        except Exception as e:
            return f"خطأ في التكامل العددي: {e}"

    def _execute_derivative_numeric(self, text):
        match = re.search(r'اشتقاق_عددي\s*\(\s*(.*?)\s*,\s*(.*?)\s*,\s*(.*?)\s*\)', text)
        if not match:
            return "خطأ: صيغة اشتقاق_عددي غير صحيحة (دالة, متغير, نقطة)"
        expr_str, var_str, point = match.groups()
        try:
            expr = sp.sympify(expr_str)
            var = sp.Symbol(var_str)
            f = sp.lambdify(var, expr, 'math')
            x0 = float(sp.sympify(point))
            return numerical_derivative(f, x0)
        except Exception as e:
            return f"خطأ في الاشتقاق العددي: {e}"

    def _execute_matrix_inverse(self, text):
        match = re.search(r'معكوس_مصفوفة\s*\(\s*(.*?)\s*\)', text)
        if not match:
            return "خطأ: صيغة معكوس_مصفوفة غير صحيحة"
        matrix_str = match.group(1)
        try:
            mat = sp.sympify(matrix_str)
            if not isinstance(mat, sp.Matrix):
                mat = sp.Matrix(mat)
            if mat.rows != mat.cols:
                return "خطأ: المصفوفة ليست مربعة"
            return mat.inv()
        except Exception as e:
            return f"خطأ في معكوس المصفوفة: {e}"

    def _execute_determinant(self, text):
        match = re.search(r'محدد\s*\(\s*(.*?)\s*\)', text)
        if not match:
            return "خطأ: صيغة محدد غير صحيحة"
        matrix_str = match.group(1)
        try:
            mat = sp.sympify(matrix_str)
            if not isinstance(mat, sp.Matrix):
                mat = sp.Matrix(mat)
            if mat.rows != mat.cols:
                return "خطأ: المصفوفة ليست مربعة"
            return mat.det()
        except Exception as e:
            return f"خطأ في حساب المحدد: {e}"

    def _execute_linsolve(self, text):
        match = re.search(r'حل_نظام\s*\(\s*(.*?)\s*,\s*(.*?)\s*\)', text)
        if not match:
            return "خطأ: صيغة حل_نظام غير صحيحة"
        A_str, b_str = match.groups()
        try:
            A = sp.sympify(A_str)
            b = sp.sympify(b_str)
            if not isinstance(A, sp.Matrix):
                A = sp.Matrix(A)
            if not isinstance(b, sp.Matrix):
                b = sp.Matrix(b)
            return A.solve(b)
        except Exception as e:
            return f"خطأ في حل النظام: {e}"

    def _execute_gamma(self, text):
        match = re.search(r'غاما\s*\(\s*(.*?)\s*\)', text)
        if not match:
            return "خطأ: صيغة غاما غير صحيحة"
        z_str = match.group(1)
        try:
            z = sp.sympify(z_str)
            return sp.gamma(z)
        except Exception as e:
            return f"خطأ في دالة غاما: {e}"

    def _execute_beta(self, text):
        match = re.search(r'بيتا\s*\(\s*(.*?)\s*,\s*(.*?)\s*\)', text)
        if not match:
            return "خطأ: صيغة بيتا غير صحيحة"
        a_str, b_str = match.group(1), match.group(2)
        try:
            a = sp.sympify(a_str)
            b = sp.sympify(b_str)
            return sp.beta(a, b)
        except Exception as e:
            return f"خطأ في دالة بيتا: {e}"

if __name__ == "__main__":
    import sys
    file_path = sys.argv[1] if len(sys.argv) > 1 else None
    interpreter = MALInterpreter(file_path)
    print(interpreter.parse_and_execute())
