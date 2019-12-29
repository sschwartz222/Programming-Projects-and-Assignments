module ArrayList exposing
  ( ArrayList, nil, isEmpty
  , cons, head, tail          -- list-like operations
  , get, set                  -- array-like operations
  )

type alias Rank = Int
type LeafTree a = Leaf a | Branch Rank (LeafTree a) (LeafTree a)
type ArrayList a = ArrayList (List (LeafTree a))


----------------------------------------------------------------------

nil : ArrayList a
nil =
  ArrayList []

isEmpty : ArrayList a -> Bool
isEmpty arrayList =
  arrayList == nil

rank : LeafTree a -> Int
rank t =
  case t of
    Leaf _       -> 0
    Branch r _ _ -> r


----------------------------------------------------------------------
-- list-like operations

cons : a -> ArrayList a -> ArrayList a
cons x (ArrayList trees) =
  ArrayList (consTree (Leaf x) trees)

consTree : LeafTree a -> List (LeafTree a) -> List (LeafTree a)
consTree t1 trees =
  let r1 = rank t1 in
    case trees of
    [] -> [t1]
    t::rest ->
      let r2 = (rank t) in
        if r1 < r2 then t1::t::rest
        else if r1 == r2 then consTree (Branch (r1+1) t1 t) rest
        else t::(consTree t1 rest) 

splitTree : LeafTree a -> (a, List (LeafTree a))
splitTree t =
  case t of
    Leaf x -> (x, [])
    Branch _ t1 t2 -> let (val, remtree) = splitTree t1 
                        in (val, (consTree t2 remtree)) 

head : ArrayList a -> Maybe a
head (ArrayList trees) =
  case trees of
    [] ->
      Nothing
    t::rest ->
      let (x, ts) = splitTree t in
      Just x

tail : ArrayList a -> Maybe (ArrayList a)
tail (ArrayList trees) =
  case trees of
    [] ->
      Nothing
    t::rest ->
      let (x, ts) = splitTree t in
      Just (ArrayList (ts ++ rest))


----------------------------------------------------------------------
-- array-like operations

get : Int -> ArrayList a -> Maybe a
get i (ArrayList trees) =
  case (i, trees) of
    (0, Leaf x :: _) ->
      Just x

    (_, Branch r left right :: trees_) ->
      let n = 2 ^ r in
      if i < n then
        if i < (n//2) then get i (ArrayList (left :: trees_))
        else 
        get ??? (ArrayList ???)
      else if i == n then
        head trees_
      else
        get ??? (ArrayList ???)

    _ ->
      Nothing
  
  
  {-case trees of
    [] -> Nothing
    t::rest ->
      let r1 = (rank t) in
        if i < (2^r1) then
          if (i >)-}

set : Int -> a -> ArrayList a -> Maybe (ArrayList a)
set i a (ArrayList trees) =
  Debug.todo "set"