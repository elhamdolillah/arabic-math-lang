#!/usr/bin/env python3
"""Fail-closed SHA-256 monitor for the governed MAL unified corpus.

The monitor compares the exact bytes on disk with an immutable expected digest
supplied by the caller. It never rewrites the corpus or its expected digest.
"""
from __future__ import annotations

import argparse
import hashlib
import pathlib
import sys

EXPECTED_SHA256_LENGTH = 64


def sha256_file(path: pathlib.Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--corpus", type=pathlib.Path, required=True)
    parser.add_argument("--expected-sha256", required=True)
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    expected = args.expected_sha256.strip().lower()
    print(f"CORPUS_PATH={args.corpus.as_posix()}")
    print(f"EXPECTED_SHA256={expected}")

    if len(expected) != EXPECTED_SHA256_LENGTH or any(
        character not in "0123456789abcdef" for character in expected
    ):
        print("CHECKSUM_REFERENCE=INVALID")
        print("STATUS=1")
        return 1

    if not args.corpus.is_file():
        print("CORPUS_PRESENT=NO")
        print("CHECKSUM_MATCH=NO")
        print("STATUS=1")
        return 1

    actual = sha256_file(args.corpus)
    print("CORPUS_PRESENT=YES")
    print(f"ACTUAL_SHA256={actual}")
    matches = actual == expected
    print(f"CHECKSUM_MATCH={'YES' if matches else 'NO'}")
    print(f"STATUS={'0' if matches else '1'}")
    return 0 if matches else 1


if __name__ == "__main__":
    sys.exit(main())
