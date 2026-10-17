#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
for b in feat/if-return-gate-t5 feat/print-string-gate-c2 feat/fib-gate-d; do
  echo "═══════ $b ═══════"
  echo "--- commits أمام main ---"
  git log main..$b --oneline | head -8
  echo "--- ملفات متغيرة ---"
  git diff main...$b --stat | tail -8
done
echo "===== هل parser فرع t5 يتعامل مع إذا؟ ====="
git show feat/if-return-gate-t5:MAL/src/parser/src/lib.rs | grep -n 'إذا' | head -8
echo "===== أين ملفات بوابات C2/D في فروعها؟ ====="
git ls-tree -r --name-only feat/print-string-gate-c2 | grep -i 'gate|.mal' | head -10
git ls-tree -r --name-only feat/fib-gate-d | grep -i 'gate|.mal' | head -10
echo "===== END: أرسل النتيجة ====="
