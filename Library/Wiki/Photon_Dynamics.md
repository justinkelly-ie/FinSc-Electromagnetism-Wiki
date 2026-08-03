# 🌈 Photons, Null Minkowski Lines & Radiation

> [[Electromagnetism](Electromagnetism.md)] — Row 10 Relativistic Electromagnetism

This module documents free electromagnetic radiation, photon propagation along **null Minkowski cones** ($Q_{\text{Red}} = x^2 - y^2 = 0$), and photon timelessness in discrete chromogeometry.

---

## 1. Literate Idris 2 Implementation

```idris
module Photon_Dynamics

import QuickCheck
import Math.Multiset
import Math.BoxInt
import Math.Pixel
import Math.Chromogeometry
import Substrate.Core
import EM.Potential

%default total
```

---

## 2. Relativistic Radiation in Discrete Geometry

1. **Light-Cone Geometry**: In special relativity, electromagnetic waves travel along null paths where spacetime interval $\text{d}s^2 = 0$.
2. **Red Chromogeometric Quadrance**: Wildberger's Red metric signature $(+, -)$ computes $Q_{\text{Red}}(p_1, p_2) = (x_2 - x_1)^2 - (y_2 - y_1)^2$.
3. **Photon Timelessness**: Along a null diagonal $x = y$, the Red quadrance is identically zero ($Q_{\text{Red}} = 0$). Free photons accumulate zero temporal interval across their trajectory.

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

||| Light-Cone Null Signature: Points on diagonal x = y have Red Quadrance = 0.
public export
prop_nullDiagonalRedQuadrance : Property
prop_nullDiagonalRedQuadrance = forAll {a = BoxInt} {prop = Bool} arbitrary (MkFn (\d =>
  let origin = MkPixel 0 0
      nullPoint = MkPixel d d
      qRed = quadranceNL Red origin nullPoint
  in qRed == 0))
```
