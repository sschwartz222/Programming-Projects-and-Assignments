module LHeaps exposing (..)

{-- Copied from LeftistHeap.elm from class. DO NOT MODIFY. -------------}

type alias Rank = Int

type Heap a = E | T Rank a (Heap a) (Heap a)

rank : Heap a -> Rank
rank h =
  case h of
    E         -> 0
    T r _ _ _ -> r

makeT : a -> Heap a -> Heap a -> Heap a
makeT x h1 h2 =
  let
    (left,right) =
      if rank h1 >= rank h2
        then (h1, h2)
        else (h2, h1)
  in
  T (1 + rank right) x left right

merge : Heap comparable -> Heap comparable -> Heap comparable
merge h1 h2 = case (h1, h2) of
  (_, E) -> h1
  (E, _) -> h2 
  (T _ x1 left1 right1, T _ x2 left2 right2) ->
    if x1 <= x2
      then makeT x1 left1 (merge right1 h2)
      else makeT x2 left2 (merge h1 right2)

{------------------------------------------------------------------------}

{-
S(n,m) <= S(n-2, m) + log(m)
S(n,m) <= (n/2) * log(m)
T(n,m) <= T(n/2, 2m) + S(n,m) which is same as T(n/2, 2m) + (n/2) * log(m)
which equals the sum from (i=1 to log(n)) of (n/(2^i)) * log(2^(i-1) * m)
factor out n to get n * (the sum from i=1 to log(n)) of 1/2^i * log (2^(i-1)*m)
m = 1 since everything in the list starts as single heap node so we get
n * (sum from i=1 to log(n)) 1/(2^i) * log(2^(i-1)) 
which equals n * (sum from i=1 to log(n)) (i-1)/(2^i)
(sum from i=1 to log(n)) (i-1)/(2^i) converges to a constant so c*n so T(n,m) = O(n) 
-}

fromList : List comparable -> Heap comparable
fromList lst =
  let n = makePass (List.map makeNode lst) in
    if n == [] then E else Maybe.withDefault E (List.head n)

makeNode : comparable -> Heap comparable
makeNode x =
  T 1 x E E

mergePairs : List (Heap comparable) -> List (Heap comparable)
mergePairs lst =
  case lst of
    [] -> []
    [h1] -> [h1]
    h1 :: h2 :: rest -> (merge h1 h2) :: (mergePairs rest)
    
makePass : List (Heap comparable) -> List (Heap comparable)
makePass lst =
  let n = mergePairs lst in
    case n of
      [] -> []
      [h1] -> [h1]
      h1 :: h2 :: rest -> makePass n
