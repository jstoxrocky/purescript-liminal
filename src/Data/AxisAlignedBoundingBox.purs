module Liminal.Data.AxisAlignedBoundingBox where

import Prelude
import TransformationMatrix.Data.Vector3 (Vector3(..))
import Data.Foldable (class Foldable, foldl, maximum, minimum)
import Data.Array.NonEmpty (NonEmptyArray, head, tail, cons')
import Data.Maybe (fromMaybe)
import Data.Array (cons)

data AxisAlignedBoundingBox = AxisAlignedBoundingBox (Vector3 Number) (Vector3 Number)

accumulateAxes
  :: forall a
  . { x :: Array a, y :: Array a, z :: Array a }
  -> Vector3 a
  -> { x :: Array a, y :: Array a, z :: Array a }
accumulateAxes { x: xs, y: ys, z: zs } (Vector3 x y z) = { x: cons x xs, y: cons y ys, z: cons z zs }

pivotAxes
  :: forall a
  . Array (Vector3 a)
  -> { x :: Array a, y :: Array a, z :: Array a }
pivotAxes vector3s = foldl accumulateAxes { x: [], y: [], z: [] } vector3s

maxByOrder
  :: forall a
   . Ord a
  => a
  -> a
  -> a
maxByOrder a1 a2 = if compare a1 a2 == GT then a1 else a2

minByOrder
  :: forall a
   . Ord a
  => a
  -> a
  -> a
minByOrder a1 a2 = if compare a1 a2 == LT then a1 else a2

consMax
  :: forall a f
   . Foldable f
  => Ord a
  => a
  -> f a
  -> a
consMax head tail = fromMaybe head $ (maxByOrder head) <$> maximum tail

consMin
  :: forall a f
   . Foldable f
  => Ord a
  => a
  -> f a
  -> a
consMin head tail = fromMaybe head $ (minByOrder head) <$> minimum tail

nonEmptyMax
  :: forall a
   . Ord a
  => NonEmptyArray a
  -> a
nonEmptyMax nonEmpty = consMax (head nonEmpty) (tail nonEmpty)

nonEmptyMin
  :: forall a
   . Ord a
  => NonEmptyArray a
  -> a
nonEmptyMin nonEmpty = consMin (head nonEmpty) (tail nonEmpty)

pivotNonEmptyAxes
  :: forall a
   . NonEmptyArray (Vector3 a)
  -> { x :: NonEmptyArray a, y :: NonEmptyArray a, z :: NonEmptyArray a }
pivotNonEmptyAxes nonEmptyVector3s = { x: cons' x xs, y: cons' y ys, z: cons' z zs }
  where
  Vector3 x y z = head nonEmptyVector3s
  { x: xs, y: ys, z: zs } = pivotAxes (tail nonEmptyVector3s)

boundingBoxFromPoints
  :: NonEmptyArray (Vector3 Number)
  -> AxisAlignedBoundingBox
boundingBoxFromPoints vertices = AxisAlignedBoundingBox minVertex maxVertex
  where
  { x, y, z } = pivotNonEmptyAxes vertices
  minX = nonEmptyMin x
  minY = nonEmptyMin y
  minZ = nonEmptyMin z
  minVertex = Vector3 minX minY minZ
  maxX = nonEmptyMax x
  maxY = nonEmptyMax y
  maxZ = nonEmptyMax z
  maxVertex = Vector3 maxX maxY maxZ
