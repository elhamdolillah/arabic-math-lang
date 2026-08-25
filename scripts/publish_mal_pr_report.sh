#!/usr/bin/env bash
set -euo pipefail

: "${GH_TOKEN:?GH_TOKEN is required}"
: "${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is required}"
: "${PR_NUMBER:?PR_NUMBER is required}"
REPORT_PATH="${1:?usage: publish_mal_pr_report.sh REPORT_PATH}"

MARKER='<!-- mal-cross-env-sha256-report -->'
if [[ ! -f "$REPORT_PATH" ]]; then
  printf 'PR_REPORT=ABSTAIN\nREASON=MISSING_REPORT\n' >&2
  exit 2
fi

body="$(cat "$REPORT_PATH")"
comment_body="$MARKER
${body}"

comments_json="$(gh api --paginate "repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments?per_page=100")"
comment_id="$(COMMENTS_JSON="$comments_json" python3 -c '
import json, os
items = json.loads(os.environ["COMMENTS_JSON"])
for item in items:
    if "<!-- mal-cross-env-sha256-report -->" in item.get("body", ""):
        print(item["id"])
        break
')"

payload="$(COMMENT_BODY="$comment_body" python3 -c '
import json, os
print(json.dumps({"body": os.environ["COMMENT_BODY"]}, ensure_ascii=False))
')"

if [[ -n "$comment_id" ]]; then
  gh api --method PATCH \
    -H 'Accept: application/vnd.github+json' \
    "repos/${GITHUB_REPOSITORY}/issues/comments/${comment_id}" \
    --input - <<<"$payload" >/dev/null
  printf 'PR_REPORT=UPDATED\nCOMMENT_ID=%s\n' "$comment_id"
else
  response="$(gh api --method POST \
    -H 'Accept: application/vnd.github+json' \
    "repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments" \
    --input - <<<"$payload")"
  new_id="$(RESPONSE="$response" python3 -c 'import json, os; print(json.loads(os.environ["RESPONSE"])["id"])')"
  printf 'PR_REPORT=CREATED\nCOMMENT_ID=%s\n' "$new_id"
fi
