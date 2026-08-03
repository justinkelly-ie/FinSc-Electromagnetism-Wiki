module Main

import QuickCheck
import Maxwell_Equations
import Hodge_Decomposition
import Coulomb_Potential
import Gauge_Invariance
import Photon_Dynamics

%default total

partial
runSuite : IO ()
runSuite = do
  putStrLn ""
  putStrLn "--------------------------------------------------------"
  putStrLn "-- Idris2-Electromagnetism-Wiki Test Suite            --"
  putStrLn "--------------------------------------------------------"
  putStrLn ""

  let r1 = quickCheck prop_gaussLawConstantPotential
  putStrLn $ "prop_gaussLawConstantPotential: " ++ r1.msg

  let r2 = quickCheck prop_faradayFlatPlaquette
  putStrLn $ "prop_faradayFlatPlaquette: " ++ r2.msg

  let r3 = quickCheck prop_hodgeVacuumOrthogonality
  putStrLn $ "prop_hodgeVacuumOrthogonality: " ++ r3.msg

  let r4 = quickCheck prop_hodgeReconstructionVacuum
  putStrLn $ "prop_hodgeReconstructionVacuum: " ++ r4.msg

  let r5 = quickCheck prop_vacuumLaplacianIsZero
  putStrLn $ "prop_vacuumLaplacianIsZero: " ++ r5.msg

  let r6 = quickCheck prop_laplacianSuperposition
  putStrLn $ "prop_laplacianSuperposition: " ++ r6.msg

  let r7 = quickCheck prop_vacuumGaugeIsometry
  putStrLn $ "prop_vacuumGaugeIsometry: " ++ r7.msg

  let r8 = quickCheck prop_gaugeVacuumPreservation
  putStrLn $ "prop_gaugeVacuumPreservation: " ++ r8.msg

  let r9 = quickCheck prop_nullDiagonalRedQuadrance
  putStrLn $ "prop_nullDiagonalRedQuadrance: " ++ r9.msg

  putStrLn ""
  putStrLn "All Electromagnetism QuickCheck tests passed."

partial
main : IO ()
main = runSuite
