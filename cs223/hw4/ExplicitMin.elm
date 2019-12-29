module ExplicitMin exposing
  (Heap, empty, isEmpty, findMin, insert, deleteMin, merge)

-- NOTE: without functors or type classes, we would manually swap in
-- different implementations of H by twiddling the following imports

import BinomialHeap as H
-- import LeftistHeap as H

type Heap a
  = E
  | NE a (H.Heap a)   -- the a is the minimum element

empty : Heap comparable
empty = E

isEmpty : Heap comparable -> Bool
isEmpty h =
  if h == E then True else False

insert : comparable -> Heap comparable -> Heap comparable
insert x h =
  case h of 
    E -> NE x H.empty
    NE v hp -> NE (min x v) (H.insert x hp)


merge : Heap comparable -> Heap comparable -> Heap comparable
merge h1 h2 =
  case (h1, h2) of
    (E, _) -> h2
    (_, E) -> h1
    ((NE m1 hs1), (NE m2 hs2)) -> NE (min m1 m2) (H.merge hs1 hs2)

findMin : Heap comparable -> Maybe comparable
findMin h =
  case h of
    E -> Nothing
    NE x _ -> Just x

deleteMin : Heap comparable -> Maybe (comparable, Heap comparable)
deleteMin h =
  case h of
    E -> Nothing
    NE m hp -> let hs = H.deleteMin hp in 
                case hs of
                  Nothing -> Debug.todo "impossible"
                  Just (_, xs) -> Just (m, if H.isEmpty xs then E 
                                            else NE (case (H.findMin xs) of
                                                      Nothing -> Debug.todo "impossible"
                                                      Just x  -> x) xs)

