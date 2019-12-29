#lang typed/racket

;; CMSC15100 Winter 2018
;; Homework 3
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; A 2D point
(define-struct Point
  ([x : Real]
   [y : Real]))

;; A Dataset is either an 'NoData or a (Sample obs ds1 ds2), where
;; obs is an observation (represented as a Point), and ds1 and ds2 are
;; Datasets.
(define-type Dataset
  (U 'NoData Sample))
(define-struct Sample
  ([obs : Point]
   [dset1 : Dataset]
   [dset2 : Dataset]))

(: dataset-size : Dataset -> Integer)
;; given a dataset, returns the number of observations as an integer
(define (dataset-size data)
  (match data
    [(Sample obs dset1 dset2) (+ 1 (dataset-size dset1)
                                 (dataset-size dset2))]
    ['NoData 0]))
(check-expect (dataset-size
               (Sample (Point 1 42)
                       (Sample (Point 17 -3) (Sample (Point 17 -1)
                                                     'NoData 'NoData) 'NoData)
                       (Sample (Point -20 -1) 'NoData
                               (Sample (Point 19 2) 'NoData 'NoData)))) 5)
(check-expect (dataset-size
               (Sample (Point 1 42)
                       (Sample (Point 17 -3) (Sample (Point 17 -1)
                                                     'NoData 'NoData)'NoData)
                       (Sample (Point -20 -1) 'NoData
                               (Sample (Point 19 2) (Sample (Point 1 2) 'NoData 'NoData)
                                       'NoData)))) 6)
(check-expect (dataset-size 'NoData) 0)

(: minpoint : Point Point -> Point)
;; returns the minimum x and y of two Point values as one point
(define (minpoint p1 p2)
    (Point (min (Point-x p1) (Point-x p2))
           (min (Point-y p1) (Point-y p2))))
(check-expect (minpoint (Point 0 0) (Point 0 0)) (Point 0 0))
(check-expect (minpoint (Point 2 0) (Point 0 7)) (Point 0 0))
(check-expect (minpoint (Point -7 1) (Point -8 52)) (Point -8 1))

(: dataset-min : Dataset -> Point)
;; returns a value (Point min-x min-y) such that min-x is the smallest x value of any
;; observation in the set and min-y is the smallest y value of any observation
(define (dataset-min data)
  (match data
    [(Sample obs 'NoData 'NoData) obs]
    [(Sample obs 'NoData dset2) (minpoint obs (dataset-min dset2))]
    [(Sample obs dset1 'NoData) (minpoint obs (dataset-min dset1))]
    [(Sample obs dset1 dset2) (minpoint obs (minpoint (dataset-min dset1) (dataset-min dset2)))]
    [ 'NoData (error "dataset-min: no data")]))
(check-expect (dataset-min
               (Sample (Point 1 42)
                       (Sample (Point 17 -3) (Sample (Point 17 -1)
                                                     'NoData 'NoData) 'NoData)
                       (Sample (Point -26 -1) 'NoData
                               (Sample (Point 19 -200) 'NoData 'NoData))))
              (Point -26 -200))
(check-expect (dataset-min
               (Sample (Point 1 42)
                       (Sample (Point 17 -3) (Sample (Point 17 -1)
                                                     'NoData 'NoData)'NoData)
                       (Sample (Point -20 -1) 'NoData
                               (Sample (Point 19 2) (Sample (Point 1 2) 'NoData 'NoData)
                                       'NoData)))) (Point -20 -3))
(check-error (dataset-min 'NoData) "dataset-min: no data")

(: dataset-adj-aux : Dataset Point -> Dataset)
;; takes a dataset and a point and adjusts the values in the dataset so that the
;; point is mapped to the origin
(define (dataset-adj-aux dataset min-point)
  (match dataset
    ['NoData 'NoData]
    [(Sample obs dset1 dset2)
     (Sample (Point ( - (Point-x obs) (Point-x min-point))
                    ( - (Point-y obs) (Point-y min-point)))
             (dataset-adj-aux dset1 min-point)
             (dataset-adj-aux dset2 min-point))]))
(check-expect (dataset-adj-aux
               (Sample (Point 1 42)
                       (Sample (Point 17 -3) (Sample (Point 17 -1)
                                                     'NoData 'NoData) 'NoData)
                       (Sample (Point -26 -1) 'NoData
                               (Sample (Point 19 -200) 'NoData 'NoData))) (Point -20 -20))
              (Sample (Point 21 62)
                       (Sample (Point 37 17) (Sample (Point 37 19)
                                                     'NoData 'NoData) 'NoData)
                       (Sample (Point -6 19) 'NoData
                               (Sample (Point 39 -180) 'NoData 'NoData))))
(check-expect (dataset-adj-aux
               (Sample (Point 1 42)
                       (Sample (Point 17 -3) (Sample (Point 17 -1)
                                                     'NoData 'NoData)'NoData)
                       (Sample (Point -20 -1) 'NoData
                               (Sample (Point 19 2) (Sample (Point 1 2) 'NoData 'NoData)
                                       'NoData))) (Point -5 5))
              (Sample (Point 6 37)
                       (Sample (Point 22 -8) (Sample (Point 22 -6)
                                                     'NoData 'NoData) 'NoData)
                       (Sample (Point -15 -6) 'NoData
                               (Sample (Point 24 -3) (Sample (Point 6 -3) 'NoData 'NoData)
                                       'NoData))))
(check-expect (dataset-adj-aux 'NoData (Point 0 0)) 'NoData)

(: dataset-adjust : Dataset -> Dataset)
;; utilizes the dataset-adj-aux and dataset-min functions to adjust the vaules in
;; the dataset so that the minimum of the dataset is mapped to the origin
(define (dataset-adjust data)
  (match data
    ['NoData 'NoData]
    [Sample (dataset-adj-aux data (dataset-min data))]))
(check-expect (dataset-adjust
               (Sample (Point 1 42)
                       (Sample (Point 17 -3) (Sample (Point 17 -1)
                                                     'NoData 'NoData) 'NoData)
                       (Sample (Point -26 -1) 'NoData
                               (Sample (Point 19 -200) 'NoData 'NoData))))
              (Sample (Point 27 242)
                       (Sample (Point 43 197) (Sample (Point 43 199)
                                                     'NoData 'NoData) 'NoData)
                       (Sample (Point 0 199) 'NoData
                               (Sample (Point 45 0) 'NoData 'NoData))))
(check-expect (dataset-adjust
               (Sample (Point 1 42)
                       (Sample (Point 17 -1) (Sample (Point 17 3)
                                                     'NoData 'NoData)'NoData)
                       (Sample (Point -1 -1) 'NoData
                               (Sample (Point 19 2) (Sample (Point 1 2) 'NoData 'NoData)
                                       'NoData))))
              (Sample (Point 2 43)
                       (Sample (Point 18 0) (Sample (Point 18 4)
                                                     'NoData 'NoData)'NoData)
                       (Sample (Point 0 0) 'NoData
                               (Sample (Point 20 3) (Sample (Point 2 3) 'NoData 'NoData)
                                       'NoData))))
(check-expect (dataset-adjust 'NoData) 'NoData)
(check-expect (dataset-adjust
               (Sample (Point 1 42) (Sample (Point 17 -1) 'NoData 'NoData) 'NoData))
               (Sample (Point 0 43) (Sample (Point 16 0) 'NoData 'NoData) 'NoData))

;; Problem 2

;; A nat is either 'Zero or (Succ n), where n is a nat
(define-type Nat (U 'Zero Succ))
(define-struct Succ
  ([prev : Nat]))

(: num->nat : Natural -> Nat)
;; consumes a natural and produces a nat representing the same value
(define (num->nat n)
  (local
    {(: counter : Natural Nat -> Nat)
     ;; helper function that counts up
     (define (counter x nat)
       (if (<= x (- n 1))
           (counter (+ x 1) (Succ nat))
           nat))}
    (counter 0 'Zero)))
(check-expect (num->nat 0) 'Zero)
(check-expect (num->nat 1) (Succ 'Zero))
(check-expect (num->nat 4) (Succ (Succ (Succ (Succ 'Zero)))))
(check-expect (num->nat 7) (Succ (Succ (Succ (Succ (Succ (Succ (Succ 'Zero))))))))

(: nat->num : Nat -> Natural)
;; consumes a nat and produces a natural representing the same value
(define (nat->num nat)
  (match nat
    ['Zero 0]
    [(Succ prev) (+ 1 (nat->num prev))]))
(check-expect (nat->num 'Zero) 0)
(check-expect (nat->num (Succ (Succ (Succ (Succ 'Zero))))) 4)
(check-expect (nat->num (num->nat 7)) 7)
(check-expect (nat->num (num->nat 0)) 0)

(: nat+ : Nat Nat -> Nat)
;; consumes two nat values and produces a nat representing their sum
(define (nat+ nat1 nat2)
  (match nat1
    ['Zero nat2]
    [(Succ nat1) (nat+ nat1 (Succ nat2))]))
(check-expect (nat+ (num->nat 3) (num->nat 7)) (num->nat 10))
(check-expect (nat+ (num->nat 0) (num->nat 0)) (num->nat 0))
(check-expect (nat+ 'Zero (num->nat 4)) (Succ (Succ (Succ (Succ 'Zero)))))
(check-expect (nat+ 'Zero (num->nat 2)) (Succ (Succ 'Zero)))
(check-expect (nat+ 'Zero (num->nat 2)) (num->nat 2))

(: nat- : Nat Nat -> Nat)
;; consumes two nat values and produces a nat representing the subtraction
;; of the second value from the first
;; if the second value is greater than the first, it will display the error
;; "nat-: result is not a Nat"
(define (nat- nat1 nat2)
  (match* (nat1 nat2)
    [(nat1 'Zero) nat1]
    [('Zero nat2) (error "nat-: result is not a Nat")]
    [((Succ nat1) (Succ nat2)) (nat- nat1 nat2)]))
(check-expect (nat- (num->nat 4) (num->nat 2)) (Succ (Succ 'Zero)))
(check-expect (nat- (num->nat 4) 'Zero) (num->nat 4))
(check-error (nat- (num->nat 1) (num->nat 2)) "nat-: result is not a Nat")
(check-error (nat- 'Zero (num->nat 2)) "nat-: result is not a Nat")

(: nat-compare : Nat Nat -> Symbol)
;; compares two nat values n1 and n2 and returns '< if n1<n2
;; '= if n1=n2 and '> if n1>n2
(define (nat-compare n1 n2)
  (match* (n1 n2)
    [('Zero 'Zero) '=]
    [(n1 'Zero) '>]
    [('Zero n2) '<]
    [((Succ n1) (Succ n2)) (nat-compare n1 n2)]))
(check-expect (nat-compare (num->nat 2) (num->nat 2)) '=)
(check-expect (nat-compare (num->nat 0) (num->nat 0)) '=)
(check-expect (nat-compare (num->nat 2) (num->nat 1)) '>)
(check-expect (nat-compare (num->nat 2) (num->nat 0)) '>)
(check-expect (nat-compare (num->nat 0) (num->nat 2)) '<)
(check-expect (nat-compare (num->nat 1) (num->nat 2)) '<)

(: nat* : Nat Nat -> Nat)
;; consumes two nat values and produces the product of the two as a nat
(define (nat* nat1 nat2)
  (match* (nat1 nat2)
    [('Zero nat2) 'Zero]
    [(nat1 'Zero) 'Zero]
    [((Succ nat1) nat2) (nat+ (nat* nat1 nat2) nat2)]))
(check-expect (nat* (num->nat 2) (num->nat 3)) (num->nat 6))
(check-expect (nat* (num->nat 2) (num->nat 2)) (num->nat 4))
(check-expect (nat* (num->nat 2) (num->nat 1)) (num->nat 2))
(check-expect (nat* (num->nat 2) 'Zero) 'Zero)
(check-expect (nat* 'Zero (num->nat 5)) 'Zero)
(check-expect (nat* (num->nat 5) 'Zero) 'Zero)

;; run tests
;;
(test)