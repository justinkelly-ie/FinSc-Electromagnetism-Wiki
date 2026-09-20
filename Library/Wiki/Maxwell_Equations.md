# ⚡ Maxwell's Equations in Discrete Exterior Calculus

> [[Electromagnetism](Electromagnetism.md)] — Row 10 Multiset Field Theory

This module formalizes classical Maxwell's equations in **Discrete Exterior Calculus (DEC)** over 0-cell nodes, 1-cell pixel edges, and 2-cell plaquette loops without continuum limits ($\text{d}x \to 0$) or floating-point precision loss.

---

## 1. Discrete Exterior Calculus $\leftrightarrow$ Multiset Differential Form Duality Dictionary

| Electromagnetic Construct | Discrete Differential Form | Native Multiset Basis Representation |
| :--- | :--- | :--- |
| **Scalar Potential $\Phi$** | 0-Form Cochain | Point Cochain `Vexel` |
| **Vector Potential $\mathbf{A}$** | 1-Form Connection Cochain | Edge Cochain `Maxel` |
| **Electric Field $\mathbf{E} = -\mathrm{d}_0 \Phi$** | 1-Form Field Cochain | `computeElectricField edges phi : Maxel` |
| **Magnetic Field $\mathbf{B} = \mathrm{d}_1 \mathbf{A}$** | 2-Form Curvature Cochain | `computeMagneticField faces a : Maxel` |
| **Charge Density $\rho = \mathrm{d}_2 \mathbf{B}$** | 3-Form Volume Density | `computeChargeDivergence voxels f : Boxel` |
| **Electromagnetic State** | Form Bundle $(E, B, J, \rho)$ | `MaxwellState = (EdgeCochain, FaceCochain, EdgeCochain, CellCochain)` |
| **Hodge Components** | Orthogonal Field Triplet | `HodgeComponents = (Maxel, Maxel, Maxel)` |

---

## 2. Literate Idris 2 Implementation

```idris
module Wiki.Maxwell_Equations

import QuickCheck
import Math.Multiset
import Math.BoxInt
import Core.BoxInt
import EM.Potential
import EM.Calculus
import EM.Flux
import EM.Maxwell

%default total
```

---

## 3. Theoretical Correspondence to Continuum Physics

| Continuum Maxwell Equation | Discrete Exterior Calculus Formulation | Multiset Implementation |
|---|---|---|
| **Gauss's Law**: $\nabla \cdot \mathbf{E} = \frac{\rho}{\varepsilon_0}$ | $\delta_1 A = \rho$ (0-chain charge divergence) | `computeElectricDivergence` / `applyDivergenceMap` |
| **Gauss's Law for Magnetism**: $\nabla \cdot \mathbf{B} = 0$ | $\partial \partial = 0$ (Boundary Nilpotency) | `prop_boundaryNilpotency` |
| **Faraday's Law**: $\nabla \times \mathbf{E} = -\frac{\partial \mathbf{B}}{\partial t}$ | $B = \oint A \cdot \text{d}l$ (Plaquette Loop Circulation) | `computePlaquetteFlux` |
| **Ampère-Maxwell Law**: $\nabla \times \mathbf{B} = \mu_0 \mathbf{J} + \mu_0 \varepsilon_0 \frac{\partial \mathbf{E}}{\partial t}$ | $\delta_2 B = J$ (Dual 1-chain Current Density) | `applyDivergenceMap` over Plaquette Maxels |

---

## 4. Executable Verification Properties

```idris
||| Vacuum Energy Density: Vacuum Maxwell State has energy density = 0.
public export
prop_vacuumEnergyZero : Property
prop_vacuumEnergyZero = property (
  let state = vacuumMaxwellState
      eZero = maxwellElectricField state
      bZero = maxwellMagneticField state
      energy = computeEnergyDensity eZero bZero
  in energy == MkBoxInt 0)
```
