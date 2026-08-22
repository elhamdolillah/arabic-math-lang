"""تقرير اكتشاف اختبارات vnext دون تنفيذ مصادر خارجية."""
from pathlib import Path
import ast

ROOT = Path(__file__).resolve().parents[2]
TESTS = ROOT / "vnext" / "tests"

def inspect(path: Path) -> dict[str, object]:
    tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
    imports_unittest = any(
        isinstance(node, ast.Import) and any(alias.name == "unittest" for alias in node.names)
        or isinstance(node, ast.ImportFrom) and node.module == "unittest"
        for node in ast.walk(tree)
    )
    classes = [node.name for node in ast.walk(tree) if isinstance(node, ast.ClassDef)]
    functions = [node.name for node in ast.walk(tree) if isinstance(node, ast.FunctionDef) and node.name.startswith("test_")]
    return {"file": path.name, "unittest": imports_unittest, "classes": classes, "functions": functions}

def main() -> None:
    rows = [inspect(path) for path in sorted(TESTS.glob("test_*.py"))]
    print(f"TEST_FILES={len(rows)}")
    print(f"UNITTEST_FILES={sum(bool(row['unittest']) for row in rows)}")
    print(f"FUNCTION_STYLE_FILES={sum(bool(row['functions']) for row in rows)}")
    for row in rows:
        print(f"{row['file']}|unittest={row['unittest']}|functions={len(row['functions'])}")

if __name__ == "__main__":
    main()
