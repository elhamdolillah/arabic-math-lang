From Coq Require Import ZArith Lia.

Open Scope Z_scope.

(** جذر Q32.32 المنفذ عبر جذر صحيح للقيمة الموسعة 2^32.
    هذا نموذج حدودي، وليس بعد برهاناً لتعليمات Assembly. *)
Definition q32_scale : Z := 4294967296.
Definition sqrt_q32 (x : Z) : Z := Z.sqrt (x * q32_scale).

Lemma q32_scale_pos : 0 < q32_scale.
Proof. unfold q32_scale; lia. Qed.

Lemma sqrt_q32_bounds : forall x : Z, 0 <= x ->
  let s := sqrt_q32 x in
  s * s <= x * q32_scale < (s + 1) * (s + 1).
Proof.
  intros x Hx.
  unfold sqrt_q32.
  assert (Hn : 0 <= x * q32_scale).
  { unfold q32_scale; nia. }
  pose proof (Z.sqrt_spec (x * q32_scale) Hn) as H.
  simpl in H.
  exact H.
Qed.

Lemma sqrt_q32_nonnegative : forall x : Z, 0 <= x -> 0 <= sqrt_q32 x.
Proof.
  intros x Hx.
  unfold sqrt_q32.
  apply Z.sqrt_nonneg.
Qed.

Print Assumptions sqrt_q32_bounds.
Print Assumptions sqrt_q32_nonnegative.
