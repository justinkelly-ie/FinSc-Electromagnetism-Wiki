# 🧲 Discrete Poisson Equation & Coulomb Potential

> [[Electromagnetism](Electromagnetism.md)] — Row 10 Electrostatics

This module documents how **Coulomb's Law** and the **Poisson Equation** ($\Delta \Phi = -\rho$) operate over discrete integer box weights without floating-point division or infinite point-charge singularities.

---

## 1. Literate Idris 2 Implementation

```idris
module Coulomb_Potential

import QuickCheck
import Math.Multiset
import Math.BoxInt
import Math.Pixel
import Substrate.Core
import Substrate.Laplacian
import EM.Potential
import EM.Calculus

%default total
```

---

## 2. Discrete Poisson Equation ($\Delta \Phi = \rho$)

In discrete physics, continuous derivatives $\nabla^2$ are replaced by the discrete graph Laplacian operator $\Delta = \delta d_0$:

$$\Delta \Phi_i = \sum_{j \sim i} (\Phi_j - \Phi_i) = \rho_i$$

- Points with uniform potential ($\Phi_i = \Phi_j$) yield $\Delta \Phi = 0$ (Laplace's equation in vacuum).
- Isolated point charges inject integer source terms $\rho_i$, deforming the spatial potential landscape.

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

||| Discrete Laplace Vacuum Condition: Vacuum potential produces zero Laplacian divergence.
public export
prop_vacuumLaplacianIsZero : Property
prop_vacuumLaplacianIsZero = property (
  let lap = computePotentialLaplacian emptyVexel emptySubstrate
  in lap == emptyVexel)

||| Linearity of Potential Laplacian: Laplacian over superposed potentials equals superposed Laplacians.
public export
prop_laplacianSuperposition : Property
prop_laplacianSuperposition = forAll {a = Geometry} {prop = Bool} arbitrary (MkFn (\g =>
  let p1 = singletonVexel g (posTerm 0 0 1)
      p2 = singletonVexel g (posTerm 1 0 2)
      superP = superposeStates p1 p2
      lap1 = computePotentialLaplacian p1 emptySubstrate
      lap2 = computePotentialLaplacian p2 emptySubstrate
      lapSuper = computePotentialLaplacian superP emptySubstrate
  in lapSuper == superposeStates lap1 lap2))
```
