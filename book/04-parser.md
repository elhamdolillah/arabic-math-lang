# الفصل 4: المُحلل النحوي (Parser) بالتفصيل

## مقدمة

بعد أن حوّل الـ Lexer النص إلى رموز، يأتي دور **المُحلل النحوي (Parser)** لتحويل هذه الرموز إلى **شجرة نحوية مجردة (AST)**.

```text
قائمة رموز → [Parser] → شجرة AST
[⎕, +, 5, 3]    🌳      Print(BinOp(+, 5, 3))
```

---

## ما هي شجرة AST؟

شجرة AST هي تمثيل هرمي لبنية البرنامج.

### مثال

**الكود:**
```arabic
س ≔ 5 + 3 · 2
```

**الـ AST:**
```text
Assign
├── name: "س"
└── value: BinOp(+)
    ├── left: Num(5)
    └── right: BinOp(·)
        ├── left: Num(3)
        └── right: Num(2)
```

**ملاحظة:** الضرب `·` أعمق من الجمع `+` لأن له أسبقية أعلى.

---

## أنواع العقد (Nodes)

```python
# العقد الأساسية
class NumNode:      # عدد
class StrNode:      # نص
class VarNode:      # متغير
class BinOpNode:    # عملية ثنائية (+, -, ·, ÷)
class UnaryNode:    # عملية أحادية (-)
class AssignNode:   # إسناد (≔)
class PrintNode:    # طباعة (⎕)
class ListNode:     # قائمة ⟨⟩
class CallNode:     # استدعاء دالة
class LambdaNode:   # دالة λ
class BlockNode:    # كتلة ﴿⋄﴾
class WhileNode:    # حلقة μ
class ForNode:      # حلقة ∀
class IfNode:       # شرط ثلاثي ؟:
```

---

## Recursive Descent Parser

نستخدم تقنية **النزول التكراري** — كل مستوى من مستويات الأسبقية له دالة خاصة.

### قواعد الأسبقية (من الأدنى للأعلى)

```text
1. parse_expr()       → parse_ternary()
2. parse_ternary()    → parse_or() ؟ :
3. parse_or()         → parse_and() ∨
4. parse_and()        → parse_comparison() ∧
5. parse_comparison() → parse_concat() = ≠ < >
6. parse_concat()     → parse_additive() ⊕
7. parse_additive()   → parse_multiplicative() + -
8. parse_multiplicative() → parse_unary() · ÷
9. parse_unary()      → parse_call() -
10. parse_call()      → parse_primary() ()
11. parse_primary()   → NUM, STR, ID, (), ⟨⟩, ﴿﴾
```

---

## التنفيذ الكامل

```python
class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.pos = 0
    
    def peek(self):
        return self.tokens[self.pos] if self.pos < len(self.tokens) else Token('EOF', None)
    
    def advance(self):
        tok = self.peek()
        self.pos += 1
        return tok
    
    def expect(self, type, value=None):
        tok = self.peek()
        if tok.type != type or (value is not None and tok.value != value):
            raise Exception(f"متوقع {type} {value!r}، حصلت على {tok}")
        return self.advance()
    
    # ═══════════════════════════════════════════════════════
    # المستوى 1: التعبير الكامل
    # ═══════════════════════════════════════════════════════
    def parse_expr(self):
        return self.parse_ternary()
    
    # ═══════════════════════════════════════════════════════
    # المستوى 2: الشرط الثلاثي (أدنى أسبقية)
    # ═══════════════════════════════════════════════════════
    def parse_ternary(self):
        condition = self.parse_or()
        if self.peek().value == '؟':
            self.advance()
            true_expr = self.parse_expr()
            self.expect('OP', ':')
            false_expr = self.parse_expr()
            return IfNode(condition, true_expr, false_expr)
        return condition
    
    # ═══════════════════════════════════════════════════════
    # المستوى 3: OR
    # ═══════════════════════════════════════════════════════
    def parse_or(self):
        left = self.parse_and()
        while self.peek().value == '∨':
            self.advance()
            right = self.parse_and()
            left = BinOpNode('∨', left, right)
        return left
    
    # ═══════════════════════════════════════════════════════
    # المستوى 4: AND
    # ═══════════════════════════════════════════════════════
    def parse_and(self):
        left = self.parse_comparison()
        while self.peek().value == '∧':
            self.advance()
            right = self.parse_comparison()
            left = BinOpNode('∧', left, right)
        return left
    
    # ═══════════════════════════════════════════════════════
    # المستوى 5: المقارنات
    # ═══════════════════════════════════════════════════════
    def parse_comparison(self):
        left = self.parse_concat()
        while self.peek().value in ('=', '≠', '<', '>', '<=', '>='):
            op = self.advance().value
            right = self.parse_concat()
            left = BinOpNode(op, left, right)
        return left
    
    # ═══════════════════════════════════════════════════════
    # المستوى 6: الدمج ⊕
    # ═══════════════════════════════════════════════════════
    def parse_concat(self):
        left = self.parse_additive()
        while self.peek().value == '⊕':
            self.advance()
            right = self.parse_additive()
            left = BinOpNode('⊕', left, right)
        return left
    
    # ═══════════════════════════════════════════════════════
    # المستوى 7: الجمع والطرح
    # ═══════════════════════════════════════════════════════
    def parse_additive(self):
        left = self.parse_multiplicative()
        while self.peek().value in ('+', '-'):
            op = self.advance().value
            right = self.parse_multiplicative()
            left = BinOpNode(op, left, right)
        return left
    
    # ═══════════════════════════════════════════════════════
    # المستوى 8: الضرب والقسمة
    # ═══════════════════════════════════════════════════════
    def parse_multiplicative(self):
        left = self.parse_unary()
        while self.peek().value in ('·', '*', '/', '÷'):
            op = self.advance().value
            right = self.parse_unary()
            left = BinOpNode(op, left, right)
        return left
    
    # ═══════════════════════════════════════════════════════
    # المستوى 9: السالب الأحادي
    # ═══════════════════════════════════════════════════════
    def parse_unary(self):
        if self.peek().value == '-':
            self.advance()
            operand = self.parse_unary()
            return UnaryNode('-', operand)
        return self.parse_call()
    
    # ═══════════════════════════════════════════════════════
    # المستوى 10: الاستدعاء
    # ═══════════════════════════════════════════════════════
    def parse_call(self):
        expr = self.parse_primary()
        while self.peek().value == '(':
            self.advance()
            args = []
            if self.peek().value != ')':
                args.append(self.parse_expr())
                while self.peek().value == ',':
                    self.advance()
                    args.append(self.parse_expr())
            self.expect('OP', ')')
            expr = CallNode(expr, args)
        return expr
    
    # ═══════════════════════════════════════════════════════
    # المستوى 11: القيم الأساسية
    # ═══════════════════════════════════════════════════════
    def parse_primary(self):
        tok = self.peek()
        
        if tok.type == 'NUM':
            self.advance()
            return NumNode(tok.value)
        
        if tok.type == 'STR':
            self.advance()
            return StrNode(tok.value)
        
        if tok.type == 'ID':
            self.advance()
            return VarNode(tok.value)
        
        if tok.value == '(':
            self.advance()
            expr = self.parse_expr()
            self.expect('OP', ')')
            return expr
        
        if tok.value == '⟨':
            return self.parse_list()
        
        if tok.value == '﴿':
            return self.parse_block()
        
        raise Exception(f"رمز غير متوقع: {tok}")
    
    def parse_list(self):
        self.expect('OP', '⟨')
        elements = []
        if self.peek().value != '⟩':
            elements.append(self.parse_expr())
            while self.peek().value == ',':
                self.advance()
                elements.append(self.parse_expr())
        self.expect('OP', '⟩')
        return ListNode(elements)
    
    def parse_block(self):
        self.expect('OP', '﴿')
        stmts = []
        while self.peek().value != '﴾':
            stmts.append(self.parse_statement())
            if self.peek().value == '⋄':
                self.advance()
        self.expect('OP', '﴾')
        return BlockNode(stmts)
```

---

## مثال تطبيقي

### الكود
```arabic
⎕ 5 + 3 · 2
```

### خطوات التحليل

```text
1. parse_expr() → parse_ternary() → ... → parse_additive()
2. parse_additive():
   - parse_multiplicative() → NumNode(5)
   - وجد '+' → تقدم
   - parse_multiplicative():
     - parse_unary() → parse_primary() → NumNode(3)
     - وجد '·' → تقدم
     - parse_unary() → parse_primary() → NumNode(2)
     - أعد BinOpNode('·', 3, 2)
   - أعد BinOpNode('+', 5, BinOp('·', 3, 2))
3. parse_statement() → PrintNode(...)
```

### الـ AST الناتج
```text
PrintNode(
  BinOpNode(
    op='+',
    left=NumNode(5),
    right=BinOpNode(
      op='·',
      left=NumNode(3),
      right=NumNode(2)
    )
  )
)
```

---

## معالجة الأخطاء

### 1. أقواس غير متوازنة
```arabic
⎕ (5 + 3
```
```text
❌ خطأ في السطر 1: متوقع ')'، حصلت على EOF
```

### 2. عامل بدون operand
```arabic
س ≔ 5 +
```
```text
❌ خطأ في السطر 1: رمز غير متوقع: EOF
```

### 3. فاصلة زائدة
```arabic
ق ≔ ⟨1, 2,⟩
```
```text
❌ خطأ في السطر 1: متوقع تعبير بعد ','
```

---

## تمارين الفصل الرابع

1. **تمرين 1:** أضف دعم الأس `^` (أسبقية أعلى من الضرب)
2. **تمرين 2:** أضف دعم الوصول للقائمة `ق[0]`
3. **تمرين 3:** أضف دعم العمليات المركبة `س += 1`
4. **تمرين 4:** حسّن رسائل الخطأ مع عرض السياق

---

## الخلاصة

الـ Parser هو **عقل المُجمّع**:
- يفهم بنية البرنامج
- يفرض قواعد الأسبقية
- يبني شجرة AST للمراحل التالية

في الفصل التالي، سندرس **نظام الأنواع** وكيف نتحقق من صحة البرنامج قبل توليد الكود.

**﴿وقل رب زدني علماً﴾**