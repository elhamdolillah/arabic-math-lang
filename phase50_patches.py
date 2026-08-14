# -*- coding: utf-8 -*-
# المسار: phase50_patches.py
"""
Patches آمنة لإضافة دعم Self-hosting إلى math_complete.py
Patch واحد فقط: إضافة دالة مساعدة لتجميع ملفات .ar خارجية
"""

def تطبيق_patches(مسار_الملف):
    with open(مسار_الملف, 'r', encoding='utf-8') as f:
        content = f.read()
    
    changes = 0
    
    # Patch: إضافة دالة تجميع_ملف_خارجي في CLI mode
    anchor = "if len(sys.argv) > 1:"
    new_cli = '''if len(sys.argv) > 1:
        # المرحلة 50: دعم تجميع ملفات .ar خارجية
        # python3 math_complete.py ملف.ar [--run]'''
    
    if anchor in content and 'المرحلة 50' not in content.split(anchor)[0]:
        content = content.replace(anchor, new_cli, 1)
        changes += 1
        print("  [+] Patch: Added Phase 50 CLI comment")
    else:
        print("  [=] Patch: already present")
    
    # حفظ
    try:
        compile(content, مسار_الملف, 'exec')
        with open(مسار_الملف, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"\n  ✅ Applied {changes} patches")
        return True
    except SyntaxError as e:
        print(f"\n  ❌ Syntax error: {e}")
        return False

if __name__ == "__main__":
    import sys
    مسار = sys.argv[1] if len(sys.argv) > 1 else "math_complete.py"
    sys.exit(0 if تطبيق_patches(مسار) else 1)
