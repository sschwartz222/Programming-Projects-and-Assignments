module BHeaps exposing
  (Heap, empty, isEmpty, findMin, insert, deleteMin, merge)

type Tree a = Node a (List (Tree a))
type alias Rank = Int
type Heap a = Heap (List (Rank, Tree a))

{-- Internal Helpers ----------------------------------------------------}
root (Node x _) = x

link : Tree comparable -> Tree comparable -> Tree comparable
link t1 t2 =
  let 
    (Node x1 ts1) = t1
    (Node x2 ts2) = t2
  in
    if x1 <= x2 then Node x1 (t2 :: ts1) else Node x2 (t1 :: ts2)

inserttree : Tree comparable -> Rank -> List (Rank, Tree comparable) -> List (Rank, Tree comparable)
inserttree t r h =
  case h of
    [] -> [(r, t)]
    ((htr, hts) :: htn) -> if htr == r then inserttree (link hts t) (r+1) htn 
                                else (r, t) :: ((htr, hts) :: htn)

mergeheaps : List (Rank, Tree comparable) -> List (Rank, Tree comparable) -> List (Rank, Tree comparable)
mergeheaps h1 h2 =
  case (h1, h2) of
    ([], _) -> h2
    (_, []) -> h1
    (((hr1, ht1) :: hts1), ((hr2, ht2) :: hts2)) ->
      if hr1 < hr2 then (hr1, ht1) :: mergeheaps hts1 h2
      else if hr2 < hr1 then (hr2, ht2) :: mergeheaps hts2 h1
      else inserttree (link ht1 ht2) (hr1+1) (mergeheaps hts1 hts2)  

removemintree : List (Rank, Tree comparable) -> (Tree comparable, List (Rank, Tree comparable))
removemintree ts =
  case ts of
    [] -> Debug.todo "removemintree: impossible"
    [t] -> (Tuple.second t, [])
    t::rest ->
      let (minTree, restTrees) = removemintree rest in
        if (root (Tuple.second t)) < (root minTree) then (Tuple.second t, rest)
        else (minTree, t :: restTrees) 

{-- External Interface --------------------------------------------------}

empty : Heap comparable
empty = Heap []

isEmpty : Heap comparable -> Bool
isEmpty h = h == empty

insert : comparable -> Heap comparable -> Heap comparable
insert x (Heap h) =
  Heap (inserttree (Node x []) 0 h)

merge : Heap comparable -> Heap comparable -> Heap comparable
merge (Heap h1) (Heap h2) =
  Heap (mergeheaps h1 h2)

findMin : Heap comparable -> Maybe comparable
findMin (Heap h) =
  case h of
    [] -> Nothing
    _ -> Just (root (Tuple.first (removemintree h)))

deleteMin : Heap comparable -> Maybe (comparable, Heap comparable)
deleteMin (Heap h) =
  case h of
    [] -> Nothing
    _ -> let (Node x hs1, hs2) = removemintree h in
      Just (x, Heap (mergeheaps hs2 (List.indexedMap Tuple.pair (List.reverse hs1))))

