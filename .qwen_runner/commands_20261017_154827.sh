#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /tmp/reconcile_ws 2>/dev/null || { echo "الـworktree اختفى"; exit 1; }
echo "===== 1) هل MAL/src مطابق لـHermes main الآن؟ ====="
git diff main HEAD --stat -- MAL/src | head -10
echo "(فارغ = مطابق تماماً)"
echo "===== 2) محتوى lib.rs الحالي ====="
grep -c 'enum Pattern' MAL/src/arena/src/lib.rs
grep -n 'TensorOpKind|AutodiffOpKind|enum BinaryOp' MAL/src/arena/src/lib.rs | head -5
echo "===== 3) من يضمّن mal_arena؟ ====="
grep -n 'arena' MAL/tools/malc-native/Cargo.toml
head -30 MAL/tools/malc-native/Cargo.toml
echo "===== 4) هل هناك نسخ arena أخرى؟ ====="
find MAL -name 'Cargo.toml' -path '*arena*' 2>/dev/null
find MAL -type d -name 'arena' 2>/dev/null | head -5
echo "===== 5) بناء نظيف مع log كامل ====="
rm -rf /tmp/reconcile_build3
CARGO_TARGET_DIR=/tmp/reconcile_build3 cargo build --release \
  --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml \
  > /tmp/reconcile_build3.log 2>&1 || true
echo "BUILD3_RC=$?"
grep -E '^error' /tmp/reconcile_build3.log | head -10
echo "----- أول خطأ -----"
grep -n -A12 '^error' /tmp/reconcile_build3.log | head -40
echo "===== END: أرسل النتيجة ====="
