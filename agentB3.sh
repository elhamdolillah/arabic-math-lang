#!/bin/bash
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native

cat > /tmp/fib.mal <<'EOF'
fn fib(n) {
    match n with
    | 0 => 0
    | 1 => 1
    | _ => fib(n - 1) + fib(n - 2)
}
fn main() -> i32 {
    return fib(10);
}
EOF

echo "════ Agent-B: fib عبر match ════"
if $BIN /tmp/fib.mal -o /tmp/fib 2>/tmp/fib.err; then
  /tmp/fib; RC=$?
  echo "fib(10) = $RC (المطلوب 55)"
  if [ "$RC" = "55" ]; then
    echo "🎉 M2 PASS: عودية حقيقية!"
    sed 's/fib(10)/fib(20)/' /tmp/fib.mal > /tmp/fib20.mal
    $BIN /tmp/fib20.mal -o /tmp/fib20 && /tmp/fib20; RC2=$?
    echo "fib(20) = $RC2 (المطلوب 6765)"
    [ "$RC2" = "6765" ] && echo "🎉🎉 M2 CONFIRMED" || echo "⚠ عمق العودية فيه مشكلة"
  else
    echo "❌ نتيجة خاطئة"
  fi
else
  echo "❌ parse فشل:"; cat /tmp/fib.err
fi
