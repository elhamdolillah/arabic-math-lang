From Coq Require Import ZArith Lia.

Open Scope Z_scope.

(** ربط دلالي أولي لجذر Q32.32.
    هذا الملف يثبت عقد الجذر الصحيح المجرد، ولا يدعي بعد دلالة WASM أو NASM. *)

Definition q32_scale : Z := 4294967296.
Definition sqrt_input (x : Z) : Z := x * q32_scale.
Definition sqrt_model (x : Z) : Z := Z.sqrt (sqrt_input x).

Lemma q32_scale_positive : 0 < q32_scale.
Proof. unfold q32_scale; lia. Qed.

Lemma sqrt_input_nonnegative : forall x : Z,
  0 <= x -> 0 <= sqrt_input x.
Proof.
  intros x Hx.
  unfold sqrt_input, q32_scale.
  nia.
Qed.

Lemma sqrt_model_nonnegative : forall x : Z,
  0 <= x -> 0 <= sqrt_model x.
Proof.
  intros x Hx.
  unfold sqrt_model.
  apply Z.sqrt_nonneg.
Qed.

Lemma sqrt_model_bounds : forall x : Z,
  0 <= x ->
  let r := sqrt_model x in
  r * r <= sqrt_input x < (r + 1) * (r + 1).
Proof.
  intros x Hx.
  unfold sqrt_model.
  pose proof (sqrt_input_nonnegative x Hx) as Hn.
  pose proof (Z.sqrt_spec (sqrt_input x) Hn) as H.
  simpl in H.
  exact H.
Qed.

(** خطوة مجردة: نتيجة أي انتقال ناجح هي جذر صحيح يحقق عقد المجال. *)
Definition sqrt_step_ok (n r : Z) : Prop :=
  0 <= r /\ r * r <= n /\ n < (r + 1) * (r + 1).

Lemma sqrt_step_ok_unique : forall n r s : Z,
  sqrt_step_ok n r -> sqrt_step_ok n s -> r = s.
Proof.
  intros n r s Hr Hs.
  destruct Hr as [Hr0 [Hrr Hrn]].
  destruct Hs as [Hs0 [Hss Hsn]].
  assert (Hrs : r <= s).
  { destruct (Z_le_gt_dec r s) as [H|H]; auto.
    exfalso.
    assert (Hsq : (s + 1) * (s + 1) <= r * r).
    { nia. }
    nia.
  }
  assert (Hsr : s <= r).
  { destruct (Z_le_gt_dec s r) as [H|H]; auto.
    exfalso.
    assert (Hsq : (r + 1) * (r + 1) <= s * s).
    { nia. }
    nia.
  }
  lia.
Qed.

(** واجهة انتقال منخفض المستوى: تبقى فرضية حتى تُربط دلالة التعليمات رسمياً. *)
Parameter low_level_sqrt_step : Z -> Z -> Prop.

Axiom low_level_sqrt_step_refines_model : forall n r : Z,
  low_level_sqrt_step n r -> sqrt_step_ok n r.

Print Assumptions sqrt_model_bounds.
Print Assumptions sqrt_step_ok_unique.
Print Assumptions low_level_sqrt_step_refines_model.
