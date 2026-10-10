module Wiki.Main

import Wiki.ElectromagnetismSpec
import Wiki.EMHomomorphismSpec
import Wiki.FieldStreamSpec
import Wiki.Coulomb_Potential
import Wiki.Gauge_Invariance
import Wiki.Hodge_Decomposition
import Wiki.Maxwell_Equations
import Wiki.Photon_Dynamics
import Stage1.Reflect.Auditor.EM
import Language.Reflection
import System

%default total

public export
%macro
auditInvariant : (prop : Bool) -> Elab (prop = True)
auditInvariant True = pure Refl
auditInvariant False = fail "Compile-time invariant audit failed!"

-- Compile-Time Invariant Audits (Rule 01)
0 auditEMDecNilpotencyWitness : Stage1.Reflect.Auditor.EM.auditEMDecNilpotencyProofExport = True
auditEMDecNilpotencyWitness = Refl

------------------------------------------------------------------------
-- MAIN VERIFICATION SUITE EXECUTABLE
------------------------------------------------------------------------

main : IO ()
main = do
  putStrLn "=========================================================================="
  putStrLn "   ⚡ IDRIS 2 DISCRETE ELECTROMAGNETISM WIKI VERIFICATION RUNNER ⚡"
  putStrLn "=========================================================================="
  putStrLn ""
  putStrLn "--- PART 1: U(1) GAUGE INVARIANCE & DISCRETE MAXWELL CALCULUS AUDITS ---"
  s1 <- runElectromagnetismSpecs
  putStrLn ""
  putStrLn "--- PART 2: CATEGORY-THEORETIC ELECTROMAGNETIC HOMOMORPHISM AUDITS ---"
  s2 <- runEMHomomorphismSpecs
  putStrLn ""
  putStrLn "--- PART 3: DEFORESTED ELECTROMAGNETIC FIELD STATE STREAM AUDITS ---"
  s3 <- auditFieldStreamProof
  putStrLn ""
  putStrLn "--- PART 4: LITERATE WIKI PHYSICAL MODEL & SPEC AUDITS ---"
  w1 <- auditCoulombPotentialProof
  w2 <- auditGaugeInvarianceWikiProof
  w3 <- auditHodgeDecompositionProof
  w4 <- auditMaxwellEquationsProof
  w5 <- auditPhotonDynamicsProof
  if s1 && s2 && s3 && w1 && w2 && w3 && w4 && w5
     then do
       putStrLn ""
       putStrLn "=========================================================================="
       putStrLn "   ✨ ALL DISCRETE ELECTROMAGNETISM SUITES PASSED WITH 100% TOTALITY! ✨"
       putStrLn "=========================================================================="
     else do
       putStrLn "   -> FAIL: Electromagnetism verification check failed!"
       exitWith (ExitFailure 1)

