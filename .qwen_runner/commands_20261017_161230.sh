#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
echo "===== 1) آخر 30 سطراً من log البناء ====="
tail -30 /tmp/reconcile_build4.log
echo "===== 2) جميع الأخطاء ====="
grep -E '^error' /tmp/reconcile_build4.log | head -15
echo "===== 3) هل lib.rs الحي سليم؟ ====="
grep -c 'enum Pattern' /root/ilm-al-kitab/MAL/src/arena/src/lib.rs
grep -nE 'enum BinaryOp|TensorOpKind' /root/ilm-al-kitab/MAL/src/arena/src/lib.rs | head -5
echo "===== 4) هل النسخة الحية تُبنى في مكانها الأصلي؟ ====="
cd /root/ilm-al-kitab/MAL
CARGO_TARGET_DIR=/tmp/live_check cargo build --release \
  --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml \
  > /tmp/live_check.log 2>&1 || true
echo "LIVE_BUILD_RC=$?"
grep -E '^error' /tmp/live_check.log | head -5
echo "===== END: أرسل النتيجة ====="
