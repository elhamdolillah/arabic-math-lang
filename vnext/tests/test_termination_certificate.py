from vnext.tools.termination_certificate import verify_certificate


def main():
    natural = verify_certificate({
        "kind": "natural",
        "transitions": [{"old": 3, "new": 2}, {"old": 2, "new": 0}],
    })
    assert natural.accepted and len(natural.fingerprint) == 64
    lex = verify_certificate({
        "kind": "lexicographic",
        "transitions": [{"old": [2, 0], "new": [1, 9]}, {"old": [1, 2], "new": [1, 1]}],
    })
    assert lex.accepted
    bad = verify_certificate({
        "kind": "natural",
        "transitions": [{"old": 1, "new": 1}],
    })
    assert not bad.accepted and bad.reason == "ranking_not_decreasing"
    print('VNEXT_RANKING_NATURAL=PASS')
    print('VNEXT_RANKING_LEXICOGRAPHIC=PASS')
    print('VNEXT_RANKING_NONDECREASE_REJECTION=PASS')
    print('VNEXT_RANKING_FINGERPRINT=PASS')


if __name__ == '__main__':
    main()
