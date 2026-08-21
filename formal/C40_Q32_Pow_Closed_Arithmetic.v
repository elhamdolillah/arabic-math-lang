From Coq Require Import ZArith Lia.
Require Import UORI.C40_Q32_Pow_Semantic_Link.
Require Import UORI.C40_Q32_Pow_Instruction_Semantics.
Open Scope Z_scope.

(** طبقة حسابية مغلقة لمسار pow.
    تثبت هذه الوحدة معنى حاصل الضرب ذي الوسيط الصحيح وإسقاط Q32.32
    وحدود الباقي. وهي لا تدعي أن ترميز NASM أو مسار السجلات قد رُبط
    بها بعد؛ ذلك يتطلب نموذجاً منفصلاً للمعالج. *)
Definition q32_mul_intermediate (x y : Z) : Z := x * y.
Definition q32_mul_result (x y : Z) : Z :=
  q32_project (q32_mul_intermediate x y).
Definition q32_mul_residual (x y : Z) : Z :=
  q32_remainder (q32_mul_intermediate x y).

Lemma q32_mul_decomposition : forall x y : Z,
  q32_mul_intermediate x y =
    q32_scale * q32_mul_result x y + q32_mul_residual x y.
Proof.
  intros x y.
  unfold q32_mul_intermediate, q32_mul_result, q32_mul_residual.
  apply q32_projection_decomposition.
Qed.

Lemma q32_mul_residual_nonnegative : forall x y : Z,
  0 <= q32_mul_residual x y.
Proof.
  intros x y.
  unfold q32_mul_residual.
  apply q32_remainder_nonnegative.
Qed.

Lemma q32_mul_residual_bounded : forall x y : Z,
  q32_mul_residual x y < q32_scale.
Proof.
  intros x y.
  unfold q32_mul_residual.
  apply q32_remainder_below_scale.
Qed.

Lemma q32_mul_result_exact_if_divisible : forall x y r : Z,
  q32_mul_intermediate x y = q32_scale * r ->
  q32_mul_result x y = r.
Proof.
  intros x y r H.
  unfold q32_mul_result, q32_mul_intermediate.
  apply q32_projection_exact_when_divisible.
  exact H.
Qed.

Definition q32_closed_result_step (x y r : Z) : Prop :=
  r = q32_mul_result x y.

Lemma q32_closed_result_step_deterministic : forall x y r s : Z,
  q32_closed_result_step x y r ->
  q32_closed_result_step x y s ->
  r = s.
Proof.
  intros x y r s Hr Hs.
  unfold q32_closed_result_step in *.
  congruence.
Qed.

Definition q32_closed_square_step (x factor : Z) (next : Z) : Prop :=
  next = q32_mul_result factor factor.

Lemma q32_closed_square_step_deterministic : forall x factor r s : Z,
  q32_closed_square_step x factor r ->
  q32_closed_square_step x factor s ->
  r = s.
Proof.
  intros x factor r s Hr Hs.
  unfold q32_closed_square_step in *.
  congruence.
Qed.

Print Assumptions q32_mul_decomposition.
Print Assumptions q32_mul_result_exact_if_divisible.
Print Assumptions q32_closed_result_step_deterministic.
