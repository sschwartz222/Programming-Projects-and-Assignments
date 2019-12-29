#lang typed/racket

;; CMSC15100 Winter 2018
;; Homework 1
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; Problem 1

(: eval-quadratic : Real Real Real Real -> Real)
;; evaluates the quadratic function ax^2+bx+c at a specified x value
(define (eval-quadratic a b c x)
  ( + ( * a ( * x x)) ( * b x) c))
(check-expect (eval-quadratic 1 2 3 4) 27)
(check-expect (eval-quadratic -1 -2 -3 -4) -11)

(: within? :  Real Real Real -> Boolean)
;; tests if two numbers are within a given epsilon of each other
(define (within? a b c)
  (if (< (abs( - a b)) c) #t #f))
(check-expect (within? 3 5 1) #f)
(check-expect (within? 3 5 3) #t)
(check-expect (within? -3 -5 1) #f)
(check-expect (within? -3 -5 3) #t)

(: on-quadratic? : Real Real Real Real Real Real -> Boolean)
#| takes the a b and c coefficients of a quadratic function and x y
and epsilon values to determine if the point (x,y_ is within epsilon of the point
(x,f(x)) |#
(define (on-quadratic? a b c x y e)
  (if (< (abs ( - ( + ( * a ( * x x)) ( * b x) c) y)) e) #t #f))
(check-expect (on-quadratic? 1 2 3 4 26 2) #t)
(check-expect (on-quadratic? 1 2 3 4 25 2) #f)
(check-expect (on-quadratic? -1 -2 -3 -4 -12 2) #t)

;; Problem 2

(: pythagorean? : Integer Integer Integer -> Boolean)
;; determines if the numbers are a pythagorean triple
(define (pythagorean? a b c)
  (if (= ( + (* a a) (* b b)) (* c c)) #t #f))
(check-expect (pythagorean? 3 4 5) #t)
(check-expect (pythagorean? 6 8 10) #t)
(check-expect (pythagorean? 5 12 13) #t)
(check-expect (pythagorean? 3 4 6) #f)

;; Problem 3

(: cm-per-inches Exact-Rational)
(define cm-per-inches 254/100)
(: in->cm : Exact-Rational -> Exact-Rational)
;; converts inches to centimeters
(define (in->cm j)
  ( * j cm-per-inches))
(check-expect (in->cm 1) 254/100)
(check-expect (in->cm 100/254) 1)

(: cm->in : Exact-Rational -> Exact-Rational)
;; converts centimeters to inches
(define (cm->in k)
  ( * k ( / 1 cm-per-inches)))
(check-expect (cm->in 254/100) 1)
(check-expect (cm->in 1) 100/254)

;; Problem 4

(: income-tax : Real -> Integer)
;; calculates income tax based on income
(define (income-tax p)
  (cond
    [ (< p 11500.01) 0]
    [ (< p 45000.01) (exact-ceiling ( * 0.2 ( - p 11500)))] 
    [ (< p 150000.01) (exact-ceiling ( + 6700 ( * 0.4 ( - p 45000))))]
    [ (> p 150000) (exact-ceiling ( + 48700 ( * 0.45 ( - p 150000))))]
    [ else 0]))
(check-expect (income-tax 10000) 0)
(check-expect (income-tax 59724.36) 12590)
(check-expect (income-tax 73593012.9344) 33098056)

;; Problem 5

(: leo : Integer -> Integer)
;; gives the n'th term of the Leonardo sequence (beginning at 0)
(define (leo n)
  (if ( <= n 1 )
      1
      ( + 1 (leo (- n 1)) (leo (- n 2)))))
(check-expect (leo -3) 1)
(check-expect (leo 1) 1)
(check-expect (leo 5) 15)
(check-expect (leo 4) 9)

;; run tests
;;
(test)