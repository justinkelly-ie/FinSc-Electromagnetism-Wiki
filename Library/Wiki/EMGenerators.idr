module Wiki.EMGenerators

import QuickCheck
import Stage0.BoxInt
import Stage1.EM.MinkowskiFaraday
import Stage1.ProjectiveDihedron
import Stage1.Carrier.Maxel
import Data.Vect

%default total

public export
Arbitrary BoxInt where
  arbitrary = map intToBoxInt arbitrary
  coarbitrary b gen = coarbitrary (unwrapBox b) gen

public export
Arbitrary MinkowskiEMField where
  arbitrary = do
    er <- map (* 2) (choose (-50, 50))
    es <- map (* 2) (choose (-50, 50))
    bz <- map (* 2) (choose (-50, 50))
    pure (MkMinkowskiEM [intToBoxInt er, intToBoxInt es] (intToBoxInt bz))
  coarbitrary (MkMinkowskiEM [er, es] bz) =
    coarbitrary (unwrapBox er) . coarbitrary (unwrapBox es) . coarbitrary (unwrapBox bz)

public export
Arbitrary ProjectiveDihedron where
  arbitrary = do
    choice <- choose (0, 2)
    case choice of
      0 => do
        r <- choose (2, 20)
        pure (mkRationalBoostR (intToBoxInt r) (intToBoxInt 1))
      1 => do
        s <- choose (2, 20)
        pure (mkRationalBoostS (intToBoxInt s) (intToBoxInt 1))
      _ => do
        x <- choose (1, 20)
        t <- choose (1, 20)
        pure (mkRationalSpatialRotation (intToBoxInt x) (intToBoxInt t))
  coarbitrary p = coarbitrary (unwrapBox (projNorm p))

