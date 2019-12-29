module RBTrees2 exposing (..)

import RedBlackTree exposing (Color(..), Tree(..))

insert : comparable -> Tree comparable -> Tree comparable
insert x t =
  case ins x t of
    (T _ l y r, _) -> T B l y r
    (E, _)         -> Debug.todo "insert"

type Dir = Left | Right

ins : comparable -> Tree comparable -> (Tree comparable, List Dir)
ins x t =
  case t of
    E -> (T R E x E, [])
    T color left y right ->
      if x < y then 
        let 
          (tree, bal) = ins x left 
          dirs = List.take 2 (Left :: bal)
        in 
          ((chooseBalance dirs) color tree y right, dirs)
      else if x > y then 
        let 
          (tree, bal) = ins x right 
          dirs = List.take 2 (Right :: bal)
        in 
          ((chooseBalance dirs) color left y tree, dirs)
      else (T color left y right, [])


type alias Balance comparable =
  Color -> Tree comparable -> comparable -> Tree comparable -> Tree comparable

chooseBalance : List Dir -> Balance comparable
chooseBalance ld =
  case ld of
    [] -> T
    [x] -> T
    x::y::rest -> if x == Left && y == Left then balanceLL
                  else if x == Left && y == Right then balanceLR
                  else if x == Right && y == Left then balanceRL
                  else balanceRR

balanceLL : Balance comparable
balanceLL color l val r =
  case (color, (l, val, r)) of
    (B, (T R (T R a x b) y c, z, d)) -> T R (T B a x b) y (T B c z d)
    _                                -> T color l val r

balanceLR : Balance comparable
balanceLR color l val r =
  case (color, (l, val, r)) of
    (B, (T R a x (T R b y c), z, d)) -> T R (T B a x b) y (T B c z d)
    _                                -> T color l val r

balanceRL : Balance comparable
balanceRL color l val r =
  case (color, (l, val, r)) of
    (B, (a, x, T R (T R b y c) z d)) -> T R (T B a x b) y (T B c z d)
    _                                -> T color l val r

balanceRR : Balance comparable
balanceRR color l val r =
  case (color, (l, val, r)) of
    (B, (a, x, T R b y (T R c z d))) -> T R (T B a x b) y (T B c z d)
    _                                -> T color l val r

