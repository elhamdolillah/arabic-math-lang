# -*- coding: utf-8 -*-
# المسار: phase48_patches.py
"""
Patches آمنة لإضافة Macros إلى math_complete.py
3 patches فقط — لا تمس أي كود موجود
"""

def تطبيق_patches(مسار_الملف):
    with open(مسار_الملف, 'r', encoding='utf-8') as f:
        content = f.read()
    
    changes = 0
    
    # ═══ Patch 1: إضافة اسم "ماكرو" إلى Lexer ═══
    old = '"نوع":"نوع","سمة":"سمة","تطبيق":"تطبيق","على":"على"'
    new = old + ',"ماكرو":"ماكرو"'
    if old in content and '"ماكرو":"ماكرو"' not in content:
        content = content.replace(old, new)
        changes += 1
        print("  [+] Patch 1: Added ماكرو keyword")
    else:
        print("  [=] Patch 1: already present")
    
    # ═══ Patch 2: إضافة parsing لـ تعريف_ماكرو في حلل_بيان ═══
    anchor = '    if ق=="تعريف_نوع":'
    macro_parser = '''    if ن=="عملية" and ق=="ماكرو":
        # المرحلة 48: تعريف ماكرو — ماكرو اسم(معاملات) : ﴿ تعبير ﴾
        i+=1
        if i>=len(رموز) or رموز[i][0]!="معرف": raise Exception(f"اسم الماكرو مطلوب عند {pos_msg(رموز, i)}")
        اسم=رموز[i][1]; i+=1
        # معاملات اختيارية
        معاملات=[]
        if i<len(رموز) and رموز[i][1]=="(":
            i+=1
            while True:
                if i>=len(رموز): raise Exception(f") مطلوبة عند {pos_msg(رموز, i)}")
                if رموز[i][1]==")": i+=1; break
                if رموز[i][0]!="معرف": raise Exception(f"اسم معامل مطلوب عند {pos_msg(رموز, i)}")
                معاملات.append(رموز[i][1]); i+=1
                if i<len(رموز) and رموز[i][1]==",": i+=1
        if i>=len(رموز) or رموز[i][1]!=":": raise Exception(f": مطلوبة عند {pos_msg(رموز, i)}")
        i+=1
        if i>=len(رموز) or رموز[i][1]!="﴿": raise Exception(f"﴿ مطلوبة عند {pos_msg(رموز, i)}")
        i+=1
        # حلل الجسم كتعبير واحد
        جسم,i=حلل_تعبير(رموز,i)
        if i>=len(رموز) or رموز[i][1]!="﴾": raise Exception(f"﴾ مطلوبة عند {pos_msg(رموز, i)}")
        i+=1
        # استيراد وتسجيل في registry
        try:
            from phase48_macros import سجل_ماكرو
            سجل_ماكرو(اسم, [{"معاملات": معاملات, "جسم": جسم}])
        except ImportError:
            pass
        return ("تعريف_ماكرو", اسم, [{"معاملات": معاملات, "جسم": جسم}]), i
    if ق=="تعريف_نوع":'''
    
    if anchor in content and 'تعريف_ماكرو' not in content.split('def حلل_بيان')[1].split('def ')[0]:
        content = content.replace(anchor, macro_parser, 1)
        changes += 1
        print("  [+] Patch 2: Added macro definition parser")
    else:
        print("  [=] Patch 2: already present")
    
    # ═══ Patch 3: استدعاء وسّع_برنامج في compile_program ═══
    anchor3 = 'def compile_program(برنامج):\n    check_ownership(برنامج)'
    new_start = '''def compile_program(برنامج):
    # المرحلة 48: توسيع الماكروزات قبل التحقق من الملكية
    try:
        from phase48_macros import وسّع_برنامج, إعادة_عداد_التوسعات
        إعادة_عداد_التوسعات()
        برنامج = وسّع_برنامج(برنامج)
    except ImportError:
        pass
    check_ownership(برنامج)'''
    
    if anchor3 in content and 'وسّع_برنامج' not in content:
        content = content.replace(anchor3, new_start, 1)
        changes += 1
        print("  [+] Patch 3: Added macro expansion in compile_program")
    else:
        print("  [=] Patch 3: already present")
    
    # ═══ حفظ ═══
    try:
        compile(content, مسار_الملف, 'exec')
        with open(مسار_الملف, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"\n  ✅ Applied {changes} patches")
        print(f"  📏 File size: {len(content.splitlines())} lines")
        return True
    except SyntaxError as e:
        print(f"\n  ❌ Syntax error: {e}")
        return False

if __name__ == "__main__":
    import sys
    مسار = sys.argv[1] if len(sys.argv) > 1 else "math_complete.py"
    sys.exit(0 if تطبيق_patches(مسار) else 1)
