from pathlib import Path

from vnext.tools.formal_assumption_audit import audit


def test_formal_assumptions_are_reported():
    result = audit(Path("formal"))
    assert result["finding_count"] >= 1
    assert result["full_proof"] is False
    assert "axiom" in result["kinds"]
    assert "parameter" in result["kinds"]


def test_empty_formal_root_is_full_proof_candidate(tmp_path):
    result = audit(tmp_path)
    assert result["finding_count"] == 0
    assert result["full_proof"] is True
