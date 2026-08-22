#!/usr/bin/env python3
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1] / "tools"))
from uori_lookup import AlgorithmRecord, RegistryError, UoriRegistry, build_identity, fingerprint


def main() -> None:
    identity = build_identity("kernel", "1.0", "uori", "جمع")
    source_ref = "repo://example/algorithm#جمع"
    fp = fingerprint(identity, source_ref, "deterministic")
    registry = UoriRegistry()
    record = AlgorithmRecord("kernel", "1.0", "uori", "جمع", source_ref, "deterministic", fp)
    assert registry.register(record) == identity
    found = registry.lookup(identity)
    assert found == record
    assert found.source_ref == source_ref
    assert "eval" not in found.source_ref

    try:
        registry.register(AlgorithmRecord("kernel", "1.0", "uori", "جمع", source_ref, "probabilistic", fp))
    except RegistryError:
        pass
    else:
        raise AssertionError("قُبل تصنيف ببصمة غير مطابقة")

    try:
        fingerprint(identity, "", "deterministic")
    except RegistryError:
        pass
    else:
        raise AssertionError("قُبل source_ref فارغ")
    registry.close()
    print("VNEXT_UORI_LOOKUP_IDENTITY=PASS")
    print("VNEXT_UORI_LOOKUP_ROUNDTRIP=PASS")
    print("VNEXT_UORI_LOOKUP_SOURCE_REF_NONEXECUTABLE=PASS")
    print("VNEXT_UORI_LOOKUP_REJECTION=PASS")


if __name__ == "__main__":
    main()
