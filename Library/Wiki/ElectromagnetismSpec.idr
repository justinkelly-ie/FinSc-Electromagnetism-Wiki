module Wiki.ElectromagnetismSpec

import Stage0.BoxInt
import Stage0.Multiset
import public Electromagnetism
import Stage1.EM.MinkowskiFaraday
import Stage1.ProjectiveDihedron
import Stage1.DihedronModel
import Stage0.DihedronStream
import Stage0.OnSeq.FusedStream
import Wiki.EMGenerators
import QuickCheck
import Data.List
import Data.String

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

||| Property: 3D Minkowski Faraday field Lorentz transport preserves scalar invariant S' = N(α)² S.
public export
prop_minkowskiFaradayLorentzInvariance : Bool
prop_minkowskiFaradayLorentzInvariance = auditMinkowskiEMFieldTransportProof

||| QuickCheck Property 1: 3D Minkowski Faraday field Lorentz transport preserves scalar invariant S' = N(α)² S.
public export
prop_qc_minkowskiFaradayLorentzInvariance : MinkowskiEMField -> ProjectiveDihedron -> Bool
prop_qc_minkowskiFaradayLorentzInvariance em alpha =
  let boosted = boostEMFieldProjective alpha em
      sOriginal = emScalarInvariant em
      sBoosted = emScalarInvariant boosted
      normAlpha = projNorm alpha
      expectedS = (normAlpha * normAlpha) * sOriginal
  in sBoosted == expectedS

||| QuickCheck Property 2: Vector action matches matrix congruence W' = μ(α*) · W · μ(α).
public export
prop_qc_emMatrixCongruence : MinkowskiEMField -> ProjectiveDihedron -> Bool
prop_qc_emMatrixCongruence em alpha =
  let boostedVector = boostEMFieldProjective alpha em
      boostedMatrix = boostEMFieldMatrix alpha em
  in boostedVector == boostedMatrix

||| QuickCheck Property 3: MinkowskiEMField <-> Maxel AVL tree round-trip preserves exact field coordinates.
public export
prop_qc_emMaxelRoundTrip : MinkowskiEMField -> Bool
prop_qc_emMaxelRoundTrip em =
  maxelToEM (emToMaxel em) == em

||| QuickCheck Property 4: MinkowskiEMField <-> Dihedron2 model stencil round-trip preserves exact coordinates.
public export
prop_qc_emDihedron2RoundTrip : MinkowskiEMField -> Bool
prop_qc_emDihedron2RoundTrip em =
  dihedron2ToEM (emToDihedron2 em) == em

||| QuickCheck Property 5: Deforested stream boost equivalence across single field states.
public export
prop_qc_emStreamBoostEquivalence : MinkowskiEMField -> ProjectiveDihedron -> Bool
prop_qc_emStreamBoostEquivalence em alpha =
  let strm = stream [em]
      boostedStrm = streamBoostEMField alpha strm
      res = foldStreamNat 1 (\acc, x => x :: acc) (the (List MinkowskiEMField) []) boostedStrm
      expected = boostEMFieldProjective alpha em
  in case res of
       [b] => b == expected
       _ => False

------------------------------------------------------------------------
-- 2. SPECS TEST SUITE RUNNER
------------------------------------------------------------------------

markdownTable : List (String, String, QCRes) -> String
markdownTable results =
  let header = "| Test | Description | Status | Details |\n|------|-------------|--------|---------|\n"
      rows = concat $ map formatRow results
  in header ++ rows
  where
    formatRow : (String, String, QCRes) -> String
    formatRow (name, desc, res) =
      let statusStr = case pass res of
                        Nothing => "❓ Unknown"
                        Just True => "✅ PASS"
                        Just False => "❌ FAIL"
      in "| " ++ name ++ " | " ++ statusStr ++ " | " ++ trim (msg res) ++ " |\n"

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
  let p8 = prop_minkowskiFaradayLorentzInvariance
  let p9 = auditEMMaxelRoundTripProof
  let p10 = auditEMDihedron2RoundTripProof
  let p11 = auditStreamBoostEMFieldProof
  let p12 = auditStreamAccumulateEMBoostsProof

  putStrLn $ "   -> Constant Potential Zero Field: " ++ (if p1 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> U(1) Gauge Invariance (B(A + d0 chi) == B(A)): " ++ (if p2 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> Gauss's Law for Magnetism (div B == 0): " ++ (if p3 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> Hodge Star Involution (star(star(F)) == F): " ++ (if p4 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> Vacuum Maxwell Energy Minimization: " ++ (if p5 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> Pure Multiset Faraday EMF Induction: " ++ (if p6 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> Deforested Electric Field Stream Equivalence: " ++ (if p7 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> 3D Minkowski Faraday Lorentz Invariance (S' = N(α)² S): " ++ (if p8 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> MinkowskiEMField <-> Maxel AVL Tree Round-Trip: " ++ (if p9 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> MinkowskiEMField <-> Dihedron2 Model Stencil Round-Trip: " ++ (if p10 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> Deforested Stream Boost Quadrance Scaling: " ++ (if p11 then "PASSED ✅" else "FAILED ❌")
  putStrLn $ "   -> Deforested Stream Boost Accumulation: " ++ (if p12 then "PASSED ✅" else "FAILED ❌")

  putStrLn "\n--- QuickCheck Randomized Invariant Verification (100 Tests Each) ---"
  putStrLn "Running QC Test 1: Minkowski Faraday Lorentz Invariance S' = N(α)² S"
  let r1 = qc2 prop_qc_minkowskiFaradayLorentzInvariance

  putStrLn "Running QC Test 2: Vector Action vs Matrix Sandwich Congruence"
  let r2 = qc2 prop_qc_emMatrixCongruence

  putStrLn "Running QC Test 3: MinkowskiEMField <-> Maxel AVL Tree Round-Trip"
  let r3 = qc prop_qc_emMaxelRoundTrip

  putStrLn "Running QC Test 4: MinkowskiEMField <-> Dihedron2 Model Stencil Round-Trip"
  let r4 = qc prop_qc_emDihedron2RoundTrip

  putStrLn "Running QC Test 5: Deforested Stream Boost Equivalence"
  let r5 = qc2 prop_qc_emStreamBoostEquivalence

  let table = markdownTable [
        ("Minkowski Faraday Lorentz Invariance", "Verifies S' = N(α)² S across random boosts & rotations.", r1),
        ("Matrix Sandwich Congruence", "Verifies vector action matches W' = μ(α*) · W · μ(α).", r2),
        ("Maxel AVL Tree Round-Trip", "Verifies bidirectional Maxel AVL coordinate preservation.", r3),
        ("Dihedron2 Stencil Round-Trip", "Verifies bidirectional Dihedron2 model stencil preservation.", r4),
        ("Stream Boost Equivalence", "Verifies deforested stream boost matches discrete vector boost.", r5)
      ]
  putStrLn "\n--- QuickCheck Results ---"
  putStrLn table

  let deterministicPass = p1 && p2 && p3 && p4 && p5 && p6 && p7 && p8 && p9 && p10 && p11 && p12
  let qcPass = (pass r1 == Just True) && (pass r2 == Just True) && (pass r3 == Just True) && (pass r4 == Just True) && (pass r5 == Just True)
  pure (deterministicPass && qcPass)


