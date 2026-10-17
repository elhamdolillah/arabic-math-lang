#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) commits التي لمست lib.rs ====="
git log --all --oneline -- src/arena/src/lib.rs | head -10
echo "===== 2) commits التي عرّفت BinaryOp ====="
git log --all -S 'pub enum BinaryOp' --oneline -- src/arena/src/lib.rs | head -5
echo "===== 3) آخر نسخة تضم التعريفات الأربعة ====="
for c in $(git log --all --format=%h -- src/arena/src/lib.rs | head -15); do
  if git show $c:src/arena/src/lib.rs 2>/dev/null | grep -q 'pub enum BinaryOp'; then
    echo "FOUND_IN=$c"
    git show $c:src/arena/src/lib.rs | grep -n -A12 'pub enum BinaryOp' | head -20
    git show $c:src/arena/src/lib.rs | grep -n -A8 'pub enum UnaryOp|pub enum TensorOpKind|pub enum AutodiffOpKind' | head -40
    break
  fi
done
echo "===== 4) هل التعريفات في mal_types؟ ====="
grep -rn 'pub enum BinaryOp|pub enum UnaryOp' src/ 2>/dev/null | head -5
echo "===== END: أرسل النتيجة ====="
