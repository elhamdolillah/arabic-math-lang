#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native
export BIN
REPORT=/root/feature_probe_report.txt
PASS=0; FAIL=0; DIFF=0
RESULTS=""
probe() {
  local name="$1" expected="$2"
  local out="/tmp/probe_out_$(echo "$name" | tr ' /' '__')"
  cat > /tmp/probe_src.mal
  set +e
  CERR=$($BIN /tmp/probe_src.mal -o "$out" 2>&1)
  CRC=$?
  COUT=""
  if [ $CRC -eq 0 ]; then
    COUT=$("$out" 2>&1)
    CRC=$?
  fi
  set -e
  if [ "$CRC" = "$expected" ]; then
    RESULTS="$RESULTS${NL}PASS | $name | exit=$CRC"
    PASS=$((PASS+1))
  elif [ $CRC -ne 0 ] && [ -n "$CERR" ]; then
    RESULTS="$RESULTS${NL}ERROR | $name | $CERR"
    FAIL=$((FAIL+1))
  else
    RESULTS="$RESULTS${NL}DIFF | $name | exit=$CRC (متوقع $expected)"
    DIFF=$((DIFF+1))
  fi
}
NL=$(printf '
')
echo "════ مسبار منجم الميزات — تنقّل ذاتي ════" | tee "$REPORT"
probe "M1 طباعة نص" 0 <<'EOF'
⎕ "مرحباً MAL"
EOF
probe "M2 حساب" 7 <<'EOF'
1 + 2 · 3
EOF
probe "M3 متغيرات في كتلة" 15 <<'EOF'
﴿ س ≔ 5 ⋄ ص ≔ 10 ⋄ س + ص ﴾
EOF
probe "M4 مقارنة صادقة" 1 <<'EOF'
5 < 10
EOF
probe "M5 مقارنة كاذبة" 0 <<'EOF'
5 > 10
EOF
probe "M6 إذا صادق" 0 <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
probe "M7 إذا كاذب يسقط" 1 <<'EOF'
﴿ إذا 0 : ﴿ أعد 0 ﴾ ﴾ ⋄ 1
EOF
probe "M8 أقواس" 9 <<'EOF'
(2 + 1) · 3
EOF
probe "M9 منطق" 1 <<'EOF'
(1 < 2) ∧ (3 < 4)
EOF
probe "M10 دالة" 21 <<'EOF'
fn ضعف س {
    س + س
}
ضعف 21
EOF
probe "M11 match" 9 <<'EOF'
match 5 with
| 5 => 9
| _ => 0
EOF
probe "M12 ثلاثي ؟:" 7 <<'EOF'
﴿ س ≔ 5 ⋄ س < 10 ؟ 7 : 3 ﴾
EOF
probe "M13 سالب" 5 <<'EOF'
0 - 5 + 10
EOF
echo "$RESULTS" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"
echo "PASS=$PASS DIFF=$DIFF FAIL=$FAIL" | tee -a "$REPORT"
echo "════ نهاية المسبار — التقرير في $REPORT ════" | tee -a "$REPORT"
echo ""
echo "════ حالة Git (لا تغييرات) ════"
git log --oneline -3
git status --short | head -6
