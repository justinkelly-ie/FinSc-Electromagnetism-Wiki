# 🧲 Discrete Poisson Equation & Coulomb Potential

> [[Electromagnetism](Electromagnetism.md)] — Row 10 Electrostatics

This module documents how **Coulomb's Law** and the **Poisson Equation** ($\Delta \Phi = -\rho$) operate over discrete integer box weights without floating-point division or infinite point-charge singularities.

---

## 1. Literate Idris 2 Implementation

```idris
module Wiki.Coulomb_Potential

import QuickCheck
import Math.Multiset
import Math.BoxInt
import Math.Pixel
import Core.BoxInt
import Core.VexelMaxel
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
||| Discrete Laplace Vacuum Condition: Vacuum potential produces zero Laplacian divergence.
public export
prop_vacuumLaplacianIsZero : Property
prop_vacuumLaplacianIsZero = property (
  let edges = [(MkUnixel 1, MkUnixel 2)]
      phi = vacuumElectricPotential
      lap = computePoissonLaplacian edges phi
  in lap == MkVexel [])
```
