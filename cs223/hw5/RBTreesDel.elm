module RBTreesDel exposing (Set, empty, member, insert, delete, size)

import RBMaps as Map

type Set comparable = Set (Map.Map comparable Bool)

empty : Set comparable
empty = Set (Map.empty)

member : comparable -> Set comparable -> Bool
member c (Set (m)) =
  case Map.get c m of
    Nothing -> False
    Just b -> b

insert : comparable -> Set comparable -> Set comparable
insert c (Set (m)) =
  Set (Map.insert c True m)

delete : comparable -> Set comparable -> Set comparable
delete c (Set (m)) =
    if member c (Set (m)) then Set (Map.insert c False m) else (Set (m))

size : Set comparable -> (Int, Int)
size (Set m) =
  let xs = List.map Tuple.second (Map.toList m) in 
    let 
      foo (a,b) ys = 
        case ys of
          [] -> (a,b)
          x :: rest -> if x == True then foo (a+1, b) rest
                        else foo (a, b+1) rest
    in
    foo (0,0) xs

