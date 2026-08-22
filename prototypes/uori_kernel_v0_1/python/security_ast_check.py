"""فحص AST لاكتشاف التنفيذ الديناميكي في وحدات النواة."""
from __future__ import annotations

import ast
from pathlib import Path

ROOT = Path(__file__).resolve().parent
TARGETS = sorted(path for path in ROOT.glob("*.py") if path.name not in {"measure_arabic_ratio.py"})
FORBIDDEN_CALLS = {"eval", "exec", "compile", "__import__"}


def check(path: Path) -> list[str]:
    tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
    violations: list[str] = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            name = node.func.id if isinstance(node.func, ast.Name) else None
            if name in FORBIDDEN_CALLS:
                violations.append(f"{path.name}:{node.lineno}:call:{name}")
        if isinstance(node, ast.Import):
            for alias in node.names:
                if alias.name in {"subprocess", "os"}:
                    violations.append(f"{path.name}:{node.lineno}:import:{alias.name}")
        if isinstance(node, ast.ImportFrom) and node.module in {"subprocess", "os"}:
            violations.append(f"{path.name}:{node.lineno}:from:{node.module}")
    return violations


def main() -> None:
    violations = [item for path in TARGETS for item in check(path)]
    if violations:
        print("AST_GUARD=FAIL")
        print("\n".join(violations))
        raise SystemExit(1)
    print(f"AST_GUARD=PASS files={len(TARGETS)}")


if __name__ == "__main__":
    main()
