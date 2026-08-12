#!/usr/bin/env python3
"""
تحديث آمن لـ math_complete.py - يقرأ سطر-بسطر ويتجنب مشاكل المسافات
"""
import shutil
from datetime import datetime

TARGET = 'math_complete.py'
BACKUP = f'math_complete.py.backup.{datetime.now().strftime("%Y%m%d_%H%M%S")}'

print("╔══════════════════════════════════════════════════════╗")
print("║  ⚡ تحديث آمن — قراءة سطر-بسطر                     ║")
print("╚══════════════════════════════════════════════════════╝")
print()

shutil.copy(TARGET, BACKUP)
print(f"✅ نسخة احتياطية: {BACKUP}")
print()

# ═══ قراءة الملف كأسطر ═══
with open(TARGET, 'r', encoding='utf-8') as f:
    lines = f.readlines()

print(f"📖 عدد الأسطر الأصلية: {len(lines)}")

new_lines = []
changes = 0

# ═══════════════════════════════════════════════════════════
# التعديل 1: إضافة كلمات التوازي في Lexer
# ═══════════════════════════════════════════════════════════
print("\n📝 التعديل 1: كلمات التوازي في Lexer...")
for i, line in enumerate(lines):
    # البحث عن قائمة الكلمات المحجوزة
    if "'إن'" in line and "'إذا'" in line and "'ارجع'" in line and "'خيط'" not in line:
        # إضافة الكلمات قبل الإغلاق
        line = line.replace("'ارجع'", "'ارجع', 'خيط', 'قناة', 'مزلاج', 'أرسل', 'استقبل', 'انتظر', 'أغلق', 'افتح'")
        changes += 1
        print(f"   ✅ تم في السطر {i+1}")
    new_lines.append(line)

lines = new_lines
new_lines = []

# ═══════════════════════════════════════════════════════════
# التعديل 2: إضافة extern declarations بعد section .text
# ═══════════════════════════════════════════════════════════
print("\n📝 التعديل 2: extern declarations...")
extern_added = False
for i, line in enumerate(lines):
    new_lines.append(line)
    if not extern_added and 'section .text' in line and 'global _start' not in line:
        extern_block = '''\n; ═══ Phase 41: External functions ═══
extern create_thread
extern wait_thread
extern create_channel
extern channel_send
extern channel_recv
extern create_mutex
extern mutex_lock
extern mutex_unlock
'''
        new_lines.append(extern_block)
        extern_added = True
        changes += 1
        print(f"   ✅ تم بعد السطر {i+1}")

lines = new_lines
new_lines = []

# ═══════════════════════════════════════════════════════════
# التعديل 3: تهيئة thread_funcs في __init__
# ═══════════════════════════════════════════════════════════
print("\n📝 التعديل 3: تهيئة thread_funcs...")
init_added = False
for i, line in enumerate(lines):
    new_lines.append(line)
    if not init_added and 'self.label_count' in line and '=' in line:
        indent = len(line) - len(line.lstrip())
        new_lines.append(' ' * indent + 'self.thread_funcs = []  # Phase 41\n')
        init_added = True
        changes += 1
        print(f"   ✅ تم في السطر {i+1}")

lines = new_lines
new_lines = []

# ═══════════════════════════════════════════════════════════
# التعديل 4: إضافة دوال CodeGen قبل class نهاية الملف
# ═══════════════════════════════════════════════════════════
print("\n📝 التعديل 4: إضافة دوال CodeGen...")

thread_methods = '''
    # ═══════════════════════════════════════════════════════
    # Phase 41: Concurrency Methods
    # ═══════════════════════════════════════════════════════
    def compile_thread_create(self, args):
        if len(args) != 1:
            raise Exception("خيط() يتطلب معامل واحد")
        self.lines.append("    call create_thread")
    
    def compile_channel_create(self, args):
        self.lines.append("    call create_channel")
    
    def compile_mutex_create(self, args):
        self.lines.append("    call create_mutex")
    
    def compile_channel_send(self, args):
        if len(args) != 2:
            raise Exception("أرسل() يتطلب معاملين")
        self.compile_expr(args[0])
        self.lines.append("    push rax")
        self.compile_expr(args[1])
        self.lines.append("    mov rsi, rax")
        self.lines.append("    pop rdi")
        self.lines.append("    call channel_send")
    
    def compile_channel_recv(self, args):
        if len(args) != 1:
            raise Exception("استقبل() يتطلب معامل واحد")
        self.compile_expr(args[0])
        self.lines.append("    mov rdi, rax")
        self.lines.append("    call channel_recv")
    
    def compile_thread_wait(self, args):
        if len(args) != 1:
            raise Exception("انتظر() يتطلب معامل واحد")
        self.compile_expr(args[0])
        self.lines.append("    mov rdi, rax")
        self.lines.append("    call wait_thread")
    
    def compile_mutex_lock(self, args):
        if len(args) != 1:
            raise Exception("أغلق() يتطلب معامل واحد")
        self.compile_expr(args[0])
        self.lines.append("    mov rdi, rax")
        self.lines.append("    call mutex_lock")
    
    def compile_mutex_unlock(self, args):
        if len(args) != 1:
            raise Exception("افتح() يتطلب معامل واحد")
        self.compile_expr(args[0])
        self.lines.append("    mov rdi, rax")
        self.lines.append("    call mutex_unlock")

'''

# البحث عن المكان المناسب (قبل دالة compile_expr في CodeGen)
methods_added = False
for i, line in enumerate(lines):
    if not methods_added and 'def compile_expr(self' in line and 'def compile_expr(self, node)' in line:
        new_lines.append(thread_methods)
        methods_added = True
        changes += 1
        print(f"   ✅ تم قبل السطر {i+1}")
    new_lines.append(line)

lines = new_lines
new_lines = []

# ═══════════════════════════════════════════════════════════
# التعديل 5: إضافة dispatch للـ builtins
# ═══════════════════════════════════════════════════════════
print("\n📝 التعديل 5: ربط builtins...")

dispatch_code = '''            # Phase 41: Concurrency
            if name == 'خيط':
                self.compile_thread_create(args)
                return
            elif name == 'قناة':
                self.compile_channel_create(args)
                return
            elif name == 'مزلاج':
                self.compile_mutex_create(args)
                return
            elif name == 'أرسل':
                self.compile_channel_send(args)
                return
            elif name == 'استقبل':
                self.compile_channel_recv(args)
                return
            elif name == 'انتظر':
                self.compile_thread_wait(args)
                return
            elif name == 'أغلق':
                self.compile_mutex_lock(args)
                return
            elif name == 'افتح':
                self.compile_mutex_unlock(args)
                return
'''

dispatch_added = False
for i, line in enumerate(lines):
    if not dispatch_added and "name == 'حجم'" in line and 'if' in line:
        # استخراج المسافة البادئة
        indent = len(line) - len(line.lstrip())
        new_lines.append(' ' * indent + '# Phase 41: Concurrency dispatch\n')
        for dline in dispatch_code.split('\n'):
            if dline.strip():
                new_lines.append(' ' * indent + dline.lstrip() + '\n')
            else:
                new_lines.append('\n')
        dispatch_added = True
        changes += 1
        print(f"   ✅ تم قبل السطر {i+1}")
    new_lines.append(line)

lines = new_lines

# ═══════════════════════════════════════════════════════════
# حفظ الملف
# ═══════════════════════════════════════════════════════════
print(f"\n{'═'*50}")
print(f"📊 عدد التعديلات: {changes}")

# اختبار الصياغة
try:
    code = ''.join(lines)
    compile(code, TARGET, 'exec')
    print("✅ صياغة Python صحيحة")
    
    with open(TARGET, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    print(f"✅ تم الحفظ — الأسطر الجديدة: {len(lines)}")
    print(f"✅ النسخة الأصلية: {BACKUP}")
except SyntaxError as e:
    print(f"❌ خطأ: {e}")
    print("🔄 استعادة...")
    shutil.copy(BACKUP, TARGET)
    print("✅ تمت الاستعادة")