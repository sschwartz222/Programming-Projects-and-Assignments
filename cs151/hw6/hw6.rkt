#lang typed/racket

;; CMSC15100 Winter 2018
;; Homework 6
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; Problem 1

(: palindrome? : (Vectorof Integer) -> Boolean)
;; returns #t if its argument is a palindrome
(define (palindrome? vec)
  (local
    {(: palinaux : (Vectorof Integer) Integer -> Boolean)
     ;; helper that checks the symmetrical values for equality
     (define (palinaux vec int)
       (if (< int (- (vector-length vec) 1))
           (if (= (vector-ref vec int)
                  (vector-ref vec (- (vector-length vec) (+ 1 int))))
               (palinaux vec (+ int 1))
               #f)
           #t))}
    (palinaux vec 0)))
(check-expect (palindrome? '#(1)) #t)
(check-expect (palindrome? '#(1 2 3 2 1)) #t)
(check-expect (palindrome? '#(1 2 2 1)) #t)
(check-expect (palindrome? '#(17 24 36 24 17)) #t)
(check-expect (palindrome? '#(1 2 3 4)) #f)
(check-expect (palindrome? '#(1 2 3 2 1 0)) #f)

;; Problem 2

;; An (Option T) is either 'None or (Some v), where v has type T
(define-type (Option T) (U 'None (Some T)))
(define-struct (Some T) ([value : T]))

;; A recursive representation of binary trees
(define-type (Tree A) (U 'Empty (Node A)))
(define-struct (Node A)
  ([left  : (Tree A)]   ;; left child
   [val   : A]          ;; value at this node
   [right : (Tree A)])) ;; right child

;; a vector representation of a complete binary tree
(define-type (VTree A) (Vectorof A))

(: in-tree? : (All (A) (VTree A) Integer -> Boolean))
;; returns true if the given index specifies a node in the tree
(define (in-tree? vtree int)
  (<= 0 int (- (vector-length vtree) 1)))
(check-expect (in-tree? (vector 'A 'B 'E 'C 'D 'F) 0) #t)
(check-expect (in-tree? (vector 'A 'B 'E 'C 'D 'F) 5) #t)
(check-expect (in-tree? (vector 'A 'B 'E 'C 'D 'F) 6) #f)
(check-expect (in-tree? (vector 'A 'B 'E 'C 'D 'F) -1) #f)

(: left-child : (All (A) (VTree A) Integer -> (Option Integer)))
;; returns the index of the specified node's left child
(define (left-child vtree int)
  (if (<= (+ (* 2 int) 1) (- (vector-length vtree) 1))
      (Some (+ (* 2 int) 1))
      'None))
(check-expect (left-child (vector 'A 'B 'E 'C 'D 'F) 1) (Some 3))
(check-expect (left-child (vector 'A 'B 'E 'C 'D 'F) 0) (Some 1))
(check-expect (left-child (vector 'A 'B 'E 'C 'D 'F) 3) 'None)

(: right-child : (All (A) (VTree A) Integer -> (Option Integer)))
;; returns the index of the specified node's right child
(define (right-child vtree int)
  (if (<= (+ (* 2 int) 2) (- (vector-length vtree) 1))
      (Some (+ (* 2 int) 2))
      'None))
(check-expect (right-child (vector 'A 'B 'E 'C 'D 'F) 1) (Some 4))
(check-expect (right-child (vector 'A 'B 'E 'C 'D 'F) 0) (Some 2))
(check-expect (right-child (vector 'A 'B 'E 'C 'D 'F) 3) 'None)

(: parent : (All (A) (VTree A) Integer -> (Option Integer)))
;; returns index of specified node's parent
(define (parent vtree int)
  (if (> int 0)
      (Some (if (odd? int)
                (exact-round (/ (- int 1) 2))
                (exact-round (/ (- int 2) 2))))
      'None))
(check-expect (parent (vector 'A 'B 'E 'C 'D 'F) 1) (Some 0))
(check-expect (parent (vector 'A 'B 'E 'C 'D 'F) 0) 'None)
(check-expect (parent (vector 'A 'B 'E 'C 'D 'F) 3) (Some 1))
(check-expect (parent (vector 'A 'B 'E 'C 'D 'F) 4) (Some 1))

(: path-to-root : (All (A) (VTree A) Integer -> (Listof A)))
;; given a vector tree and the index of a node v in the tree
;; returns the values on the nodes in the path from v to the root
(define (path-to-root vtree int)
  (if (<= 0 int (- (vector-length vtree) 1))
      (match (parent vtree int)
        ['None (cons (vector-ref vtree int) '())]
        [(Some x) (cons (vector-ref vtree int) (path-to-root vtree x))])
      '()))
(check-expect (path-to-root (vector 'A 'B 'E 'C 'D 'F) 1) '(B A))
(check-expect (path-to-root (vector 'A 'B 'E 'C 'D 'F) 0) '(A))
(check-expect (path-to-root (vector 'A 'B 'E 'C 'D 'F) 3) '(C B A))
(check-expect (path-to-root (vector 'A 'B 'E 'C 'D 'F) 4) '(D B A))
(check-expect (path-to-root (vector 'A 'B 'E 'C 'D 'F) -1) '())

(: vtree->tree : (All (A) (VTree A) -> (Tree A)))
;; returns the recursive-tree representation corresponding to the
;; given vector tree
(define (vtree->tree vtree)
  (local
    {(: make-tree : (VTree A) (Option Integer) -> (Tree A))
     ;; gets the value from the index
     (define (make-tree vtree opt)
       (match opt
         ['None 'Empty]
         [(Some x) (Node (make-tree vtree (left-child vtree x)) (vector-ref vtree x)
                         (make-tree vtree (right-child vtree x)))]))}
    (if (> (vector-length vtree) 0) (Node (make-tree vtree (left-child vtree 0))
                                          (vector-ref vtree 0)
                                          (make-tree vtree (right-child vtree 0)))
        'Empty)))
(check-expect (vtree->tree (vector 'A 'B 'E 'C 'D 'F))
              (Node
               (Node
                (Node
                 'Empty
                 'C
                 'Empty)
                'B
                (Node
                 'Empty
                 'D
                 'Empty))
               'A
               (Node
                (Node
                 'Empty
                 'F
                 'Empty)
                'E
                'Empty)))
(check-expect (vtree->tree (vector 'A)) (Node 'Empty 'A 'Empty))
(check-expect (vtree->tree (vector)) 'Empty)
        
;; Problem 3

;; Graph nodes are identified by integer indices and a graph is represented
;; by a vector of adjacency lists
(define-type Graph (Vectorof (Listof Integer)))

(: valid-edge? : Graph -> (Integer Integer -> Boolean))
;; ((valid-edge? g) u v) returns true if u->v is in the graph g
(define (valid-edge? g)
  (lambda ([u : Integer] [v : Integer]) (if (<= 0 u (- (vector-length g) 1))
                                            (ormap (lambda ([x : Integer]) (= x v))
                                                   (vector-ref g u)) #f)))
(check-expect ((valid-edge? (vector '(1 2) '(2) '())) 0 2) #t)
(check-expect ((valid-edge? (vector '(1 2) '(2) '())) 2 0) #f)
(check-expect ((valid-edge? (vector '(1 2) '(2) '())) 1 2) #t)
(check-expect ((valid-edge? (vector '(1 2) '(2) '())) 3 2) #f)
(check-expect ((valid-edge? (vector '())) 0 0) #f)

(: valid-path? : Graph (Listof Integer) -> Boolean)
;; (valid-path? g path) returns true if the path exists in the graph g
(define (valid-path? g path)
  (match path
    ['() #f]
    [(cons x '()) (if (<= 0 x (- (vector-length g) 1)) #t #f)]
    [(cons x xr) (if ((valid-edge? g) x (first xr)) (valid-path? g xr) #f)]))
(check-expect (valid-path? (vector '(1 2) '(2) '()) '(0 1 2)) #t)
(check-expect (valid-path? (vector '(1 2) '(2) '(0)) '(0 2 0 1 2)) #t)
(check-expect (valid-path? (vector '(1 2) '(2) '()) '()) #f)
(check-expect (valid-path? (vector '()) '(0)) #t)
(check-expect (valid-path? (vector '()) '(0 0)) #f)

;; run tests
;;
(test)