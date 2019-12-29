#lang typed/racket

;; CMSC15100 Winter 2018
;; Homework 4
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; Problem 1

;; A 2D point
(define-struct Point
  ([x : Real]
   [y : Real]))

;; A Dataset is a list of points
(define-type Dataset (Listof Point))

;; A line has a slope and y-axis intercept
(define-struct Line
  ([slope : Real]
   [intercept : Real]))

(: compute-line : Integer Real Real Real Real -> Line)
;; compute the linear-regression line.  The arguments are the number of samples,
;; the sum of x_i, the sum of y_i, the sum of x_i*y_i, and the sum of the
;; squares of x_i.
(define (compute-line n x y xy xx)
 (Line (/ (- (* n xy) (* x y)) (- (* n xx) (* x x)))
       (- (/ y n) (* (/ x n) (/ (- (* n xy) (* x y)) (- (* n xx) (* x x)))))))
(check-within (compute-line 11 99 82.51 797.6 1001) (Line 0.5 3) 0.01)
(check-within (compute-line 11 99 82.51 797.58 1001) (Line 0.5 3) 0.01)

(: compute-sums : Dataset Integer Real Real Real Real -> Line)
;; computes the sums needed for compute-line then does compute-line
(define (compute-sums data n x y xy xx)
  (match data
    [(cons dat datr)
     (compute-sums datr
                   (+ n 1)
                   (+ (Point-x dat) x)
                   (+ (Point-y dat) y)
                   (+ (* (Point-x dat) (Point-y dat)) xy)
                   (+ (* (Point-x dat) (Point-x dat)) xx))]
    ['() (compute-line n x y xy xx)]))
(check-within
 (compute-sums
  (list (Point 10.0 8.04)
        (Point 8.0 6.95)
        (Point 13.0 7.58)
        (Point 9.0 8.81)
        (Point 11.0 8.33)
        (Point 14.0 9.96)
        (Point 6.0 7.24)
        (Point 4.0 4.26)
        (Point 12.0 10.84)
        (Point 7.0 4.82)
        (Point 5.0 5.68)) 0 0 0 0 0) (Line 0.5 3) 0.1)
(check-within
 (compute-sums
  (list (Point 8.0 6.58)
        (Point 8.0 5.76)
        (Point 8.0 7.71)
        (Point 8.0 8.84)
        (Point 8.0 8.47)
        (Point 8.0 7.04)
        (Point 8.0 5.25)
        (Point 19.0 12.50)
        (Point 8.0 5.56)
        (Point 8.0 7.91)
        (Point 8.0 6.89)) 0 0 0 0 0) (Line 0.5 3) 0.1)

(: linear-regression : Dataset -> Line)
;; computes the best-fit line for the dataset
(define (linear-regression data)
  (if (> (length data) 2)
      (compute-sums data 0 0 0 0 0)
      (error "linear-regression: too few elements")))
(check-within
 (linear-regression
  (list (Point 8.0 6.58)
        (Point 8.0 5.76)
        (Point 8.0 7.71)
        (Point 8.0 8.84)
        (Point 8.0 8.47)
        (Point 8.0 7.04)
        (Point 8.0 5.25)
        (Point 19.0 12.50)
        (Point 8.0 5.56)
        (Point 8.0 7.91)
        (Point 8.0 6.89))) (Line 0.5 3) 0.1)
(check-expect
 (linear-regression
  (list (Point 1 1)
        (Point 2 2)
        (Point 3 3))) (Line 1 0))
(check-error
 (linear-regression
  (list (Point 1 1))) "linear-regression: too few elements")

;; Problem 2

(: halves : (Listof Exact-Rational) -> (Listof Exact-Rational))
;; divide all numbers in the list by two
(define (halves list)
  (match list
    ['() list]
    [(cons rat ratr) (cons (/ rat 2) (halves ratr))]))
(check-expect (halves '(2 2 4)) '(1 1 2))
(check-expect (halves '(2 2 5 4 1 0 -9)) '(1 1 5/2 2 1/2 0 -9/2))
(check-expect (halves '()) '())

(: scale-list : Number (Listof Number) -> (Listof Number))
;; multiply each element of the list by the first argument
(define (scale-list num list)
  (match list
    ['() list]
    [(cons numb numbr) (cons (* num numb) (scale-list num numbr))]))
(check-expect (scale-list 0 '(2 2 4)) '(0 0 0))
(check-expect (scale-list -1/2 '(2 2 5 4 1 0 -9))
              '(-1 -1 -5/2 -2 -1/2 0 9/2))
(check-expect (scale-list 9/2 '()) '())

(: non-zeros : (Listof Integer) -> (Listof Integer))
;; filter out any occurrences of 0 in the list
(define (non-zeros list)
  (match list
    ['() list]
    [(cons 0 intr) (non-zeros intr)]
    [(cons int intr) (cons int (non-zeros intr))]))
(check-expect (non-zeros '(2 2 4)) '(2 2 4))
(check-expect (non-zeros '(2 2 0 4 0)) '(2 2 4))
(check-expect (non-zeros '(0 0 0)) '())

(: smaller-than : Real (Listof Real) -> (Listof Real))
;; keep numbers below the threshold, discard others
(define (smaller-than thresh list)
  (match list
    ['() list]
    [(cons real realr) (if (>= real thresh) (smaller-than thresh realr)
                           (cons real (smaller-than thresh realr)))]))
(check-expect (smaller-than 7 '(6 7 8 5 8 7 6)) '(6 5 6))
(check-expect (smaller-than 9 '(6 7 8 5 8 7 6)) '(6 7 8 5 8 7 6))
(check-expect (smaller-than 4 '(6 7 8 5 8 7 6)) '())

(: replicate : (All (A) (Integer A -> (Listof A))))
;; takes a length n and a value v and returns a list of length
;; n where every element in the list is v
(define (replicate n v)
  (local
    {(: rep-aux : (All (A) (Integer Integer A -> (Listof A))))
     ;; helper for replicate which counts down from n
     (define (rep-aux n i v)
       (if (> n i) (cons v (rep-aux (- n 1) i v))
           '()))}
    (rep-aux n 0 v)))
(check-expect (replicate 4 "hello") '("hello" "hello" "hello" "hello"))
(check-expect (replicate 0 "hello") '())
(check-expect (replicate -1 "hello") '())

(: list-xor : (Listof Boolean) -> Boolean)
;; returns true if exactly one item in the list is true and false otherwise
(define (list-xor list)
  (local
    {(: xor-aux : (Listof Boolean) -> (Listof Boolean))
     ;; helper for list-xor to see if there is exactly one #t
     (define (xor-aux list)
       (match list
         ['() list]
         [(cons #t boolr) (cons #t (xor-aux boolr))]
         [(cons #f boolr) (xor-aux boolr)]))}
    (match (xor-aux list)
      ['(#t) #t]
      [_ #f])))
(check-expect (list-xor '(#f #f #f)) #f)
(check-expect (list-xor '(#t #t #t)) #f)
(check-expect (list-xor '(#t #t #f)) #f)
(check-expect (list-xor '(#f #f #t)) #t)
(check-expect (list-xor '()) #f)

(: that-many : (Listof Integer) -> (Listof (Listof Integer)))
;; builds a list of lists containing "that many" of each
(define (that-many list)
  (match list
    ['() list]
    [(cons int intr) (cons (replicate int int) (that-many intr))]))
(check-expect (that-many '(2 1 3)) '((2 2) (1) (3 3 3)))
(check-expect (that-many '(2 2 2)) '((2 2) (2 2) (2 2)))
(check-expect (that-many '(0 -1 -2)) '(() () ()))

(: drop : (All (A) ((Listof A) Integer -> (Listof A))))
;; given a list xs and an integer n, removes the first n elements of xs
;; if n is less than or equal to zero, then returns xs, if n is greater or equal
;; then returns empty list
(define (drop xs n)
  (local
    {(: drop-aux : (All (A) ((Listof A) Integer Integer -> (Listof A))))
     ;; helper for drop that counts down from n, removing the first n number of elements
     (define (drop-aux xs n i)
       (match xs
         [(cons x xr) (if (> n i) (drop-aux (rest xs) (- n 1) i) xs)]
         ['() '()]))}
    (drop-aux xs n 0)))
(check-expect (drop '(1 2 3 4 5) 2) '(3 4 5))
(check-expect (drop '(1 2 3 4 5) 0) '(1 2 3 4 5))
(check-expect (drop '(1 2 3 4 5) 5) '())
(check-expect (drop '(1 2 3 4 5) 6) '())

;; run tests
;;
(test)
