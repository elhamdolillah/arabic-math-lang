from pathlib import Path

path = Path('/home/ubuntu/work/math_integrated_v4_test/math_complete.py')
c = path.read_text(encoding='utf-8')
old = '''            "    xor rax, rax",\n            "    syscall",'''
new = '''            "    xor rax, rax",\n            "    push rcx",\n            "    syscall",\n            "    pop rcx",'''
if old not in c:
    raise SystemExit('لم أجد نمط حلقة القراءة المطلوب')
c = c.replace(old, new, 1)
path.write_text(c, encoding='utf-8')
print('✅ تم إضافة push/pop rcx حول syscall في حلقة القراءة')

# تحقق من أن التعديل وقع في الموضع الصحيح
patched = path.read_text(encoding='utf-8')
if '"    push rcx",\n            "    syscall",\n            "    pop rcx",' not in patched:
    raise SystemExit('فشل التحقق من الرقعة')
print('✅ تم التحقق من وجود الرقعة')
