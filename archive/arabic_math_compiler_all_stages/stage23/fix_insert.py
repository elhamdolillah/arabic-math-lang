#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""إصلاح موقع كتل دوال الملفات: كانت تُدخل بعد return code (كود ميت)"""

with open('math_complete.py', 'r', encoding='utf-8') as f:
    c = f.read()

start = c.find('        # ═══ دوال الملفات (syscalls خام) ═══\n')
# ابحث عن نهاية الكتلة: أول سطر بعد .fr_d_{k}:"... "pop rax",  ثم سطر اختم حتى return code الخاص به
end_marker = '''            ]
            return code
'''
# نهاية كتلة اختم
end = c.find(end_marker, start)
if end < 0:
    raise SystemExit('لم أجد نهاية كتل دوال الملفات')
end += len(end_marker)

funcs_block = c[start:end]
c = c[:start] + c[end:]
print('✅ أزيلت الكتلة من موقعها الميت')

# الإدخال الصحيح: في قسم استدعاء الدوال المعرفة — بعد تجهيز args وقبل فحص locals
anchor = '''        for j in range(len(args)-1,-1,-1):
            if j<len(ARG_REGS): code.append(f"    pop {ARG_REGS[j]}")
'''
if anchor not in c:
    raise SystemExit('لم أجد مرساة الإدراج')
insertion = funcs_block + anchor
c = c.replace(anchor, insertion, 1)
print('✅ أُدخلت كتل دوال الملفات في قسم استدعاء الدوال (قبل فحص locals/globals)')

with open('math_complete.py', 'w', encoding='utf-8') as f:
    f.write(c)
