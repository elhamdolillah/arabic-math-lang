#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native
export BIN
PASS=0; FAIL=0; RESULTS=""
probe() {
  local name="$1" expected="$2" code="$3"
  cat > /tmp/probe.mal <<EOF
$code
EOF
  set +e
  OUT=$($BIN /tmp/probe.mal -o /tmp/probe 2>&1 && /tmp/probe 2>&1)
  RC=$?
  set -e
  if [ "$RC" = "$expected" ]; then
    RESULTS="$RESULTS
PASS | $name | exit=$RC"
    PASS=$((PASS+1))
  else
    RESULTS="$RESULTS
FAIL | $name | exit=$RC (متوقع $expected) | $OUT"
    FAIL=$((FAIL+1))
  fi
}
echo "════ مسبار منجم الميزات — دفعة واحدة ════"
probe "M1 طباعة نص" 0 '⎕ "مرحباً MAL"'
probe "M2 حساب بسيط" 7 '1 + 2 · 3'
probe "M3 متغيرات" 15 'س ≔ 5 ⋄ ص ≔ 10 ⋄ س + ص'
probe "M4 مقارنة" 1 '5 < 10'
probe "M5 شرط إذا" 0 '﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾'
probe "M6 شرط كاذب" 1 '﴿ إذا 0 : ﴿ أعد 0 ﴾ ﴾ ⋄ 1'
probe "M7 أعداد سالبة" 5 '0 - 5 + 10'
probe "M8 أقواس" 9 '(2 + 1) · 3'
probe "M9 منطقي" 1 '(1 < 2) ∧ (3 < 4)'
probe "M10 تكرار μ" 3 'μ ن . ن + 1'
echo "════ النتيجة ════"
echo "$RESULTS"
echo ""
echo "PASS=$PASS FAIL=$FAIL"
echo "════ نسبة التحويل الآلي: $PASS / $((PASS+FAIL)) ════"
echo ""
echo "════ ميزات تحتاج فحصاً إضافياً (دوال/match/when) ════"
cat > /tmp/p_fn.mal <<'EOF'
fn ضعف س {
    س + س
}
ضعف 21
EOF
set +e
$BIN /tmp/p_fn.mal -o /tmp/p_fn 2>&1 && /tmp/p_fn; echo "FN_EXIT=$? (42 = دوال تعمل)"
cat > /tmp/p_match.mal <<'EOF'
match 5 with
| 5 => 9
| _ => 0
EOF
$BIN /tmp/p_match.mal -o /tmp/p_match 2>&1 && /tmp/p_match; echo "MATCH_EXIT=$? (9 = match يعمل)"
set -e
echo ""
echo "════ حالة Git (لا تغييرات) ════"
git log --oneline -3
git status --short | head -6
echo "════ END PROBE ════"
