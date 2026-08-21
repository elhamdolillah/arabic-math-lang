From Coq Require Import ZArith Lia.
Require Import UORI.Q32_Core.
Open Scope Z_scope.

(** ربط دلالي مجرد لـوتر Q32.32.
    يثبت أن النموذج يعيد الجذر الصحيح لمجموع مربعات المدخلين.
    لا يدعي هذا الملف وحده تطابق تعليمات NASM الفعلية. *)
Definition q32_hypot_model (x y : Z) : Z :=
  Z.sqrt (q32_square_sum x y).

Definition q32_hypot_contract (x y r : Z) : Prop :=
  0 <= r /\
  r * r <= q32_square_sum x y /\
  q32_square_sum x y < (r + 1) * (r + 1).

Lemma q32_hypot_nonnegative : forall x y : Z,
  0 <= q32_hypot_model x y.
Proof.
  intros x y.
  unfold q32_hypot_model.
  apply Z.sqrt_nonneg.
Qed.

Lemma q32_hypot_contract_holds : forall x y : Z,
  q32_hypot_contract x y (q32_hypot_model x y).
Proof.
  intros x y.
  unfold q32_hypot_contract, q32_hypot_model.
  pose proof (q32_square_sum_nonnegative x y) as Hn.
  split.
  - apply Z.sqrt_nonneg.
  - pose proof (Z.sqrt_spec (q32_square_sum x y) Hn) as H.
    simpl in H.
    destruct H as [Hlow Hhigh].
    split; [exact Hlow |].
    assert (Hhigh' : q32_square_sum x y <
      (Z.sqrt (q32_square_sum x y) + 1) *
      (Z.sqrt (q32_square_sum x y) + 1)) by nia.
    exact Hhigh'.
Qed.

Lemma q32_hypot_contract_unique : forall x y r s : Z,
  q32_hypot_contract x y r ->
  q32_hypot_contract x y s ->
  r = s.
Proof.
  intros x y r s Hr Hs.
  destruct Hr as [Hr0 [Hrr Hrn]].
  destruct Hs as [Hs0 [Hss Hsn]].
  assert (Hrs : r <= s).
  { destruct (Z_le_gt_dec r s) as [H|H].
    - exact H.
    - exfalso.
      assert (Hsq : (s + 1) * (s + 1) <= r * r) by nia.
      nia. }
  assert (Hsr : s <= r).
  { destruct (Z_le_gt_dec s r) as [H|H].
    - exact H.
    - exfalso.
      assert (Hsq : (r + 1) * (r + 1) <= s * s) by nia.
      nia. }
  lia.
Qed.

Lemma q32_hypot_symmetric : forall x y : Z,
  q32_hypot_model x y = q32_hypot_model y x.
Proof.
  intros x y.
  unfold q32_hypot_model, q32_square_sum.
  f_equal.
  ring.
Qed.

Print Assumptions q32_hypot_contract_holds.
Print Assumptions q32_hypot_contract_unique.
Print Assumptions q32_hypot_symmetric.
