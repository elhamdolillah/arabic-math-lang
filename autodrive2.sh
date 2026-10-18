#!/bin/bash
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native

echo "════ 1) اختبار: semicolons + ternary ════"
cat > /tmp/t1.mal <<'EOF'
fn main() -> i32 {
    x ≔ 5;
    y ≔ x < 10 ؟ 7 : 3;
    return y;
}
EOF
if $BIN /tmp/t1.mal -o /tmp/t1 2>/tmp/t1.err; then
  /tmp/t1; RC=$?
  echo "exit code = $RC (متوقع 7)"
  [ "$RC" = "7" ] && echo "✅ TERNARY WORKS" || echo "❌ wrong result"
else
  echo "❌ TERNARY PARSE FAILS:"; cat /tmp/t1.err
fi
echo ""

echo "════ 2) اختبار: if بأسلوب C ════"
cat > /tmp/t2.mal <<'EOF'
fn main() -> i32 {
    x ≔ 5;
    if (x < 10) return 7;
    return 3;
}
EOF
if $BIN /tmp/t2.mal -o /tmp/t2 2>/tmp/t2.err; then
  /tmp/t2; RC=$?
  echo "exit code = $RC (متوقع 7)"
  [ "$RC" = "7" ] && echo "✅ IF WORKS" || echo "❌ wrong result"
else
  echo "❌ IF PARSE FAILS:"; cat /tmp/t2.err
fi
echo ""

echo "════ 3) fib عودي — تلقائي حسب المتاح ════"
cat > /tmp/fib.mal <<'EOF'
fn fib(n) {
    n < 2 ؟ n : fib(n - 1) + fib(n - 2)
}
fn main() -> i32 {
    return fib(10);
}
EOF
if ! $BIN /tmp/fib.mal -o /tmp/fib 2>/tmp/fib.err; then
  echo "ternary fib فشل، نجرب if:"
  cat > /tmp/fib.mal <<'EOF'
fn fib(n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}
fn main() -> i32 {
    return fib(10);
}
EOF
  $BIN /tmp/fib.mal -o /tmp/fib 2>/tmp/fib.err || { echo "❌ fib parse fails:"; cat /tmp/fib.err; exit 1; }
fi
/tmp/fib; RC=$?
echo "fib(10) exit code = $RC"
[ "$RC" = "55" ] && echo "🎉 M2 PASS: عودية حقيقية عبر call/ret!" || echo "❌ M2 FAIL"
