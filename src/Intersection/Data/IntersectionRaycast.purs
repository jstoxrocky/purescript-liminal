module Liminal.Intersection.Data.IntersectionRaycast where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

data IntersectionRaycast a = IntersectionRaycast Number a

instance functorIntersectionRaycast :: Functor IntersectionRaycast where
  map f (IntersectionRaycast distance object) = IntersectionRaycast distance $ f object

derive instance genericIntersectionRaycast :: Generic (IntersectionRaycast a) _

instance showIntersectionRaycast :: Show a => Show (IntersectionRaycast a) where
  show = genericShow

derive instance eqIntersectionRaycast :: Eq a => Eq (IntersectionRaycast a)

instance ordIntersectionRaycast :: Ord a => Ord (IntersectionRaycast a) where
  compare
    (IntersectionRaycast distance1 object1)
    (IntersectionRaycast distance2 object2) =
    if distance1 < distance2 then LT
    else if distance1 == distance2 then compare object1 object2
    else GT

getRaycastHoveredObject
  :: forall a
   . IntersectionRaycast a
  -> a
getRaycastHoveredObject (IntersectionRaycast _ object) = object