module Wiki.Main

import Wiki.ElectromagnetismSpec
import Wiki.EMHomomorphismSpec
import Reflect.Auditor.EM
import System

%default total

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
  if s1 && s2
     then do
       putStrLn ""
       putStrLn "=========================================================================="
       putStrLn "   ✨ ALL DISCRETE ELECTROMAGNETISM SUITES PASSED WITH 100% TOTALITY! ✨"
       putStrLn "=========================================================================="
     else do
       putStrLn "   -> FAIL: Electromagnetism verification check failed!"
       exitWith (ExitFailure 1)
