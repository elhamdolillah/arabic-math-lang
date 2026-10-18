#!/usr/bin/env bash
set +e

PROJECT_DIR='/root/ilm-al-kitab'
COMMAND_FILE='/root/ilm-al-kitab/.qwen_runner/commands_20261017_191825.sh'
RESULT_FILE='/root/ilm-al-kitab/.qwen_runner/result_20261017_191825.log'

mkdir -p "$(dirname "$RESULT_FILE")"

{
  echo "========== QWEN RUN START =========="
  echo "project_dir: $PROJECT_DIR"
  echo "command_file: $COMMAND_FILE"
  echo "executed_at_utc: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "---------- COMMANDS ----------"
  cat "$COMMAND_FILE"
  echo "---------- OUTPUT ----------"

  cd "$PROJECT_DIR" || exit 90
  bash "$COMMAND_FILE"
  CODE=$?

  echo "---------- EXIT CODE ----------"
  echo "$CODE"
  echo "=========== QWEN RUN END ==========="
  exit "$CODE"
} > "$RESULT_FILE" 2>&1

exit "$CODE"
