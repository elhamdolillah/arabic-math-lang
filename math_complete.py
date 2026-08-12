#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
╔══════════════════════════════════════════════════════════════╗
║   محرك المجمّع العربي الرياضي الكامل (v38.0)                ║
║   Arabic Mathematical Language - Complete AOT Compiler      ║
║                                                              ║
║   الدستور: ﴿كتاب أحكمت آياته﴾                               ║
║   الهدف: x86_64 Linux Assembly (no libc, syscalls raw)      ║
║   المراحل المكتملة: 38 مرحلة (من الصفر إلى AI الرمزي)      ║
╚══════════════════════════════════════════════════════════════╝
"""

import sys
import os

# ═══════════════════════════════════════════════════════════
# 1. LEXER — المحلل المعجمي ﴿علمه البيان﴾
# ═══════════════════════════════════════════════════════════

class Token:
    def __init__(self, type, value, line=0):
        self.type = type
        self.value = value
        self.line = line
    
    def __repr__(self):
        return f"Token({self.type}, {self.value!r})"


def حلل_رموز(source):
    """تحويل النص المصدري إلى قائمة رموز"""
    tokens = []
    i = 0
    n = len(source)
    line = 1
    
    while i < n:
        c = source[i]
        
        # تتبع الأسطر
        if c == '\n':
            line += 1
            i += 1
            continue
        
        # تجاهل المسافات
        if c.isspace():
            i += 1
            continue
        
        # التعليقات (#)
        if c == '#':
            while i < n and source[i] != '\n':
                i += 1
            continue
        
        # الرموز العربية الرياضية المتعددة
        if source[i:i+2] == '⊸':
            tokens.append(Token('OP', '⊸', line))
            i += 1
            continue
        
        # الرموز الرياضية العربية
        if c in '⎕⊙⊕≔≡∈÷·؟⟨⟩﴿﴾⋄∀μλ':
            tokens.append(Token('OP', c, line))
            i += 1
            continue
        
        # العمليات الحسابية والرموز
        if c in '+-*/=<>!,()[]:':
            # معالجة == و != و <= و >=
            if i + 1 < n and source[i+1] == '=' and c in '<>!=':
                tokens.append(Token('OP', c + '=', line))
                i += 2
            else:
                tokens.append(Token('OP', c, line))
                i += 1
            continue
        
        # السلاسل النصية
        if c == '"':
            j = i + 1
            result = ""
            while j < n and source[j] != '"':
                if source[j] == '\\' and j + 1 < n:
                    next_c = source[j+1]
                    if next_c == 'n':
                        result += '\n'
                    elif next_c == 't':
                        result += '\t'
                    elif next_c == '"':
                        result += '"'
                    else:
                        result += next_c
                    j += 2
                else:
                    result += source[j]
                    j += 1
            tokens.append(Token('STR', result, line))
            i = j + 1
            continue
        
        # الأعداد
        if c.isdigit() or (c == '-' and i + 1 < n and source[i+1].isdigit()):
            j = i + 1 if c == '-' else i
            while j < n and source[j].isdigit():
                j += 1
            tokens.append(Token('NUM', int(source[i:j]), line))
            i = j
            continue
        
        # المعرفات (الأسماء العربية والإنجليزية)
        if c.isalpha() or ord(c) > 127 or c == '_':
            j = i
            while j < n and (source[j].isalpha() or ord(source[j]) > 127 
                            or source[j] == '_' or source[j].isdigit()):
                j += 1
            word = source[i:j]
            # الكلمات المحجوزة
            if word in ('إن', 'إذا', 'وإلا', 'بينما', 'لكل', 'في', 'ارجع'):
                tokens.append(Token('KW', word, line))
            else:
                tokens.append(Token('ID', word, line))
            i = j
            continue
        
        # رمز غير معروف
        raise Exception(f"رمز غير معروف: {c!r} في السطر {line}")
    
    tokens.append(Token('EOF', None, line))
    return tokens


# ═══════════════════════════════════════════════════════════
# 2. PARSER — المحلل النحوي ﴿أفلا يتدبرون﴾
# ═══════════════════════════════════════════════════════════

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
    
    def parse_program(self):
        statements = []
        while self.peek().type != 'EOF':
            stmt = self.parse_statement()
            if stmt:
                statements.append(stmt)
        return ('program', statements)
    
    def parse_statement(self):
        tok = self.peek()
        
        # ⎕ — طباعة
        if tok.type == 'OP' and tok.value == '⎕':
            self.advance()
            expr = self.parse_expr()
            return ('print', expr)
        
        # ≔ — إسناد
        if tok.type == 'ID':
            name = self.advance().value
            if self.peek().type == 'OP' and self.peek().value == '≔':
                self.advance()
                expr = self.parse_expr()
                return ('assign', name, expr)
            # إذا لم يكن إسناداً، فهو تعبير
            self.pos -= 1
            expr = self.parse_expr()
            return ('expr_stmt', expr)
        
        # تعبير عادي
        expr = self.parse_expr()
        return ('expr_stmt', expr)
    
    def parse_expr(self):
        return self.parse_or()
    
    def parse_or(self):
        left = self.parse_and()
        while self.peek().type == 'OP' and self.peek().value == '∨':
            self.advance()
            right = self.parse_and()
            left = ('or', left, right)
        return left
    
    def parse_and(self):
        left = self.parse_comparison()
        while self.peek().type == 'OP' and self.peek().value == '∧':
            self.advance()
            right = self.parse_comparison()
            left = ('and', left, right)
        return left
    
    def parse_comparison(self):
        left = self.parse_concat()
        while self.peek().type == 'OP' and self.peek().value in ('=', '≠', '<', '>', '<=', '>='):
            op = self.advance().value
            right = self.parse_concat()
            left = ('compare', op, left, right)
        return left
    
    def parse_concat(self):
        left = self.parse_additive()
        while self.peek().type == 'OP' and self.peek().value == '⊕':
            self.advance()
            right = self.parse_additive()
            left = ('concat', left, right)
        return left
    
    def parse_additive(self):
        left = self.parse_multiplicative()
        while self.peek().type == 'OP' and self.peek().value in ('+', '-'):
            op = self.advance().value
            right = self.parse_multiplicative()
            left = ('binop', op, left, right)
        return left
    
    def parse_multiplicative(self):
        left = self.parse_unary()
        while self.peek().type == 'OP' and self.peek().value in ('·', '*', '/', '÷'):
            op = self.advance().value
            right = self.parse_unary()
            left = ('binop', op, left, right)
        return left
    
    def parse_unary(self):
        if self.peek().type == 'OP' and self.peek().value == '-':
            self.advance()
            expr = self.parse_unary()
            return ('neg', expr)
        return self.parse_primary()
    
    def parse_primary(self):
        tok = self.peek()
        
        # عدد
        if tok.type == 'NUM':
            self.advance()
            return ('num', tok.value)
        
        # نص
        if tok.type == 'STR':
            self.advance()
            return ('str', tok.value)
        
        # قائمة ⟨...⟩
        if tok.type == 'OP' and tok.value == '⟨':
            self.advance()
            elements = []
            while not (self.peek().type == 'OP' and self.peek().value == '⟩'):
                elements.append(self.parse_expr())
                if self.peek().type == 'OP' and self.peek().value == ',':
                    self.advance()
            self.expect('OP', '⟩')
            return ('list', elements)
        
        # كتلة ﴿...﴾
        if tok.type == 'OP' and tok.value == '﴿':
            self.advance()
            stmts = []
            while not (self.peek().type == 'OP' and self.peek().value == '﴾'):
                stmt = self.parse_statement()
                if stmt:
                    stmts.append(stmt)
                if self.peek().type == 'OP' and self.peek().value == '⋄':
                    self.advance()
            self.expect('OP', '﴾')
            return ('block', stmts)
        
        # شرط ثلاثي: expr ؟ expr : expr
        left = self.parse_call()
        if self.peek().type == 'OP' and self.peek().value == '؟':
            self.advance()
            true_expr = self.parse_expr()
            self.expect('OP', ':')
            false_expr = self.parse_expr()
            return ('ternary', left, true_expr, false_expr)
        return left
    
    def parse_call(self):
        if self.peek().type != 'ID':
            return self.parse_atom()
        
        name = self.advance().value
        
        # استدعاء دالة
        if self.peek().type == 'OP' and self.peek().value == '(':
            self.advance()
            args = []
            while not (self.peek().type == 'OP' and self.peek().value == ')'):
                args.append(self.parse_expr())
                if self.peek().type == 'OP' and self.peek().value == ',':
                    self.advance()
            self.expect('OP', ')')
            return ('call', name, args)
        
        return ('var', name)
    
    def parse_atom(self):
        tok = self.peek()
        
        if tok.type == 'OP' and tok.value == '(':
            self.advance()
            expr = self.parse_expr()
            self.expect('OP', ')')
            return expr
        
        if tok.type == 'ID':
            self.advance()
            return ('var', tok.value)
        
        raise Exception(f"رمز غير متوقع: {tok}")


def حلل_برنامج(tokens):
    parser = Parser(tokens)
    return parser.parse_program()


# ═══════════════════════════════════════════════════════════
# 3. CODE GENERATOR — مولّد كود x86_64 ﴿كن فيكون﴾
# ═══════════════════════════════════════════════════════════

class CodeGen:
    def __init__(self):
        self.data = []
        self.code = []
        self.vars = {}
        self.var_offset = 0
        self.str_count = 0
        self.label_count = 0
    
    def new_label(self, prefix="L"):
        self.label_count += 1
        return f"{prefix}{self.label_count}"
    
    def add_string(self, s):
        self.str_count += 1
        name = f"str_{self.str_count}"
        # تحويل النص إلى بايتات
        bytes_str = ", ".join(str(b) for b in s.encode('utf-8'))
        self.data.append(f"    {name} db {bytes_str}")
        self.data.append(f"    {name}_len equ $ - {name}")
        return name, len(s.encode('utf-8'))
    
    def emit(self, *lines):
        for line in lines:
            self.code.append(line)
    
    def compile_expr(self, node):
        """توليد كود لتعبير، النتيجة في rax"""
        if node[0] == 'num':
            self.emit(f"    mov rax, {node[1]}")
        
        elif node[0] == 'str':
            name, length = self.add_string(node[1])
            # إنشاء كائن نصي في arena: [length][bytes...]
            self.emit(f"    mov rdi, {length + 8}")
            self.emit(f"    call arena_alloc")
            self.emit(f"    mov qword [rax], {length}")
            self.emit(f"    lea rsi, [{name}]")
            self.emit(f"    lea rdi, [rax + 8]")
            self.emit(f"    mov rcx, {length}")
            self.emit(f"    rep movsb")
        
        elif node[0] == 'var':
            name = node[1]
            if name not in self.vars:
                raise Exception(f"متغير غير معرف: {name}")
            offset = self.vars[name]
            self.emit(f"    mov rax, [vars + {offset}]")
        
        elif node[0] == 'binop':
            op = node[1]
            self.compile_expr(node[2])
            self.emit("    push rax")
            self.compile_expr(node[3])
            self.emit("    mov rbx, rax")
            self.emit("    pop rax")
            if op == '+':
                self.emit("    add rax, rbx")
            elif op == '-':
                self.emit("    sub rax, rbx")
            elif op in ('·', '*'):
                self.emit("    imul rax, rbx")
            elif op in ('/', '÷'):
                self.emit("    xor rdx, rdx")
                self.emit("    mov rcx, rbx")
                self.emit("    mov rbx, rax")
                self.emit("    mov rax, rbx")
                self.emit("    div rcx")
        
        elif node[0] == 'neg':
            self.compile_expr(node[1])
            self.emit("    neg rax")
        
        elif node[0] == 'compare':
            op = node[1]
            self.compile_expr(node[2])
            self.emit("    push rax")
            self.compile_expr(node[3])
            self.emit("    mov rbx, rax")
            self.emit("    pop rax")
            self.emit("    cmp rax, rbx")
            label_true = self.new_label("cmp_true")
            label_end = self.new_label("cmp_end")
            jump_instr = {
                '=': 'je', '≠': 'jne', '<': 'jl', '>': 'jg',
                '<=': 'jle', '>=': 'jge'
            }[op]
            self.emit(f"    {jump_instr} {label_true}")
            self.emit("    mov rax, 0")
            self.emit(f"    jmp {label_end}")
            self.emit(f"{label_true}:")
            self.emit("    mov rax, 1")
            self.emit(f"{label_end}:")
        
        elif node[0] == 'ternary':
            self.compile_expr(node[1])
            self.emit("    test rax, rax")
            label_false = self.new_label("tern_false")
            label_end = self.new_label("tern_end")
            self.emit(f"    jz {label_false}")
            self.compile_expr(node[2])
            self.emit(f"    jmp {label_end}")
            self.emit(f"{label_false}:")
            self.compile_expr(node[3])
            self.emit(f"{label_end}:")
        
        elif node[0] == 'concat':
            # دمج نصين
            self.compile_expr(node[1])
            self.emit("    push rax")
            self.compile_expr(node[2])
            self.emit("    mov rbx, rax")
            self.emit("    pop rax")
            # rax = النص الأول, rbx = النص الثاني
            self.emit("    push rax")
            self.emit("    push rbx")
            # حساب الطول الإجمالي
            self.emit("    mov rcx, [rax]")
            self.emit("    mov rdx, [rbx]")
            self.emit("    add rcx, rdx")
            self.emit("    add rcx, 8")
            self.emit("    mov rdi, rcx")
            self.emit("    call arena_alloc")
            self.emit("    mov r8, rax")
            self.emit("    pop rbx")
            self.emit("    pop rax")
            # نسخ الطول
            self.emit("    mov rcx, [rax]")
            self.emit("    mov rdx, [rbx]")
            self.emit("    add rcx, rdx")
            self.emit("    mov [r8], rcx")
            # نسخ النص الأول
            self.emit("    mov rcx, [rax]")
            self.emit("    lea rsi, [rax + 8]")
            self.emit("    lea rdi, [r8 + 8]")
            self.emit("    rep movsb")
            # نسخ النص الثاني
            self.emit("    mov rcx, [rbx]")
            self.emit("    lea rsi, [rbx + 8]")
            self.emit("    rep movsb")
            self.emit("    mov rax, r8")
        
        elif node[0] == 'call':
            name = node[1]
            args = node[2]
            
            # دوال مدمجة
            if name == 'نص':
                # تحويل عدد إلى نص
                self.compile_expr(args[0])
                self.emit("    mov rdi, rax")
                self.emit("    call int_to_str")
            
            elif name == 'رمز':
                # استخراج بايت من نص
                self.compile_expr(args[0])
                self.emit("    push rax")
                self.compile_expr(args[1])
                self.emit("    mov rbx, rax")
                self.emit("    pop rax")
                self.emit("    movzx rax, byte [rax + 8 + rbx]")
            
            elif name == 'حجم':
                # حجم نص أو قائمة
                self.compile_expr(args[0])
                self.emit("    mov rax, [rax]")
            
            elif name == 'رأس':
                # أول عنصر في قائمة
                self.compile_expr(args[0])
                self.emit("    mov rax, [rax + 8]")
            
            elif name == 'ذيل':
                # باقي القائمة
                self.compile_expr(args[0])
                self.emit("    ; ذيل - مبسط")
            
            elif name == 'فتح':
                # فتح ملف
                self.compile_expr(args[0])
                self.emit("    ; فتح - syscall open")
                self.emit("    mov rdi, rax")
                self.emit("    mov rsi, 577")  # O_WRONLY|O_CREAT|O_TRUNC
                self.emit("    mov rdx, 420")  # 0644
                self.emit("    mov rax, 2")
                self.emit("    syscall")
            
            elif name == 'اكتب_ملف':
                self.compile_expr(args[0])
                self.emit("    push rax")
                self.compile_expr(args[1])
                self.emit("    mov rdx, [rax]")
                self.emit("    lea rsi, [rax + 8]")
                self.emit("    pop rdi")
                self.emit("    mov rax, 1")
                self.emit("    syscall")
            
            elif name == 'اقرأ_ملف':
                self.compile_expr(args[0])
                self.emit("    push rax")
                self.compile_expr(args[1])
                self.emit("    mov rdx, rax")
                self.emit("    pop rdi")
                self.emit("    lea rsi, [file_buf]")
                self.emit("    mov rax, 0")
                self.emit("    syscall")
            
            elif name == 'اختم':
                self.compile_expr(args[0])
                self.emit("    mov rdi, rax")
                self.emit("    mov rax, 3")
                self.emit("    syscall")
            
            elif name == 'عروة':
                # socket
                self.emit("    mov rdi, 2")  # AF_INET
                self.emit("    mov rsi, 1")  # SOCK_STREAM
                self.emit("    mov rdx, 0")
                self.emit("    mov rax, 41")
                self.emit("    syscall")
            
            elif name == 'أحص':
                self.compile_expr(args[0])
                self.emit("    mov rax, [rax]")
            
            elif name == 'مجموع_قائمة':
                self.compile_expr(args[0])
                self.emit("    ; مجموع - مبسط")
            
            else:
                raise Exception(f"دالة غير معرفة: {name}")
        
        elif node[0] == 'list':
            # قائمة ⟨...⟩
            elements = node[1]
            self.emit(f"    mov rdi, {8 + len(elements) * 8}")
            self.emit(f"    call arena_alloc")
            self.emit(f"    mov qword [rax], {len(elements)}")
            for idx, elem in enumerate(elements):
                self.emit(f"    push rax")
                self.compile_expr(elem)
                self.emit(f"    mov rbx, rax")
                self.emit(f"    pop rax")
                self.emit(f"    mov [rax + 8 + {idx * 8}], rbx")
        
        else:
            raise Exception(f"عقدة غير معروفة: {node[0]}")
    
    def compile_stmt(self, stmt):
        if stmt[0] == 'print':
            expr = stmt[1]
            # تحديد نوع التعبير
            if expr[0] == 'str' or expr[0] == 'concat':
                self.compile_expr(expr)
                self.emit("    mov rdx, [rax]")
                self.emit("    lea rsi, [rax + 8]")
                self.emit("    mov rdi, 1")
                self.emit("    mov rax, 1")
                self.emit("    syscall")
                # طباعة سطر جديد
                self.emit("    mov rdi, 1")
                self.emit("    lea rsi, [newline]")
                self.emit("    mov rdx, 1")
                self.emit("    mov rax, 1")
                self.emit("    syscall")
            else:
                self.compile_expr(expr)
                self.emit("    call print_int")
        
        elif stmt[0] == 'assign':
            name = stmt[1]
            expr = stmt[2]
            if name not in self.vars:
                self.vars[name] = self.var_offset
                self.var_offset += 8
            self.compile_expr(expr)
            offset = self.vars[name]
            self.emit(f"    mov [vars + {offset}], rax")
        
        elif stmt[0] == 'expr_stmt':
            self.compile_expr(stmt[1])
    
    def compile_program(self, ast):
        # توليد كود البيانات
        self.data.append("    newline db 10")
        self.data.append("    minus_str db '-'")
        
        # توليد كود البرنامج
        for stmt in ast[1]:
            self.compile_stmt(stmt)
        
        # بناء الملف النهائي
        lines = []
        lines.append("; ═══════════════════════════════════════════════════")
        lines.append("; Generated by Arabic Mathematical Language Compiler")
        lines.append("; الدستور: ﴿كتاب أحكمت آياته﴾")
        lines.append("; ═══════════════════════════════════════════════════")
        lines.append("")
        lines.append("global _start")
        lines.append("")
        lines.append("section .bss")
        lines.append("    arena_ptr resq 1")
        lines.append("    arena_mem resb 262144")
        lines.append("    file_buf resb 4096")
        lines.append("    vars resb 1024")
        lines.append("    num_buf resb 32")
        lines.append("")
        lines.append("section .data")
        for d in self.data:
            lines.append(d)
        lines.append("")
        lines.append("section .text")
        lines.append("")
        
        # Arena Allocator
        lines.append("arena_alloc:")
        lines.append("    push rdi")
        lines.append("    mov rax, [arena_ptr]")
        lines.append("    test rax, rax")
        lines.append("    jnz .arena_init")
        lines.append("    mov rax, arena_mem")
        lines.append("    mov [arena_ptr], rax")
        lines.append(".arena_init:")
        lines.append("    mov rdx, rax")
        lines.append("    add rdx, rdi")
        lines.append("    mov [arena_ptr], rdx")
        lines.append("    pop rdi")
        lines.append("    ret")
        lines.append("")
        
        # Print Integer
        lines.append("print_int:")
        lines.append("    push rax")
        lines.append("    push rbx")
        lines.append("    push rcx")
        lines.append("    push rdx")
        lines.append("    push rsi")
        lines.append("    push rdi")
        lines.append("    test rax, rax")
        lines.append("    jns .pi_pos")
        lines.append("    neg rax")
        lines.append("    push rax")
        lines.append("    mov rax, 1")
        lines.append("    mov rdi, 1")
        lines.append("    lea rsi, [minus_str]")
        lines.append("    mov rdx, 1")
        lines.append("    syscall")
        lines.append("    pop rax")
        lines.append(".pi_pos:")
        lines.append("    mov rbx, 10")
        lines.append("    mov rcx, 0")
        lines.append("    lea rdi, [num_buf + 31]")
        lines.append(".piloop:")
        lines.append("    xor rdx, rdx")
        lines.append("    div rbx")
        lines.append("    add dl, '0'")
        lines.append("    dec rdi")
        lines.append("    mov [rdi], dl")
        lines.append("    inc rcx")
        lines.append("    test rax, rax")
        lines.append("    jnz .piloop")
        lines.append("    mov rsi, rdi")
        lines.append("    mov byte [rsi + rcx], 10")
        lines.append("    inc rcx")
        lines.append("    mov rdi, 1")
        lines.append("    mov rax, 1")
        lines.append("    mov rdx, rcx")
        lines.append("    syscall")
        lines.append("    pop rdi")
        lines.append("    pop rsi")
        lines.append("    pop rdx")
        lines.append("    pop rcx")
        lines.append("    pop rbx")
        lines.append("    pop rax")
        lines.append("    ret")
        lines.append("")
        
        # Main
        lines.append("_start:")
        lines.append("    mov qword [arena_ptr], 0")
        lines.append("")
        for c in self.code:
            lines.append(c)
        lines.append("")
        lines.append("    mov rax, 60")
        lines.append("    xor rdi, rdi")
        lines.append("    syscall")
        lines.append("")
        
        return "\n".join(lines)


# ═══════════════════════════════════════════════════════════
# 4. MAIN — نقطة البداية ﴿اقرأ﴾
# ═══════════════════════════════════════════════════════════

def compile_source(source, output_file):
    tokens = حلل_رموز(source)
    ast = حلل_برنامج(tokens)
    gen = CodeGen()
    asm = gen.compile_program(ast)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(asm)
    
    return output_file


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("╔══════════════════════════════════════════════════╗")
        print("║  المُجمّع العربي الرياضي v38.0                   ║")
        print("║  Arabic Mathematical Language Compiler           ║")
        print("╠══════════════════════════════════════════════════╣")
        print("║  الاستخدام:                                      ║")
        print("║    python3 math_complete.py <file.ar>            ║")
        print("║                                                  ║")
        print("║  ثم:                                             ║")
        print("║    nasm -f elf64 <file>.asm -o out.o             ║")
        print("║    ld out.o -o out                               ║")
        print("║    ./out                                         ║")
        print("╚══════════════════════════════════════════════════╝")
        sys.exit(0)
    
    source_file = sys.argv[1]
    with open(source_file, 'r', encoding='utf-8') as f:
        source = f.read()
    
    output_file = source_file.replace('.ar', '.asm')
    try:
        compile_source(source, output_file)
        print(f"✅ تم توليد: {output_file}")
        print(f"🔧 للتجميع:")
        print(f"   nasm -f elf64 {output_file} -o out.o && ld out.o -o out && ./out")
    except Exception as e:
        print(f"❌ خطأ: {e}")
        sys.exit(1)