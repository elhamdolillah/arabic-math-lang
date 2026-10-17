#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) حفظ العمل غير الملتزم (stash آمن مع رسالة) ====="
git stash push -m "wip: mal_tiny reports + parse_with_fns main.rs (قبل محاذاة main)"
git stash list | head -3
git status --short | head -5
echo "===== 2) الانتقال إلى main وعرض التباعد ====="
git checkout main
git log --oneline -3
git fetch origin
echo "--- local ahead/behind ---"
git rev-list --left-right --count main...origin/main
echo "===== 3) محاذاة main: دمج origin/main في المحلي ====="
set +e
git merge origin/main --no-edit 2>&1 | tee /tmp/merge_main.log
MERGE_EXIT=$?
set -e
echo "MERGE_EXIT=$MERGE_EXIT"
if [ "$MERGE_EXIT" -ne 0 ]; then
  echo "===== تعارضات في الدمج — إلغاء آمن والعودة للحالة السابقة ====="
  git merge --abort 2>/dev/null
  git checkout feat/if-return-gate-t5
  git stash pop
  echo "ABORT: main diverged — أرسل النتيجة لقرار استراتيجية المحاذاة"
  exit 1
fi
echo "===== 4) بعد المحاذاة: بناء main للتأكد ====="
CARGO_TARGET_DIR=/tmp/main-align-check cargo build --release --manifest-path tools/malc-native/Cargo.toml 2>&1 | tail -3
echo "MAIN_BUILD_EXIT=$?"
echo "===== 5) استعادة العمل المحفوظ ====="
set +e
git stash pop 2>&1 | tee /tmp/stash_pop.log
POP_EXIT=$?
set -e
echo "POP_EXIT=$POP_EXIT"
if [ "$POP_EXIT" -ne 0 ]; then
  echo "===== تعارض في استعادة الـstash — أبلغ فقط، لا تلمس شيئاً ====="
  git status --short | head -10
  echo "ABORT: stash conflict — أرسل النتيجة"
  exit 1
fi
echo "===== 6) commit منفصل لـparse_with_fns على فرع جديد ====="
git checkout -b feat/multi-fn-entry
git diff --stat tools/malc-native/src/main.rs
git add tools/malc-native/src/main.rs
git diff --cached --stat
git commit -m 'feat(cli): parse_with_fns — multi-function program entry
PROVEN_FOR_SCOPE: main.rs wiring only (parser parse_with_fns pre-existing)'
echo "PARSE_WITH_FNS_COMMITTED=1"
echo "===== 7) فحص سريع: هل المترجم يعمل بعد الدمج؟ ====="
BIN=/tmp/main-align-check/release/malc-native
cat > /tmp/basic.mal <<'EOF'
1 + 2 · 3
EOF
set +e
$BIN /tmp/basic.mal -o /tmp/basic && /tmp/basic; BASIC=$?
set -e
echo "BASIC_EXIT=$BASIC (متوقع 7)"
echo "===== 8) الحالة النهائية ====="
git log --oneline -5
git status --short | head -8
echo "===== END: لا push — انتظار قرارك ====="
