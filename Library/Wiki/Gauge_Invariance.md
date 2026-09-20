# 🛡️ Gauge Invariance & Energy Conservation

> [[Electromagnetism](Electromagnetism.md)] — Row 10 Gauge Theory

This module formalizes **$U(1)$ Local Gauge Symmetry**, **Gauge Operators (`MaxelOperator`)**, and **Charge / Energy Conservation** over discrete multisets.

---

## 1. Literate Idris 2 Implementation

```idris
module Wiki.Gauge_Invariance

import QuickCheck
import Math.Multiset
import Math.BoxInt
import Math.Pixel
import Core.BoxInt
import Core.VexelMaxel
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
||| Vacuum Operator Isometry: Empty vector potential is zero Maxel.
public export
prop_vacuumGaugeIsometry : Property
prop_vacuumGaugeIsometry = property (
  let emptyOp : VectorPotential
      emptyOp = vacuumVectorPotential
  in emptyOp == MkMaxel [])
```
