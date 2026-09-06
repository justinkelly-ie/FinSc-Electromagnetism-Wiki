# ⚡ Idris2-Electromagnetism-Wiki

**Layer 3c Electromagnetism & Discrete Exterior Calculus Executable Verification Wiki.**

[![Idris2](https://img.shields.io/badge/Idris2-Electromagnetism--Wiki-yellow.svg)](https://github.com/idris-lang/Idris2)

---

## 🏛️ Overview

`Idris2-Electromagnetism-Wiki` provides executable verification and category-theoretic homomorphism specifications for **Constructive Discrete Electromagnetism**.

### Literate Verification Chapters & Specs

- **[Electromagnetism & DEC](Library/Wiki/Electromagnetism.md)** — Singletons, Pixels, Vexels, Maxels, gauge vector potentials ($A$), magnetic flux ($B = d_1 A$), and discrete Maxwell equations.
- **[Maxwell's Equations in DEC](Library/Wiki/Maxwell_Equations.md)** — Gauss's Law ($\nabla \cdot \mathbf{E} = \rho$), Faraday's Law ($\oint A \cdot \text{d}l$), and discrete divergence/flux conservation.
- **[Hodge Field Decomposition](Library/Wiki/Hodge_Decomposition.md)** — Orthogonal splitting into Harmonic ($V_{\text{harm}}$), Electrostatic ($\nabla \Phi$), and Solenoidal ($\nabla \times \mathbf{A}$) fields.
- **[Coulomb Potential & Poisson Equation](Library/Wiki/Coulomb_Potential.md)** — Discrete Poisson solver ($\Delta \Phi = -\rho$) over whole-number integer box weights.
- **[Gauge Invariance & Energy Conservation](Library/Wiki/Gauge_Invariance.md)** — $U(1)$ local phase symmetry, unitary transitions, and discrete Poynting conservation.
- **[Photons & Light-Cone Dynamics](Library/Wiki/Photon_Dynamics.md)** — Relativistic null Minkowski cone geometry ($Q_{\text{Red}} = x^2 - y^2 = 0$) and photon timelessness.

---

## 🧪 Executable Verification Suite (`lem-wiki`)

| Module | Verification Target |
|---|---|
| [Wiki.ElectromagnetismSpec](Library/Wiki/ElectromagnetismSpec.idr) | U(1) gauge invariance, constant potential zero field, Gauss's law for magnetism ($\nabla \cdot B = 0$), Hodge star involution, and vacuum energy density minimization. |
| [Wiki.EMHomomorphismSpec](Library/Wiki/EMHomomorphismSpec.idr) | Category-theoretic additive homomorphisms for discrete gradient $d_0(\Phi_1 + \Phi_2) = d_0 \Phi_1 + d_0 \Phi_2$, curl $d_1(A_1 + A_2) = d_1 A_1 + d_1 A_2$, and Hodge star dual $\star(E_1 + E_2) = \star E_1 + \star E_2$. |
| [Wiki.Main](Library/Wiki/Main.idr) | Executable verification runner (`lem-wiki`) injecting `%macro` elaborator reflection proof witnesses and running total property specifications. |

---

## 🛠️ Build & Run Verification

```bash
toolbox run -c fedora-toolbox-44 /var/home/justin/.local/bin/idris2 --build Idris2-Electromagnetism-Wiki.ipkg
toolbox run -c fedora-toolbox-44 ./build/exec/lem-wiki
```

© Justin Kelly. All rights reserved.
