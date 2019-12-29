#lang typed/racket

;; CMSC15100 Winter 2018
;; Homework 5
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; Problem 1

(define-struct (RTree A)
  ([value : A]                    ;; the value at a node
   [kids : (Listof (RTree A))]))  ;; the children of the node

(define testtree : (RTree Integer)
  (RTree 1 (list
            (RTree 2 '())
            (RTree 3 (list
                      (RTree 4 (list
                                (RTree 5 '())
                                (RTree 6 '())))
                      (RTree 7 '())))
            (RTree 8 (list
                      (RTree 9 '()))))))

(: rose-size : (All (A) (RTree A) -> Integer))
;; takes a rose tree and returns the number of nodes in the tree
(define (rose-size rtree)
  (local
    {(: rose-help : (RTree A) Integer -> Integer)
     ;; accumulates number of nodes
     (define (rose-help rose n)
       (match rose
         [(RTree val '()) (+ n 1)]
         [(RTree val list)
          (+ (foldl (lambda ([r : (RTree A)] [i : Integer])
                      (rose-help r i)) 1 list) n)]))}
    (foldl (lambda ([t : (RTree A)] [x : Integer]) (rose-help t x)) 0 (list rtree))))
(check-expect (rose-size testtree) 9)
(check-expect (rose-size (RTree 0 '())) 1)

(: rose-map : (All (A B) (A -> B) (RTree A) -> (RTree B)))
;; maps a function over a rose tree
(define (rose-map func rtree)
  (local
    {(: function : (RTree A) (Listof (RTree B)) -> (Listof (RTree B)))
     ;; implements the function
     (define (function rose list)
       (match rose
         [(RTree val '()) (cons (RTree (func val) '()) list)]
         [(RTree val valr)
          (cons (RTree (func val) (foldl (lambda ([r : (RTree A)]
                                                  [l : (Listof (RTree B))])
                                           (function r l))
                                         '() (reverse valr))) list)]))}
    (match rtree
      [(RTree v k)
       (RTree (func v) (foldl (lambda ([tree : (RTree A)] [lst : (Listof (RTree B))])
                                (function tree lst)) '() (reverse k)))])))
(check-expect (rose-map (lambda ([x : Integer]) (* 3 x)) testtree)
              (RTree 3 (list
                        (RTree 6 '())
                        (RTree 9 (list
                                  (RTree 12 (list
                                             (RTree 15 '())
                                             (RTree 18 '())))
                                  (RTree 21 '())))
                        (RTree 24 (list
                                   (RTree 27 '()))))))
(check-expect (rose-map (lambda ([x : Exact-Rational]) (/ x 2)) testtree)
              (RTree 1/2 (list
                          (RTree 1 '())
                          (RTree 3/2 (list
                                      (RTree 2 (list
                                                (RTree 5/2 '())
                                                (RTree 3 '())))
                                      (RTree 7/2 '())))
                          (RTree 4 (list
                                    (RTree 9/2 '()))))))

(: rose-foldl-post : (All (A B) (A B -> B) B (RTree A) -> B))
;; right-to-left post-order reduction of the tree
(define (rose-foldl-post func z rtree)
  (match rtree
    [(RTree v k)
     (local
       {(: values : (RTree A) (Listof A) -> (Listof A))
        ;; helper to be used in foldr
        (define (values rose list)
          (match rose
            [(RTree val '()) (cons val list)]
            [(RTree val kids)
             (cons val
                   (append (foldr (lambda ([tree : (RTree A)] [lst : (Listof A)])
                                    (values tree lst)) '() kids) list))]))}
       (foldr (lambda ([a : A] [b : B]) (func a b)) z
              (cons v (foldr (lambda ([tree : (RTree A)] [lst : (Listof A)])
                               (values tree lst)) '() k))))]))
(check-expect (rose-foldl-post (inst cons Integer) '() testtree)
              '(1 2 3 4 5 6 7 8 9))
(check-expect (rose-foldl-post string-append "" (rose-map number->string testtree))
              "123456789")

(: rose-ormap : (All (A) (A -> Boolean) (RTree A) -> Boolean))
;; ormap-like function for rose trees
(define (rose-ormap func rtree)
  (local
    {(: values : (RTree A) (Listof A) -> (Listof A))
     ;; helper to be used in foldl
     (define (values rose list)
       (match rose
         [(RTree val '()) (cons val list)]
         [(RTree val kids)
          (cons val
                (append (foldr (lambda ([tree : (RTree A)] [lst : (Listof A)])
                                 (values tree lst)) '() kids) list))]))}
    (match rtree
      [(RTree v k)
       (if (func v) #t
           (ormap (lambda ([a : A]) (func a))
                  (foldl (lambda ([tree : (RTree A)] [lst : (Listof A)])
                           (values tree lst)) '() k)))])))
(check-expect (rose-ormap positive? testtree) #t)
(check-expect (rose-ormap negative? testtree) #f)
          
;; Problem 2

;; A polynomial is represented as a list of coefficients, where the
;; value at position i is the coefficient for x^i.  Furthermore,
;; polynomials have the invariant that the last element of the list is
;; guaranteed to be non-zero.
(define-type Polynomial (Listof Exact-Rational))

(: poly-negate : Polynomial -> Polynomial)
;; negate the coefficients of a polynomial
(define (poly-negate poly)
  (map (lambda ([x : Exact-Rational]) (* x -1)) poly))
(check-expect (poly-negate '(2 3 4 1 -1 1/2))
              '(-2 -3 -4 -1 1 -1/2))

(: poly-add : Polynomial Polynomial -> Polynomial)
;; add two polynomials, guaranteeing that the last element is non-zero
(define (poly-add poly1 poly2)
  (local
    {(: check-0 : Polynomial -> Polynomial)
     ;; helper that removes trailing 0's
     (define (check-0 poly)
       (match poly
         ['() '()]
         [(cons z zr)
          (if
           (= 0 (last poly))
           (check-0 (drop poly (length poly)))
           poly)]))}
    (check-0
     (match* (poly1 poly2)
       [('() '()) '()]
       [((cons x xr) '()) (cons x xr)]
       [('() (cons y yr)) (cons y yr)]
       [((cons x xr) (cons y yr)) (cons (+ x y) (poly-add xr yr))]))))

(check-expect (poly-add '(1 2 3 4) '(1 2 3 4 5 6))
              '(2 4 6 8 5 6))
(check-expect (poly-add '(1 2 3 4) '(1 -2 -3 -4))
              '(2))
(check-expect (poly-add '(1 2 3 4) '(1 -2 -3 4))
              '(2 0 0 8))

(: poly-eval : Polynomial -> (Real -> Real))
;; given a polynomial, evaluates it at a given location
(define (poly-eval poly)
  (lambda ([x : Real]) (foldl (lambda ([p : Exact-Rational] [acc : Real])
                                (+ p (* x acc)))
                              0 (reverse poly))))
(check-expect ((poly-eval '(1 2 3 4)) 2)
              49)
(check-expect ((poly-eval '(1 2 3 4)) -2)
              -23)
(check-expect ((poly-eval '(1 2 3 4)) 0)
              1)

(: poly-derivative : Polynomial -> Polynomial)
;; computes the derivative of a polynomial
(define (poly-derivative poly)
  (if (empty? poly)
      '()
      (rest (build-list (length poly)
                        (lambda ([x : Integer]) (* x (list-ref poly x)))))))
(check-expect (poly-derivative '(4 4 4 4)) '(4 8 12))
(check-expect (poly-derivative '()) '())

;; Problem 3

(: halves : (Listof Exact-Rational) -> (Listof Exact-Rational))
;; divide all numbers in the list by two
(define (halves list)
  (map (lambda ([x : Exact-Rational]) (/ x 2)) list))
(check-expect (halves '(1 2 3 -2 4))
              '(1/2 1 3/2 -1 2))
(check-expect (halves '(1/2 1/3 1/4))
              '(1/4 1/6 1/8))
(check-expect (halves '())
              '())

(: scale-list : Number (Listof Number) -> (Listof Number))
;; multiply each element of the list by the first argument
(define (scale-list mult list)
  (map (lambda ([x : Number]) (* x mult)) list))
(check-expect (scale-list 7 '(1 2 3))
              '(7 14 21))
(check-expect (scale-list -2 '(1 2 3))
              '(-2 -4 -6))
(check-expect (scale-list 2 '())
              '())

(: non-zeros : (Listof Integer) -> (Listof Integer))
;; filter out any occurrences of 0 in the list
(define (non-zeros list)
  (remove* '(0) list))
(check-expect (non-zeros '(4 5 3 3 5 0 3 0 0 1))
              '(4 5 3 3 5 3 1))
(check-expect (non-zeros '(0 0 0 0 0))
              '())
(check-expect (non-zeros '())
              '())

(: smaller-than : Real (Listof Real) -> (Listof Real))
;; keep numbers below the threshold and discard others
(define (smaller-than thresh list)
  (filter (lambda ([x : Real]) (< x thresh)) list))
(check-expect (smaller-than 7 '(6 7 8 5 8 7 6))
              '(6 5 6))
(check-expect (smaller-than -1 '(-2 -3 -4 3))
              '(-2 -3 -4))
(check-expect (smaller-than 1 '())
              '())

(: that-many : (Listof Integer) -> (Listof (Listof Integer)))
;; builds a list of lists containing "that many" of each
(define (that-many list)
  (map (lambda ([x : Integer]) (if (> x 0) (make-list x x) '())) list))
(check-expect (that-many '(-2 1 3))
              '(() (1) (3 3 3)))
(check-expect (that-many '(-1 0 1))
              '(() () (1)))
(check-expect (that-many '())
              '())

  

;; run tests
;;
(test)