#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) تعريف If في arena ====="
grep -n -B3 -A8 'If {' src/arena/src/lib.rs | head -25
echo "===== 2) ذراع If في nir/lowering.rs (170-215) ====="
sed -n '170,215p' src/nir/src/lowering.rs
echo "===== 3) كيف عالجت النسخ التاريخية If؟ ====="
git log --all -S 'else_body' --oneline -- src/nir/src/lowering.rs | head -5
git show 08784ab4:src/nir/src/lowering.rs | grep -n -B2 -A15 'ASTNode::If' | head -30
echo "===== 4) هل 08784ab4 (فرع t5) يبني نظرياً؟ مقارنة If فيه ====="
git show 08784ab4:src/arena/src/lib.rs | grep -n -B2 -A6 'If {' | head -20
echo "===== END: أرسل النتيجة ====="
