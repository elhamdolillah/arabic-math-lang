#!/bin/bash
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native
PASS=0; FAIL=0

check() {
  local name="$1" expected="$2" actual="$3"
  if echo "$actual" | grep -q "$expected"; then
    echo "✅ PASS: $name (found: $expected)"
    PASS=$((PASS+1))
  else
    echo "❌ FAIL: $name — expected '$expected', got:"
    echo "$actual"
    FAIL=$((FAIL+1))
  fi
}

echo "════════ M1: hello.mal ════════"
OUT=$($BIN examples/hello.mal -o /tmp/h 2>&1 && /tmp/h 2>&1)
check "M1 hello" "PASS" "$OUT"

echo ""
echo "════════ M2: fib عودي ════════"
cat > examples/fib.mal <<'EOF'
fn fib(n: i32) -> i32 {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}
fn main() -> i32 {
    printf("fib(10) = %d
", fib(10));
    return 0;
}
EOF
OUT=$($BIN examples/fib.mal -o /tmp/fib 2>&1 && /tmp/fib 2>&1)
check "M2 fib(10)=55" "fib(10) = 55" "$OUT"

echo ""
echo "════════ M2: factorial ════════"
OUT=$($BIN examples/factorial.mal -o /tmp/fact 2>&1 && /tmp/fact 2>&1)
check "M2 factorial 10!=3628800" "3628800" "$OUT"

echo ""
echo "════════ M2: gcd ════════"
OUT=$($BIN examples/gcd.mal -o /tmp/gcd 2>&1 && /tmp/gcd 2>&1)
echo "$OUT" | head -3

echo ""
echo "══════════════════════════"
echo "النتيجة: $PASS ناجح / $FAIL فاشل"
echo "══════════════════════════"
