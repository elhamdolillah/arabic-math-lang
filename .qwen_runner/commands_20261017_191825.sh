#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) هل الفرع يبني وحده؟ (التحقق المرجعي) ====="
rm -rf /tmp/branch_check
CARGO_TARGET_DIR=/tmp/branch_check cargo build --release --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml > /tmp/branch_check.log 2>&1 || true
grep -E '^error' /tmp/branch_check.log | head -5
echo "BRANCH_BUILD_ERRORS=$(grep -cE '^error' /tmp/branch_check.log)"
echo "===== 2) بنية arena الفرع ====="
grep -n 'pub enum |pub struct ' src/arena/src/lib.rs | head -25
echo "===== 3) هل فيها op enums أو TensorOp؟ ====="
grep -n 'BinaryOp|UnaryOp|TensorOpKind|AutodiffOpKind' src/arena/src/lib.rs | head -10
echo "===== 4) مقطع Pattern وderive ====="
grep -n -B3 -A12 'enum Pattern' src/arena/src/lib.rs | head -25
echo "===== 5) مقطع If/Return في ASTNode ====="
grep -n -B2 -A6 'If {|Return {' src/arena/src/lib.rs | head -30
echo "===== END: أرسل النتيجة ====="
