#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) أين التعريفات في 133378d7؟ ====="
git grep -n 'pub enum BinaryOp|pub enum UnaryOp|pub enum TensorOpKind|pub enum AutodiffOpKind' 133378d7 | head -10
echo "===== 2) نص BinaryOp + UnaryOp كاملين ====="
git show 133378d7:src/arena/src/lib.rs | grep -n -A22 'pub enum BinaryOp' | head -30
git show 133378d7:src/arena/src/lib.rs | grep -n -A6 'pub enum UnaryOp' | head -10
echo "===== 3) من عرّف TensorOpKind وAutodiffOpKind؟ ====="
git log --all -S 'pub enum TensorOpKind' --oneline | head -3
git log --all -S 'pub enum AutodiffOpKind' --oneline | head -3
echo "===== 4) نص TensorOpKind + AutodiffOpKind من آخر commit يحويهما ====="
for c in $(git log --all -S 'pub enum TensorOpKind' --format=%h | head -5); do
  if git show $c:src/arena/src/lib.rs 2>/dev/null | grep -q 'pub enum TensorOpKind'; then
    echo "TENSOR_FOUND_IN=$c"
    git show $c:src/arena/src/lib.rs | grep -n -A15 'pub enum TensorOpKind' | head -20
    git show $c:src/arena/src/lib.rs | grep -n -A10 'pub enum AutodiffOpKind' | head -15
    break
  fi
done
echo "===== 5) نسخة 1f0aa14b من مقطع Pattern (الإصلاح السابق) ====="
git show 1f0aa14b:src/arena/src/lib.rs | grep -n -B3 -A12 'pub enum Pattern' | head -25
echo "===== END: أرسل النتيجة ====="
