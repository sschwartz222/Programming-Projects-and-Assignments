module Deque exposing
  ( Deque, empty, isEmpty
  , addFront, removeFront, peekFront
  , addBack, removeBack, peekBack
  )

type Deque a = D { front : List a, back : List a }

empty : Deque a
empty = D {front = [], back = []}

isEmpty : Deque a -> Bool
isEmpty q = q == empty

--------------------------------------------------------------------------------
-- FILL IN THE DEFINITIONS BELOW

check : List a -> List a -> Deque a
check f b =
    case (f,b) of
      ([],[])   -> D {front = [], back = []}
      ([],[x])  -> D {front = [], back = b}
      ([x],[])  -> D {front = f, back = []}
      ([],_)    -> let len = List.length b in
                    D {front = List.reverse(List.drop (len//2) b),
                        back = List.take (len//2) b}
      (_,[])    -> let len = List.length f in
                    D {front = List.take (len//2) f,
                        back = List.reverse(List.drop (len//2) f)}
      (_,_)     -> D {front = f, back = b}

addFront : a -> Deque a -> Deque a
addFront x (D {front, back}) =
    check (x::front) back

addBack : a -> Deque a -> Deque a
addBack x (D {front, back}) =
    check front (x::back)

peekFront : Deque a -> Maybe a
peekFront (D {front, back}) =
    case front of
      [] -> List.head back
      _  -> List.head front


peekBack : Deque a -> Maybe a
peekBack (D {front, back}) =
    case back of
      [] -> List.head front
      _  -> List.head back

removeFront : Deque a -> Maybe (Deque a)
removeFront (D {front, back}) =
    case front of
      [] -> case back of
              [] -> Nothing
              _::rest -> Just (check front rest)
      x::rest -> Just (check rest back)
 
removeBack : Deque a -> Maybe (Deque a)
removeBack (D {front, back}) =
    case back of
      [] -> case front of
              [] -> Nothing
              _::rest -> Just (check rest back)
      x::rest -> Just (check front rest)