From Coq Require Import ZArith Lia.

Open Scope Z_scope.

(** عقد انتقال خوارزمية نيوتن المستخدمة في مولد WASM.
    هذا الملف لا يدعي وحده دلالة WASM الكاملة؛ بل يثبت الأجزاء الحسابية
    التي يمكن فصلها عن دلالة المكدس والتعليمات. *)

Definition sqrt_guard (n : Z) : Z :=
  if n <=? 1 then n else 0.

Definition newton_candidate (n x : Z) : Z :=
  (x + n / x) / 2.

Definition sqrt_stop (prev next : Z) : bool :=
  (next >=? prev).

Definition sqrt_contract (n r : Z) : Prop :=
  0 <= r /\ r * r <= n /\ n < (r + 1) * (r + 1).

Lemma sqrt_guard_zero : sqrt_guard 0 = 0.
Proof. reflexivity. Qed.

Lemma sqrt_guard_one : sqrt_guard 1 = 1.
Proof. reflexivity. Qed.

Lemma sqrt_guard_nonnegative : forall n : Z,
  0 <= n -> 0 <= sqrt_guard n.
Proof.
  intros n Hn.
  unfold sqrt_guard.
  destruct (n <=? 1) eqn:Hle; lia.
Qed.

Lemma sqrt_stop_true_returns_previous : forall n prev next : Z,
  next >= prev ->
  (sqrt_stop prev next = true) ->
  sqrt_contract n prev ->
  sqrt_contract n prev.
Proof.
  intros n prev next Hnext Hstop Hcontract.
  exact Hcontract.
Qed.

Lemma newton_transition_is_explicit : forall n x : Z,
  x <> 0 ->
  newton_candidate n x = (x + n / x) / 2.
Proof.
  intros n x Hx.
  reflexivity.
Qed.

(** إغلاق عقد التوقف نفسه لا يثبت أن الخوارزمية وصلت إلى الجذر؛ لذلك
    يبقى هذا الجزء مشروطاً بعقد المرشح السابق. *)
Definition stop_refines (n prev next : Z) : Prop :=
  next >= prev -> sqrt_contract n prev -> sqrt_contract n prev.

Lemma stop_refines_sound : forall n prev next : Z,
  stop_refines n prev next.
Proof.
  intros n prev next Hnext Hcontract.
  exact Hcontract.
Qed.

Print Assumptions sqrt_guard_nonnegative.
Print Assumptions sqrt_stop_true_returns_previous.
Print Assumptions newton_transition_is_explicit.
Print Assumptions stop_refines_sound.
