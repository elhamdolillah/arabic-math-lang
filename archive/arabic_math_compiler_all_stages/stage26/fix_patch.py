import sys

with open('math_complete.py', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Remove the wrongly inserted code at line 365
# The wrong insertion is after 'return code' at ~364
wrong_block = '''        if اسم=="عروة":
            code = [
                "    mov rdi, 2",
                "    mov rsi, 1",
                "    mov rdx, 0",
                "    mov rax, 41",
                "    syscall",
            ]
            return code
'''
if wrong_block in content:
    content = content.replace(wrong_block, "")
    print("✅ Removed wrongly placed 'عروة' block")

# 2. Correctly insert into compile_expr builtin dispatch
# We insert it after the 'فتح' block's return code in the REAL dispatch section
# The real dispatch is around line 700
target = '            return code\n        if اسم=="فتح":'
# Wait, let's find the 'فتح' return code in the dispatch section
# Based on sed output, it's at line 703
insertion_point = '            return code\n        if اسم=="اكتب_ملف":'
new_block = '''            return code
        if اسم=="عروة":
            code = [
                "    mov rdi, 2",
                "    mov rsi, 1",
                "    mov rdx, 0",
                "    mov rax, 41",
                "    syscall",
            ]
            return code
        if اسم=="اكتب_ملف":'''

if insertion_point in content:
    content = content.replace(insertion_point, new_block)
    print("✅ Correctly inserted 'عروة' into compile_expr dispatch")
else:
    # Try another anchor
    insertion_point = '            return code\n        if اسم=="فتح":'
    new_block = '''            return code
        if اسم=="عروة":
            code = [
                "    mov rdi, 2",
                "    mov rsi, 1",
                "    mov rdx, 0",
                "    mov rax, 41",
                "    syscall",
            ]
            return code
        if اسم=="فتح":'''
    if insertion_point in content:
        content = content.replace(insertion_point, new_block)
        print("✅ Correctly inserted 'عروة' into compile_expr dispatch (alt anchor)")
    else:
        print("❌ Could not find insertion point")
        sys.exit(1)

with open('math_complete.py', 'w', encoding='utf-8') as f:
    f.write(content)
