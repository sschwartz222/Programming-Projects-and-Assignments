module ListsAndTrees exposing
  ( suffixes, Tree, testtree
  , mem, fullTree, create2, balancedTree, balancedTrees, insert, driver
  , completeTrees, almostCompleteTrees
  )


------------------------------------------------------------------------------
-- Problem 1 
------------------------------------------------------------------------------
-- T(0) = c_0
-- T(1) = c_1 + T(0) = c_1 + c_0
-- T(2) = c_1 + T(1) = 2*c_1 + c_0
-- T(n) = n*c_1 + c_0
-- T(n) is O(n)
--------
-- S(0) = a_0
-- S(1) = a_1 + T(0) = a_1 + a_0
-- S(2) = a_1 + T(1) = 2*a_1 + a_0
-- S(n) = n*a_1 + a_0
-- S(n) is O(n)
suffixes : List a -> List (List a)
suffixes xs =
  case xs of
    [] -> [[]] -- c_0     space: a_0
    head :: tail -> xs :: (suffixes tail) --c_1 + T(n-1)     space: a_1 + S(n-1)


------------------------------------------------------------------------------
-- Problem 2 
------------------------------------------------------------------------------

type Tree a = Empty | Node a (Tree a) (Tree a)

testtree = Node 4 (Node 3 (Node 1 Empty Empty) Empty) (Node 6 (Node 5 Empty Empty) (Node 7 Empty Empty))

memhelper : comparable -> Tree comparable -> Tree comparable -> Tree comparable
memhelper x t counter =
    case t of
      Empty -> counter
      Node value left right -> 
        if x <= value then
          memhelper x left (Node value left right)
        else
          memhelper x right counter

mem : comparable -> Tree comparable -> Bool
mem x t =
  case (memhelper x t Empty) of
    Empty -> False
    Node value left right -> if value == x then True else False

fullTree : a -> Int -> Tree a
fullTree x h =
  let
      tr = if h > 0 then fullTree x (h-1) else Empty
  in
    if h == 0 then Empty else Node x tr tr

balancedTree : a -> Int -> Tree a
balancedTree x h =
  Tuple.first (create2 x h)

create2 : a -> Int -> (Tree a, Tree a)
create2 x h =
  if h == 0 then (Empty, Node x Empty Empty)
  else if (remainderBy 2 h) == 1 then 
    let (t1, t2) = create2 x ((h-1) // 2)
    in (Node x t1 t1, Node x t2 t1)
  else let (t1, t2) = create2 x ((h // 2) - 1) in (Node x t2 t1, Node x t2 t2)

{-findleaf : a -> Tree a -> (Tree a, Tree a)
findleaf x tr =
  case tr of
    Empty -> []
    Node value left right -> 
      if ((left == Empty) && (right == Empty)) 
        then (Node x (Node x Empty Empty) Empty, Node x (Node x Empty Empty) (Node x Empty Empty))
      else let ((t1, t2), (t3, t4)) = (Node value (Tuple.first(findleaf left)) ++ (findleaf right) -}


{-addonenode : a -> Int -> List (Tree a)
addonenode x h =
  let tr = (fullTree x (h-1))
  in
    case tr of
      Empty -> [Node x Empty Empty]
      Node value left right ->  -}

{-makealltrees : a -> Int -> Int -> Tree a
makealltrees x n counter=
   if n == 0 then Empty
   else if counter > n then Empty
   else Node x (makealltrees x n (counter+1)) (makealltrees x (n-counter) (counter+1))

makealltreesrunner : a -> Int -> Int -> List (Tree a)
makealltreesrunner x n counter =
  if n == 0 then [Empty]
  else if counter >= n then []
  else let tr = makealltrees x n counter in tr :: makealltreesrunner x n (counter+1)-}

balancedTrees : a -> Int -> List (Tree a)
balancedTrees _ _ =
  Debug.todo "TODO"

insert : a -> Tree a -> Int -> Int -> Tree a
insert x tr h counter =
  if h > 0 then
    let c = ((2^(h-1))//2) in
      case tr of
        Empty -> Node x Empty Empty
        Node value left right ->
          if ((left == Empty) && (right == Empty))
            then Node value (Node x Empty Empty) Empty
          else if ((left == Empty) && (right /= Empty))
            then Node value left (Node x Empty Empty)
          else if counter < c 
            then Node value (insert x left (h-1) counter) right
          else
            Node value left (insert x right (h-1) (counter-c))
  else Node x Empty Empty

driver : a -> Tree a -> Int -> Int -> List (Tree a)
driver x tr h counter =
  let c = (2^(h-1)) in
    let inittr = (insert x tr h counter) in
      if counter < c then inittr :: (driver x inittr h (counter+1))
      else []

completeTrees : a -> Int -> List (Tree a)
completeTrees x h =
  if h == 0 then [Empty] else driver x (fullTree x (h-1)) h 0

almostCompleteTrees : a -> Int -> List (Tree a)
almostCompleteTrees _ _ =
  Debug.todo "TODO"
