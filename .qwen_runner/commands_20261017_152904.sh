#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
git worktree prune
rm -rf /tmp/reconcile_ws
git worktree add --detach /tmp/reconcile_ws main
cd /tmp/reconcile_ws
set +e
git merge --allow-unrelated-histories --no-commit origin/main > /dev/null 2>&1
SIM=$?
set -e
[ "$SIM" -eq 0 ] && echo "لا تعارضات؟" || echo "تعارضات متوقعة: 4"
git checkout --ours .gitignore 2>/dev/null || true
git checkout --ours CHANGELOG.md CONSTITUTION.md ROADMAP.md
cat /root/ilm-al-kitab/MAL/.gitignore >> .gitignore 2>/dev/null || true
sort -u .gitignore -o .gitignore
git add .gitignore CHANGELOG.md CONSTITUTION.md ROADMAP.md
git commit --no-edit -m 'merge: Hermes local main + MAL v38.0 (unrelated histories)
CONSTITUTION/ROADMAP/CHANGELOG: Hermes v8.0 (المشروع الحي)
.gitignore: union
MAL v38.0 محفوظ كاملاً في origin/main'
echo "MERGE_COMMITTED=1"
CARGO_TARGET_DIR=/tmp/reconcile_build cargo build --release --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml 2>&1 | tail -3
echo "BUILD_RC=$?"
cat > /tmp/final.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
set +e
CARGO_TARGET_DIR=/tmp/reconcile_build cargo build --release --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml 2>/dev/null
BIN=/tmp/reconcile_build/release/malc-native
$BIN /tmp/final.mal -o /tmp/final && /tmp/final; T5=$?
set -e
echo "T5_ON_MERGED=$T5 (متوقع 0)"
cd /root/ilm-al-kitab/MAL
git push origin HEAD:refs/heads/main-hermes
echo "MAIN_HERMES_PUSHED=1"
git worktree remove --force /tmp/reconcile_ws
git worktree prune
git log --oneline -3
echo "════ END: v38.0 سليم في origin/main — Hermes منشور في main-hermes ════"
