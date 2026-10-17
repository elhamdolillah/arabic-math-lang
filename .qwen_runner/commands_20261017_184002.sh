#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
echo "===== 1) أين ملفات البوابات فعلياً؟ ====="
find /root/ilm-al-kitab -name '*gate*' -type f 2>/dev/null | head -15
find /root/ilm-al-kitab -name 'm11.mal' -o -name 'm12*.mal' 2>/dev/null | head -10
echo "===== 2) محتوى m11.mal ====="
cat /tmp/m11.mal 2>/dev/null || echo "m11.mal غير موجود في /tmp"
echo "===== 3) اختبار t5 يدوياً ====="
BIN=/tmp/fix_build7/release/malc-native
cat > /tmp/t5check.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
$BIN /tmp/t5check.mal -o /tmp/t5check && /tmp/t5check; echo "T5_EXIT=$?"
echo "===== 4) كيف كان t5 في النسخة التاريخية؟ ====="
git log --all -S 'إذا' --oneline -- MAL/src/parser/src/lib.rs | head -5
echo "===== 5) هل parser الحالي يتعامل مع 'إذا'؟ ====="
grep -n 'إذا|If|Conditional' MAL/src/parser/src/lib.rs | head -10
echo "===== END: أرسل النتيجة ====="
