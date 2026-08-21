From Coq Require Import ZArith Lia.
Require Import UORI.Q32_Core.
Open Scope Z_scope.

(** زوج عقدي Q32.32.
    كل مركبة مخزنة كعدد صحيح مقيّس بـ 2^32.
    هذه الوحدة تثبت النموذج الجبري والإشارات، ولا تدعي بعدُ
    تطابق تنفيذ Assembly الفعلي. *)
Record q32_complex := {
  qc_real : Z;
  qc_imag : Z
}.

Definition qc_zero : q32_complex := {| qc_real := 0; qc_imag := 0 |}.
Definition qc_add (z w : q32_complex) : q32_complex :=
  {| qc_real := qc_real z + qc_real w;
     qc_imag := qc_imag z + qc_imag w |}.
Definition qc_sub (z w : q32_complex) : q32_complex :=
  {| qc_real := qc_real z - qc_real w;
     qc_imag := qc_imag z - qc_imag w |}.
Definition qc_conj (z : q32_complex) : q32_complex :=
  {| qc_real := qc_real z; qc_imag := - qc_imag z |}.
Definition qc_mul_raw (z w : q32_complex) : q32_complex :=
  {| qc_real := qc_real z * qc_real w - qc_imag z * qc_imag w;
     qc_imag := qc_real z * qc_imag w + qc_imag z * qc_real w |}.
Definition qc_mul (z w : q32_complex) : q32_complex :=
  {| qc_real := (qc_real z * qc_real w - qc_imag z * qc_imag w) / q32_scale;
     qc_imag := (qc_real z * qc_imag w + qc_imag z * qc_real w) / q32_scale |}.
Definition qc_norm2_raw (z : q32_complex) : Z :=
  qc_real z * qc_real z + qc_imag z * qc_imag z.

Lemma qc_ext : forall z w,
  qc_real z = qc_real w -> qc_imag z = qc_imag w -> z = w.
Proof.
  intros [a b] [c d] Hr Hi. simpl in *. subst. reflexivity.
Qed.

Lemma qc_add_real : forall z w,
  qc_real (qc_add z w) = qc_real z + qc_real w.
Proof. reflexivity. Qed.

Lemma qc_add_imag : forall z w,
  qc_imag (qc_add z w) = qc_imag z + qc_imag w.
Proof. reflexivity. Qed.

Lemma qc_sub_real : forall z w,
  qc_real (qc_sub z w) = qc_real z - qc_real w.
Proof. reflexivity. Qed.

Lemma qc_sub_imag : forall z w,
  qc_imag (qc_sub z w) = qc_imag z - qc_imag w.
Proof. reflexivity. Qed.

Lemma qc_conj_involutive : forall z,
  qc_conj (qc_conj z) = z.
Proof.
  intros z. apply qc_ext; cbn; [reflexivity | lia].
Qed.

Lemma qc_mul_raw_real : forall z w,
  qc_real (qc_mul_raw z w) = qc_real z * qc_real w - qc_imag z * qc_imag w.
Proof. reflexivity. Qed.

Lemma qc_mul_raw_imag : forall z w,
  qc_imag (qc_mul_raw z w) = qc_real z * qc_imag w + qc_imag z * qc_real w.
Proof. reflexivity. Qed.

Lemma qc_mul_real_formula : forall z w,
  qc_real (qc_mul z w) =
    (qc_real z * qc_real w - qc_imag z * qc_imag w) / q32_scale.
Proof. reflexivity. Qed.

Lemma qc_mul_imag_formula : forall z w,
  qc_imag (qc_mul z w) =
    (qc_real z * qc_imag w + qc_imag z * qc_real w) / q32_scale.
Proof. reflexivity. Qed.

Lemma qc_norm2_nonnegative : forall z,
  0 <= qc_norm2_raw z.
Proof.
  intros z. destruct z as [a b]. simpl.
  assert (Ha : 0 <= a * a) by apply Z.square_nonneg.
  assert (Hb : 0 <= b * b) by apply Z.square_nonneg.
  apply Z.add_nonneg_nonneg; assumption.
Qed.

Lemma qc_conj_real : forall z,
  qc_real (qc_conj z) = qc_real z.
Proof. reflexivity. Qed.

Lemma qc_conj_imag : forall z,
  qc_imag (qc_conj z) = - qc_imag z.
Proof. reflexivity. Qed.

Lemma qc_mul_raw_conjugate_compat : forall z w,
  qc_mul_raw (qc_conj z) (qc_conj w) = qc_conj (qc_mul_raw z w).
Proof.
  intros z w. destruct z as [a b]. destruct w as [c d].
  apply qc_ext; simpl; ring.
Qed.

Print Assumptions qc_conj_involutive.
Print Assumptions qc_norm2_nonnegative.
Print Assumptions qc_mul_raw_conjugate_compat.
