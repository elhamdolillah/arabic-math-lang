"""سجل خوارزميات UORI المحلي الآمن.

هذا الملف لا يفسر source_ref ولا يستدعيه؛ إنه مرجع نصي فقط.
"""
from __future__ import annotations

import hashlib
import re
import sqlite3
from dataclasses import dataclass
from pathlib import Path

_KIND = re.compile(r"^[a-z][a-z0-9_.-]{0,63}$")
_VERSION = re.compile(r"^[0-9]+(?:\.[0-9]+){0,3}(?:[-+][A-Za-z0-9_.-]+)?$")


class RegistryError(ValueError):
    """خطأ في عقد السجل أو في هوية الخوارزمية."""


@dataclass(frozen=True)
class AlgorithmRecord:
    kind: str
    version: str
    namespace: str
    canonical: str
    source_ref: str
    classification: str
    fingerprint: str


def normalize(value: str) -> str:
    """تطبيع سطحي حتمي: إزالة التشكيل وتوحيد المسافات فقط."""
    if not isinstance(value, str):
        raise RegistryError("القيمة النصية مطلوبة")
    value = re.sub(r"[\u064B-\u065F\u0670]", "", value)
    return " ".join(value.split())


def build_identity(kind: str, version: str, namespace: str, canonical: str) -> str:
    kind, version, namespace, canonical = map(normalize, (kind, version, namespace, canonical))
    if not _KIND.fullmatch(kind):
        raise RegistryError("kind غير صالح")
    if not _VERSION.fullmatch(version):
        raise RegistryError("version غير صالح")
    if not namespace or not canonical:
        raise RegistryError("namespace وcanonical مطلوبان")
    return f"{kind}:{version}:{namespace}:{canonical}"


def fingerprint(identity: str, source_ref: str, classification: str) -> str:
    if not isinstance(source_ref, str) or not source_ref.strip():
        raise RegistryError("source_ref يجب أن يكون نصاً غير فارغ")
    if classification not in {"deterministic", "interval", "probabilistic"}:
        raise RegistryError("تصنيف غير مسموح")
    payload = "\x00".join((identity, source_ref, classification)).encode("utf-8")
    return hashlib.sha256(payload).hexdigest()


class UoriRegistry:
    def __init__(self, database: str | Path = ":memory:") -> None:
        self._connection = sqlite3.connect(str(database))
        self._connection.execute("PRAGMA foreign_keys=ON")
        self._connection.execute(
            """CREATE TABLE IF NOT EXISTS algorithms (
                identity TEXT PRIMARY KEY,
                kind TEXT NOT NULL,
                version TEXT NOT NULL,
                namespace TEXT NOT NULL,
                canonical TEXT NOT NULL,
                source_ref TEXT NOT NULL,
                classification TEXT NOT NULL,
                fingerprint TEXT NOT NULL UNIQUE
            )"""
        )
        self._connection.commit()

    def register(self, record: AlgorithmRecord) -> str:
        identity = build_identity(record.kind, record.version, record.namespace, record.canonical)
        expected = fingerprint(identity, record.source_ref, record.classification)
        if expected != record.fingerprint:
            raise RegistryError("بصمة السجل لا تطابق محتواه")
        self._connection.execute(
            "INSERT INTO algorithms VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            (identity, normalize(record.kind), normalize(record.version), normalize(record.namespace),
             normalize(record.canonical), record.source_ref, record.classification, record.fingerprint),
        )
        self._connection.commit()
        return identity

    def lookup(self, identity: str) -> AlgorithmRecord | None:
        row = self._connection.execute(
            "SELECT kind,version,namespace,canonical,source_ref,classification,fingerprint "
            "FROM algorithms WHERE identity=?", (identity,)
        ).fetchone()
        return AlgorithmRecord(*row) if row else None

    def close(self) -> None:
        self._connection.close()
