#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
echo "===== 1) المنطقة 260-300 من lexer ====="
sed -n '260,300p' /root/ilm-al-kitab/MAL/src/lexer/src/lib.rs
echo "===== 2) تعريف TokenKind (الvariants) ====="
grep -n -A60 'pub enum TokenKind' /root/ilm-al-kitab/MAL/src/lexer/src/lib.rs | head -70
echo "===== 3) كيف تعاملت النسخة السليمة تاريخياً مع '>' في symbol_kind؟ ====="
cd /root/ilm-al-kitab
git show 5e95427a:MAL/src/lexer/src/lib.rs | grep -n -B2 -A6 "'=>'" | head -30
echo "===== 4) آخر نسخة سليمة من symbol_kind ====="
git show 5e95427a:MAL/src/lexer/src/lib.rs | grep -n -A40 'fn symbol_kind' | head -50
echo "===== END: أرسل النتيجة ====="
