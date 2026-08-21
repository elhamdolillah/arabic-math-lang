#!/usr/bin/env python3
"""عقد ABI حتمي لمسار UORI v9 الأول.

لا ينفذ هذا الملف نداءات عتادية، بل ينشئ وصفاً قابلاً للتحقق
للنقل بين المترجم والنواة. وكل سجل يحمل بصمة SHA-256.
"""
from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from typing import Any


ABI_VERSION = "uori-abi-v1"
EVIDENCE_MODE = "DETERMINISTIC"


class ABIError(ValueError):
    """خطأ في عقد ABI أو في الدليل المدخل."""


@dataclass(frozen=True)
class ABIOperation:
    opcode: str
    argument: str
    line: int


def _canonical(value: Any) -> bytes:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")


def sha256_hex(value: Any) -> str:
    return hashlib.sha256(_canonical(value)).hexdigest()


def lower_to_abi(ast: tuple[dict[str, object], ...]) -> dict[str, object]:
    """تحويل التمثيل المنخفض إلى حزمة ABI حتمية دون تنفيذ خارجي."""
    operations: list[dict[str, object]] = []
    for item in ast:
        if item.get("op") != "print":
            raise ABIError("امتناع: تعليمة غير مدعومة في ABI v1")
        value = item.get("value")
        line = item.get("line")
        if not isinstance(value, str) or not isinstance(line, int) or line < 1:
            raise ABIError("امتناع: وسيط طباعة غير صالح")
        operations.append({"opcode": "SYS_PRINT_UTF8", "argument": value, "line": line})
    body = {"abi_version": ABI_VERSION, "operations": operations}
    return {**body, "content_hash": sha256_hex(body), "evidence_mode": EVIDENCE_MODE}


def verify_abi(packet: dict[str, object]) -> None:
    """التحقق من الحزمة قبل تسليمها إلى طبقة التنفيذ."""
    required = {"abi_version", "operations", "content_hash", "evidence_mode"}
    missing = required - packet.keys()
    if missing:
        raise ABIError(f"امتناع: حقول ABI مفقودة: {sorted(missing)}")
    if packet["abi_version"] != ABI_VERSION:
        raise ABIError("امتناع: إصدار ABI غير مدعوم")
    if packet["evidence_mode"] != EVIDENCE_MODE:
        raise ABIError("امتناع: نمط الدليل غير حتمي")
    body = {"abi_version": packet["abi_version"], "operations": packet["operations"]}
    if packet["content_hash"] != sha256_hex(body):
        raise ABIError("امتناع: فشل تحقق بصمة ABI")
    operations = packet["operations"]
    if not isinstance(operations, list):
        raise ABIError("امتناع: operations ليست قائمة")
    for operation in operations:
        if not isinstance(operation, dict) or operation.get("opcode") != "SYS_PRINT_UTF8":
            raise ABIError("امتناع: opcode غير مسموح")
        if not isinstance(operation.get("argument"), str):
            raise ABIError("امتناع: argument ليس نصاً UTF-8")


def chain_step(previous_hash: str, packet: dict[str, object]) -> dict[str, str]:
    """إضافة خطوة إلى سلسلة الأدلة دون تغيير الحزمة الأصلية."""
    if len(previous_hash) != 64 or any(c not in "0123456789abcdef" for c in previous_hash):
        raise ABIError("امتناع: previous_hash ليس SHA-256 صالحاً")
    verify_abi(packet)
    record = {"previous_hash": previous_hash, "packet_hash": str(packet["content_hash"]), "abi_version": ABI_VERSION}
    return {**record, "chain_hash": sha256_hex(record)}
