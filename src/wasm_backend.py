"""
المرحلة 51: WebAssembly Backend
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

المبدأ:
- Lexer/Parser/AST لا يُمسان (مثل ARM64)
- فقط compile_expr/compile_program يُستنسخان
- يخرجان WAT (WebAssembly Text) بدل x86-64

الفروق الجوهرية:

| x86-64           | WASM المقابل             | ملاحظة              |
|------------------|--------------------------|---------------------|
| mov rax, N       | i64.const N             | stack machine       |
| add rax, rbx     | i64.add                 | no registers        |
| syscall          | import "env"."syscall"  | host function       |
| push/pop         | stack-based             | implicit            |
| registers        | locals                  | limited             |
| memory           | linear memory           | flat array          |

المصادر:
- WebAssembly Spec (W3C, 2019)
- "WebAssembly: The Definitive Guide" (2022)

﴿وقل رب زدني علماً﴾
"""

from typing import Dict, List, Tuple, Optional, Set
from dataclasses import dataclass


# ═══════════════════════════════════════════════════════════
# 1. WASM Types
# ═══════════════════════════════════════════════════════════

WASM_TYPES = {
    'عدد': 'i64',       # عدد صحيح 64-bit
    'نص': 'i32',        # مؤشر إلى linear memory
    'منطقي': 'i32',     # 0 أو 1
    'قائمة': 'i32',     # مؤشر إلى linear memory
}


# ═══════════════════════════════════════════════════════════
# 2. WASM Backend
# ═══════════════════════════════════════════════════════════

class WASMBackend:
    """
    WASM Backend
    
    يولّد WAT (WebAssembly Text Format)
    
    WASM هو stack machine:
    - لا registers
    - كل العمليات على stack
    - locals محدودة
    - linear memory (flat array)
    """
    
    def __init__(self):
        self.code: List[str] = []
        self.local_count = 0
        self.memory_pages = 1  # 64KB per page
    
    # ─── العمليات الأساسية ───
    
    def const_i64(self, value: int) -> List[str]:
        """تحميل قيمة فورية: i64.const N"""
        return [f"    i64.const {value}"]
    
    def const_i32(self, value: int) -> List[str]:
        """تحميل قيمة فورية 32-bit"""
        return [f"    i32.const {value}"]
    
    def add_i64(self) -> List[str]:
        """جمع: i64.add (يأخذ قيمتين من stack)"""
        return ["    i64.add"]
    
    def sub_i64(self) -> List[str]:
        """طرح: i64.sub"""
        return ["    i64.sub"]
    
    def mul_i64(self) -> List[str]:
        """ضرب: i64.mul"""
        return ["    i64.mul"]
    
    def div_i64(self) -> List[str]:
        """قسمة صحيحة: i64.div_s"""
        return ["    i64.div_s"]
    
    # ─── المتغيرات المحلية ───
    
    def new_local(self, name: str = "") -> int:
        """إنشاء متغير محلي جديد"""
        idx = self.local_count
        self.local_count += 1
        return idx
    
    def local_get(self, idx: int) -> List[str]:
        """تحميل متغير محلي: local.get N"""
        return [f"    local.get {idx}"]
    
    def local_set(self, idx: int) -> List[str]:
        """تخزين في متغير محلي: local.set N"""
        return [f"    local.set {idx}"]
    
    def local_tee(self, idx: int) -> List[str]:
        """تخزين مع إبقاء القيمة على stack: local.tee N"""
        return [f"    local.tee {idx}"]
    
    # ─── الذاكرة الخطية ───
    
    def memory_load(self, offset: int = 0) -> List[str]:
        """تحميل من الذاكرة: i64.load offset"""
        return [f"    i64.load offset={offset}"]
    
    def memory_store(self, offset: int = 0) -> List[str]:
        """تخزين في الذاكرة: i64.store offset"""
        return [f"    i64.store offset={offset}"]
    
    def memory_grow(self) -> List[str]:
        """توسيع الذاكرة: memory.grow"""
        return ["    memory.grow"]
    
    # ─── الفروع ───
    
    def if_block(self) -> List[str]:
        """بداية شرط: if"""
        return ["    if"]
    
    def else_block(self) -> List[str]:
        """فرع وإلا: else"""
        return ["    else"]
    
    def end_block(self) -> List[str]:
        """نهاية بلوك: end"""
        return ["    end"]
    
    def br(self, label: str) -> List[str]:
        """فرع: br label"""
        return [f"    br {label}"]
    
    def br_if(self, label: str) -> List[str]:
        """فرع شرطي: br_if label"""
        return [f"    br_if {label}"]
    
    # ─── الدوال ───
    
    def call(self, func_name: str) -> List[str]:
        """استدعاء دالة: call func_name"""
        return [f"    call ${func_name}"]
    
    def function_start(self, name: str, params: List[Tuple[str, str]], results: List[str]) -> List[str]:
        """بداية دالة"""
        code = [f"(func ${name}"]
        for param_name, param_type in params:
            code.append(f"  (param ${param_name} {param_type})")
        for result in results:
            code.append(f"  (result {result})")
        return code
    
    def function_end(self) -> List[str]:
        """نهاية دالة"""
        return [")"]
    
    # ─── المقارنات ───
    
    def compare_eq(self) -> List[str]:
        """مقارنة تساوي: i64.eq"""
        return ["    i64.eq"]
    
    def compare_ne(self) -> List[str]:
        """مقارنة عدم تساوي: i64.ne"""
        return ["    i64.ne"]
    
    def compare_lt(self) -> List[str]:
        """مقارنة أقل من: i64.lt_s"""
        return ["    i64.lt_s"]
    
    def compare_gt(self) -> List[str]:
        """مقارنة أكبر من: i64.gt_s"""
        return ["    i64.gt_s"]


# ═══════════════════════════════════════════════════════════
# 3. WASM Compiler
# ═══════════════════════════════════════════════════════════

class WASMCompiler:
    """
    المُجمّع WASM
    
    نفس واجهة compile_expr/compile_program
    لكن بتعليمات WASM
    
    المبدأ: Lexer/Parser/AST لا يُمسان
    """
    
    def __init__(self):
        self.backend = WASMBackend()
        self.code: List[str] = []
        self.functions: Dict[str, str] = {}  # اسم الدالة → WAT
        self.global_vars: Dict[str, int] = {}  # متغير عام → offset في الذاكرة
        self.memory_offset = 0
    
    def compile_expr(self, expr: Tuple, env: Dict) -> List[str]:
        """تجميع تعبير إلى WASM"""
        if not isinstance(expr, tuple):
            return []
        
        node_type = expr[0]
        
        # عدد
        if node_type == 'عدد':
            return self.backend.const_i64(expr[1])
        
        # نص
        if node_type == 'نص':
            return self._compile_string(expr[1])
        
        # متغير
        if node_type == 'متغير':
            return self._compile_var(expr[1], env)
        
        # عملية ثنائية
        if node_type == 'ثنائية':
            return self._compile_binary(expr[1], expr[2], expr[3], env)
        
        # استدعاء دالة
        if node_type == 'استدعاء':
            return self._compile_call(expr[1], expr[2], env)
        
        # قائمة
        if node_type == 'قائمة':
            return self._compile_list(expr[1], env)
        
        # سالب
        if node_type == 'سالب':
            code = self.compile_expr(expr[1], env)
            code.extend(self.backend.const_i64(0))
            code.extend(self.backend.sub_i64())
            return code
        
        return []
    
    def _compile_var(self, var: str, env: Dict) -> List[str]:
        """تجميع متغير"""
        if var in env.get('locals', {}):
            idx = env['locals'][var]
            return self.backend.local_get(idx)
        
        if var in self.global_vars:
            offset = self.global_vars[var]
            code = self.backend.const_i32(offset)
            code.extend(self.backend.memory_load())
            return code
        
        return []  # متغير غير معرف — يُترك للتحقق
    
    def _compile_binary(self, op: str, left: Tuple, right: Tuple, env: Dict) -> List[str]:
        """تجميع عملية ثنائية"""
        code = []
        
        # احسب الجانب الأيسر (يُوضع على stack)
        code.extend(self.compile_expr(left, env))
        
        # احسب الجانب الأيمن (يُوضع على stack)
        code.extend(self.compile_expr(right, env))
        
        # العملية (تأخذ قيمتين من stack وتضع نتيجة)
        if op == '+':
            code.extend(self.backend.add_i64())
        elif op == '-':
            code.extend(self.backend.sub_i64())
        elif op == '·':
            code.extend(self.backend.mul_i64())
        elif op == '÷':
            code.extend(self.backend.div_i64())
        
        return code
    
    def _compile_string(self, text: str) -> List[str]:
        """تجميع نص (تخزين في linear memory)"""
        byts = text.encode('utf-8')
        offset = self.memory_offset
        self.memory_offset += len(byts) + 8  # 8 bytes للطول
        
        code = []
        # تخزين الطول
        code.extend(self.backend.const_i32(offset))
        code.extend(self.backend.const_i64(len(byts)))
        code.extend(self.backend.memory_store())
        
        # تخزين البيانات
        for i, b in enumerate(byts):
            code.extend(self.backend.const_i32(offset + 8 + i))
            code.extend(self.backend.const_i64(b))
            code.append("    i64.store8")
        
        # أرجع المؤشر
        code.extend(self.backend.const_i32(offset))
        
        return code
    
    def _compile_call(self, func_name: str, args: List[Tuple], env: Dict) -> List[str]:
        """تجميع استدعاء دالة"""
        code = []
        
        # دوال مدمجة
        if func_name == 'جذر':
            code.extend(self.compile_expr(args[0], env))
            code.extend(self.backend.call('sqrt_i64'))
            return code
        
        if func_name == 'مطلق':
            code.extend(self.compile_expr(args[0], env))
            code.extend(self.backend.call('abs_i64'))
            return code
        
        if func_name == 'نص':
            code.extend(self.compile_expr(args[0], env))
            code.extend(self.backend.call('int_to_string'))
            return code
        
        # استدعاء دالة عادية
        for arg in args:
            code.extend(self.compile_expr(arg, env))
        code.extend(self.backend.call(func_name))
        
        return code
    
    def _compile_list(self, elements: List[Tuple], env: Dict) -> List[str]:
        """تجميع قائمة"""
        code = []
        
        # حساب الطول
        length = len(elements)
        
        # تخصيص مساحة في الذاكرة
        offset = self.memory_offset
        self.memory_offset += 8 + length * 8
        
        # تخزين الطول
        code.extend(self.backend.const_i32(offset))
        code.extend(self.backend.const_i64(length))
        code.extend(self.backend.memory_store())
        
        # تخزين العناصر
        for i, elem in enumerate(elements):
            code.extend(self.compile_expr(elem, env))
            code.extend(self.backend.const_i32(offset + 8 + i * 8))
            code.append("    i64.store")
        
        # أرجع المؤشر
        code.extend(self.backend.const_i32(offset))
        
        return code
    
    def compile_stmt(self, stmt: Tuple, env: Dict) -> List[str]:
        """تجميع بيان"""
        if stmt[0] == 'أسند':
            var, expr = stmt[1], stmt[2]
            code = self.compile_expr(expr, env)
            
            if var in env.get('locals', {}):
                idx = env['locals'][var]
                code.extend(self.backend.local_set(idx))
            elif var in self.global_vars:
                offset = self.global_vars[var]
                code.extend(self.backend.const_i32(offset))
                code.append("    i64.store")
            else:
                if var not in self.global_vars:
                    self.global_vars[var] = self.memory_offset
                    self.memory_offset += 8
                
                offset = self.global_vars[var]
                code.extend(self.backend.const_i32(offset))
                code.append("    i64.store")
            
            return code
        
        if stmt[0] == 'اطبع':
            expr = stmt[1]
            code = self.compile_expr(expr, env)
            # رقم → print_i64، نص/قائمة → print_string
            if expr[0] in ('نص', 'قائمة'):
                code.extend(self.backend.call('print_string'))
            else:
                code.extend(self.backend.call('print_i64'))
            return code
        
        return []
    
    def compile_program(self, stmts: List[Tuple], env: Dict) -> str:
        """تجميع برنامج كامل إلى WAT"""
        code = []
        
        # مقدمة WASM
        code.append("(module")
        code.append("  ;; اللغة العربية الرياضية → WASM")
        code.append("  ;; المرحلة 51")
        code.append("")
        
        # استيراد دوال البيئة (يجب أن تسبق كل التعريفات المحلية)
        code.append("  ;; استيراد دوال البيئة")
        code.append('  (import "env" "print_i64" (func $print_i64 (param i64)))')
        code.append('  (import "env" "print_string" (func $print_string (param i32)))')
        code.append("")
        
        # الذاكرة الخطية
        code.append("  ;; الذاكرة الخطية")
        code.append(f"  (memory (export \"memory\") {self.backend.memory_pages})")
        code.append("")
        
        # الدالة الرئيسية
        code.append("  ;; الدالة الرئيسية")
        code.append("  (func $main (export \"main\")")
        
        # المتغيرات المحلية
        local_idx = 0
        local_vars = {}
        for stmt in stmts:
            if stmt[0] in ('أسند', 'عرف'):
                var = stmt[1]
                if var not in local_vars:
                    local_vars[var] = local_idx
                    # أسماء locals في WASM يجب أن تكون ASCII صالحة — نستخدم فهرسًا رقميًا
                    code.append(f"    (local $l{local_idx} i64)")
                    local_idx += 1
        
        env_with_locals = {**env, 'locals': local_vars}
        
        # تجميع البيانات
        code.append("")
        code.append("    ;; الجسم")
        for stmt in stmts:
            stmt_code = self.compile_stmt(stmt, env_with_locals)
            code.extend(stmt_code)
        
        code.append("  )")
        code.append("")
        
        # دوال مساعدة (بعد كل التعريفات المستوردة والوظائف الرئيسية)
        code.extend(self._generate_helpers())
        
        # نقطة البداية
        code.append("  ;; نقطة البداية")
        code.append("  (start $main)")
        code.append(")")
        
        return '\n'.join(code)
    
    def _generate_helpers(self) -> List[str]:
        """توليد دوال مساعدة"""
        code = []
        
        # جذر تربيعي (خوارزمية نيوتن)
        code.append("  ;; جذر تربيعي (خوارزمية نيوتن)")
        code.append("  (func $sqrt_i64 (param $n i64) (result i64)")
        code.append("    (local $x i64)")
        code.append("    (local $prev i64)")
        code.append("    ;; x = n / 2")
        code.append("    local.get $n")
        code.append("    i64.const 2")
        code.append("    i64.div_s")
        code.append("    local.set $x")
        code.append("    ;; حلقة نيوتن")
        code.append("    block")
        code.append("      loop")
        code.append("        local.get $x")
        code.append("        local.set $prev")
        code.append("        ;; x = (x + n/x) / 2")
        code.append("        local.get $x")
        code.append("        local.get $n")
        code.append("        local.get $x")
        code.append("        i64.div_s")
        code.append("        i64.add")
        code.append("        i64.const 2")
        code.append("        i64.div_s")
        code.append("        local.set $x")
        code.append("        ;; إذا x >= prev، توقف")
        code.append("        local.get $x")
        code.append("        local.get $prev")
        code.append("        i64.ge_s")
        code.append("        br_if 1")
        code.append("        br 0")
        code.append("      end")
        code.append("    end")
        code.append("    local.get $x")
        code.append("  )")
        code.append("")
        
        # قيمة مطلقة
        code.append("  ;; قيمة مطلقة")
        code.append("  (func $abs_i64 (param $n i64) (result i64)")
        code.append("    local.get $n")
        code.append("    i64.const 0")
        code.append("    i64.lt_s")
        code.append("    if (result i64)")
        code.append("      i64.const 0")
        code.append("      local.get $n")
        code.append("      i64.sub")
        code.append("    else")
        code.append("      local.get $n")
        code.append("    end")
        code.append("  )")
        code.append("")
        
        return code
    
    def save(self, wat_code: str, filename: str):
        """حفظ WAT إلى ملف"""
        with open(filename, 'w') as f:
            f.write(wat_code)
        print(f"✅ تم الحفظ إلى {filename}")


# ═══════════════════════════════════════════════════════════
# مثال
# ═══════════════════════════════════════════════════════════

def demo_wasm():
    """مثال على WASM backend"""
    
    print("=" * 60)
    print("🌐 المرحلة 51: WebAssembly Backend")
    print("=" * 60)
    
    compiler = WASMCompiler()
    
    # مثال: س ≔ 5 ⋄ ⎕ س + 3
    stmts = [
        ('أسند', 'س', ('عدد', 5)),
        ('اطبع', ('ثنائية', '+', ('متغير', 'س'), ('عدد', 3))),
    ]
    
    env = {'locals': {}, 'globals': {}}
    
    wat_code = compiler.compile_program(stmts, env)
    
    print("\n📋 كود WAT المُولَّد:")
    print("-" * 40)
    print(wat_code)
    print("-" * 40)
    
    compiler.save(wat_code, 'output.wat')
    
    print("\n📊 الفروق بين x86-64 و WASM:")
    print("  x86-64:  mov rax, 5; add rax, 3")
    print("  WASM:    i64.const 5; i64.const 3; i64.add")
    print("  الفرق:   WASM stack-based، لا registers")
    
    print("\n📋 التجميع:")
    print("  wat2wasm output.wat -o output.wasm")
    print("  أو: wasmtime output.wasm")
    print("  أو: node --experimental-wasm-modules output.wasm")
    
    print("\n" + "=" * 60)


if __name__ == '__main__':
    demo_wasm()
