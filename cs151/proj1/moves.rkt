#lang typed/racket

;; CMSC15100 Winter 2018
;; Project 1 -- moves.rkt
;; Sam Schwartz
;;
;; Game logic

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; include board.rkt
(require "board.rkt")

;; A game state is a Board and a next player
(define-struct Game
  ([board : Board]
   [next : Player]))

(: initial-board : Natural -> Board)
;; create an initial board of the given size, which should be even and
;; between 6 and 16, and four pieces (two of each color) in the
;; center.  Signal an error if the width is invalid
(define (initial-board nat)
  (if (and (even? nat) (<= 6 nat 16))
      (board-update
       (board-update
        (board-update
         (board-update (make-board nat)
                       (Coord (truncate (/ nat 2))
                              (truncate (- (/ nat 2) 1))) 'black)
         (Coord (truncate (/ nat 2)) (truncate (/ nat 2))) 'white)
        (Coord (truncate (- (/ nat 2) 1)) (truncate (- (/ nat 2) 1))) 'white)
       (Coord (truncate (- (/ nat 2) 1)) (truncate (/ nat 2))) 'black)
      (error "expects an even natural number between 6 and 16")))
(check-expect (initial-board 6) (Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ white black
                                             _ _ _ _ black white _ _ _ _ _ _ _ _
                                             _ _ _ _ _ _)))

(: make-game : Natural -> Game)
;; make a game in its initial state with the specified board width
(define (make-game nat)
  (Game (initial-board nat) 'black))
(check-expect (make-game 6)
              (Game (Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _
                                 _ _ white black _ _
                                 _ _ black white _ _
                                 _ _ _ _ _ _ _ _ _ _ _ _))
                    'black))

;; A move is a player and a position on the board
(define-struct Move
  ([player : Player]
   [coord : Coord]))

(: outflanks? : Board Move -> Boolean)
;; determines if a piece outflanks one or more of the opponent's pieces
(define (outflanks? b m)
  (local
    {(: outflank-help : Coord (Listof Coord) -> (Listof Coord))
     ;; helper for outflanks
     (define (outflank-help dir list)
       (cond
         [(boolean=? (on-board? b (coord+ (Move-coord m) dir)) #f) '()]
         [(symbol=? (board-ref b (coord+ (Move-coord m) dir)) (Move-player m)) list]
         [(symbol=? (board-ref b (coord+ (Move-coord m) dir)) '_) '()]
         [else (outflank-help (coord+ dir dir)
                              (cons (coord+ (Move-coord m) dir) list))]))}
    (if (= (length (append (outflank-help (Coord -1 -1) '())
                           (outflank-help (Coord -1 0) '())
                           (outflank-help (Coord -1 1) '())
                           (outflank-help (Coord 0 -1) '())
                           (outflank-help (Coord 0 1) '())
                           (outflank-help (Coord 1 -1) '())
                           (outflank-help (Coord 1 0) '())
                           (outflank-help (Coord 1 1) '()))) 0) #f #t)))
(check-expect (outflanks? (Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ white black _ _
                                       _ _ black black black _ _ _ _ _ _ _ _ _ _
                                       _ _ _))
                          (Move 'white (Coord 4 2))) #t)
(check-expect (outflanks? (Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ white black _ _
                                       _ _ black black black _ _ _ _ _ _ _ _ _ _
                                       _ _ _))
                          (Move 'white (Coord 4 4))) #t)
(check-expect (outflanks? (Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ white black _ _
                                       _ _ black black black _ _ _ _ _ _ _ _ _ _
                                       _ _ _))
                          (Move 'white (Coord 5 2))) #f)
(check-expect (outflanks? (Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ white black _ _
                                       _ _ black black black _ _ _ _ _ _ _ _ _ _
                                       _ _ _))
                          (Move 'white (Coord 2 4))) #t)
    
(: flips : Board Move -> (Listof Coord))
;; given a board and a move, returns the list of coordinates of cells
;; containing pieces to flip if that move is made
(define (flips b m)
  (local
    {(: outflank-help : Coord (Listof Coord) -> (Listof Coord))
     ;; helper for outflanks
     (define (outflank-help dir list)
       (cond
         [(boolean=? (on-board? b (coord+ (Move-coord m) dir)) #f) '()]
         [(symbol=? (board-ref b (coord+ (Move-coord m) dir)) (Move-player m)) list]
         [(symbol=? (board-ref b (coord+ (Move-coord m) dir)) '_) '()]
         [else (outflank-help (coord+ dir dir)
                              (cons (coord+ (Move-coord m) dir) list))]))}
    (append (outflank-help (Coord -1 -1) '())
            (outflank-help (Coord -1 0) '())
            (outflank-help (Coord -1 1) '())
            (outflank-help (Coord 0 -1) '())
            (outflank-help (Coord 0 1) '())
            (outflank-help (Coord 1 -1) '())
            (outflank-help (Coord 1 0) '())
            (outflank-help (Coord 1 1) '()))))
(check-expect (flips (Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ white black _ _
                                  _ _ black black black _ _ _ _ _ _ _ _ _ _
                                  _ _ _))
                     (Move 'white (Coord 4 2))) (list (Coord 3 2)))
(check-expect (flips(Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ white black _ _
                                 _ _ black black black _ _ _ _ _ _ _ _ _ _
                                 _ _ _))
                    (Move 'white (Coord 4 4))) (list (Coord 3 3)))
(check-expect (flips (Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ white black _ _
                                  _ _ black black black _ _ _ _ _ _ _ _ _ _
                                  _ _ _))
                     (Move 'white (Coord 5 2))) '())
(check-expect (flips (Board 6 '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ white black _ _
                                  _ _ black black black _ _ _ _ _ _ _ _ _ _
                                  _ _ _))
                     (Move 'white (Coord 2 4))) (list (Coord 2 3)))

(: apply-move : Game Move -> Game)
;; applies flips to board
(define (apply-move g m)
  (local
    {(: insert : Integer (Listof Integer) -> (Listof Integer))
     ;; inserts a coord into a list of coords
     (define (insert x xs)
       (match xs
         ['() (list x)]
         [(cons y ys) (if (<= x y)
                          (cons x xs)
                          (cons y (insert x ys)))]))
     (: coords->indices : Move -> (Listof Integer))
     ;; makes list of indices of flips and the move
     (define (coords->indices m)
       (sort (insert (coord->index (Game-board g) (Move-coord m))
                     (map (lambda ([cor : Coord])
                            (coord->index (Game-board g) cor))
                          (flips (Game-board g) m))) <))
     (: update-board : (Listof Integer) -> (Listof Cell))
     ;; updates the board with the tiles of the move's color at the
     ;; index positions
     (define (update-board list)
       (match list
         ['() (Board-cells (Game-board g))]
         [(cons lst lstr) (list-set (update-board lstr) lst
                                    (Move-player m))]))}
    (if (outflanks? (Game-board g) m)
        (Game
         (Board (Board-size (Game-board g))
                (update-board (coords->indices m)))
         (other-player (Move-player m)))
        (error "apply-move: illegal move"))))
(check-expect (apply-move
               (Game
                (Board 6 '(_ _ _ _ _ _
                             _ _ _ _ _ _
                             _ white black white _ _
                             _ _ black black black _
                             _ _ _ _ _ _
                             _ _ _ _ _ _))
                'black)
               (Move 'black (Coord 2 4)))
              (Game (Board 6'(_ _ _ _ _ _
                                _ _ _ _ _ _
                                _ white black black black _
                                _ _ black black black _
                                _ _ _ _ _ _
                                _ _ _ _ _ _))
                    'white))
(check-error (apply-move
              (Game
               (Board 6 '(_ _ _ _ _ _
                            _ _ _ _ _ _
                            _ white black black _ _
                            _ _ black black black _
                            _ _ _ _ _ _
                            _ _ _ _ _ _))
               'black)
              (Move 'black (Coord 0 40)))
             "apply-move: illegal move")     

;;;;; moves.rkt API

;; type exports
;;
(provide
 (struct-out Game)
 (struct-out Move))

;; operations
(provide
 initial-board
 make-game
 outflanks?
 flips
 apply-move)      


