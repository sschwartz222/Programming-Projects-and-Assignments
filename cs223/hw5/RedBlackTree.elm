module RedBlackTree exposing (..)

type Color  = R | B
type Tree a = E | T Color (Tree a) a (Tree a)

empty = E

member : comparable -> Tree comparable -> Bool
member x t = case t of
  E -> False
  T _ l y r ->
    if x == y then True
    else if x < y then member x l
    else member x r

insert : comparable -> Tree comparable -> Tree comparable
insert x t =
  case ins x t of
    T _ l y r -> T B l y r
    E         -> Debug.todo "insert"

ins : comparable -> Tree comparable -> Tree comparable
ins x t =
  case t of
    E -> T R E x E
    T color l y r ->
      if x == y then t
      else if x < y then balance color (ins x l) y r
      else balance color l y (ins x r)

balance : Color -> Tree comparable -> comparable -> Tree comparable -> Tree comparable
balance color l val r =
  case (color, (l, val, r)) of
    (B, (T R (T R a x b) y c, z, d)) -> T R (T B a x b) y (T B c z d)
    (B, (T R a x (T R b y c), z, d)) -> T R (T B a x b) y (T B c z d)
    (B, (a, x, T R (T R b y c) z d)) -> T R (T B a x b) y (T B c z d)
    (B, (a, x, T R b y (T R c z d))) -> T R (T B a x b) y (T B c z d)
    _                                -> T color l val r

------------------------------------------------------------------------------

getColor t = case t of
  T c _ _ _ -> c
  E         -> B

root t = case t of
  T _ _ x _ -> x
  E         -> Debug.todo "root"

getLeft t = case t of
  T _ l _ _ -> l
  E         -> Debug.todo "left"

getRight t = case t of
  T _ _ _ r -> r
  E         -> Debug.todo "right"

height t = case t of
  E         -> 0
  T _ l _ r -> 1 + max (height l) (height r)

size t = case t of
  E         -> 0
  T _ l _ r -> 1 + size l + size r

bso t =
  let
    nonDecreasing xs =
      case xs of
        x1::x2::rest -> x1 <= x2 && nonDecreasing (x2::rest)
        _            -> True
  in
  nonDecreasing (toList t)

toList : Tree a -> List a
toList t = case t of
  E                -> []
  T _ left x right -> toList left ++ [x] ++ toList right

maybeBlackHeight t = case t of
  E -> Just 0
  T c l _ r ->
    maybeBlackHeight l |> Maybe.andThen (\n ->
    maybeBlackHeight r |> Maybe.andThen (\m ->
      if n /= m then Nothing
      else if c == B then Just (1 + n)
      else Just n
    ))

okBlackHeight t =
  case maybeBlackHeight t of
    Just _  -> True
    Nothing -> False

blackHeight t =
  case maybeBlackHeight t of
    Just n  -> n
    Nothing -> Debug.todo "bh"

noRedRed t = case t of
  E                   -> True
  T R (T R _ _ _) _ _ -> False
  T R _ _ (T R _ _ _) -> False
  T _ l _ r           -> noRedRed l && noRedRed r

oneRedRed t = case t of
  E                             -> False
  T R (T R _ _ _) _ (T R _ _ _) -> False
  T R (T R l1 _ r1) _ r         -> noRedRed l1 && noRedRed r1 && noRedRed r
  T R l _ (T R l2 _ r2)         -> noRedRed l && noRedRed l2 && noRedRed r2
  T _ l _ r                     -> False

maybeOneRedRed t = oneRedRed t || noRedRed t

redBlackTree t = bso t && noRedRed t && okBlackHeight t

------------------------------------------------------------------------------