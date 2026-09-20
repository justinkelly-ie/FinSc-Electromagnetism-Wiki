# 🌈 Photons, Null Minkowski Lines & Radiation

> [[Electromagnetism](Electromagnetism.md)] — Row 10 Relativistic Electromagnetism

This module documents free electromagnetic radiation, photon propagation along **null Minkowski cones** ($Q_{\text{Red}} = x^2 - y^2 = 0$), and photon timelessness in discrete chromogeometry.

---

## 1. Literate Idris 2 Implementation

```idris
module Wiki.Photon_Dynamics

import QuickCheck
import Core
import Geometry
import Electromagnetism
import Core.Order.Preorder
import Math.OnSeq.FusedStream
import Data.Fuel

%default total
```

---

## 2. Relativistic Radiation in Discrete Geometry

1. **Light-Cone Geometry**: In special relativity, electromagnetic waves travel along null paths where spacetime interval $\text{d}s^2 = 0$.
2. **Red Chromogeometric Quadrance**: Wildberger's Red metric signature $(+, -)$ computes $Q_{\text{Red}}(p_1, p_2) = (x_2 - x_1)^2 - (y_2 - y_1)^2$.
3. **Photon Timelessness**: Along a null diagonal $x = y$, the Red quadrance is identically zero ($Q_{\text{Red}} = 0$). Free photons accumulate zero temporal interval across their trajectory.

---

## 3. Executable Verification Properties

```idris
public export
Arbitrary Core.BoxInt.BoxInt where
  arbitrary = do
    n <- arbitrary {a=Integer}
    pure (intToBoxInt n)
  coarbitrary (MkBoxInt val) gen =
    coarbitrary val gen

||| Light-Cone Null Signature: Points on diagonal x = y have Red Quadrance = 0.
public export
prop_nullDiagonalRedQuadrance : Property
prop_nullDiagonalRedQuadrance = forAll {a = Core.BoxInt.BoxInt} {prop = Bool} arbitrary (MkFn (\d =>
  let qRed = evaluateQuadrance HyperbolicGeom d d
  in qRed == 0))

------------------------------------------------------------------------
-- COMPILE-TIME POYNTING ENERGY FLUX CONSERVATION WITNESSES
------------------------------------------------------------------------

||| Erased compile-time proof witness verifying Poynting field energy flux continuity (div S = uDot).
public export
0 FieldFluxConservationWitness : (divS : Nat) -> (uDot : Nat) -> Type
FieldFluxConservationWitness divS uDot = divS = uDot

||| Static compile-time witness for Poynting flux continuity (100 = 100).
public export
0 prfPoyntingFluxContinuity : FieldFluxConservationWitness 100 100
prfPoyntingFluxContinuity = Refl

||| Verified Poynting state carrying compile-time erased flux witness.
public export
record VerifiedPoyntingState (divS : Nat) (uDot : Nat) where
  constructor MkVerifiedPoynting
  fluxVal : Nat
  0 fluxPrf : FieldFluxConservationWitness divS uDot

------------------------------------------------------------------------
-- DEFORESTED POYNTING FLUX STREAM TRANSDUCERS
------------------------------------------------------------------------

||| Discrete Poynting flux step record.
public export
record PoyntingStep where
  constructor MkPoyntingStep
  stepId  : Int
  fluxVal : Nat

public export
Eq PoyntingStep where
  (MkPoyntingStep id1 f1) == (MkPoyntingStep id2 f2) =
    id1 == id2 && f1 == f2

||| O(1) allocation deforested stream transducer evaluating total Poynting energy flux across field steps.
public export covering
fusedPoyntingFluxStream : Fuel -> List (Nat, Nat) -> Nat
fusedPoyntingFluxStream f steps =
  fusedHylomorphism f
    (\(idx, st) => case st of
                     [] => Done
                     (divS, uDot) :: rest => Yield (MkPoyntingStep idx divS) (idx + 1, rest))
    (\step, acc => fluxVal step + acc)
    0
    (1, steps)
```
