module THeaps exposing
  (Heap, empty, isEmpty, findMin, insert, deleteMin, merge, pathTo)

type Tree a = Empty | Node a (Tree a) (Tree a)
type Heap a = Heap (Int, Tree a)

------------------------------------------------------------------------------
-- Helper functions

type Dir = Left | Right

pathTo : Int -> List Dir
pathTo =
  let
    foo i =
      if i == 0 then []
      else if remainderBy 2 i == 1 then Left :: foo (parentIndex i)
      else Right :: foo (parentIndex i)
  in
  List.reverse << foo

parentIndex i = (i-1) // 2

unwrapNode t =
  case t of
    Node x left right -> (x, left, right)
    Empty             -> Debug.todo "don't call unwrapNode with Empty"

------------------------------------------------------------------------------

empty : Heap comparable
empty = Debug.todo "TODO"

isEmpty : Heap comparble -> Bool
isEmpty h = Debug.todo "TODO"

findMin : Heap comparable -> Maybe comparable
findMin h = Debug.todo "TODO"

insert : comparable -> Heap comparable -> Heap comparable
insert x h = Debug.todo "TODO"

deleteMin : Heap comparable -> Maybe (comparable, Heap comparable)
deleteMin h = Debug.todo "TODO"

------------------------------------------------------------------------------

merge : Heap comparable -> Heap comparable -> Heap comparable
merge _ _ = Debug.todo "merge: not implemented"

------------------------------------------------------------------------------
