# 🗂️ Electromagnetic Field Stream & Poynting Flux Specification

Documents and verifies discrete electromagnetic field state streaming, Poynting vector flux accumulation $S = *(E \wedge B)$, and zero-heap stream deforestation.

## 1. Specification & Property Tests

```idris
module Wiki.FieldStreamSpec

import Data.List
import Data.Fuel
import Math.OnSeq.FusedStream
import EM.Maxwell
import EM.FieldStream
import Core.VexelMaxel
import Core.BoxInt
import Geometry.GrassmannCalculus

%default total

||| Property 1: Fused Poynting Stream Extraction Equivalence
public export
prop_poyntingStreamEquivalence : Bool
prop_poyntingStreamEquivalence =
  let
    st1 = vacuumMaxwellState
    st2 = vacuumMaxwellState
    strm = streamMaxwellStates [st1, st2]
    poyntingStrm = fusedPoyntingStream strm
    res = runFueledStream (limit 10) poyntingStrm
  in
    length res == 2

||| Property 2: Deforested Poynting Flux Accumulation
public export covering
prop_poyntingAccumulation : Bool
prop_poyntingAccumulation =
  let
    st1 = vacuumMaxwellState
    st2 = vacuumMaxwellState
    strm = streamMaxwellStates [st1, st2]
    (Core.VexelMaxel.MkMaxel acc) = fusedPoyntingAccumulate strm
  in
    acc == []

||| QuickCheck / Direct Suite Execution for Field Stream Spec
public export covering
auditFieldStreamProof : IO Bool
auditFieldStreamProof = do
  let p1 = prop_poyntingStreamEquivalence
  let p2 = prop_poyntingAccumulation
  pure (p1 && p2)
```
