#!/bin/bash
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native

echo "════ M2: fib عودي بـ if{} ════"
cat > /tmp/fib.mal <<'EOF'
fn fib(n) {
    if (n <= 1) {
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
  echo "fib(10) exit code = $RC (المطلوب 55)"
  if [ "$RC" = "55" ]; then
    echo "🎉🎉 M2 PASS — عودية حقيقية عبر call/ret + stack frames!"
    echo ""
    echo "════ اختبار إضافي: fib(20) = 6765 ════"
    sed 's/fib(10)/fib(20)/' /tmp/fib.mal > /tmp/fib20.mal
    $BIN /tmp/fib20.mal -o /tmp/fib20 && /tmp/fib20; RC2=$?
    echo "fib(20) = $RC2 (المطلوب 6765)"
  else
    echo "❌ نتيجة خاطئة — نحتاج فحص codegen"
  fi
else
  echo "❌ parse فشل، نجرب صيغة if/else:"
  cat > /tmp/fib.mal <<'EOF'
fn fib(n) {
    if (n <= 1) {
        n
    } else {
        fib(n - 1) + fib(n - 2)
    }
}
fn main() -> i32 {
    return fib(10);
}
EOF
  $BIN /tmp/fib.mal -o /tmp/fib 2>/tmp/fib.err && /tmp/fib; RC=$?
  echo "fib(10) = $RC"
  [ "$RC" = "55" ] && echo "🎉 M2 PASS" || { echo "❌ فشل:"; cat /tmp/fib.err; }
fi
