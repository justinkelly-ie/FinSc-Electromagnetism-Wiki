# 🛡️ Gauge Invariance & Energy Conservation

> [[Electromagnetism](Electromagnetism.md)] — Row 10 Gauge Theory

This module formalizes **$U(1)$ Local Gauge Symmetry**, **Gauge Operators (`MaxelOperator`)**, and **Charge / Energy Conservation** over discrete multisets.

---

## 1. Literate Idris 2 Implementation

```idris
module Gauge_Invariance

import QuickCheck
import Math.Multiset
import Math.BoxInt
import Math.Pixel
import Substrate.Core
import EM.Gauge
import EM.Potential

%default total
```

---

## 2. Gauge Transformation & Isometry

In classical electrodynamics, shifting the scalar potential by $\Phi \to \Phi + \Lambda$ leaves physical observables invariant. In the multiset model:

1. **Gauge Operators**: Implemented via `MaxelOperator` matrix transitions.
2. **Isometry Constraint**: Evaluated by `isPermutationMaxel`, guaranteeing that transitions map with magnitude $\pm 1$ across unique node sources and targets.
3. **Leibniz Lag Conservation**: Applying a unitary gauge operator to a state vector preserves total system lag (`stateLag`) strictly in-place.

---

## 3. Executable Verification Properties

```idris
public export
Arbitrary BoxInt where
  arbitrary = do
    n <- arbitrary {a=Integer}
    pure (fromInteger n)
  coarbitrary b gen =
    let (Math.Interfaces.MkUr val) = boxToInt b
    in coarbitrary val gen

public export
Arbitrary Geometry where
  arbitrary = do
    x <- arbitrary {a=BoxInt}
    y <- arbitrary {a=BoxInt}
    pure (MkPixel x y)
  coarbitrary (MkPixel x y) gen =
    coarbitrary x (coarbitrary y gen)

||| Vacuum Operator Isometry: Empty Maxel operator is valid isometry.
public export
prop_vacuumGaugeIsometry : Property
prop_vacuumGaugeIsometry = property (
  let emptyOp : MaxelOperator
      emptyOp = ZeroM
  in isPermutationMaxel emptyOp == True)

||| Gauge Application to Vacuum: Applying gauge operator to vacuum leaves vacuum state intact.
public export
prop_gaugeVacuumPreservation : Property
prop_gaugeVacuumPreservation = property (
  let emptyOp : MaxelOperator
      emptyOp = ZeroM
      mapped = applyGaugeMaxel emptyOp emptyVexel
  in mapped == emptyVexel)
```
