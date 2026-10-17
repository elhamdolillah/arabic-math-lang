#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
echo "===== 1) lib.rs كاملاً (أول 160 سطراً) ====="
sed -n '1,160p' /root/ilm-al-kitab/MAL/src/arena/src/lib.rs
echo "===== 2) عدد الأسطر وبنية الملف ====="
wc -l /root/ilm-al-kitab/MAL/src/arena/src/lib.rs
grep -n 'enum|struct|mod|use ' /root/ilm-al-kitab/MAL/src/arena/src/lib.rs | head -30
echo "===== 3) هل التعريفات الناقصة في ملفات أخرى بالـcrate؟ ====="
grep -rn 'enum BinaryOp|enum UnaryOp|enum TensorOpKind|enum AutodiffOpKind' /root/ilm-al-kitab/MAL/src/arena/src/ | head -10
echo "===== 4) تاريخ آخر تعديل على الملف ====="
cd /root/ilm-al-kitab/MAL
git log --oneline -3 -- MAL/src/arena/src/lib.rs
git status --short MAL/src/arena/
echo "===== END: أرسل النتيجة ====="
