#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
# --- إصلاح BIN (السبب في فشل الجولة السابقة) ---
BIN=/tmp/m2-target/release/malc-native
export BIN
$BIN --help >/dev/null 2>&1; echo "BIN_CHECK=$?"
# --- 1) lexer: كيف تُطابق الكلمات المفتاحية والمعرفات ---
sed -n '400,570p' src/lexer/src/lib.rs
# --- 2) parser: جسم parse_stmt وparse_program والكتل ---
sed -n '570,670p' src/parser/src/lib.rs
# --- 3) lowering: كيف تُخفَّض List (الكتل) والعبارات المتتالية ---
grep -n 'ASTNode::List' src/nir/src/lowering.rs
sed -n '220,330p' src/nir/src/lowering.rs
# --- 4) native: كيف تُجمَّع الدوال والكتل المتعددة ---
grep -nE 'fn compile_to_native|entry_block|for .*blocks|.blocks' src/native/src/lib.rs | head -20
sed -n '100,180p' src/native/src/lib.rs
# --- 5) تأكيد أن البوابة ستعمل بعد إضافة BIN ---
printf '%s
' '﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾' > /tmp/t5.mal
set +e
$BIN /tmp/t5.mal -o /tmp/t5; echo "COMPILE_EXIT=$?"
set -e
# المتوقع الآن: COMPILE_EXIT=1 (لأن إذا/أعد غير منفذة) — وهذا يؤكد البوابة تعمل
