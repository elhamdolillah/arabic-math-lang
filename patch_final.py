#!/usr/bin/env python3
"""
تحديث آمن — بدون أحرف Unicode داخل كود Python
"""
import shutil
from datetime import datetime

TARGET = 'math_complete.py'
BACKUP = f'math_complete.py.backup.{datetime.now().strftime("%Y%m%d_%H%M%S")}'

print("="*60)
print("  Update safe - ASCII only inside generated Python code")
print("="*60)
print()

shutil.copy(TARGET, BACKUP)
print(f"[OK] Backup: {BACKUP}")

with open(TARGET, 'r', encoding='utf-8') as f:
    lines = f.readlines()

print(f"[INFO] Original lines: {len(lines)}")

new_lines = []
changes = 0

# ── Modification 1: Add concurrency keywords to Lexer ──
print("\n[1] Adding concurrency keywords...")
for i, line in enumerate(lines):
    if "'إن'" in line and "'إذا'" in line and "'ارجع'" in line and "'خيط'" not in line:
        line = line.replace(
            "'ارجع'",
            "'ارجع', 'خيط', 'قناة', 'مزلاج', 'أرسل', 'استقبل', 'انتظر', 'أغلق', 'افتح'"
        )
        changes += 1
        print(f"    Done at line {i+1}")
    new_lines.append(line)

lines = new_lines
new_lines = []

# ── Modification 2: extern declarations ──
print("\n[2] Adding extern declarations...")
extern_added = False
extern_block = '\n; --- Phase 41: External functions ---\nextern create_thread\nextern wait_thread\nextern create_channel\nextern channel_send\nextern channel_recv\nextern create_mutex\nextern mutex_lock\nextern mutex_unlock\n'

for i, line in enumerate(lines):
    new_lines.append(line)
    if not extern_added and 'section .text' in line and 'global _start' not in line:
        new_lines.append(extern_block)
        extern_added = True
        changes += 1
        print(f"    Done after line {i+1}")

lines = new_lines
new_lines = []

# ── Modification 3: init thread_funcs ──
print("\n[3] Initializing thread_funcs...")
init_added = False
for i, line in enumerate(lines):
    new_lines.append(line)
    if not init_added and 'self.label_count' in line and '=' in line and 'self.label_count' in line.split('=')[0]:
        indent = len(line) - len(line.lstrip())
        new_lines.append(' ' * indent + 'self.thread_funcs = []  # Phase 41\n')
        init_added = True
        changes += 1
        print(f"    Done at line {i+1}")

lines = new_lines
new_lines = []

# ── Modification 4: CodeGen methods (ASCII decoration only) ──
print("\n[4] Adding CodeGen methods...")

thread_methods = '''
    # -------------------------------------------------------
    # Phase 41: Concurrency Methods
    # -------------------------------------------------------
    def compile_thread_create(self, args):
        if len(args) != 1:
            raise Exception("thread_create requires 1 argument")
        self.lines.append("    call create_thread")

    def compile_channel_create(self, args):
        self.lines.append("    call create_channel")

    def compile_mutex_create(self, args):
        self.lines.append("    call create_mutex")

    def compile_channel_send(self, args):
        if len(args) != 2:
            raise Exception("channel_send requires 2 arguments")
        self.compile_expr(args[0])
        self.lines.append("    push rax")
        self.compile_expr(args[1])
        self.lines.append("    mov rsi, rax")
        self.lines.append("    pop rdi")
        self.lines.append("    call channel_send")

    def compile_channel_recv(self, args):
        if len(args) != 1:
            raise Exception("channel_recv requires 1 argument")
        self.compile_expr(args[0])
        self.lines.append("    mov rdi, rax")
        self.lines.append("    call channel_recv")

    def compile_thread_wait(self, args):
        if len(args) != 1:
            raise Exception("thread_wait requires 1 argument")
        self.compile_expr(args[0])
        self.lines.append("    mov rdi, rax")
        self.lines.append("    call wait_thread")

    def compile_mutex_lock(self, args):
        if len(args) != 1:
            raise Exception("mutex_lock requires 1 argument")
        self.compile_expr(args[0])
        self.lines.append("    mov rdi, rax")
        self.lines.append("    call mutex_lock")

    def compile_mutex_unlock(self, args):
        if len(args) != 1:
            raise Exception("mutex_unlock requires 1 argument")
        self.compile_expr(args[0])
        self.lines.append("    mov rdi, rax")
        self.lines.append("    call mutex_unlock")

'''

methods_added = False
for i, line in enumerate(lines):
    if not methods_added and 'def compile_expr(self' in line and 'def compile_expr(self, node)' in line:
        new_lines.append(thread_methods)
        methods_added = True
        changes += 1
        print(f"    Done before line {i+1}")
    new_lines.append(line)

lines = new_lines
new_lines = []

# ── Modification 5: dispatch builtins ──
print("\n[5] Linking builtins to CodeGen...")

dispatch_code_lines = [
    "            # Phase 41: Concurrency dispatch",
    "            if name == 'خيط':",
    "                self.compile_thread_create(args)",
    "                return",
    "            elif name == 'قناة':",
    "                self.compile_channel_create(args)",
    "                return",
    "            elif name == 'مزلاج':",
    "                self.compile_mutex_create(args)",
    "                return",
    "            elif name == 'أرسل':",
    "                self.compile_channel_send(args)",
    "                return",
    "            elif name == 'استقبل':",
    "                self.compile_channel_recv(args)",
    "                return",
    "            elif name == 'انتظر':",
    "                self.compile_thread_wait(args)",
    "                return",
    "            elif name == 'أغلق':",
    "                self.compile_mutex_lock(args)",
    "                return",
    "            elif name == 'افتح':",
    "                self.compile_mutex_unlock(args)",
    "                return",
]

dispatch_added = False
for i, line in enumerate(lines):
    if not dispatch_added and "name == 'حجم'" in line and 'if' in line:
        indent = len(line) - len(line.lstrip())
        for dline in dispatch_code_lines:
            new_lines.append(dline + '\n')
        dispatch_added = True
        changes += 1
        print(f"    Done before line {i+1}")
    new_lines.append(line)

lines = new_lines

# ── Save ──
print(f"\n{'='*60}")
print(f"[RESULT] {changes} modifications applied")

try:
    code = ''.join(lines)
    compile(code, TARGET, 'exec')
    print("[OK] Python syntax valid")

    with open(TARGET, 'w', encoding='utf-8') as f:
        f.writelines(lines)

    print(f"[OK] Saved - new lines: {len(lines)}")
    print(f"[OK] Original backup: {BACKUP}")
except SyntaxError as e:
    print(f"[FAIL] Syntax error: {e}")
    print("[ROLLBACK] Restoring backup...")
    shutil.copy(BACKUP, TARGET)
    print("[OK] Restored")