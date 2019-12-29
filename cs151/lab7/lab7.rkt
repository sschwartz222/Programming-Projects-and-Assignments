#lang typed/racket

;; CMSC15100 Winter 2018
;; Labratory 7
;; Sam Schwartz

;; load testing infrastructure
;;
(require typed/test-engine/racket-tests)

;; load custom definitions
;;
(require "../include/cs151-core.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Utility types and functions
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A pair of values
;;
(define-struct (Pair A B)
  ([fst : A]
   [snd : B]))

;; An (Option T) is either 'None or (Some x), where x has type T
(define-type (Option T) (U 'None (Some T)))
(define-struct (Some T) ([value : T]))

;; Represents the possible relations between totally-ordered values
(define-type Order (U '< '= '>))

;; The type of a comparison function
(define-type (Cmp A) (A A -> Order))

(: integer-cmp : (Cmp Integer))
;; comparisons of integer keys
;;
(define (integer-cmp a b)
  (cond
    [(< a b) '<]
    [(= a b) '=]
    [else '>]))

(: string-cmp : (Cmp String))
;; comparisons of string keys
;;
(define (string-cmp a b)
  (cond
    [(string<? a b) '<]
    [(string=? a b) '=]
    [else '>]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Binary Trees
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A binary tree is either 'Empty or a (Node l v r), where l and r are binary
;; trees and v is a value
(define-type (Tree A) (U 'Empty (Node A)))

;; A node in a binary tree
(define-struct (Node A)
  ([left : (Tree A)]
   [value : A]
   [right : (Tree A)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Finite Maps
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A finite map from key type K to value type T is represented as the value
;; (Map cmp bst), where cmp is a comparison function that defines a total
;; ordering on keys, and bst is a binary tree annotated with key-value pairs
;; that satisfies the Binary-Search-Tree invariant.
;;
(define-struct (Map K T)
  ([cmp : (Cmp K)]
   [bst : (Tree (Pair K T))]))

(: make-empty-map : (All (K T) (Cmp K) -> (Map K T)))
;; create an empty map from the given comparison
;;
(define (make-empty-map cmp) (Map cmp 'Empty))

(: map-find : (All (K T) (Map K T) K -> (Option T)))
;; apply a finite map to a key (i.e., lookup the key in the map).  Return (Some v)
;; if (Pair key v) is in the map, otherwise return 'None
;;
(define (map-find map key)
  (match map
    [(Map cmp bst)
     (local
       {(: find : (Tree (Pair K T)) -> (Option T))
        ;; search the BST for the key
        (define (find bst)
          (match bst
            ['Empty 'None]
            [(Node l (Pair k v) r)
             (match (cmp key k)
               ['< (find l)]
               ['= (Some v)]
               ['> (find r)])]))}
       (find bst))]))

;; A test map
(define test-map1 : (Map Integer String)
  (Map
   integer-cmp
   (Node
    (Node
     (Node 'Empty (Pair 0 "0") 'Empty)
     (Pair 2 "2")
     (Node 'Empty (Pair 3 "3") 'Empty))
    (Pair 5 "5")
    (Node
     (Node 'Empty (Pair 6 "6") 'Empty)
     (Pair 8 "8")
     (Node 'Empty (Pair 10 "10") 'Empty)))))

(check-expect (map-find ((inst make-empty-map Integer String) integer-cmp) 1) 'None)
(check-expect (map-find test-map1 -1) 'None)
(check-expect (map-find test-map1  0) (Some "0"))
(check-expect (map-find test-map1  1) 'None)
(check-expect (map-find test-map1  2) (Some "2"))
(check-expect (map-find test-map1  3) (Some "3"))
(check-expect (map-find test-map1  4) 'None)
(check-expect (map-find test-map1  5) (Some "5"))
(check-expect (map-find test-map1  6) (Some "6"))
(check-expect (map-find test-map1  7) 'None)
(check-expect (map-find test-map1  8) (Some "8"))
(check-expect (map-find test-map1  9) 'None)
(check-expect (map-find test-map1 10) (Some "10"))
(check-expect (map-find test-map1 11) 'None)

(: map-insert : (All (K T) (Map K T) K T -> (Map K T)))
;; insert the key-value pair into the finite map.
(define (map-insert map key val)
  (match map
    [(Map cmp bst)
     (local
       {(: insert : (Tree (Pair K T)) -> (Tree (Pair K T)))
        ;; helper to insert a node
        (define (insert bst)
          (match bst
            ['Empty (Node 'Empty (Pair key val) 'Empty)]
            [(Node l (Pair k v) r)
             (match (cmp key k)
               ('< (Node (insert  l) (Pair k v) r))
               ('= (Node l (Pair k val) r))
               ('> (Node l (Pair k v) (insert r))))]))}
       (Map cmp (insert bst)))]))
(check-expect (Map-bst (map-insert test-map1 8 "xyz"))
              (Node
               (Node
                (Node 'Empty (Pair 0 "0") 'Empty)
                (Pair 2 "2")
                (Node 'Empty (Pair 3 "3") 'Empty))
               (Pair 5 "5")
               (Node
                (Node 'Empty (Pair 6 "6") 'Empty)
                (Pair 8 "xyz")
                (Node 'Empty (Pair 10 "10") 'Empty))))
(check-expect (Map-bst (map-insert test-map1 4 "zzz"))
              (Node
               (Node
                (Node 'Empty (Pair 0 "0") 'Empty)
                (Pair 2 "2")
                (Node 'Empty (Pair 3 "3") (Node 'Empty (Pair 4 "zzz") 'Empty)))
               (Pair 5 "5")
               (Node
                (Node 'Empty (Pair 6 "6") 'Empty)
                (Pair 8 "8")
                (Node 'Empty (Pair 10 "10") 'Empty))))

(: bst-remove-min : (All (A) (Tree A) -> (Pair A (Tree A))))
;; remove the minimum node from a non-empty BST.  Return a pair of the node's
;; value and the residual tree.
(define (bst-remove-min tree)
  (match tree
    ['Empty (error "bst-remove-min: expected non-empty tree")]
    [(Node l v r)
     (local
       {(: find-min : (Tree A) -> A)
        ;; finds the minimum node by moving left
        (define (find-min l)
          (match l
            ['Empty v]
            [(Node 'Empty val rt) val]
            [(Node lf val rt) (find-min lf)]))
        (: min-tree : (Tree A) -> (Tree A))
        ;; gets the residual tree after find-min
        (define (min-tree tree)
          (match tree
            [(Node 'Empty v 'Empty) 'Empty]
            [(Node 'Empty v r) r]
            [(Node l v r) (Node (min-tree l) v r)]))}
       (Pair (find-min l) (min-tree tree)))]))
(check-expect (bst-remove-min (Map-bst test-map1))
              (Pair (Pair 0 "0")
                    (Node
                     (Node
                      'Empty
                      (Pair 2 "2")
                      (Node 'Empty (Pair 3 "3") 'Empty))
                     (Pair 5 "5")
                     (Node
                      (Node 'Empty (Pair 6 "6") 'Empty)
                      (Pair 8 "8")
                      (Node 'Empty (Pair 10 "10") 'Empty)))))
(check-expect (bst-remove-min (Pair-snd (bst-remove-min (Map-bst test-map1))))
              (Pair (Pair 2 "2")
                    (Node
                     (Node
                      'Empty
                      (Pair 3 "3")
                      'Empty)
                     (Pair 5 "5")
                     (Node
                      (Node 'Empty (Pair 6 "6") 'Empty)
                      (Pair 8 "8")
                      (Node 'Empty (Pair 10 "10") 'Empty)))))
(check-error (bst-remove-min 'Empty)
             "bst-remove-min: expected non-empty tree")

(: bst-remove-root : (All (A) (Tree A) -> (Tree A)))
;; remove the root from the tree and restore the BST structure.  Return 'Empty
;; for the empty tree.
(define (bst-remove-root tree)
  (match tree
    ['Empty 'Empty]
    [(Node 'Empty v 'Empty) 'Empty]
    [(Node l v 'Empty) l]
    [(Node 'Empty v r) r]
    [(Node l v r)
     (local
       {(: root-aux : (Tree A) -> (Tree A))
        ;; helper that removes the root and restores the tree with bst-remove-min
        (define (root-aux tree)
          (Node l (Pair-fst (bst-remove-min r)) (Pair-snd (bst-remove-min r))))}
       (root-aux tree))]))
(check-expect (bst-remove-root (Map-bst test-map1))
              (Node
               (Node
                (Node 'Empty (Pair 0 "0") 'Empty)
                (Pair 2 "2")
                (Node 'Empty (Pair 3 "3") 'Empty))
               (Pair 6 "6")
               (Node
                'Empty
                (Pair 8 "8")
                (Node 'Empty (Pair 10 "10") 'Empty))))
(check-expect (bst-remove-root (bst-remove-root (Map-bst test-map1)))
              (Node
               (Node
                (Node 'Empty (Pair 0 "0") 'Empty)
                (Pair 2 "2")
                (Node 'Empty (Pair 3 "3") 'Empty))
               (Pair 8 "8")
               (Node
                'Empty
                (Pair 10 "10")
                'Empty)))
(check-expect (bst-remove-root 'Empty)
              'Empty)

(: map-remove : (All (K T) (Map K T) K -> (Map K T)))
;; remove the key from the finite map.  If the key is not present, then this
;; operation has no effect on the map.
(define (map-remove map key)
  (match (map-find map key)
    ['None map]
    [(Some T)
     (match map
       [(Map cmp bst)
        (local
          {(: remove-aux : (Tree (Pair K T)) -> (Tree (Pair K T)))
           ;; helper to move down the tree and remove the node with
           ;; the specified key
           (define (remove-aux bst)
             (match bst
               [(Node l (Pair k v) r)
                (match (cmp key k)
                  ('< (Node (remove-aux l) (Pair k v) r))
                  ('= (bst-remove-root bst))
                  ('> (Node l (Pair k v) (remove-aux r))))]))}
          (Map cmp (remove-aux bst)))])]))
(check-expect (Map-bst (map-remove test-map1 2))
              (Node
               (Node
                (Node 'Empty (Pair 0 "0") 'Empty)
                (Pair 3 "3")
                'Empty)
               (Pair 5 "5")
               (Node
                (Node 'Empty (Pair 6 "6") 'Empty)
                (Pair 8 "8")
                (Node 'Empty (Pair 10 "10") 'Empty))))
(check-expect (map-remove test-map1 17)
              test-map1)
(check-expect (Map-bst (map-remove test-map1 10))
              (Node
               (Node
                (Node 'Empty (Pair 0 "0") 'Empty)
                (Pair 2 "2")
                (Node 'Empty (Pair 3 "3") 'Empty))
               (Pair 5 "5")
               (Node
                (Node 'Empty (Pair 6 "6") 'Empty)
                (Pair 8 "8")
                'Empty)))
                       
              
              

;; run tests
;;
(test)