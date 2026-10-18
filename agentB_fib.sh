#!/bin/bash
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native

echo "════ Agent-B: fib عودي بـ ≤ ════"
cat > /tmp/fib.mal <<'EOF'
fn fib(n) {
    if (n ≤ 1) {
        return n;
    }
    return fib(n - 1) + fib(n - 2);
}
fn main() -> i32 {
    return fib(10);
}
EOF

if $BIN /tmp/fib.mal -o /tmp/fib 2>/tmp/fib.err; then
  /tmp/fib; RC=$?
  echo "fib(10) = $RC (المطلوب 55)"
  if [ "$RC" = "55" ]; then
    echo "🎉 M2 PASS: عودية حقيقية عبر call/ret!"
    echo ""
    echo "════ تصعيد: fib(20) = 6765 ════"
    sed 's/fib(10)/fib(20)/' /tmp/fib.mal > /tmp/fib20.mal
    $BIN /tmp/fib20.mal -o /tmp/fib20 && /tmp/fib20; RC2=$?
    echo "fib(20) = $RC2 (المطلوب 6765)"
    [ "$RC2" = "6765" ] && echo "🎉🎉 M2 CONFIRMED — stack frames صحيحة تحت عمق عودي!" \
      || echo "⚠ fib(20) خاطئ — مشكلة عمق في frames"
  else
    echo "❌ نتيجة خاطئة — الفرق يشير لمشكلة codegen"
  fi
else
  echo "❌ parse فشل:"; cat /tmp/fib.err
fi
