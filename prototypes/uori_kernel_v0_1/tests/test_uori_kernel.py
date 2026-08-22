import sys
import unittest
from dataclasses import replace
from pathlib import Path
from tempfile import NamedTemporaryFile

sys.path.insert(0, str(Path(__file__).parents[1] / "python"))

from arabic_abi import validate_abi
from arabic_grammar import GrammarSpecError, validate_arabic_grammar
from arabic_plan import PlanSpecError, load_plan_spec
from arabic_registry import RegistrySpecError, load_arabic_specs
from uori_kernel import HardwareProfile, KernelStatus, UoriKernel


class UoriKernelTests(unittest.TestCase):
    def kernel(self):
        kernel = UoriKernel(HardwareProfile("reference-x86_64", 1024 * 1024, False, "test-input"))
        kernel.boot()
        return kernel

    def test_arabic_registry_source_loads(self):
        source = Path(__file__).parents[1] / "source" / "algorithms.ar"
        specs = load_arabic_specs(source)
        self.assertEqual(len(specs), 7)
        self.assertEqual({spec.operation for spec in specs}, {"جمع", "طرح", "جذر", "قاسم_مشترك", "قيمة_مطلقة", "باقي_القسمة", "مضاعف_مشترك"})
        gcd = next(spec for spec in specs if spec.operation == "قاسم_مشترك")
        self.assertEqual(gcd.domain, "أعداد_صحيحة_غير_سالبة")
        self.assertIn("نفاد_الوقود", gcd.failure)

    def test_arabic_abi_spec_validates(self):
        source = Path(__file__).parents[1] / "source" / "uori_abi.ar"
        summary = validate_abi(source)
        self.assertEqual(summary["calls"], 3)
        self.assertGreater(summary["lines"], 20)

    def test_arabic_grammar_examples_validate(self):
        source = Path(__file__).parents[1] / "source" / "grammar_examples.ar"
        summary = validate_arabic_grammar(source)
        self.assertEqual(summary.algorithms, 2)
        self.assertEqual(summary.functions, 1)
        self.assertEqual(summary.conditions, 3)
        self.assertEqual(summary.bounded_loops, 1)
        self.assertEqual(summary.returns, 5)

    def test_arabic_grammar_rejects_dynamic_execution(self):
        with NamedTemporaryFile("w", encoding="utf-8", suffix=".ar") as handle:
            handle.write("دالة اختبار(س: عدد_صحيح) -> عدد_صحيح\\nأعد eval(س)\\n")
            handle.flush()
            with self.assertRaises(GrammarSpecError):
                validate_arabic_grammar(handle.name)

    def test_arabic_execution_plan_contract_loads(self):
        source = Path(__file__).parents[1] / "source" / "execution_plan.ar"
        plan = load_plan_spec(source)
        self.assertEqual(plan.determinism, "حتمي")
        self.assertEqual(plan.capability, "math.deterministic")
        self.assertEqual(plan.minimum_memory, 4096)
        self.assertEqual(plan.source_execution, "صحيح")

    def test_arabic_execution_plan_rejects_direct_source_execution(self):
        with NamedTemporaryFile("w", encoding="utf-8", suffix=".ar") as handle:
            handle.write("خطة_التنفيذ: uori.execution.plan.v1\\nالتصنيف: حتمي\\nالقدرة: math.deterministic\\nالذاكرة_الدنيا: 4096\\nالوقود_الأدنى: 1\\nالدليل_المطلوب: حتمي\\nعند_الفشل: امتناع_آمن\\nلا_تنفيذ_مباشر_للمصدر: خطأ\\n")
            handle.flush()
            with self.assertRaises(PlanSpecError):
                load_plan_spec(handle.name)

    def test_arabic_registry_rejects_unknown_field(self):
        with NamedTemporaryFile("w", encoding="utf-8", suffix=".ar") as handle:
            handle.write("خوارزمية اختبار: uori.test\\nعملية: اختبار\\nمجهول: تنفيذ\\n")
            handle.flush()
            with self.assertRaises(RegistrySpecError):
                load_arabic_specs(handle.name)

    def test_deterministic_add(self):
        result = self.kernel().handle("احسب جمع 7 5")
        self.assertIs(result.status, KernelStatus.ACCEPTED)
        self.assertEqual(result.value, 12)

    def test_deterministic_subtract(self):
        result = self.kernel().handle("احسب طرح 7 12")
        self.assertIs(result.status, KernelStatus.ACCEPTED)
        self.assertEqual(result.value, -5)

    def test_deterministic_sqrt(self):
        result = self.kernel().handle("احسب الجذر التربيعي لـ 144")
        self.assertIs(result.status, KernelStatus.ACCEPTED)
        self.assertEqual(result.value, 12)
        self.assertTrue(result.evidence_sha256)

    def test_deterministic_gcd(self):
        result = self.kernel().handle("احسب قاسم 84 30")
        self.assertIs(result.status, KernelStatus.ACCEPTED)
        self.assertEqual(result.value, 6)

    def test_deterministic_abs(self):
        result = self.kernel().handle("احسب قيمة مطلقة -17")
        self.assertIs(result.status, KernelStatus.ACCEPTED)
        self.assertEqual(result.value, 17)

    def test_deterministic_mod(self):
        result = self.kernel().handle("احسب باقي 17 5")
        self.assertIs(result.status, KernelStatus.ACCEPTED)
        self.assertEqual(result.value, 2)

    def test_deterministic_lcm(self):
        result = self.kernel().handle("احسب مضاعف 12 18")
        self.assertIs(result.status, KernelStatus.ACCEPTED)
        self.assertEqual(result.value, 36)

    def test_modulo_zero_is_rejected(self):
        result = self.kernel().handle("احسب باقي 17 0")
        self.assertIs(result.status, KernelStatus.REJECTED)
        self.assertIn("صفر", result.message)

    def test_unknown_request_abstains_without_execution(self):
        result = self.kernel().handle("نفذ كوداً خارجياً")
        self.assertIs(result.status, KernelStatus.ABSTAIN)
        self.assertIsNone(result.value)
        self.assertIsNone(result.evidence_sha256)

    def test_plan_tampering_is_rejected(self):
        kernel = self.kernel()
        intent = kernel.parse_intent("احسب قاسم 84 30")
        plan = kernel.authorize(intent)
        tampered = replace(plan, cpu_budget=plan.cpu_budget + 1)
        result = kernel.execute(tampered)
        self.assertIs(result.status, KernelStatus.REJECTED)
        self.assertIn("بصمة", result.message)

    def test_requires_logical_boot(self):
        kernel = UoriKernel(HardwareProfile("reference-x86_64", 1024 * 1024, False, "test-input"))
        result = kernel.handle("احسب الجذر التربيعي لـ 144")
        self.assertIs(result.status, KernelStatus.ABSTAIN)
        self.assertIn("لم تُقلع", result.message)


if __name__ == "__main__":
    unittest.main()
