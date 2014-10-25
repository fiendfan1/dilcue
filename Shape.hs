{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
module Shape where

import Data.Vec ((:.)(..), Vec3)
import qualified Data.Vec as Vec

import AABB

data Triangle a = Triangle !(Vec3 a) !(Vec3 a) !(Vec3 a)
  deriving (Show, Eq)

instance Ord s => HasAABB s (Triangle s) where
    boundingBox (Triangle a b c) =
        let testComponent f p =
                f (f (component p a) (component p b)) (component p c)
            testAllComps f =
                (testComponent f X:.
                 testComponent f Y:.
                 testComponent f Z:.())
            low = testAllComps min
            high = testAllComps max
        in AABB low high

surfaceNormal :: Floating a => Triangle a -> Vec3 a
surfaceNormal (Triangle p1 p2 p3) =
    let e1 = p2 - p1
        e2 = p3 - p1
    in Vec.normalize $ Vec.cross e1 e2
