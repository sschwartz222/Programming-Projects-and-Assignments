module FPWarmup exposing
  ( digitsOfInt
  , digitshelper
  , additivePersistence
  , digitalRoot
  , subsequenceshelper
  , subsequenceshelper2
  , subsequences
  , take
  )

-- Add some imports here if you'd like. ------------------------------
import List.Extra
import List.Unique
----------------------------------------------------------------------
digitshelper : Int -> List Int
digitshelper n =
  if n < 0 then []
  else if n < 10 then [n]
  else (remainderBy 10 n) :: (digitshelper (n // 10))

digitsOfInt : Int -> List Int
digitsOfInt n =
  List.reverse (digitshelper n)

additivehelper : Int -> Int -> Int
additivehelper n count =
  if n < 10 then count
  else additivehelper (List.sum (digitsOfInt n)) (count + 1)

additivePersistence : Int -> Int
additivePersistence n =
  additivehelper n 0

digitalRoot : Int -> Int
digitalRoot n =
  if n < 10 then n 
  else digitalRoot (List.sum (digitsOfInt n))

subsequenceshelper : Int -> List a -> List(List a)
--in a list of n number of elements, find all possible lists of n-1 elements
subsequenceshelper len xs =
  if len > 0 then (List.Extra.removeAt len xs) :: (subsequenceshelper (len - 1) xs)
  else if len == 0 then [(List.Extra.removeAt len xs)]
  else []

subsequenceshelper2 : List a -> List (List a)
--perform a calculation for the subsequences of a set of lists created by subsequenceshelper
subsequenceshelper2 xs =
  if xs == [] then []
  else (xs :: (List.foldl (++) [] (List.map subsequenceshelper2 (subsequenceshelper ((List.length xs) - 1) xs)))) 

subsequences : List a -> List (List a)
--make it pretty and add the empty list
subsequences xs =
  [] :: List.reverse (List.Unique.filterDuplicates (subsequenceshelper2 xs))

take : Int -> List a -> Result String (List a)
take k xs =
  if k < 0 then Err "negative index"
  else if k > (List.length xs) then Err "not enough elements"
  else Ok (List.take k xs)
