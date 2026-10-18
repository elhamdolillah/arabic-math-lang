#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
# --- 0) تأكيد الحالة ---
git log --oneline -3
git status --short | head -10
# --- 1) قراءة البنية (grep -E هذه المرة) ---
grep -nE 'LBlock|RBlock|Semicolon|Question|If|Return' src/parser/src/lib.rs | head -20
grep -nE 'ASTNode::' src/arena/src/lib.rs | head -40
sed -n '120,220p' src/nir/src/lowering.rs
grep -nE 'parse_program|parse_block|parse_stmt' src/parser/src/lib.rs
# --- 2) القرار الموثق للصياغة ---
cat > /tmp/t5_syntax_decision.txt <<'EOF'
الصياغة المعتمدة:
﴿ إذا شرط : ﴿ أعد قيمة ﴾ ﴾
- إذا = IfKeyword جديد في lexer
- أعد = ReturnKeyword جديد في lexer
- : يفصل الشرط عن الجسم
- ﴿﴾ كتلة موجودة أصلاً
EOF
cat /tmp/t5_syntax_decision.txt
# --- 3) الرقعة الفعلية — الوكيل يكتب الكود هنا، لا تعليقات ---
# a) lexer: أضف IfKeyword وReturnKeyword إلى TokenKind
#    وأضف 'إذا' => IfKeyword و'أعد' => ReturnKeyword في مسار الكلمات المفتاحية
# b) arena: أضف ASTNode::If { cond, then_body } و ASTNode::Return { value }
# c) parser: في parse_program/parse_block، تعرف على IfKeyword وReturnKeyword
# d) lowering: If → CondBranch + كتل؛ Return → NIRInstruction::Return
# بعد كتابة الرقعة (ملف .patch أو تعديل مباشر):
CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
echo "BUILD_EXIT=$?"
# --- 4) t5.mal بالصياغة المعتمدة ---
printf '%s
' '﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾' > /tmp/t5.mal
cat /tmp/t5.mal
# --- 5) بوابة صارمة ---
set +e
$BIN /tmp/t5.mal -o /tmp/t5; COMPILE_EXIT=$?
/tmp/t5; T5_EXIT=$?
H1=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
$BIN /tmp/t5.mal -o /tmp/t5 && /tmp/t5; H2=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
$BIN /tmp/t5.mal -o /tmp/t5 && /tmp/t5; H3=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
set -e
if [ "$COMPILE_EXIT" -eq 0 ] && [ "$T5_EXIT" -eq 0 ] && [ "$H1" = "$H2" ] && [ "$H2" = "$H3" ]; then
  git add src/lexer/src/lib.rs src/parser/src/lib.rs src/arena/src/lib.rs \
          src/nir/src/lib.rs src/nir/src/lowering.rs src/native/src/lib.rs \
          tools/malc-native/src/main.rs
  git diff --cached --stat
  git commit -m 'feat(parser+native): إذا/أعد — gate t5
PROVEN_FOR_SCOPE: t5 (positive exit=0, determinism x3)'
  echo "T5_GATE_CLOSED=1"
else
  echo "ABORT: t5 not proven — COMPILE=$COMPILE_EXIT T5=$T5_EXIT"
  echo "H1=$H1"; echo "H2=$H2"; echo "H3=$H3"
  exit 1
fi
git log --oneline -4
git status --short
