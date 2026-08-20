#!/usr/bin/env bash
set -Eeuo pipefail

# UORI CI Gate — report-only, no commit, no merge.
ROOT="${UORI_WORKTREE:-/home/uori-agent/uori_c40_work}"
ORIGINAL="${UORI_ORIGINAL:-/home/uori-agent/lib/math_complete.py}"
REPORTS="${UORI_REPORTS:-/home/uori-agent/uori_ci_reports}"
LOCK="${UORI_LOCK:-/home/uori-agent/.uori_ci_gate.lock}"
EXPECTED_ORIGINAL_SHA="${UORI_EXPECTED_ORIGINAL_SHA:-b325c4b2b57a1590a09d7d75701b32a0e139fd95acf89820b5f9fb2308929f2b}"
MAX_DISK_PCT="${UORI_MAX_DISK_PCT:-90}"
mkdir -p "$REPORTS"
exec 9>"$LOCK"
if ! flock -n 9; then echo 'STATUS=مؤجل: توجد دورة أخرى قيد التشغيل'; exit 75; fi

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="$REPORTS/$STAMP"
mkdir -p "$OUT"
exec > >(tee "$OUT/run.log") 2>&1
FAIL=0
fail(){ echo "FAIL=$*"; FAIL=1; }
check(){ local label="$1"; shift; echo "CHECK=$label"; if "$@"; then echo "PASS=$label"; else echo "FAIL=$label"; FAIL=1; fi; }

printf '%s\n' "=== UORI CI GATE $STAMP ==="
echo 'POLICY=report-only; no commit; no merge; isolated worktree'
echo "WORKTREE=$ROOT"
echo "ORIGINAL=$ORIGINAL"

[ -d "$ROOT" ] || { echo 'STATUS=مرفوض: worktree مفقود'; exit 2; }
[ -f "$ORIGINAL" ] || { echo 'STATUS=مرفوض: الأصل مفقود'; exit 2; }

DISK_PCT="$(df -P "$ROOT" | awk 'NR==2 {gsub(/%/,"",$5); print $5}')"
echo "DISK_USED_PCT=$DISK_PCT"
if [ "$DISK_PCT" -ge "$MAX_DISK_PCT" ]; then fail "مساحة القرص تجاوزت الحد $MAX_DISK_PCT%"; fi

ORIGINAL_SHA="$(sha256sum "$ORIGINAL" | awk '{print $1}')"
WORK_SHA="$(sha256sum "$ROOT/lib/math_complete.py" | awk '{print $1}')"
echo "ORIGINAL_SHA=$ORIGINAL_SHA"
echo "WORK_SHA=$WORK_SHA"
echo "EXPECTED_ORIGINAL_SHA=$EXPECTED_ORIGINAL_SHA"
[ "$ORIGINAL_SHA" = "$EXPECTED_ORIGINAL_SHA" ] || fail 'الأصل تغيّر'

if command -v ssh-keygen >/dev/null 2>&1; then
  if [ -f "${UORI_KNOWN_HOSTS:-/home/uori-agent/.ssh/known_hosts}" ]; then
    echo 'HOST_KEY_POLICY=known_hosts-present; StrictHostKeyChecking=yes required for wrappers'
  else
    fail 'ملف known_hosts غير موجود'
  fi
fi

printf '%s\n' '--- ENVIRONMENT ---'
python3 --version || fail 'python3 missing'
nasm -v || fail 'nasm missing'
ld --version | head -n 1 || fail 'ld missing'
python3 -m py_compile "$ROOT/lib/math_complete.py" "$ROOT/test_c40_reproduction.py" "$ROOT/test_c40_q32_stress.py" || fail 'py_compile'

printf '%s\n' '--- HASH MANIFEST ---'
sha256sum "$ORIGINAL" "$ROOT/lib/math_complete.py" "$ROOT/test_c40_reproduction.py" "$ROOT/test_c40_q32_stress.py" | tee "$OUT/hashes.sha256"

auto_test(){
  local name="$1"; shift
  echo "RUN=$name"
  set +e
  "$@" > "$OUT/$name.log" 2>&1
  local rc=$?
  set -e
  cat "$OUT/$name.log"
  echo "RC_$name=$rc"
  [ "$rc" -eq 0 ] || FAIL=1
}

auto_test c40_reproduction python3 "$ROOT/test_c40_reproduction.py"
auto_test c40_q32_stress python3 "$ROOT/test_c40_q32_stress.py"

if git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git -C "$ROOT" diff --check > "$OUT/diff_check.log" 2>&1 || fail 'diff --check'
  git -C "$ROOT" status --short > "$OUT/status.short"
  git -C "$ROOT" diff -- "$ROOT/lib/math_complete.py" > "$OUT/math_complete.diff"
  echo 'GIT_METADATA=present'
else
  printf '%s\n' 'GIT_METADATA=absent; source-only worktree; Git diff checks skipped' | tee "$OUT/diff_check.log" "$OUT/status.short"
  : > "$OUT/math_complete.diff"
fi

if [ "$FAIL" -eq 0 ]; then STATUS='مقبول-للمراجعة-فقط'; else STATUS='مرفوض'; fi
echo "STATUS=$STATUS"
echo "REPORT=$OUT"
echo 'COMMIT=not-created'
echo 'MERGE=not-performed'
# Exit nonzero on any failed gate, so systemd/cron can alert without merging.
exit "$FAIL"
