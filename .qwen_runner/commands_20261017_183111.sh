#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
echo "===== 1) اعتماديات parser مقابل arena ====="
echo "--- parser/Cargo.toml ---"
cat MAL/src/parser/Cargo.toml
echo "--- arena/Cargo.toml ---"
cat MAL/src/arena/Cargo.toml
echo "===== 2) سياق parse_type (الأسطر 580-615) ====="
sed -n '580,615p' MAL/src/parser/src/lib.rs
echo "===== 3) هل وُجدت parse_type يوماً في التاريخ؟ ====="
git log --all -S 'fn parse_type' --oneline | head -5
echo "===== 4) إن وُجدت: نصها من آخر commit ====="
for c in $(git log --all -S 'fn parse_type' --format=%h | head -5); do
  if git show $c:MAL/src/parser/src/lib.rs 2>/dev/null | grep -q 'fn parse_type'; then
    echo "FOUND_IN=$c"
    git show $c:MAL/src/parser/src/lib.rs | grep -n -A25 'fn parse_type' | head -30
    break
  fi
done
echo "===== END: أرسل النتيجة ====="
