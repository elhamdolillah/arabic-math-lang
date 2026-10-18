#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) المنطقة 90-110 من main.rs ====="
sed -n '90,110p' src/cli/src/main.rs
echo "===== 2) جميع استدعاءات compile_to_native ====="
grep -n 'compile_to_native' src/cli/src/main.rs
echo "===== 3) توقيع الدالة في native ====="
grep -n -A3 'fn compile_to_native' src/native/src/lib.rs | head -10
echo "===== END: أرسل النتيجة ====="
