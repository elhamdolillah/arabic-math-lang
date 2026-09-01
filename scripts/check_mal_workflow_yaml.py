from pathlib import Path
import sys
try:
    import yaml
except Exception as exc:
    print(f"YAML_PARSER_UNAVAILABLE={type(exc).__name__}")
    raise SystemExit(2)
path = Path(__file__).resolve().parents[1] / ".github/workflows/mal-deterministic-audit.yml"
text = path.read_text(encoding="utf-8")
if text.count("retention-days: 7") < 5:
    print("RETENTION_POLICY=FAIL")
    raise SystemExit(1)
data = yaml.safe_load(text)
if not isinstance(data, dict) or "jobs" not in data:
    print("WORKFLOW_SCHEMA=FAIL")
    raise SystemExit(1)
print("WORKFLOW_YAML=PASS")
print(f"RETENTION_DECLARATIONS={text.count('retention-days: 7')}")
print("BASELINE_MUTATION=NOT_PERFORMED")
