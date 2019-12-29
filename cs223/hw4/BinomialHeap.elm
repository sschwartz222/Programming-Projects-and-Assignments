module BinomialHeap exposing
  (Heap, empty, isEmpty, findMin, insert, deleteMin, merge)

type alias Rank = Int
type Tree a = Node Rank a (List (Tree a))

type Heap a = Heap (List (Tree a))

rank (Node r _ _) = r
root (Node _ x _) = x

link : Tree comparable -> Tree comparable -> Tree comparable
link t1 t2 =
  let
    (Node r x1 ts1) = t1
    (Node _ x2 ts2) = t2
  in
  if x1 <= x2
    then Node (r+1) x1 (t2::ts1)
    else Node (r+1) x2 (t1::ts2)

insertTree : Tree comparable -> List (Tree comparable) -> List (Tree comparable)
insertTree t ts = case ts of
  []      -> [t]
  t1::ts1 ->
    if rank t == rank t1 then insertTree (link t t1) ts1
    else if rank t < rank t1 then t :: ts
    else Debug.todo "insertTree: impossible"

merge_two_pass
    : List (Tree comparable) -> List (Tree comparable)
   -> List (Tree comparable)
merge_two_pass ts1 ts2 = case (ts1, ts2) of
  ([], _) -> ts2
  (_, []) -> ts1
  (t1::ts1_rest, t2::ts2_rest) ->
    if rank t1 < rank t2 then t1 :: merge_two_pass ts1_rest ts2
    else if rank t2 < rank t1 then t2 :: merge_two_pass ts2_rest ts1
    else insertTree (link t1 t2) (merge_two_pass ts1_rest ts2_rest)

removeMinTree
    : List (Tree comparable)
   -> (Tree comparable, List (Tree comparable))
removeMinTree ts = case ts of
  []     -> Debug.todo "removeMinTree: impossible"
  [t]    -> (t, [])
  t::ts_rest ->
    let (minTree, restTrees) = removeMinTree ts_rest in
    if root t < root minTree
      then (t, ts_rest)
      else (minTree, t::restTrees)

empty : Heap comparable
empty = Heap []

isEmpty : Heap comparable -> Bool
isEmpty h = h == empty

insert : comparable -> Heap comparable -> Heap comparable
insert x (Heap ts) = Heap (insertTree (Node 0 x []) ts)

merge : Heap comparable -> Heap comparable -> Heap comparable
merge (Heap ts1) (Heap ts2) = Heap (merge_two_pass ts1 ts2)

findMin0 : Heap comparable -> Maybe comparable
findMin0 (Heap ts) =
  case List.map root ts of
    []    -> Nothing
    n::ns -> Just (List.foldl min n ns)

findMin : Heap comparable -> Maybe comparable
findMin (Heap ts) =
  case ts of
    [] -> Nothing
    _  -> Just (root (Tuple.first (removeMinTree ts)))

deleteMin : Heap comparable -> Maybe (comparable, Heap comparable)
deleteMin (Heap ts) = case ts of
  [] -> Nothing
  _  -> let (Node _ x ts1, ts2) = removeMinTree ts in
        Just (x, Heap (merge_two_pass (List.reverse ts1) ts2))
