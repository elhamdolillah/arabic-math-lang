From Coq Require Import ZArith Lia.
Require Import UORI.C40_Q64_Model.

Open Scope Z_scope.

Lemma q64_mod_bounds : forall n : Z,
  0 < q64_scale -> 0 <= n mod q64_scale < q64_scale.
Proof.
  intros n Hd.
  apply Z.mod_pos_bound; exact Hd.
Qed.

Lemma q64_div_mod_identity : forall n : Z,
  n = q64_scale * (n / q64_scale) + n mod q64_scale.
Proof.
  intro n.
  apply Z.div_mod.
  pose proof q64_scale_pos as Hpos.
  lia.
Qed.

Lemma q64_mul_floor_error : forall a b : q64,
  0 <= a -> 0 <= b ->
  0 <= a * b - q64_mul_floor a b * q64_scale < q64_scale.
Proof.
  intros a b Ha Hb.
  unfold q64_mul_floor.
  pose proof (q64_mod_bounds (a * b) q64_scale_pos) as Hmod.
  pose proof (Z.div_mod (a * b) q64_scale) as Hdiv.
  nia.
Qed.

Lemma q64_mul_floor_reconstruction : forall a b : q64,
  0 <= a -> 0 <= b ->
  a * b = q64_scale * q64_mul_floor a b +
          (a * b - q64_mul_floor a b * q64_scale).
Proof.
  intros a b Ha Hb.
  ring.
Qed.

(** هذا الملف يثبت حدود عملية الإسقاط فقط؛ لا يثبت تقريب exp أو صحة هورنر. *)
Print Assumptions q64_mul_floor_error.
Print Assumptions q64_mul_floor_reconstruction.
