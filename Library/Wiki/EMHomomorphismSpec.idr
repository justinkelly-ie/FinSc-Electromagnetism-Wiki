module Wiki.EMHomomorphismSpec

import Stage0.BoxInt
import Stage0.BoxInt
import Stage1.Basis.Coordinate
import public Electromagnetism
import QuickCheck
import Data.List
import Data.Vect

%default total

------------------------------------------------------------------------
-- 1. U(1) GAUGE & DISCRETE DIFFERENTIAL HOMOMORPHISM SPECS
------------------------------------------------------------------------

||| Homomorphism Property 1: Discrete Exterior Derivative d0 is an Additive Homomorphism
||| d0(Phi1 + Phi2) == d0(Phi1) + d0(Phi2).
public export
prop_d0AdditiveHomomorphism : Bool
prop_d0AdditiveHomomorphism =
  let edges = [(MkUnixel 1, MkUnixel 2), (MkUnixel 2, MkUnixel 3)]
      phi1 : CellMultiset 1 = singletonCell (MkUnixel 1) (intToBoxInt 3) <+> singletonCell (MkUnixel 2) (intToBoxInt 5)
      phi2 : CellMultiset 1 = singletonCell (MkUnixel 2) (intToBoxInt 2) <+> singletonCell (MkUnixel 3) (intToBoxInt 7)
      
      eCombined = computeElectricField edges (addCellMultiset phi1 phi2)
      eSum      = canonicalizeCell (addCellMultiset (computeElectricField edges phi1) (computeElectricField edges phi2))
  in eCombined == eSum

||| Homomorphism Property 2: Discrete Exterior Derivative d1 is an Additive Homomorphism
||| d1(A1 + A2) == d1(A1) + d1(A2).
public export
prop_d1AdditiveHomomorphism : Bool
prop_d1AdditiveHomomorphism =
  let faces = [(MkPixel 1 2, [ (MkUnixel 1, MkUnixel 2)
                             , (MkUnixel 2, MkUnixel 3)
                             , (MkUnixel 3, MkUnixel 4)
                             , (MkUnixel 4, MkUnixel 1)
                             ])]
      a1 : CellMultiset 2 = singletonCell (MkPixel 1 2) (intToBoxInt 3)
      a2 : CellMultiset 2 = singletonCell (MkPixel 1 2) (intToBoxInt 7)
      
      bCombined = computeMagneticField faces (addCellMultiset a1 a2)
      bSum      = canonicalizeCell (addCellMultiset (computeMagneticField faces a1) (computeMagneticField faces a2))
  in bCombined == bSum

||| Homomorphism Property 3: Discrete Hodge Star Dual is an Additive Homomorphism
||| star(E1 + E2) == star(E1) + star(E2).
public export
prop_hodgeAdditiveHomomorphism : Bool
prop_hodgeAdditiveHomomorphism =
  let e1 : CellMultiset 2 = singletonCell (MkPixel 1 0) (intToBoxInt 4)
      e2 : CellMultiset 2 = singletonCell (MkPixel 2 0) (intToBoxInt 6)
      
      dualCombined = hodgeDualElectricToMagnetic (addCellMultiset e1 e2)
      dualSum      = canonicalizeCell (addCellMultiset (hodgeDualElectricToMagnetic e1) (hodgeDualElectricToMagnetic e2))
  in dualCombined == dualSum

------------------------------------------------------------------------
-- 2. HOMOMORPHISM SPEC TEST SUITE RUNNER
------------------------------------------------------------------------

public export
runEMHomomorphismSpecs : IO Bool
runEMHomomorphismSpecs = do
  let p0 = prop_d0AdditiveHomomorphism
  let p1 = prop_d1AdditiveHomomorphism
  let ph = prop_hodgeAdditiveHomomorphism
  putStrLn $ "   -> Checking d0 (Gradient) Additive Homomorphism: " ++ (if p0 then "PASSED" else "FAILED")
  putStrLn $ "   -> Checking d1 (Curl) Additive Homomorphism: " ++ (if p1 then "PASSED" else "FAILED")
  putStrLn $ "   -> Checking Hodge Star Dual Additive Homomorphism: " ++ (if ph then "PASSED" else "FAILED")
  pure (p0 && p1 && ph)
