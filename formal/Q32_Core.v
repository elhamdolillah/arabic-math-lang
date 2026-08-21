From Coq Require Import ZArith Lia.
Open Scope Z_scope.

(** نواة Q32.32 المشتركة.
    القيمة الصحيحة تمثل العدد الحقيقي v / 2^32.
    هذه الوحدة تثبت عقوداً عددية مجردة، ولا تدعي وحدها دلالة تعليمات المعالج. *)
Definition q32_frac_bits : Z := 32.
Definition q32_scale : Z := 4294967296.
Definition q32_max : Z := 9223372036854775807.
Definition q32_min : Z := -9223372036854775808.

Lemma q32_scale_positive : 0 < q32_scale.
Proof. unfold q32_scale; lia. Qed.

Lemma q32_bounds_ordered : q32_min < 0 /\ 0 < q32_max.
Proof. unfold q32_min, q32_max; lia. Qed.

Definition q32_in_range (x : Z) : Prop :=
  q32_min <= x /\ x <= q32_max.

Lemma q32_zero_in_range : q32_in_range 0.
Proof. unfold q32_in_range, q32_min, q32_max; lia. Qed.

Definition q32_abs (x : Z) : Z := Z.abs x.

Lemma q32_abs_nonnegative : forall x : Z, 0 <= q32_abs x.
Proof.
  intros x.
  unfold q32_abs.
  apply Z.abs_nonneg.
Qed.

Lemma q32_abs_spec : forall x : Z,
  q32_abs x = x \/ q32_abs x = -x.
Proof.
  intros x.
  unfold q32_abs.
  destruct (Z_le_gt_dec 0 x); [left; apply Z.abs_eq; lia | right; apply Z.abs_neq; lia].
Qed.

Definition q32_square_sum (x y : Z) : Z := x * x + y * y.

Lemma q32_square_sum_nonnegative : forall x y : Z,
  0 <= q32_square_sum x y.
Proof.
  intros x y.
  unfold q32_square_sum.
  nia.
Qed.

Print Assumptions q32_abs_nonnegative.
Print Assumptions q32_square_sum_nonnegative.
