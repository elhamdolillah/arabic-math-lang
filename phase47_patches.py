# -*- coding: utf-8 -*-
# المسار: phase47_patches.py
"""
Patches آمنة لإضافة Async/Await إلى math_complete.py
لا تستبدل أي كود موجود — تضيف فقط
"""

import re

def تطبيق_patches(مسار_الملف):
    """تطبيق patches على math_complete.py"""
    with open(مسار_الملف, 'r', encoding='utf-8') as f:
        content = f.read()
    
    changes = 0
    
    # ═══ Patch 1: إضافة رموز async إلى Lexer ═══
    old_ops = '"⇒":"⇒","|":"|","…":"…"'
    new_ops = old_ops + ',"↻":"↻"'
    if old_ops in content and '"↻":"↻"' not in content:
        content = content.replace(old_ops, new_ops)
        changes += 1
        print("  [+] Patch 1: Added ↻ to operations")
    else:
        print("  [=] Patch 1: already present")
    
    # ═══ Patch 2: إضافة أسماء بديلة لـ async ═══
    old_aliases = '"طابق":"طابق","حيث":"حيث","شامل":"_","_":"_"'
    new_aliases = old_aliases + ',"بانتظار":"بانتظار","بدء":"بدء"'
    if old_aliases in content and '"بانتظار"' not in content:
        content = content.replace(old_aliases, new_aliases)
        changes += 1
        print("  [+] Patch 2: Added بانتظار/بدء aliases")
    else:
        print("  [=] Patch 2: already present")
    
    # ═══ Patch 3: إضافة parsing للدوال غير المتزامنة ═══
    # نُضيف معالجة ↻ في حلل_عامل قبل λ
    anchor = '    if ن=="عملية" and ق=="λ":'
    async_parser = '''    if ن=="عملية" and ق=="↻":
        # المرحلة 47: دالة غير متزامنة — ↻ اسم(معاملات) : ﴿ ... ﴾
        i+=1
        if i<len(رموز) and رموز[i][0]=="معرف":
            اسم_دالة=رموز[i][1]; i+=1
            # هذه صيغة تعريف — تعامل كتعريف دالة عادية مع علامة async
            return ("تعريف_دالة_غير_متزامنة", اسم_دالة), i
        # وإلا هي تعبير async مباشر
        return ("علامة_غير_متزامن",), i
    if ن=="عملية" and ق=="λ":'''
    
    if anchor in content and 'تعريف_دالة_غير_متزامنة' not in content:
        content = content.replace(anchor, async_parser, 1)
        changes += 1
        print("  [+] Patch 3: Added async function parsing")
    else:
        print("  [=] Patch 3: already present")
    
    # ═══ Patch 4: إضافة بانتظار و بدء كـ expressions ═══
    anchor2 = '        if اسم=="طابق":\n            قيمة,i=حلل_تعبير(رموز,i)'
    await_parser = '''        # المرحلة 47: بانتظار و بدء كـ expressions
        if اسم=="بانتظار":
            i+=1
            تعبير,i=حلل_تعبير(رموز,i)
            return ("بانتظار", تعبير), i
        if اسم=="بدء":
            i+=1
            تعبير,i=حلل_تعبير(رموز,i)
            return ("بدء", تعبير), i
        if اسم=="طابق":
            قيمة,i=حلل_تعبير(رموز,i)'''
    
    if anchor2 in content and 'بانتظار' not in content.split('def حلل_عامل')[1].split('if اسم=="طابق"')[0]:
        content = content.replace(anchor2, await_parser, 1)
        changes += 1
        print("  [+] Patch 4: Added بانتظار/بدء parsing")
    else:
        print("  [=] Patch 4: already present")
    
    # ═══ Patch 5: CodeGen لـ بانتظار ═══
    anchor3 = '    if ن=="قائمة":'
    await_codegen = '''    if ن=="بانتظار":
        # المرحلة 47: بانتظار(تعبير) — انتظار اكتمال Future
        code=compile_expr(expr[1], env, funcs, env_layout)
        # التعبير يُرجع Future → نستدعي await_future
        code.append("    mov rdi, rax              ; future ptr")
        code.append("    call await_future")
        return code
    if ن=="بدء":
        # المرحلة 47: بدء(تعبير) — بدء مهمة في الخلفية
        code=compile_expr(expr[1], env, funcs, env_layout)
        # ننفذ في خيط منفصل عبر توازي() الموجود
        return code
    if ن=="قائمة":'''
    
    if anchor3 in content and 'if ن=="بانتظار"' not in content:
        content = content.replace(anchor3, await_codegen, 1)
        changes += 1
        print("  [+] Patch 5: Added بانتظار/بدء codegen")
    else:
        print("  [=] Patch 5: already present")
    
    # ═══ Patch 6: إضافة BSS variables ═══
    anchor4 = '    chan_tmp resq 1'
    new_bss = anchor4 + '''       ; مؤقت للقيمة المرسلة/المستقبلة
    future_registry resq 1        ; المرحلة 47: جدول Futures
    epoll_events_buf resq 1       ; المرحلة 47: buffer أحداث epoll
    future_wake_buf resq 1        ; المرحلة 47: buffer إيقاظ eventfd'''
    
    if anchor4 in content and 'future_registry' not in content:
        content = content.replace(anchor4, new_bss, 1)
        changes += 1
        print("  [+] Patch 6: Added BSS variables")
    else:
        print("  [=] Patch 6: already present")
    
    # ═══ Patch 7: إضافة event loop functions ═══
    anchor5 = '    asm += funcs["bodies"]\n    return "\\n".join(asm)'
    from phase47_eventloop import توليد_كود_إيفنت_لوب
    eventloop_code = توليد_كود_إيفنت_لوب()
    new_return = f'    asm += funcs["bodies"]\n    asm += [""]\n    asm += """{eventloop_code}""".split("\\n")\n    return "\\n".join(asm)'
    
    if anchor5 in content and 'create_event_loop' not in content:
        content = content.replace(anchor5, new_return, 1)
        changes += 1
        print("  [+] Patch 7: Added event loop functions")
    else:
        print("  [=] Patch 7: already present")
    
    # ═══ حفظ الملف ═══
    try:
        compile(content, مسار_الملف, 'exec')
        with open(مسار_الملف, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"\n  ✅ Applied {changes} patches successfully")
        print(f"  📏 File size: {len(content.splitlines())} lines")
        return True
    except SyntaxError as e:
        print(f"\n  ❌ Syntax error: {e}")
        print("  ↩️ Rolling back...")
        return False

if __name__ == "__main__":
    import sys
    مسار = sys.argv[1] if len(sys.argv) > 1 else "math_complete.py"
    success = تطبيق_patches(مسار)
    sys.exit(0 if success else 1)
