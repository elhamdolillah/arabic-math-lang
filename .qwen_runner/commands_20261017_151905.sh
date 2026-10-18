#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
REPORT=/root/reconcile_report.txt
echo "════ مسبار المصالحة الدلالي: main ↔ origin/main ════" | tee "$REPORT"
echo "" | tee -a "$REPORT"
echo "===== 1) الجرد =====" | tee -a "$REPORT"
git diff --name-status main origin/main > /tmp/reconcile_raw.txt
ONLY_LOCAL=$(grep -c '^D' /tmp/reconcile_raw.txt || true)
ONLY_REMOTE=$(grep -c '^A' /tmp/reconcile_raw.txt || true)
DIFFERENT=$(grep -c '^M' /tmp/reconcile_raw.txt || true)
echo "محلي فقط: $ONLY_LOCAL | GitHub فقط: $ONLY_REMOTE | مختلفة: $DIFFERENT" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"
echo "===== 2) محاكاة الدمج في worktree معزول =====" | tee -a "$REPORT"
git worktree add /tmp/reconcile_ws main 2>&1 | head -2
cd /tmp/reconcile_ws
set +e
git merge --allow-unrelated-histories --no-commit origin/main > /tmp/merge_sim.log 2>&1
SIM=$?
set -e
if [ "$SIM" -ne 0 ]; then
  CONFLICTS=$(git diff --name-only --diff-filter=U 2>/dev/null | wc -l)
  echo "تعارضات نصية: $CONFLICTS" | tee -a "$REPORT"
  git diff --name-only --diff-filter=U 2>/dev/null | head -30 | tee -a "$REPORT"
  echo "VERDICT: TEXT_CONFLICTS=$CONFLICTS" | tee -a "$REPORT"
else
  echo "الدمج النصي نجح بلا تعارض — ننتقل للبوابة الدلالية" | tee -a "$REPORT"
  echo "" | tee -a "$REPORT"
  echo "===== 3) بوابة الدلالة: بناء بعد الدمج =====" | tee -a "$REPORT"
  CARGO_TARGET_DIR=/tmp/reconcile_build cargo build --release \
    --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml \
    > /tmp/reconcile_build.log 2>&1
  BUILD_RC=$?
  echo "BUILD_RC=$BUILD_RC" | tee -a "$REPORT"
  tail -5 /tmp/reconcile_build.log | tee -a "$REPORT"
  if [ "$BUILD_RC" -eq 0 ]; then
    echo "" | tee -a "$REPORT"
    echo "===== 4) بوابة الدلالة: اختبارات بعد الدمج =====" | tee -a "$REPORT"
    CARGO_TARGET_DIR=/tmp/reconcile_build cargo test --release \
      --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml \
      > /tmp/reconcile_test.log 2>&1
    TEST_RC=$?
    echo "TEST_RC=$TEST_RC" | tee -a "$REPORT"
    tail -8 /tmp/reconcile_test.log | tee -a "$REPORT"
  else
    TEST_RC=-1
    echo "البناء فشل بعد الدمج — الدمج النصي الناجح كان مضللاً دلالياً" | tee -a "$REPORT"
  fi
  echo "" | tee -a "$REPORT"
  if [ "$BUILD_RC" -eq 0 ] && [ "$TEST_RC" -eq 0 ]; then
    echo "VERDICT: AUTO_MERGE_FULLY_POSSIBLE (نصياً + دلالياً)" | tee -a "$REPORT"
  elif [ "$BUILD_RC" -eq 0 ]; then
    echo "VERDICT: MERGE_COMPILES_BUT_TESTS_FAIL — مراجعة بشرية مطلوبة" | tee -a "$REPORT"
  else
    echo "VERDICT: MERGE_BREAKS_BUILD — مراجعة بشرية مطلوبة" | tee -a "$REPORT"
  fi
fi
echo "" | tee -a "$REPORT"
echo "===== 5) تنظيف المحاكاة بالكامل =====" | tee -a "$REPORT"
cd /root/ilm-al-kitab/MAL
git merge --abort 2>/dev/null
git worktree remove --force /tmp/reconcile_ws 2>/dev/null
git worktree prune
echo "تم تنظيف worktree والدمج التجريبي — main الحقيقي لم يُلمس" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"
echo "===== 6) الحالة النهائية للمستودع الحقيقي =====" | tee -a "$REPORT"
git status --short | head -6
git log --oneline -2 | tee -a "$REPORT"
echo "════ END — التقرير في $REPORT ════" | tee -a "$REPORT"
