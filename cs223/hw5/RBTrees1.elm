module RBTrees1 exposing (..)

import RedBlackTree exposing (Color(..), Tree(..))

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
      else if x < y then balanceL color (ins x l) y r
      else balanceR color l y (ins x r)
  

type alias Balance comparable =
  Color -> Tree comparable -> comparable -> Tree comparable -> Tree comparable

balanceL : Balance comparable
balanceL color l val r =
  case (color, (l, val, r)) of
    (B, (T R (T R a x b) y c, z, d)) -> T R (T B a x b) y (T B c z d)
    (B, (T R a x (T R b y c), z, d)) -> T R (T B a x b) y (T B c z d)
    _                                -> T color l val r

balanceR : Balance comparable
balanceR color l val r =
  case (color, (l, val, r)) of
    (B, (a, x, T R (T R b y c) z d)) -> T R (T B a x b) y (T B c z d)
    (B, (a, x, T R b y (T R c z d))) -> T R (T B a x b) y (T B c z d)
    _                                -> T color l val r

