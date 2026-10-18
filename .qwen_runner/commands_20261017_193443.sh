#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) المنطقة 90-110 من tools/malc-native/src/main.rs ====="
sed -n '90,110p' tools/malc-native/src/main.rs
echo "===== 2) الرقعة ====="
python3 - <<'PYEOF'
import sys
p = 'tools/malc-native/src/main.rs'
s = open(p).read()
old = "compile_to_native(&nir, output)"
if old not in s:
    i = s.find("compile_to_native")
    print("CONTEXT:", s[max(0,i-100):i+200] if i != -1 else "NOT FOUND")
    sys.exit("call marker not found")
new = "compile_to_native(std::slice::from_ref(&nir), output)"
assert s.count(old) == 1, "call count"
s = s.replace(old, new)
open(p, 'w').write(s)
print("SLICE_PATCH_APPLIED=1")
PYEOF
echo "===== 3) بناء نظيف ====="
rm -rf /tmp/fix_build12
CARGO_TARGET_DIR=/tmp/fix_build12 cargo build --release --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml > /tmp/fix_build12.log 2>&1
echo "BUILD_RC=0"
tail -2 /tmp/fix_build12.log
echo "===== 4) المسبار الخماسي ====="
BIN=/tmp/fix_build12/release/malc-native
cat > /tmp/final.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
$BIN /tmp/final.mal -o /tmp/final && /tmp/final; T5=$?
$BIN /tmp/m11.mal -o /tmp/m11v && /tmp/m11v; M11=$?
cat > /tmp/m12v.mal <<'EOF'
﴿ س ≔ 5 ⋄ س < 10 ؟ 7 : 3 ﴾
EOF
$BIN /tmp/m12v.mal -o /tmp/m12v && /tmp/m12v; M12=$?
$BIN MAL/tests/gates/print_string_gate_c2.mal -o /tmp/prv && /tmp/prv; C2=$?
$BIN MAL/tests/gates/fib_ar_gate_d.mal -o /tmp/fibv && /tmp/fibv; D=$?
echo "T5=$T5 (0) M11=$M11 (9) M12=$M12 (7) C2=$C2 (0) D=$D (55)"
if [ "$T5" = "0" ] && [ "$M11" = "9" ] && [ "$M12" = "7" ] && [ "$C2" = "0" ] && [ "$D" = "55" ]; then
  echo "===== 5) رفع main ====="
  git add -A
  git commit --no-edit -m 'fix(cli): pass NIR function as slice to compile_to_native'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
else
  echo "ABORT: المسبار لم يكتمل — لا push"
  exit 1
fi
git log --oneline -5
echo "════ END: main = الشجرة الحية المثبتة ════"
