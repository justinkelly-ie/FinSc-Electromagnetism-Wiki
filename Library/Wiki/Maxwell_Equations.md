# ⚡ Maxwell's Equations in Discrete Exterior Calculus

> [[Electromagnetism](Electromagnetism.md)] — Row 10 Multiset Field Theory

This module formalizes classical Maxwell's equations in **Discrete Exterior Calculus (DEC)** over 0-cell nodes, 1-cell pixel edges, and 2-cell plaquette loops without continuum limits ($\text{d}x \to 0$) or floating-point precision loss.

---

## 1. Literate Idris 2 Implementation

```idris
module Maxwell_Equations

import QuickCheck
import Math.Multiset
import Math.BoxInt
import Math.Pixel
import Math.Chromogeometry
import Substrate.Core
import Substrate.Difference
import Substrate.Divergence
import Substrate.Laplacian
import EM.Potential
import EM.Calculus
import EM.Flux

%default total
```

---

## 2. Theoretical Correspondence to Continuum Physics

| Continuum Maxwell Equation | Discrete Exterior Calculus Formulation | Multiset Implementation |
|---|---|---|
| **Gauss's Law**: $\nabla \cdot \mathbf{E} = \frac{\rho}{\varepsilon_0}$ | $\delta_1 A = \rho$ (0-chain charge divergence) | `computeElectricDivergence` / `applyDivergenceMap` |
| **Gauss's Law for Magnetism**: $\nabla \cdot \mathbf{B} = 0$ | $\partial \partial = 0$ (Boundary Nilpotency) | `prop_boundaryNilpotency` |
| **Faraday's Law**: $\nabla \times \mathbf{E} = -\frac{\partial \mathbf{B}}{\partial t}$ | $B = \oint A \cdot \text{d}l$ (Plaquette Loop Circulation) | `computePlaquetteFlux` |
| **Ampère-Maxwell Law**: $\nabla \times \mathbf{B} = \mu_0 \mathbf{J} + \mu_0 \varepsilon_0 \frac{\partial \mathbf{E}}{\partial t}$ | $\delta_2 B = J$ (Dual 1-chain Current Density) | `applyDivergenceMap` over Plaquette Maxels |

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

||| Gauss's Law: The electric field divergence of constant potential is identically zero.
public export
prop_gaussLawConstantPotential : Property
prop_gaussLawConstantPotential = forAll {a = (Geometry, Geometry)} {prop = Bool} arbitrary (MkFn (\(p1, p2) =>
  let nodes = [p1, p2]
      constPotential = fromList (map (\p => ((p, emptyIntPoly), 5)) nodes)
      sub = singleEdge p1 p2
      gaugeField = computeGaugeField constPotential sub
      divField = computeElectricDivergence gaugeField
      nonZeroDiv = filter (\(_, count) => count /= 0) (multisetToList divField)
  in null nonZeroDiv))

||| Faraday's Law: Circulation around a flat unit plaquette with uniform potential is zero.
public export
prop_faradayFlatPlaquette : Property
prop_faradayFlatPlaquette = forAll {a = Geometry} {prop = Bool} arbitrary (MkFn (\p =>
  let (MkPixel x y) = p
      p1 = MkPixel x y
      p2 = MkPixel (x + 1) y
      p3 = MkPixel (x + 1) (y + 1)
      p4 = MkPixel x (y + 1)
      pl = MkPlaquette p1 p2 p3 p4
      sub = fromList [ ((p1, p2), 0)
                     , ((p2, p3), 0)
                     , ((p3, p4), 0)
                     , ((p4, p1), 0)
                     ]
      flux = computePlaquetteFlux pl sub
  in flux == 0))
```
