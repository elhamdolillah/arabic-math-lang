cd ~/ilm-al-kitab
# إنشاء سكربت إصلاح مؤقت
cat << 'PYEOF' > /tmp/fix_mal_arena.py
import re
file_path = "/root/ilm-al-kitab/MAL/src/arena/src/lib.rs"
with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()
# الإصلاح 1: إضافة الاستيرادات المفقودة في الأعلى إذا لم تكن موجودة
if not any("use mal_types::{BinaryOp, UnaryOp};" in line for line in lines[:20]):
    lines.insert(0, "use mal_types::{BinaryOp, UnaryOp};\n")
# الإصلاح 2: إزالة أسطر #[derive] المكررة التي تسبب خطأ E0119
# نبحث عن النمط المكرر ونحتفظ فقط بآخر وأكبر derive
new_lines = []
skip_next_derives = False
i = 0
while i < len(lines):
    line = lines[i]
    # إذا وجدنا السطر الأول من التكرار المعطوب
    if "#[derive(Debug, Clone)]" in line and i+1 < len(lines) and "/// Tensor operations" in lines[i+1]:
        # نتخطى السطر 116 و 117
        i += 2
        # الآن نحن عند السطر 118: #[derive(Debug, Clone, Copy, PartialEq, Eq)]
        # نحتفظ به
        new_lines.append(lines[i])
        i += 1
        # نتخطي أي أسطر #[derive] مكررة أخرى حتى نصل إلى تعريف الـ struct/enum الفعلي
        while i < len(lines) and lines[i].strip().startswith("#[derive"):
            i += 1
        continue
    else:
        new_lines.append(line)
    i += 1
with open(file_path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)
print("✅ تم تطبيق الإصلاح الجراحي على lib.rs بنجاح")
PYEOF
# تشغيل سكربت الإصلاح
python3 /tmp/fix_mal_arena.py
# التحقق من أن الملف أصبح نظيفاً (عرض الأسطر 110-125)
echo "🔍 التحقق من إصلاح التكرار:"
sed -n '110,125p' /root/ilm-al-kitab/MAL/src/arena/src/lib.rs
