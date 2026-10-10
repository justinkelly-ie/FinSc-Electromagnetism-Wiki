module Wiki.ElectromagnetismSpec

import Stage0.BoxInt
import Stage1.VexelMaxel
import Stage0.Multiset
import public Electromagnetism
import QuickCheck
import Data.List

%default total

------------------------------------------------------------------------
-- 1. ELECTROMAGNETIC QUICKCHECK PROPERTY SPECS
------------------------------------------------------------------------

||| Property: Electrostatic field from constant scalar potential is zero.
public export
prop_constantPotentialZeroField : Bool
prop_constantPotentialZeroField = auditConstantPotentialZeroFieldProof

||| Property: U(1) gauge transformation preserves magnetic curvature B(A + d0 chi) == B(A).
public export
prop_gaugeInvariance : Bool
prop_gaugeInvariance = auditGaugeInvarianceProof

||| Property: Gauss's Law for Magnetism holds (div B == 0 / no magnetic monopoles).
public export
prop_noMagneticMonopoles : Bool
prop_noMagneticMonopoles = auditNoMagneticMonopolesProof

||| Property: Combinatorial Hodge Star operator is an involution (star(star(F)) == F).
public export
prop_hodgeInvolution : Bool
prop_hodgeInvolution = Stage1.EM.Hodge.auditHodgeStarInvolutionProof

||| Property: Vacuum Maxwell field minimizes discrete electromagnetic energy density.
public export
prop_vacuumMaxwellEnergyMinimization : Bool
prop_vacuumMaxwellEnergyMinimization = auditMaxwellVacuumSolenoidProof

||| Property: Pure Multiset Faraday EMF obeys induction flux conservation.
public export
prop_multisetFaradayEMFConservation : Bool
prop_multisetFaradayEMFConservation =
  let loop = [MkPixel 1 2, MkPixel 2 3, MkPixel 3 1]
      potT1 = fromList [(MkPixel 1 2, intToBoxInt 5), (MkPixel 2 3, intToBoxInt 3)]
      potT2 = fromList [(MkPixel 1 2, intToBoxInt 9), (MkPixel 2 3, intToBoxInt 3)]
      emf = computeMultisetFaradayEMF potT1 potT2 loop (intToBoxInt 1)
  in emf == intToBoxInt (-4)

------------------------------------------------------------------------
-- 2. SPECS TEST SUITE RUNNER
------------------------------------------------------------------------

public export
runElectromagnetismSpecs : IO Bool
runElectromagnetismSpecs = do
  let p1 = prop_constantPotentialZeroField
  let p2 = prop_gaugeInvariance
  let p3 = prop_noMagneticMonopoles
  let p4 = prop_hodgeInvolution
  let p5 = prop_vacuumMaxwellEnergyMinimization
  let p6 = prop_multisetFaradayEMFConservation
  let p7 = Stage1.EM.Calculus.auditElectricFieldStreamEquivalenceProof
  putStrLn $ "   -> Checking Constant Potential Zero Field: " ++ (if p1 then "PASSED" else "FAILED")
  putStrLn $ "   -> Checking U(1) Gauge Invariance (B(A + d0 chi) == B(A)): " ++ (if p2 then "PASSED" else "FAILED")
  putStrLn $ "   -> Checking Gauss's Law for Magnetism (div B == 0): " ++ (if p3 then "PASSED" else "FAILED")
  putStrLn $ "   -> Checking Hodge Star Involution (star(star(F)) == F): " ++ (if p4 then "PASSED" else "FAILED")
  putStrLn $ "   -> Checking Vacuum Maxwell Energy Minimization: " ++ (if p5 then "PASSED" else "FAILED")
  putStrLn $ "   -> Checking Pure Multiset Faraday EMF Induction: " ++ (if p6 then "PASSED" else "FAILED")
  putStrLn $ "   -> Checking Deforested Electric Field Stream Equivalence: " ++ (if p7 then "PASSED" else "FAILED")
  pure (p1 && p2 && p3 && p4 && p5 && p6 && p7)


