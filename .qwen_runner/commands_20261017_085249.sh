#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
# --- 0) إلغاء commit الادعاء الكاذب 352d8e7c (mixed: يحفظ التعديلات) ---
git reset HEAD~1
git log --oneline -2
# --- 1) اقرأ نقطة الدخول والكتل قبل أي رقعة ---
sed -n '660,760p' src/parser/src/lib.rs
grep -n 'LBlock|RBlock|Semicolon|Question' src/parser/src/lib.rs | head -20
grep -n 'ASTNode::' src/arena/src/lib.rs | head -40
sed -n '120,200p' src/nir/src/lowering.rs
# --- 2) قرر الصياغة من الواقع لا من التخمين ---
# إن كان parser يدعم تسلسل عبارات وكتل ﴿﴾، استخدم:
#   إذا شرط : ﴿ عبارة ﴾
#   أعد تعبير
# إن كان التعبير-المحور فقط، استخدم صيغة شرطية تعبيرية إن وُجدت (؟ أو ما يقابلها).
# اكتب قرارك في /tmp/t5_syntax_decision.txt قبل البرمجة.
# --- 3) طبّق الرقعة فعلياً (lexer + arena + parser + lowering) ---
# لا تترك هذه الخطوة تعليقاً — اكتب الكود هنا أو عبر ملف رقعة .patch يُطبق بـ git apply.
# بعد الرقعة:
CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
# --- 4) اكتب t5.mal بالصياغة الفعلية (استبدل السطر التالي بالصياغة الحقيقية) ---
printf '%s
' 'أعد 0' > /tmp/t5.mal
# ↑ هذا placeholder — الوكيل يستبدله بالصياغة التي قررها في الخطوة 2
# --- 5) بوابة صارمة: لا commit إلا إذا نجح كل شيء ---
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
  git commit -m 'feat(parser+native): if/return — gate t5
PROVEN_FOR_SCOPE: t5 (positive exit=0, determinism x3)'
  echo "T5_GATE_CLOSED=1"
else
  echo "ABORT: t5 not proven — COMPILE=$COMPILE_EXIT T5=$T5_EXIT H1=$H1 H2=$H2 H3=$H3"
  exit 1
fi
git log --oneline -4
git status --short
