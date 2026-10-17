"""اختبار ساكن وقابل لإعادة الإنتاج لـ mal_ownership_arena."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from extensions.mal_ownership_arena import Arena, OwnershipError, static_source_guard


def expect_error(code: str, action) -> None:
    try:
        action()
    except OwnershipError as exc:
        if str(exc) != code:
            raise AssertionError(f"expected {code}, got {exc}")
    else:
        raise AssertionError(f"expected {code}")


def main() -> int:
    static_source_guard("برنامج سليم")
    expect_error("RAW_POINTER_SYNTAX_FORBIDDEN", lambda: static_source_guard("x -> y"))
    expect_error("UNTRUSTED_OR_DYNAMIC_CONSTRUCT", lambda: static_source_guard("eval(x)"))

    arena = Arena[int](arena_id=1, owner_scope=10)
    owned = arena.allocate(42, "عدد صحيح")
    assert arena.read(owned, 10) == 42

    shared = arena.borrow_shared(owned, 10)
    assert arena.read(shared, 10) == 42
    expect_error("MULTIPLE_ACTIVE_BORROWS", lambda: arena.borrow_exclusive(owned, 10))
    arena.end_shared_borrow(shared, 10)

    exclusive = arena.borrow_exclusive(owned, 10)
    expect_error("MOVE_WHILE_BORROWED", lambda: arena.move(owned, 10, 20))
    arena.end_exclusive_borrow(exclusive, 10)

    moved = arena.move(owned, 10, 20)
    expect_error("STALE_HANDLE_GENERATION", lambda: arena.read(owned, 10))
    assert arena.read(moved, 20) == 42
    expect_error("ARENA_LIFETIME_ESCAPE", lambda: arena.read(moved, 10))
    arena.release(moved, 20)
    expect_error("STALE_HANDLE_GENERATION", lambda: arena.read(moved, 20))

    expect_error("RAW_POINTER_TYPE_FORBIDDEN", lambda: arena.allocate(1, "*عدد"))
    print("MAL_OWNERSHIP_ARENA=PASS")
    print("RAW_POINTERS=FORBIDDEN")
    print("CASES=10")
    print("EXECUTION=NOT_PERFORMED")
    print("NETWORK=DISABLED_BY_CONTRACT")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
