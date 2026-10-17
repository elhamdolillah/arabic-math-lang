#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
F=MAL/src/arena/src/lib.rs
echo "===== 1) نص BinaryOp + UnaryOp من 133378d7 ====="
git show 133378d7:$F | grep -n -A24 'pub enum BinaryOp' | head -32
git show 133378d7:$F | grep -n -A6 'pub enum UnaryOp' | head -10
echo "===== 2) نص TensorOpKind + AutodiffOpKind من 70d48f4f ====="
git show 70d48f4f:$F | grep -n -A16 'pub enum TensorOpKind' | head -22
git show 70d48f4f:$F | grep -n -A10 'pub enum AutodiffOpKind' | head -14
echo "===== 3) مقطع Pattern السليم من 1f0aa14b ====="
git show 1f0aa14b:$F | grep -n -B4 -A14 'pub enum Pattern' | head -28
echo "===== 4) هل 70d48f4f يبني؟ (التحقق من سلامة النسخة) ====="
git show 70d48f4f:$F | grep -c 'pub enum BinaryOp|pub enum UnaryOp|pub enum TensorOpKind|pub enum AutodiffOpKind'
echo "===== END: أرسل النتيجة ====="
