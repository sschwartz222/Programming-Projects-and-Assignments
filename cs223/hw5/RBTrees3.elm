module RBTrees3 exposing (..)

import RedBlackTree exposing (Color(..), Tree(..))
import RBTrees2 exposing (Balance, balanceLL, balanceLR, balanceRL, balanceRR)

insert : comparable -> Tree comparable -> Tree comparable
insert x t =
  case ins x t of
    (T _ l y r, _) -> T B l y r
    (E, _)         -> Debug.todo "insert"

nobalance : Balance comparable
nobalance color l val r = T color l val r

ins : comparable
   -> Tree comparable
   -> (Tree comparable, (Balance comparable, Balance comparable))
ins x t =
  case t of
    E -> (T R E x E, (T, T))
    T color left y right ->
      if x < y then let (tree, bal) = ins x left in 
                      (((Tuple.first bal)) color tree y right, (balanceLL, balanceRL))
      else if x > y then let (tree, bal) = ins x right in 
                      ((Tuple.second bal) color left y tree, (balanceLR, balanceRR))
      else (T color left y right, (T, T))
  

