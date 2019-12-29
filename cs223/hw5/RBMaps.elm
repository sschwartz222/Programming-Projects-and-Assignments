module RBMaps exposing (Map, empty, get, insert, toList)

type Color = R | B
type Map comparable v
  = E
  | T Color (Map comparable v) (comparable, v) (Map comparable v)

empty : Map comparable v
empty = E

get : comparable -> Map comparable v -> Maybe v
get c m =
  case m of
    E -> Nothing
    T col left (k, v) right -> if c > k then get c right
                                else if c < k then get c left
                                else Just v 

insert : comparable -> v -> Map comparable v -> Map comparable v
insert k v m =
  case ins k v m of
    T _ l y r -> T B l y r
    E         -> Debug.todo "impossible"
  

ins : comparable -> v -> Map comparable v -> Map comparable v
ins k v m =
  case m of 
    E -> T R E (k, v) E
    T col left (key, val) right ->
      if k == key then T col left (key, v) right
      else if k < key then balance col (ins k v left) (key, val) right 
      else balance col left (key, val) (ins k v right)
  

balance : Color
       -> Map comparable v -> (comparable, v) -> Map comparable v
       -> Map comparable v
balance col l val r =
  case (col, (l, val, r)) of
    (B, (T R (T R a x b) y c, z, d)) -> T R (T B a x b) y (T B c z d)
    (B, (T R a x (T R b y c), z, d)) -> T R (T B a x b) y (T B c z d)
    (B, (a, x, T R (T R b y c) z d)) -> T R (T B a x b) y (T B c z d)
    (B, (a, x, T R b y (T R c z d))) -> T R (T B a x b) y (T B c z d)
    _                                -> T col l val r

toList : Map comparable v -> List (comparable, v)
toList m =
  case m of
    E -> []
    T _ left val right -> (((toList left) ++ [val]) ++ (toList right))  

