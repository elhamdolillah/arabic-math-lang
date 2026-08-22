"""نموذج UORI Kernel v0.1 المرجعي.

هذا الملف نموذج حتمي قابل للاختبار، وليس نواة bare-metal ولا منفذاً لمصادر خارجية.
المبدأ: الإدخال لا يتحول إلى تنفيذ مباشر؛ يمر عبر Intent ثم سجل خوارزميات ثم
خطة تنفيذ وبوابات السلامة والموارد، وبعدها يُنفذ تطبيق معروف ومضمّن فقط.
"""
from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
import hashlib
import json
import math
from pathlib import Path
from typing import Callable, Mapping

from arabic_backend import BackendSpecError, bind_trusted_backend
from arabic_plan import PlanSpecError, load_plan_spec
from arabic_registry import RegistrySpecError, load_arabic_specs


class KernelStatus(str, Enum):
    ACCEPTED = "ACCEPTED"
    REJECTED = "REJECTED"
    ABSTAIN = "ABSTAIN"


@dataclass(frozen=True)
class HardwareProfile:
    cpu: str
    memory_bytes: int
    display: bool
    input_device: str
    network: bool = False


@dataclass(frozen=True)
class Intent:
    operation: str
    arguments: tuple[int, ...]
    source: str

    def canonical(self) -> bytes:
        return json.dumps({"operation": self.operation, "arguments": self.arguments},
                          ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()


@dataclass(frozen=True)
class Evidence:
    algorithm_id: str
    version: int
    deterministic: bool
    termination_proven: bool
    resource_bound: int
    source_sha256: str


@dataclass(frozen=True)
class Algorithm:
    algorithm_id: str
    version: int
    operation: str
    deterministic: bool
    implementation: Callable[[tuple[int, ...]], int]
    evidence: Evidence


@dataclass(frozen=True)
class ExecutionPlan:
    algorithm: Algorithm
    intent: Intent
    cpu_budget: int
    memory_budget: int
    fuel_budget: int
    capability: str
    plan_sha256: str

    def canonical(self) -> bytes:
        return json.dumps({
            "algorithm_id": self.algorithm.algorithm_id,
            "version": self.algorithm.version,
            "intent": self.intent.canonical().decode("utf-8"),
            "cpu_budget": self.cpu_budget,
            "memory_budget": self.memory_budget,
            "fuel_budget": self.fuel_budget,
            "capability": self.capability,
        }, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")

    def is_intact(self) -> bool:
        return hashlib.sha256(self.canonical()).hexdigest() == self.plan_sha256


@dataclass(frozen=True)
class ExecutionResult:
    status: KernelStatus
    value: int | None
    message: str
    evidence_sha256: str | None


class KernelFault(Exception):
    pass


def _add(args: tuple[int, ...]) -> int:
    if len(args) != 2 or any(isinstance(value, bool) for value in args):
        raise KernelFault("مدخل الجمع يجب أن يكون عددين صحيحين")
    return args[0] + args[1]


def _subtract(args: tuple[int, ...]) -> int:
    if len(args) != 2 or any(isinstance(value, bool) for value in args):
        raise KernelFault("مدخل الطرح يجب أن يكون عددين صحيحين")
    return args[0] - args[1]


def _sqrt_144(args: tuple[int, ...]) -> int:
    if args != (144,):
        raise KernelFault("مدخل الجذر النموذجي يجب أن يكون (144,)")
    return 12


def _gcd(args: tuple[int, ...]) -> int:
    if len(args) != 2 or min(args) < 0:
        raise KernelFault("مدخل القاسم المشترك يجب أن يكون عددين غير سالبين")
    a, b = args
    fuel = 128
    while b:
        fuel -= 1
        if fuel < 0:
            raise KernelFault("تجاوز حارس الوقود")
        a, b = b, a % b
    return a


class AlgorithmRegistry:
    def __init__(self) -> None:
        self._items: dict[str, Algorithm] = {}

    def register(self, algorithm: Algorithm) -> None:
        if not algorithm.algorithm_id or not algorithm.evidence.deterministic:
            raise KernelFault("لا تُقبل خوارزمية غير حتمية في السجل المرجعي")
        if algorithm.evidence.algorithm_id != algorithm.algorithm_id:
            raise KernelFault("عدم تطابق هوية الدليل")
        self._items[algorithm.operation] = algorithm

    def find(self, operation: str) -> Algorithm | None:
        return self._items.get(operation)


class UoriKernel:
    def __init__(self, hardware: HardwareProfile) -> None:
        if hardware.memory_bytes <= 0:
            raise KernelFault("ملف العتاد غير صالح")
        self.hardware = hardware
        self.registry = AlgorithmRegistry()
        self.booted = False
        plan_path = Path(__file__).resolve().parents[1] / "source" / "execution_plan.ar"
        try:
            self.plan_spec = load_plan_spec(plan_path)
        except (OSError, PlanSpecError) as exc:
            raise KernelFault(f"تعذر اعتماد مواصفة خطة التنفيذ العربية: {exc}") from exc
        self._register_builtins()

    def _register_builtins(self) -> None:
        implementations: dict[str, Callable[[tuple[int, ...]], int]] = {
            "جمع": _add,
            "طرح": _subtract,
            "جذر": _sqrt_144,
            "قاسم_مشترك": _gcd,
        }
        source_path = Path(__file__).resolve().parents[1] / "source" / "algorithms.ar"
        try:
            specifications = load_arabic_specs(source_path)
        except (OSError, RegistrySpecError) as exc:
            raise KernelFault(f"تعذر اعتماد السجل العربي: {exc}") from exc
        try:
            bound = bind_trusted_backend(specifications, implementations)
        except BackendSpecError as exc:
            raise KernelFault(str(exc)) from exc
        for spec in specifications:
            implementation = bound[spec.operation]
            source = f"{spec.algorithm_id}:v{spec.version}:{spec.operation}:{spec.fuel}".encode()
            digest = hashlib.sha256(source).hexdigest()
            evidence = Evidence(spec.algorithm_id, spec.version, True, True, spec.fuel, digest)
            self.registry.register(Algorithm(
                spec.algorithm_id, spec.version, spec.operation, True, implementation, evidence
            ))

    def boot(self) -> dict[str, object]:
        # إقلاع منطقي فقط؛ لا يدّعي التعامل مع BIOS/UEFI أو العتاد الحقيقي.
        self.booted = True
        return {"status": KernelStatus.ACCEPTED.value, "stage": "logical_boot",
                "hardware": self.hardware}

    def parse_intent(self, source: str) -> Intent:
        normalized = " ".join(source.strip().split())
        if normalized == "احسب الجذر التربيعي لـ 144":
            return Intent("جذر", (144,), normalized)
        for prefix, operation in (("احسب جمع ", "جمع"), ("احسب طرح ", "طرح")):
            if normalized.startswith(prefix):
                parts = normalized.split()
                if len(parts) == 4 and parts[2].lstrip("-").isdigit() and parts[3].lstrip("-").isdigit():
                    return Intent(operation, (int(parts[2]), int(parts[3])), normalized)
        if normalized.startswith("احسب قاسم "):
            parts = normalized.split()
            if len(parts) == 4 and parts[2].isdigit() and parts[3].isdigit():
                return Intent("قاسم_مشترك", (int(parts[2]), int(parts[3])), normalized)
        raise KernelFault("الطلب خارج مجموعة النوايا المثبتة")

    def authorize(self, intent: Intent) -> ExecutionPlan:
        if not self.booted:
            raise KernelFault("النواة لم تُقلع منطقياً")
        algorithm = self.registry.find(intent.operation)
        if algorithm is None:
            raise KernelFault("لا توجد خوارزمية حتمية مسجلة")
        ev = algorithm.evidence
        if not (ev.deterministic and ev.termination_proven and ev.resource_bound > 0):
            raise KernelFault("دليل القبول ناقص")
        if self.hardware.memory_bytes < self.plan_spec.minimum_memory:
            raise KernelFault("ذاكرة غير كافية وفق عقد الخطة العربية")
        plan = ExecutionPlan(
            algorithm=algorithm,
            intent=intent,
            cpu_budget=ev.resource_bound,
            memory_budget=self.plan_spec.minimum_memory,
            fuel_budget=max(ev.resource_bound, self.plan_spec.minimum_fuel),
            capability=self.plan_spec.capability,
            plan_sha256="",
        )
        return ExecutionPlan(
            algorithm=plan.algorithm,
            intent=plan.intent,
            cpu_budget=plan.cpu_budget,
            memory_budget=plan.memory_budget,
            fuel_budget=plan.fuel_budget,
            capability=plan.capability,
            plan_sha256=hashlib.sha256(plan.canonical()).hexdigest(),
        )

    def execute(self, plan: ExecutionPlan) -> ExecutionResult:
        try:
            if not plan.is_intact():
                raise KernelFault("بصمة خطة التنفيذ غير مطابقة")
            if plan.capability != self.plan_spec.capability:
                raise KernelFault("قدرة التنفيذ غير مصرح بها")
            if plan.cpu_budget <= 0 or plan.memory_budget < self.plan_spec.minimum_memory or plan.fuel_budget < self.plan_spec.minimum_fuel:
                raise KernelFault("ميزانية خطة التنفيذ غير صالحة")
            value = plan.algorithm.implementation(plan.intent.arguments)
            if not isinstance(value, int) or isinstance(value, bool):
                raise KernelFault("نوع نتيجة غير مسموح")
            evidence = plan.algorithm.evidence
            evidence_hash = hashlib.sha256(json.dumps(evidence.__dict__, sort_keys=True).encode()).hexdigest()
            return ExecutionResult(KernelStatus.ACCEPTED, value, "تم التنفيذ الحتمي", evidence_hash)
        except (KernelFault, ValueError, ZeroDivisionError) as exc:
            return ExecutionResult(KernelStatus.REJECTED, None, str(exc), None)

    def handle(self, source: str) -> ExecutionResult:
        try:
            return self.execute(self.authorize(self.parse_intent(source)))
        except KernelFault as exc:
            return ExecutionResult(KernelStatus.ABSTAIN, None, str(exc), None)


if __name__ == "__main__":
    kernel = UoriKernel(HardwareProfile("reference-x86_64", 1024 * 1024, False, "test-input"))
    print(kernel.boot())
    print(kernel.handle("احسب الجذر التربيعي لـ 144"))
    print(kernel.handle("احسب قاسم 84 30"))
    print(kernel.handle("نفذ كوداً خارجياً"))
