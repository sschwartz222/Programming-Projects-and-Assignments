module ThunkList exposing (..)

type alias ThunkList a
  = Thunk (ThunkListCell a)

type ThunkListCell a
  = Nil
  | Cons a (ThunkList a)

type Thunk a
  = Thunk (() -> a)

lazy : (() -> a) -> Thunk a
lazy = Thunk

force : Thunk a -> a
force (Thunk f) = f ()

--------------------------------------------------------------------------------

append : ThunkList a -> ThunkList a -> ThunkList a
append xs ys =
  lazy (\() ->
    case force xs of
      Nil -> force ys
      Cons first rest -> Cons first (append rest ys))


map : (a -> b) -> ThunkList a -> ThunkList b
map f xs =
  lazy (\() ->
    case force xs of
      Nil -> Nil
      Cons first rest -> Cons (f first) (map f rest))

concat : ThunkList (ThunkList a) -> ThunkList a
concat xss =
  lazy (\() ->
    case force xss of
      Nil -> Nil
      Cons first rest -> force (append first (concat rest)))

concatMap : (a -> ThunkList b) -> ThunkList a -> ThunkList b
concatMap f xs =
  concat (map f xs)

cartProdWith : (a -> b -> c) -> ThunkList a -> ThunkList b -> ThunkList c 
cartProdWith f xs ys =
  lazy (\() ->  
    case force xs of
      Nil -> Nil
      Cons first rest -> 
        case force ys of
          Nil -> Nil
          Cons _ _ -> force (append (map (f first) ys) (cartProdWith f rest ys)))
