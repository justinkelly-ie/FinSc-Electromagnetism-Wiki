# ⚡ Electromagnetism & Discrete Exterior Calculus — [idris2-Universe](https://github.com/justinkelly-ie/idris2-Universe)

> **Row 10 of the Global Finite Science Table: Multiset Gauge Theory**
>
> In the Finite Science framework, electromagnetism is not modeled using continuous differential forms, infinite limits ($\text{d}x \to 0$), or floating-point vector fields ($\vec{E}, \vec{B}$). Instead, it is formalized as **Discrete Exterior Calculus (DEC)** over a causal substrate network using the four fundamental multiset primitives: **Singletons**, **Pixels**, **Vexels**, and **Maxels**.

---

## 🏛️ Multiset Primitive Mapping for Electromagnetism

Electromagnetism emerges naturally by parameterizing the core multiset containers across the topological dimension of the cell complex ($0\text{-cells}, 1\text{-cells}, 2\text{-cells}$):

```text
 CELL COMPLEX DIMENSION      MULTISET CONTAINER           PHYSICAL ELECTROMAGNETIC ENTITY
 ──────────────────────      ──────────────────           ───────────────────────────────
 0-Cell (Vertex/Node)    ➔   Singleton (Sing BoxInt node)  Scalar Electric Potential (Φ_i)
 1-Cell (Directed Edge)  ➔   Pixel (Pixel metric node)     Vector Gauge Potential (A_ij)
 0/1-Cochain (Fields)    ➔   Vexel (Multiset BoxInt A)     State Vector / Charge Distribution
 2-Cell (Plaquette/Loop) ➔   Maxel (Multiset c Plaquette)  Magnetic Flux / Field Strength (F_ij)
```

### 1. Singletons (`Sing` / `Sing1`): 0-Cells and Scalar Potential
A **Singleton** `Sing BoxInt Node` represents an isolated 0-cell (vertex/node in the causal poset). The scalar electric potential $\Phi$ at node $i$ is stored as an integer weight (`BoxInt`) attached to the singleton node anchor.

### 2. Pixels (`Pixel metric Node`): 1-Cells and Gauge Connections
A **Pixel** `MkPixel nodeSrc nodeTgt` represents a directed 1-cell (edge) connecting source node $i$ to target node $j$. The vector gauge potential $A_{ij}$ is stored as an integer value assigned across the directed Pixel link.

### 3. Vexels (`Vexel BoxInt State`): 0-Cochains and 1-Cochains
A **Vexel** is a multiset of singletons or pixels weighted by integer charges or potential amplitudes (`BoxInt`):
- **0-Cochain (Electric Potential Field $\Phi$)**: `Vexel BoxInt Node` — a multiset mapping nodes to scalar electric potentials.
- **1-Cochain (Vector Gauge Field $A$)**: `Vexel BoxInt (Pixel metric Node)` — a multiset mapping directed edges to gauge connection values.

### 4. Maxels (`Maxel metric c Node` = `Multiset c (Pixel metric Node)`): 2-Cells and Gauge Operators
A **Maxel** (Material Pixel) represents a 2-cell (Plaquette / closed loop of Pixels) or a linear operator mapping fields:
- **Plaquette / 2-Cell**: A closed loop of Pixels forming a 2D face. Summing gauge potentials around a Plaquette Maxel computes the exact integer **Magnetic Flux** $B = \oint A \cdot \text{d}l$.
- **Gauge Operator**: A transition operator mapping input Vexel state fields to output Vexel state fields via multiset term annihilation.

---

## 🧮 Discrete Exterior Calculus (DEC) over Multisets

### 1. The Coboundary Operator ($d_0$): Gradient / Gauge Field Generation
The coboundary operator `applyCoboundary` maps a 0-cochain potential Vexel $\Phi$ to a 1-cochain gauge field Substrate $A$ by computing node potential differences over directed Pixel links:

$$A_{ij} = (d_0 \Phi)_{ij} = \Phi_j - \Phi_i$$

```text
-- Evaluates A_ij = Φ_j - Φ_i across directed Pixel links
applyCoboundary : Vexel -> Substrate -> Substrate
```

### 2. The Boundary Operator ($\partial_1$): Divergence & Net Charge
The discrete boundary operator `boundaryOp` maps 1-chains (Substrate edges) to 0-chains (Vexel nodes), evaluating the net flux / charge divergence entering or exiting each node:

$$\partial_1 A = \sum_{j} A_{ij}$$

### 3. Magnetic Flux & Plaquette Circulation ($B = d_1 A$)
Magnetic flux is the 2-cochain field strength $F = d_1 A$. For a plaquette (a closed loop of 4 Pixels $e_1, e_2, e_3, e_4$), the magnetic flux $B$ is computed as the exact sum of edge gauge potentials around the loop:

$$B_{\text{plaquette}} = A_{12} + A_{23} + A_{34} + A_{41}$$

In flat space, a closed unit square plaquette has a rational spread deficit and flux deficit of exactly zero (`prop_plaquetteDefectInFlatSpace`).

### 4. The Poincaré Lemma ($d \circ d = 0$): Exact Conservation
In continuum physics, $\nabla \times (\nabla \Phi) = 0$ and $\nabla \cdot (\nabla \times \vec{A}) = 0$. In our multiset DEC framework, applying the coboundary operator twice identically annihilates all intermediate states:

$$d_1 (d_0 \Phi) \equiv \emptyset$$

Because multiset addition cancels identical opposite terms (`addMultiset` + `annihilateMultiset`), conservation of gauge is guaranteed at compile-time without rounding errors.

### 5. Discrete Laplacian ($\Delta = \partial_1 \circ d_0$)
The discrete Laplacian $\Delta \Phi = \partial_1 (d_0 \Phi)$ evaluates the spatial divergence of the potential gradient using whole-number multiset arithmetic:

```text
discreteLaplacian : Vexel -> Substrate -> Vexel
discreteLaplacian field substrate = boundaryOp (applyCoboundary field substrate)
```

---

## 💻 Dependent Type Formalization (Idris 2)

```idris
module Wiki.Electromagnetism

import Math.Multiset
import Math.BoxInt
import Math.Pixel
import EM.Potential
import EM.Calculus

%default total

||| A 0-Cochain: Electric Potential Field mapped over Node Singletons.
public export
0 ElectricPotentialType : Type
ElectricPotentialType = ElectricPotential

||| A 1-Cochain: Gauge Vector Field mapped over Directed Edge Pixels.
public export
0 VectorPotentialType : Type
VectorPotentialType = VectorPotential
```

---

## 🔄 Integration with Higher Science Rows

* **Row 10 (Electromagnetism)** $\to$ **Row 11 (Inversive Space Relativity)**: Plaquette gauge loops generalize to conic equation vexels and circle-reflection inversions.
* **Row 10 (Electromagnetism)** $\to$ **Row 12 (Quantum Invariants)**: The closed loop path integral over gauge Maxel ensembles (`pathEnsemble`) yields the discrete Feynman path formulation and Spread Polynomial trace conservation.
