#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native
export BIN
cat > /tmp/m7.mal <<'EOF'
﴿ إذا 0 : ﴿ أعد 0 ﴾ ⋄ 1 ﴾
EOF
cat > /tmp/m12.mal <<'EOF'
﴿ س ≔ 5 ⋄ س < 10 ؟ 7 : 3 ﴾
EOF
cat > /tmp/m11.mal <<'EOF'
match 5 with
| 5 => 9
| _ => 0
EOF
cat > /tmp/t5.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
set +e
$BIN /tmp/m7.mal -o /tmp/m7 && /tmp/m7; M7=$?
$BIN /tmp/m12.mal -o /tmp/m12 && /tmp/m12; M12=$?
$BIN /tmp/m11.mal -o /tmp/m11 && /tmp/m11; M11=$?
$BIN /tmp/t5.mal -o /tmp/t5v && /tmp/t5v; T5=$?
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/pr && /tmp/pr; C2=$?
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fib && /tmp/fib; D=$?
set -e
echo "M7=$M7 (1) M12=$M12 (7) M11=$M11 (9) T5=$T5 (0) C2=$C2 (0) D=$D (55)"
if [ "$M7" = "1" ] && [ "$M12" = "7" ] && [ "$M11" = "9" ] && [ "$T5" = "0" ] && [ "$C2" = "0" ]; then
  echo "PROBE_13_OF_13=1"
else
  echo "PROBE_INCOMPLETE: M7=$M7"
fi
