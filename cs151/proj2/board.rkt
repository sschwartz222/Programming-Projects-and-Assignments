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

(define offsets (list (Coord -1 -1)
                      (Coord -1 0)
                      (Coord -1 1)
                      (Coord 0 -1)
                      (Coord 0 1)
                      (Coord 1 -1)
                      (Coord 1 0)
                      (Coord 1 1)))

(: neighbors : Board Coord -> (Listof Coord))
;; return the list of valid neighbors to a position
(define (neighbors b c)
  (filter (lambda ([cor1 : Coord]) (on-board? b cor1))
          (map (lambda ([cor2 : Coord]) (coord+ c cor2)) offsets)))
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
  (foldl (lambda ([c : Cell] [i : Integer]) (if ((cell-is-player? p) c) (+ i 1) i))
         0 (Board-cells b)))
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

;; provide offsets
(provide offsets)

;; ====== GRADER TESTS for board.rkt =====

"========== GRADER TESTS (board.rkt) =========="

;; first we define some test boards.  We also export these
;; for use in testing moves.rkt and render.rkt
;;
(define grader-b6x6-0 (Board 6 (make-list 36 '_)))
(define grader-b6x6-0+b00  ;; update (0 0) to black
  (local
    {(define bb 'black) (define ww 'white)}
    (Board 6
           (list bb '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_))))
(define grader-b6x6-0+w34  ;; update (3 4) to white
  (local
    {(define bb 'black) (define ww 'white)}
    (Board 6
           (list '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ ww '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_))))
(define grader-b6x6-0+b45  ;; update (4 5) to black
  (local
    {(define bb 'black) (define ww 'white)}
    (Board 6
           (list '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ bb
                 '_ '_ '_ '_ '_ '_))))
(define grader-b6x6-0+b00+w32  ;; update (3 2) to white
  (local
    {(define bb 'black) (define ww 'white)}
    (Board 6
           (list bb '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ ww '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_))))
(define grader-b6x6-1
  (local
    {(define bb 'black) (define ww 'white)}
    (Board 6
           (list '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ ww bb '_ '_
                 '_ '_ bb ww '_ '_
                 '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_))))
(define grader-b8x8-1
  (local
    {(define bb 'black) (define ww 'white)}
    (Board 8
           (list '_ '_ '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_ '_ '_
                 '_ '_ '_ ww bb '_ '_ '_
                 '_ '_ '_ bb ww '_ '_ '_
                 '_ '_ '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_ '_ '_))))
(define grader-b8x8-2
  (local
    {(define bb 'black) (define ww 'white)}
    (Board 8
           (list '_ '_ '_ '_ '_ '_ '_ '_
                 '_ ww bb bb bb bb bb '_
                 '_ bb ww ww ww ww ww '_
                 '_ bb bb bb '_ bb '_ '_
                 '_ ww '_ '_ '_ '_ '_ '_
                 '_ bb '_ '_ '_ '_ '_ '_
                 '_ ww '_ '_ '_ '_ '_ '_
                 '_ '_ '_ '_ '_ '_ '_ '_))))
(define grader-b10x10-0 (Board 10 (make-list 100 '_)))

(: grader-valid-board? : Board -> Boolean)
;; check that a board's size is valid and that it
;; agrees with the length of the cells list
(define (grader-valid-board? b)
  (match b
    [(Board w cells) (and (even? w)
                          (<= 6 w 12)
                          (= (* w w) (length cells)))]))

(: grader-sort-coords : (Listof Coord) -> (Listof Coord))
;; sort a list of coordinates into canonical order; we use this function
;; to ignore differences in order in tests
(define (grader-sort-coords coords)
  (sort coords
        (lambda ([c1 : Coord] [c2 : Coord])
          (or (< (Coord-row c1) (Coord-row c2))
              (and (= (Coord-row c1) (Coord-row c2))
                   (< (Coord-col c1) (Coord-col c2)))))))

;; other-player
(check-expect (other-player 'black) 'white)
(check-expect (other-player 'white) 'black)

;; cell-is-player?
(check-expect ((cell-is-player? 'white) 'white) #t)
(check-expect ((cell-is-player? 'white) 'black) #f)
(check-expect ((cell-is-player? 'white) '_) #f)
(check-expect ((cell-is-player? 'black) 'white) #f)
(check-expect ((cell-is-player? 'black) 'black) #t)
(check-expect ((cell-is-player? 'black) '_) #f)

;; player->string
(check-expect (player->string 'white) "White")
(check-expect (player->string 'black) "Black")

;; empty-cell?
(check-expect (empty-cell? '_) #t)
(check-expect (empty-cell? 'black) #f)
(check-expect (empty-cell? 'white) #f)

;; coord+
(check-expect (coord+ (Coord 1 4) (Coord 2 7)) (Coord 3 11))
(check-expect (coord+ (Coord 1 4) (Coord -2 1)) (Coord -1 5))
(check-expect (coord+ (Coord 0 0) (Coord 2 7)) (Coord 2 7))

;; make-board
(check-expect (make-board 6) grader-b6x6-0)
(check-expect (make-board 10) grader-b10x10-0)

;; num-cells
(check-expect (num-cells grader-b6x6-0) 36)
(check-expect (num-cells grader-b6x6-1) 36)
(check-expect (num-cells grader-b10x10-0) 100)

;; on-board?
(check-expect (on-board? grader-b6x6-0 (Coord 0 0)) #t)
(check-expect (on-board? grader-b6x6-0 (Coord 1 2)) #t)
(check-expect (on-board? grader-b6x6-0 (Coord 0 5)) #t)
(check-expect (on-board? grader-b6x6-0 (Coord 5 0)) #t)
(check-expect (on-board? grader-b6x6-0 (Coord 5 5)) #t)
(check-expect (on-board? grader-b6x6-0 (Coord -1 0)) #f)
(check-expect (on-board? grader-b6x6-0 (Coord 0 -1)) #f)
(check-expect (on-board? grader-b6x6-0 (Coord 5 6)) #f)
(check-expect (on-board? grader-b6x6-0 (Coord 6 5)) #f)
(check-expect (on-board? grader-b6x6-0 (Coord 2 -1)) #f)
(check-expect (on-board? grader-b6x6-0 (Coord -1 6)) #f)

;; coord->index
(check-expect (coord->index grader-b6x6-0 (Coord 0 0)) 0)
(check-expect (coord->index grader-b6x6-0 (Coord 1 2)) 8)
(check-expect (coord->index grader-b6x6-0 (Coord 0 5)) 5)
(check-expect (coord->index grader-b6x6-0 (Coord 5 0)) 30)
(check-expect (coord->index grader-b6x6-0 (Coord 5 5)) 35)

;; index->coord
(check-expect (index->coord grader-b6x6-0 0) (Coord 0 0))
(check-expect (index->coord grader-b6x6-0 8) (Coord 1 2))
(check-expect (index->coord grader-b6x6-0 5) (Coord 0 5))
(check-expect (index->coord grader-b6x6-0 30) (Coord 5 0))
(check-expect (index->coord grader-b6x6-0 35) (Coord 5 5))

;; board-ref
(check-expect (board-ref grader-b6x6-1 (Coord 0 0)) '_)
(check-expect (board-ref grader-b6x6-1 (Coord 0 5)) '_)
(check-expect (board-ref grader-b6x6-1 (Coord 1 2)) '_)
(check-expect (board-ref grader-b6x6-1 (Coord 2 1)) '_)
(check-expect (board-ref grader-b6x6-1 (Coord 2 2)) 'white)
(check-expect (board-ref grader-b6x6-1 (Coord 2 3)) 'black)
(check-expect (board-ref grader-b6x6-1 (Coord 3 2)) 'black)
(check-expect (board-ref grader-b6x6-1 (Coord 3 3)) 'white)
(check-expect (board-ref grader-b6x6-1 (Coord 2 4)) '_)
(check-expect (board-ref grader-b6x6-1 (Coord 4 2)) '_)
(check-expect (board-ref grader-b6x6-1 (Coord 5 0)) '_)
(check-expect (board-ref grader-b6x6-1 (Coord 5 5)) '_)

;; board-update
(check-expect (grader-valid-board? (board-update grader-b6x6-0
                                                 (Coord 0 0) 'white)) #t)
(check-expect (grader-valid-board? (board-update grader-b6x6-0
                                                 (Coord 2 3) 'white)) #t)
(check-expect (grader-valid-board? (board-update grader-b6x6-0
                                                 (Coord 5 5) 'white)) #t)
(check-expect (board-update grader-b6x6-0 (Coord 0 0) 'black) grader-b6x6-0+b00)
(check-expect (board-update grader-b6x6-0 (Coord 3 4) 'white) grader-b6x6-0+w34)
(check-expect (board-update grader-b6x6-0 (Coord 4 5) 'black) grader-b6x6-0+b45)
(check-expect (board-update grader-b6x6-0+b00 (Coord 3 2) 'white)
              grader-b6x6-0+b00+w32)
(check-expect (board-update grader-b6x6-0+b00 (Coord 0 0) '_) grader-b6x6-0)

;; neighbors
;;   - corners
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 0 0)))
              (list (Coord 0 1) (Coord 1 0) (Coord 1 1)))
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 0 5)))
              (list (Coord 0 4) (Coord 1 4) (Coord 1 5)))
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 5 0)))
              (list (Coord 4 0) (Coord 4 1) (Coord 5 1)))
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 5 5)))
              (list (Coord 4 4) (Coord 4 5) (Coord 5 4)))
;;   - edges
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 0 2)))
              (list (Coord 0 1) (Coord 0 3) (Coord 1 1) (Coord 1 2) (Coord 1 3)))
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 3 0)))
              (list (Coord 2 0) (Coord 2 1) (Coord 3 1) (Coord 4 0) (Coord 4 1)))
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 4 5)))
              (list (Coord 3 4) (Coord 3 5) (Coord 4 4) (Coord 5 4) (Coord 5 5)))
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 5 1)))
              (list (Coord 4 0) (Coord 4 1) (Coord 4 2) (Coord 5 0) (Coord 5 2)))
;;   - interior
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 1 1)))
              (list (Coord 0 0) (Coord 0 1) (Coord 0 2)
                    (Coord 1 0)             (Coord 1 2)
                    (Coord 2 0) (Coord 2 1) (Coord 2 2)))
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 2 3)))
              (list (Coord 1 2) (Coord 1 3) (Coord 1 4)
                    (Coord 2 2)             (Coord 2 4)
                    (Coord 3 2) (Coord 3 3) (Coord 3 4)))
(check-expect (grader-sort-coords (neighbors grader-b6x6-1 (Coord 4 4)))
              (list (Coord 3 3) (Coord 3 4) (Coord 3 5)
                    (Coord 4 3)             (Coord 4 5)
                    (Coord 5 3) (Coord 5 4) (Coord 5 5)))

;; count-pieces
(check-expect (count-pieces grader-b6x6-0 'black) 0)
(check-expect (count-pieces grader-b6x6-0 'white) 0)
(check-expect (count-pieces grader-b6x6-1 'black) 2)
(check-expect (count-pieces grader-b6x6-1 'white) 2)

"========== END GRADER TESTS (board.rkt) =========="

;; ===== END GRADER TESTS =====

;; export grader definitions for testing in other modules
;;
(provide
 grader-b6x6-0
 grader-b6x6-1
 grader-b8x8-1
 grader-b8x8-2
 grader-valid-board?
 grader-sort-coords)
  



