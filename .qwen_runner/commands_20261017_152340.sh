#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
REPORT=/root/reconcile_report.txt
echo "════ مسبار المصالحة الدلالي v2 ════" | tee "$REPORT"
git worktree add --detach /tmp/reconcile_ws main 2>&1 | tee -a "$REPORT"
if [ ! -d /tmp/reconcile_ws ]; then echo "ABORT: worktree لم يُنشأ"; exit 1; fi
cd /tmp/reconcile_ws
set +e
git merge --allow-unrelated-histories --no-commit origin/main > /tmp/merge_sim.log 2>&1
SIM=$?
set -e
if [ "$SIM" -ne 0 ]; then
  CONFLICTS=$(git diff --name-only --diff-filter=U 2>/dev/null | wc -l)
  echo "تعارضات نصية حقيقية: $CONFLICTS" | tee -a "$REPORT"
  git diff --name-only --diff-filter=U 2>/dev/null | tee -a "$REPORT"
  echo "VERDICT: TEXT_CONFLICTS=$CONFLICTS" | tee -a "$REPORT"
else
  echo "الدمج النصي نجح — بوابة الدلالة:" | tee -a "$REPORT"
  CARGO_TARGET_DIR=/tmp/reconcile_build cargo build --release --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml > /tmp/reconcile_build.log 2>&1
  BUILD_RC=$?
  echo "BUILD_RC=$BUILD_RC" | tee -a "$REPORT"
  tail -5 /tmp/reconcile_build.log | tee -a "$REPORT"
  if [ "$BUILD_RC" -eq 0 ]; then
    CARGO_TARGET_DIR=/tmp/reconcile_build cargo test --release --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml > /tmp/reconcile_test.log 2>&1
    TEST_RC=$?
    echo "TEST_RC=$TEST_RC" | tee -a "$REPORT"
    tail -8 /tmp/reconcile_test.log | tee -a "$REPORT"
  else
    TEST_RC=-1
    echo "البناء فشل بعد الدمج — تعارض دلالي" | tee -a "$REPORT"
  fi
  if [ "$BUILD_RC" -eq 0 ] && [ "$TEST_RC" -eq 0 ]; then
    echo "VERDICT: AUTO_MERGE_FULLY_POSSIBLE" | tee -a "$REPORT"
  elif [ "$BUILD_RC" -eq 0 ]; then
    echo "VERDICT: MERGE_COMPILES_BUT_TESTS_FAIL" | tee -a "$REPORT"
  else
    echo "VERDICT: MERGE_BREAKS_BUILD" | tee -a "$REPORT"
  fi
fi
git merge --abort 2>/dev/null
cd /root/ilm-al-kitab/MAL
git worktree remove --force /tmp/reconcile_ws 2>/dev/null
git worktree prune
echo "تم التنظيف — main الحقيقي لم يُلمس" | tee -a "$REPORT"
git status --short | head -6
echo "════ END ════" | tee -a "$REPORT"
