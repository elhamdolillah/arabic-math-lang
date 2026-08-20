From Coq Require Import ZArith Lia.

Open Scope Z_scope.

(** وتر Q32.32: المدخلان هنا وحدات Q32، ولذلك فإن مجموع مربعاتهما
    يقع في وحدة مربعة والجذر يعيد وحدة Q32. هذا نموذج حدودي، وليس
    برهاناً لصحة تعليمات Assembly. *)
Definition hypot_q32 (x y : Z) : Z := Z.sqrt (x * x + y * y).

Lemma hypot_q32_nonnegative : forall x y : Z,
  0 <= x -> 0 <= y -> 0 <= hypot_q32 x y.
Proof.
  intros x y Hx Hy.
  unfold hypot_q32.
  apply Z.sqrt_nonneg.
Qed.

Lemma hypot_q32_bounds : forall x y : Z,
  0 <= x -> 0 <= y ->
  let h := hypot_q32 x y in
  h * h <= x * x + y * y < (h + 1) * (h + 1).
Proof.
  intros x y Hx Hy.
  unfold hypot_q32.
  assert (Hn : 0 <= x * x + y * y) by nia.
  pose proof (Z.sqrt_spec (x * x + y * y) Hn) as H.
  simpl in H.
  exact H.
Qed.

Lemma hypot_q32_symmetry : forall x y : Z,
  hypot_q32 x y = hypot_q32 y x.
Proof.
  intros x y.
  unfold hypot_q32.
  f_equal.
  ring.
Qed.

Print Assumptions hypot_q32_bounds.
Print Assumptions hypot_q32_nonnegative.
Print Assumptions hypot_q32_symmetry.
