"""Prototype ساكن لـ Arena وOwnership في UORI/MAL.

هذا الملف لا ينفذ MAL ولا يملك raw pointers. كل مرجع هو Handle مفهرس
ومتحقق من arena وslot وgeneration والنوع والحالة.
"""
from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from typing import Dict, Generic, TypeVar

T = TypeVar("T")


class OwnershipError(ValueError):
    """خطأ حتمي في عقد الملكية أو العمر."""


class Ownership(str, Enum):
    OWNED = "owned"
    SHARED_BORROW = "shared_borrow"
    EXCLUSIVE_BORROW = "exclusive_borrow"
    MOVED = "moved"
    RELEASED = "released"


@dataclass(frozen=True)
class Handle:
    arena_id: int
    slot_id: int
    generation: int
    type_name: str


@dataclass
class Slot(Generic[T]):
    value: T
    type_name: str
    generation: int
    owner_scope: int
    state: Ownership = Ownership.OWNED
    shared_borrows: int = 0
    exclusive_borrow: bool = False


class Arena(Generic[T]):
    """Arena ذات slots متسلسلة؛ لا تعرض عنواناً أو مؤشراً."""

    def __init__(self, arena_id: int, owner_scope: int) -> None:
        if arena_id < 1 or owner_scope < 1:
            raise OwnershipError("ARENA_ID_OR_SCOPE_INVALID")
        self.arena_id = arena_id
        self.owner_scope = owner_scope
        self._next_slot = 1
        self._slots: Dict[int, Slot[T]] = {}

    def allocate(self, value: T, type_name: str) -> Handle:
        if not type_name or type_name.startswith("*") or " pointer" in type_name.lower():
            raise OwnershipError("RAW_POINTER_TYPE_FORBIDDEN")
        slot_id = self._next_slot
        self._next_slot += 1
        self._slots[slot_id] = Slot(
            value=value,
            type_name=type_name,
            generation=0,
            owner_scope=self.owner_scope,
        )
        return Handle(self.arena_id, slot_id, 0, type_name)

    def _get(self, handle: Handle, scope: int) -> Slot[T]:
        if handle.arena_id != self.arena_id:
            raise OwnershipError("ARENA_MISMATCH")
        slot = self._slots.get(handle.slot_id)
        if slot is None:
            raise OwnershipError("SLOT_NOT_FOUND")
        if slot.generation != handle.generation:
            raise OwnershipError("STALE_HANDLE_GENERATION")
        if slot.type_name != handle.type_name:
            raise OwnershipError("HANDLE_TYPE_MISMATCH")
        if slot.owner_scope != scope:
            raise OwnershipError("ARENA_LIFETIME_ESCAPE")
        if slot.state in (Ownership.MOVED, Ownership.RELEASED):
            raise OwnershipError("USE_AFTER_MOVE_OR_RELEASE")
        return slot

    def read(self, handle: Handle, scope: int) -> T:
        slot = self._get(handle, scope)
        return slot.value

    def borrow_shared(self, handle: Handle, scope: int) -> Handle:
        slot = self._get(handle, scope)
        if slot.exclusive_borrow:
            raise OwnershipError("SHARED_BORROW_DURING_EXCLUSIVE_BORROW")
        slot.shared_borrows += 1
        return Handle(handle.arena_id, handle.slot_id, handle.generation, handle.type_name)

    def borrow_exclusive(self, handle: Handle, scope: int) -> Handle:
        slot = self._get(handle, scope)
        if slot.shared_borrows or slot.exclusive_borrow:
            raise OwnershipError("MULTIPLE_ACTIVE_BORROWS")
        slot.exclusive_borrow = True
        return Handle(handle.arena_id, handle.slot_id, handle.generation, handle.type_name)

    def end_shared_borrow(self, handle: Handle, scope: int) -> None:
        slot = self._get(handle, scope)
        if slot.shared_borrows < 1:
            raise OwnershipError("SHARED_BORROW_NOT_ACTIVE")
        slot.shared_borrows -= 1

    def end_exclusive_borrow(self, handle: Handle, scope: int) -> None:
        slot = self._get(handle, scope)
        if not slot.exclusive_borrow:
            raise OwnershipError("EXCLUSIVE_BORROW_NOT_ACTIVE")
        slot.exclusive_borrow = False

    def move(self, handle: Handle, scope: int, target_scope: int) -> Handle:
        slot = self._get(handle, scope)
        if slot.shared_borrows or slot.exclusive_borrow:
            raise OwnershipError("MOVE_WHILE_BORROWED")
        slot.owner_scope = target_scope
        slot.state = Ownership.OWNED
        slot.generation += 1
        slot_handle = Handle(handle.arena_id, handle.slot_id, slot.generation, handle.type_name)
        return slot_handle

    def release(self, handle: Handle, scope: int) -> None:
        slot = self._get(handle, scope)
        if slot.shared_borrows or slot.exclusive_borrow:
            raise OwnershipError("RELEASE_WHILE_BORROWED")
        slot.state = Ownership.RELEASED
        slot.generation += 1


def static_source_guard(source: str) -> None:
    """حارس نصي أولي؛ ليس بديلاً عن parser/AST security pass."""
    forbidden = ("eval(", "exec(", "ctypes", "subprocess", "ffi", "unsafe")
    if any(token in source for token in forbidden):
        raise OwnershipError("UNTRUSTED_OR_DYNAMIC_CONSTRUCT")
    if "*" in source or "->" in source:
        raise OwnershipError("RAW_POINTER_SYNTAX_FORBIDDEN")


__all__ = ["Arena", "Handle", "Ownership", "OwnershipError", "static_source_guard"]
