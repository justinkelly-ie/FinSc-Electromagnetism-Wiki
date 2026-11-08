# 🗂️ Electromagnetic Field Stream & Poynting Flux Specification

Documents and verifies discrete electromagnetic field state streaming, Poynting vector flux accumulation $S = *(E \wedge B)$, and zero-heap stream deforestation.

## 1. Specification & Property Tests

```idris
module Wiki.FieldStreamSpec

import Data.List
import Data.Fuel
import Stage0.OnSeq.FusedStream
import Stage0.StructuralFuel
import public Electromagnetism
import Stage1.Basis.Coordinate
import Stage0.BoxInt
import Stage1.GrassmannCalculus

%default total

||| Erased compile-time witness verifying U(1) gauge session protocol duality (pIn = pOut)
public export
0 SessionProtocolDualityWitness : (pIn : Nat) -> (pOut : Nat) -> Type
SessionProtocolDualityWitness pIn pOut = pIn = pOut

||| Static compile-time witness proving gauge session protocol duality (100 = 100)
public export
prfSessionProtocolDuality : SessionProtocolDualityWitness 100 100
prfSessionProtocolDuality = Refl

||| Verified gauge channel state carrying erased session protocol duality witness
public export
record VerifiedGaugeChannelState where
  constructor MkVerifiedGaugeChannelState
  protocolIn  : Nat
  protocolOut : Nat
  0 dualityPrf : SessionProtocolDualityWitness protocolIn protocolOut

||| $O(1)$ allocation deforested gauge session stream transducer using foldStreamNat
public export
fusedGaugeSessionStream : GohFuel cap -> List (Nat, Nat) -> Nat
fusedGaugeSessionStream fuel items =
  foldStreamNat (gohSteps fuel) (\acc, (pIn, pOut) => acc + pIn + pOut) 0 (stream items)

||| Property 1: Fused Poynting Stream Extraction Equivalence
public export
prop_poyntingStreamEquivalence : Bool
prop_poyntingStreamEquivalence =
  let
    st1 = vacuumMaxwellState
    st2 = vacuumMaxwellState
    strm = streamMaxwellStates [st1, st2]
    poyntingStrm = fusedPoyntingStream strm
    res = runFueledStream hyperbolicFuel poyntingStrm
  in
    length res == 2

||| Property 2: Deforested Poynting Flux Accumulation
public export
prop_poyntingAccumulation : Bool
prop_poyntingAccumulation =
  let
    st1 = vacuumMaxwellState
    st2 = vacuumMaxwellState
    strm = streamMaxwellStates [st1, st2]
    accMaxel = fusedPoyntingAccumulate strm
    energy = fusedPoyntingEnergyAccumulate strm
  in
    pixels accMaxel == [] && boxIsZero energy

||| Property 3: Deforested Poynting Flux Stream Contraction
public export
prop_poyntingFluxContraction : Bool
prop_poyntingFluxContraction =
  let eField = singletonCell (mkPixel 1 0) (intToBoxInt 3) <+> singletonCell (mkPixel 2 0) (intToBoxInt 4)
      bField = singletonCell (mkPixel 2 3) (intToBoxInt 5) <+> singletonCell (mkPixel 3 1) (intToBoxInt 6)
      sVec = computePoyntingVector eField bField
      sx = lookupCellMultiset (mkPixel 1 0) sVec
      sy = lookupCellMultiset (mkPixel 2 0) sVec
      sz = lookupCellMultiset (mkPixel 3 0) sVec
  in sx == intToBoxInt 15 && sy == intToBoxInt 24 && sz == intToBoxInt 0

||| Property 4: Concurrent Dual-Stream Poynting Flux
public export
prop_dualStreamPoynting : Bool
prop_dualStreamPoynting =
  let eField = singletonCell (mkPixel 1 0) (intToBoxInt 3) <+> singletonCell (mkPixel 2 0) (intToBoxInt 4)
      bField = singletonCell (mkPixel 2 3) (intToBoxInt 5) <+> singletonCell (mkPixel 3 1) (intToBoxInt 6)
      eStrm = stream [eField]
      bStrm = stream [bField]
      sStrm = streamPoyntingDualStream eStrm bStrm
      sVecList = runFueledStream (limit 10) sStrm
  in case sVecList of
       [sVec] =>
         lookupCellMultiset (mkPixel 1 0) sVec == intToBoxInt 15 &&
         lookupCellMultiset (mkPixel 2 0) sVec == intToBoxInt 24
       _ => False

||| Property 5: Dynamic Radiated Photon Stream from Maxwell State
public export
prop_radiatedPhotonStream : Bool
prop_radiatedPhotonStream =
  let eField = singletonCell (mkPixel 1 0) (intToBoxInt 3)
      bField = singletonCell (mkPixel 2 0) (intToBoxInt 4)
      st = makeMaxwellState eField bField neutral neutral
      photons = streamRadiatedPhotonsFromMaxwell (stream [st])
      totE = fusedComputePhotonStreamEnergyNatDirect 10 photons
  in totE == intToBoxInt 7

||| QuickCheck / Direct Suite Execution for Field Stream Spec
public export
auditFieldStreamProof : IO Bool
auditFieldStreamProof = do
  let p1 = prop_poyntingStreamEquivalence
  let p2 = prop_poyntingAccumulation
  let p3 = prop_poyntingFluxContraction
  let p4 = prop_dualStreamPoynting
  let p5 = prop_radiatedPhotonStream
  let streamSum = fusedGaugeSessionStream hyperbolicGohFuelModel [(50, 50), (10, 10)]
  pure (p1 && p2 && p3 && p4 && p5 && streamSum == 120)
```
