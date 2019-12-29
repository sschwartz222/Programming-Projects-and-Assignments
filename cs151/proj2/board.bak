#lang typed/racket

;; CMSC15100 Winter 2018
;; Project 1 -- board.rkt
;; Sam Schwartz
;;
;; Definition of basic types to represent players, boards, and games.

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS

;; A player is identified by the color of his/her/its pieces
(define-type Player (U 'black 'white))

;; A (Coord r c) specifies the row (r) and column (c) of a board location
(define-struct Coord
  ([row : Integer]
   [col : Integer]))

;; A cell in the board either has a player's piece or is empty ('_)
(define-type Cell (U Player '_))

;; A (Board w cells) represents a (w x w) Othello board, where cells is a
;; list of the cells in the board in row-major order.  We require that w be
;; even and in the range 6..16.
(define-struct Board
  ([size : Integer]            ;; the dimension of the board;
   [cells : (Listof Cell)]))   ;; a list of length size*size

(: other-player : Player -> Player)
;; return the other player
(define (other-player play)
  (match play
    ['black 'white]
    ['white 'black]))
(check-expect (other-player 'black) 'white)
(check-expect (other-player 'white) 'black)

(: cell-is-player? : Player -> (Cell -> Boolean))
;; curried function for testing if a cell holds a player's piece
(define (cell-is-player? p)
  (lambda ([cel : Cell]) (symbol=? p cel)))
(check-expect ((cell-is-player? 'white) 'white) #t)
(check-expect ((cell-is-player? 'white) 'black) #f)
(check-expect ((cell-is-player? 'white) '_) #f)
(check-expect ((cell-is-player? 'black) 'black) #t)

(: player->string : Player -> String)
;; return the name of the player
(define (player->string play)
  (match play
    ['white "White"]
    ['black "Black"]))
(check-expect (player->string 'white) "White")
(check-expect (player->string 'black) "Black")

(: empty-cell? : Cell -> Boolean)
;; is the cell an empty cell?
(define (empty-cell? c)
  (match c
    ['white #f]
    ['black #f]
    ['_ #t]))
(check-expect (empty-cell? '_) #t)
(check-expect (empty-cell? 'black) #f)

(: coord+ : Coord Coord -> Coord)
;; add two coordinates
(define (coord+ c1 c2)
  (Coord (+ (Coord-row c1) (Coord-row c2))
         (+ (Coord-col c1) (Coord-col c2))))
(check-expect (coord+ (Coord 2 3) (Coord 1 7)) (Coord 3 10))
(check-expect (coord+ (Coord 2 3) (Coord -2 -3)) (Coord 0 0))
(check-expect (coord+ (Coord 0 -1) (Coord 0 0)) (Coord 0 -1))

(: make-board : Natural -> Board)
;; make an empty board of the specified width...does not check that size is valid
(define (make-board nat)
  (Board nat (make-list (* nat nat) '_)))
(check-expect (make-board 3) (Board 3 '(_ _ _ _ _ _ _ _ _)))
(check-expect (make-board 0) (Board 0 '()))

(: num-cells : Board -> Integer)
;; return the number of cells in the board
(define (num-cells b)
  (* (Board-size b) (Board-size b)))
(check-expect (num-cells (Board 3 '(_ _ _ _ _ _ _ _ _))) 9)
(check-expect (num-cells (Board 1 '(_))) 1)

(: on-board? : Board Coord -> Boolean)
;; is a position on a board?
(define (on-board? b c)
  (and (< -1 (Coord-row c) (Board-size b))
       (< -1 (Coord-col c) (Board-size b))))
(check-expect (on-board? (Board 3 '(_ _ _ _ _ _ _ _ _)) (Coord 3 3)) #f)
(check-expect (on-board? (Board 3 '(_ _ _ _ _ _ _ _ _)) (Coord 2 2)) #t)
(check-expect (on-board? (Board 3 '(_ _ _ _ _ _ _ _ _)) (Coord -1 -1)) #f)

(: coord->index : Board Coord -> Integer)
;; convert a coordinate to an index into the list of cells for the board
(define (coord->index b c)
  (+ (* (Board-size b) (Coord-row c)) (Coord-col c)))
(check-expect (coord->index (Board 3 '(_ _ _ _ _ _ _ _ _)) (Coord 2 2)) 8)
(check-expect (coord->index (Board 3 '(_ _ _ _ _ _ _ _ _)) (Coord 1 2)) 5)
(check-expect (coord->index (Board 3 '(_ _ _ _ _ _ _ _ _)) (Coord 2 0)) 6)

(: index->coord : Board Integer -> Coord)
;; convert an index into the list of cells to a coordinate
(define (index->coord b int)
  (Coord (truncate (/ int (Board-size b)))
         (remainder int (Board-size b))))
(check-expect (index->coord (Board 3 '(_ _ _ _ _ _ _ _ _)) 8) (Coord 2 2))
(check-expect (index->coord (Board 3 '(_ _ _ _ _ _ _ _ _)) 5) (Coord 1 2))
(check-expect (index->coord (Board 3 '(_ _ _ _ _ _ _ _ _)) 6) (Coord 2 0))
  
(: board-ref : Board Coord -> Cell)
;; return the cell value at the given position
(define (board-ref b c)
  (list-ref (Board-cells b) (coord->index b c)))
(check-expect (board-ref (Board 3 '(_ _ _ _ _ _ _ _ black)) (Coord 2 2)) 'black)
(check-expect (board-ref (Board 3 '(_ _ _ _ _ _ _ _ black)) (Coord 2 1)) '_)
(check-expect (board-ref (Board 3 '(white _ _ _ _ _ _ _ black)) (Coord 0 0)) 'white)

(: board-update : Board Coord Cell -> Board)
;; functional update of a board
(define (board-update b cor cel)
  (Board (Board-size b) (list-set (Board-cells b) (coord->index b cor) cel)))
(check-expect (board-update (Board 3 '(_ _ _ _ _ _ _ _ black)) (Coord 2 2) '_)
              (Board 3 '(_ _ _ _ _ _ _ _ _)))
(check-expect (board-update (Board 3 '(_ _ _ _ _ _ _ _ black)) (Coord 0 0) 'white)
              (Board 3 '(white _ _ _ _ _ _ _ black)))

(: neighbors : Board Coord -> (Listof Coord))
;; return the list of valid neighbors to a position
(define (neighbors b c)
  (local
    {(: allneigh : Board Coord -> (Listof Coord))
     ;; helper that finds all neighbors, regardless of whether they are valid
     (define (allneigh b c)
       (list (Coord (- (Coord-row c) 1)  (- (Coord-col c) 1))
             (Coord (- (Coord-row c) 1)  (Coord-col c))
             (Coord (- (Coord-row c) 1)  (+ (Coord-col c) 1))
             (Coord (Coord-row c) (- (Coord-col c) 1))
             (Coord (Coord-row c) (+ (Coord-col c) 1))
             (Coord (+ (Coord-row c) 1)  (- (Coord-col c) 1))
             (Coord (+ (Coord-row c) 1)  (Coord-col c))
             (Coord (+ (Coord-row c) 1)  (+ (Coord-col c) 1))))}
    (filter (lambda ([cor1 : Coord]) (on-board? b cor1)) (allneigh b c))))
(check-expect (neighbors (Board 3 '(_ _ _ _ _ _ _ _ _)) (Coord 2 2))
              (list (Coord 1 1) (Coord 1 2) (Coord 2 1)))
(check-expect (neighbors (Board 3 '(_ _ _ _ _ _ _ _ _)) (Coord 0 0))
              (list (Coord 0 1) (Coord 1 0) (Coord 1 1)))
(check-expect (neighbors (Board 3 '(_ _ _ _ _ _ _ _ _)) (Coord 1 1))
              (list (Coord 0 0) (Coord 0 1) (Coord 0 2) (Coord 1 0) (Coord 1 2)
                    (Coord 2 0) (Coord 2 1) (Coord 2 2)))

(: count-pieces : Board Player -> Integer)
;; count the pieces on the board belonging to the player
(define (count-pieces b p)
  (length (filter (lambda ([cel : Cell]) ((cell-is-player? p) cel))
                  (Board-cells b))))
(check-expect (count-pieces (Board 2 '(_ _ black white)) 'white) 1)
(check-expect (count-pieces (Board 2 '(black black black white)) 'black) 3)
(check-expect (count-pieces (Board 3 '(_ _ _ _ _ _ _ _ _)) 'white) 0)


;;;;; board.rkt API

;; type exports
(provide
 Player
 (struct-out Coord)
 Cell
 (struct-out Board))

;; operations on players and cells
(provide
 other-player
 cell-is-player?
 player->string
 empty-cell?)

;; operations on coordinates
(provide
 coord+)

;; operations on boards
(provide
 make-board
 (rename-out [Board-size board-size])
 num-cells
 on-board?
 index->coord
 coord->index
 board-ref
 board-update
 neighbors
 count-pieces)

  



