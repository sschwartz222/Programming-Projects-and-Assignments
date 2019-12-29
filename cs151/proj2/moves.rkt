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

(: flip-help : Board Move Coord Coord (Listof Coord) -> (Listof Coord))
;; helper gets list of coords to flip in a direction
(define (flip-help b m dir cor list)
  (cond
    [(not (on-board? b (coord+ cor dir))) '()]
    [(symbol=? (board-ref b (coord+ cor dir)) '_) '()]
    [(symbol=? (board-ref b (coord+ cor dir)) (Move-player m)) list]
    [else (flip-help b m dir (coord+ cor dir)
                     (cons (coord+ cor dir) list))]))

(: outflanks? : Board Move -> Boolean)
;; determines if a piece outflanks one or more of the opponent's pieces
(define (outflanks? b m)
  (ormap (lambda ([d : Coord]) (not (empty? (flip-help b m d (Move-coord m) '()))))
         offsets))

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
  (foldl (lambda ([e : (Listof Coord)] [f : (Listof Coord)])
           (append e f))
         '()
         (map (lambda ([x : Coord]) (flip-help b m x (Move-coord m) '())) offsets)))
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
    (if (and (not (empty? (flips (Game-board g) m)))
             (empty-cell? (board-ref (Game-board g) (Move-coord m))))
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

(: valid-move? : Game -> Coord -> Boolean)
;; tests if placing a piece at a given position is valid
(define (valid-move? g)
  (lambda ([cor : Coord]) (and (outflanks? (Game-board g)
                                           (Move (Game-next g) cor))
                               (empty-cell? (board-ref (Game-board g) cor)))))
(check-expect
 ((valid-move?
   (Game (Board 8
                (list 'white '_     '_     'white '_     '_     'white '_
                      '_     'black '_     'black '_     'black '_     '_
                      '_     '_     'black 'black 'black '_     '_     '_
                      'white 'black 'black '_     'black 'black 'black 'white
                      '_     '_     'black 'black 'black '_     '_     '_
                      '_     'black '_     'black '_     'black '_     '_
                      'white '_     '_     'black '_     '_     'black '_
                      '_     '_     '_     'white '_     '_     '_     'white))
         'white)) (Coord 3 3)) #t)
(check-expect
 ((valid-move?
   (Game (Board 8
                (list 'white '_     '_     'white '_     '_     'white '_
                      '_     'black '_     'black '_     'black '_     '_
                      '_     '_     'black 'black 'black '_     '_     '_
                      'white 'black 'black '_     'black 'black 'black 'white
                      '_     '_     'black 'black 'black '_     '_     '_
                      '_     'black '_     'black '_     'black '_     '_
                      'white '_     '_     'black '_     '_     'black '_
                      '_     '_     '_     'white '_     '_     '_     'white))
         'white)) (Coord 0 0)) #f)
(check-expect
 ((valid-move?
   (Game (Board 8
                (list 'white '_     '_     'white '_     '_     'white '_
                      '_     'black '_     'black '_     'black '_     '_
                      '_     '_     'black 'black 'black '_     '_     '_
                      'white 'black 'black '_     'black 'black 'black 'white
                      '_     '_     'black 'black 'black '_     '_     '_
                      '_     'black '_     'black '_     'black '_     '_
                      'white '_     '_     'black '_     '_     'black '_
                      '_     '_     '_     'white '_     '_     '_     'white))
         'white)) (Coord -1 -1)) #f)

(: skip-move : Game -> Game)
;; flips the current player in a game
(define (skip-move g)
  (Game
   (Game-board g)
   (other-player (Game-next g))))
(check-expect
 (skip-move
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black '_     'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'white))
 (Game (Board 8
              (list 'white '_     '_     'white '_     '_     'white '_
                    '_     'black '_     'black '_     'black '_     '_
                    '_     '_     'black 'black 'black '_     '_     '_
                    'white 'black 'black '_     'black 'black 'black 'white
                    '_     '_     'black 'black 'black '_     '_     '_
                    '_     'black '_     'black '_     'black '_     '_
                    'white '_     '_     'black '_     '_     'black '_
                    '_     '_     '_     'white '_     '_     '_     'white))
       'black))
(check-expect
 (skip-move
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black '_     'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'black))
 (Game (Board 8
              (list 'white '_     '_     'white '_     '_     'white '_
                    '_     'black '_     'black '_     'black '_     '_
                    '_     '_     'black 'black 'black '_     '_     '_
                    'white 'black 'black '_     'black 'black 'black 'white
                    '_     '_     'black 'black 'black '_     '_     '_
                    '_     'black '_     'black '_     'black '_     '_
                    'white '_     '_     'black '_     '_     'black '_
                    '_     '_     '_     'white '_     '_     '_     'white))
       'white))

(: count-flips : Board Move -> Integer)
;; count the number of flips if the given move is made. Return 0 on
;; invalid moves (e.g., no flips or the square already has a piece in it)
(define (count-flips brd move)
  (match move
    [(Move player start)
     (if (empty-cell? (board-ref brd start))
         (local
           {(: count-flips-in-dir : Coord Integer -> Integer)
            ;; count the number of flips in the specified direction;
            ;; the second argument is an accumulator of the total
            ;; number of flips
            (define (count-flips-in-dir dir nflips)
              (local
                {(: count : Coord Integer -> Integer)
                 ;; helper function for counting flips in the direction dir
                 (define (count coord n)
                   (if (on-board? brd coord)
                       (match (board-ref brd coord)
                         ['_ nflips] ;; not an out-flanking move
                         [p (if (symbol=? p player)
                                (+ n nflips)
                                (count (coord+ coord dir) (+ n 1)))])
                       nflips))} ;; not an out-flanking move
                (count (coord+ start dir) 0)))}
           (foldl count-flips-in-dir 0 offsets))
         0)]))

(: possible-moves : Game -> (Listof Move))
;; returns a list of legal moves
(define (possible-moves g)
  (filter (lambda ([m : Move]) ((valid-move? g) (Move-coord m)))
          (map (lambda ([i : Integer])
                 (Move (Game-next g) (index->coord (Game-board g) i)))
               (build-list (* (Board-size (Game-board g))
                              (Board-size (Game-board g))) (inst values Integer)))))
(check-expect
 (possible-moves
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black '_     'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'white)) (list (Move 'white (Coord 3 3))))
(check-expect
 (possible-moves
  (Game grader-b8x8-1 'black))
 (list (Move 'black (Coord 2 3)) (Move 'black (Coord 3 2)) (Move 'black (Coord 4 5))
       (Move 'black (Coord 5 4))))

(: move-possible? : Game -> Boolean)
;; determines if the next player in a game state has a legal move
(define (move-possible? g)
  (ormap (lambda ([m : Move]) ((valid-move? g) (Move-coord m)))
          (map (lambda ([i : Integer])
                 (Move (Game-next g) (index->coord (Game-board g) i)))
               (build-list (* (Board-size (Game-board g))
                              (Board-size (Game-board g))) (inst values Integer)))))
(check-expect
 (move-possible?
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black '_     'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'white)) #t)
(check-expect
 (move-possible?
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black '_     'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'black)) #f)

(: game-over? : Game -> Boolean)
;; checks if either player has a possible move
(define (game-over? g)
  (not (or (move-possible? g)
           (move-possible? (skip-move g)))))
(check-expect
 (game-over?
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black 'black 'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'white)) #t)
(check-expect
 (game-over?
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black '_     'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'black)) #f)
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

;; project-2 exports
(provide
  valid-move?
  skip-move
  count-flips
  possible-moves
  move-possible?
  game-over?)

;; Grader test game
(define grader-g6x6-1 (Game grader-b6x6-1 'black))
(define grader-g8x8-2 (Game grader-b8x8-2 'black))
(define grader-g8x8-3 (Game grader-b8x8-2 'white))

;; initial-board
(check-expect (initial-board 6) grader-b6x6-1)
(check-expect (grader-valid-board? (initial-board 8)) #t)
(check-expect (grader-valid-board? (initial-board 10)) #t)
(check-expect (grader-valid-board? (initial-board 12)) #t)

;; make-game
(check-expect (make-game 6) (Game grader-b6x6-1 'black))

;; === test outflanks?

;; --- some basics first
(check-expect (outflanks? grader-b8x8-1 (Move 'white (Coord 5 3))) #t)
(check-expect (outflanks? grader-b8x8-1 (Move 'black (Coord 5 3))) #f)
(check-expect (outflanks? grader-b8x8-1 (Move 'white (Coord 4 5))) #f)
(check-expect (outflanks? grader-b8x8-1 (Move 'black (Coord 4 5))) #t)
(check-expect (outflanks? grader-b8x8-1 (Move 'black (Coord 7 7))) #f)
(check-expect (outflanks? grader-b8x8-1 (Move 'white (Coord 7 7))) #f)

;; --- test black in every direction
(check-expect (outflanks? grader-b8x8-2 (Move 'black (Coord 1 0))) #t)
(check-expect (outflanks? grader-b8x8-2 (Move 'black (Coord 0 1))) #t)
(check-expect (outflanks? grader-b8x8-2 (Move 'black (Coord 7 1))) #t)
(check-expect (outflanks? grader-b8x8-2 (Move 'black (Coord 2 7))) #t)  
(check-expect (outflanks? grader-b8x8-2 (Move 'black (Coord 5 0))) #t)
(check-expect (outflanks? grader-b8x8-2 (Move 'black (Coord 0 0))) #t)  
(check-expect (outflanks? grader-b8x8-2 (Move 'black (Coord 3 7))) #t)
(check-expect (outflanks? grader-b8x8-2 (Move 'black (Coord 1 7))) #t)

(check-expect (flips grader-b8x8-1 (Move 'white (Coord 5 3))) (list (Coord 4 3)))
(check-expect (flips grader-b8x8-1 (Move 'black (Coord 5 3))) '())
(check-expect (flips grader-b8x8-1 (Move 'white (Coord 4 5))) '())
(check-expect (flips grader-b8x8-1 (Move 'black (Coord 4 5))) (list (Coord 4 4)))
(check-expect (flips grader-b8x8-1 (Move 'black (Coord 7 7))) '())
(check-expect (flips grader-b8x8-1 (Move 'white (Coord 7 7))) '())
(check-expect (flips grader-b8x8-2 (Move 'black (Coord 1 0)))
              (list (Coord 1 1)))
(check-expect (flips grader-b8x8-2 (Move 'black (Coord 0 1)))
              (list (Coord 1 1)))
(check-expect (grader-sort-coords (flips grader-b8x8-2 (Move 'black (Coord 2 7))))  
              (list (Coord 2 2) (Coord 2 3) (Coord 2 4) (Coord 2 5) (Coord 2 6)))
(check-expect (grader-sort-coords (flips grader-b8x8-2 (Move 'black (Coord 0 0))))  
              (list (Coord 1 1) (Coord 2 2)))
(check-expect (grader-sort-coords (flips grader-b8x8-2 (Move 'black (Coord 3 4))))
              (list (Coord 2 3) (Coord 2 4) (Coord 2 5)))
(check-expect (flips grader-b8x8-2 (Move 'white (Coord 4 6)))
              (list (Coord 3 5)))
(check-expect (flips grader-b8x8-2 (Move 'white (Coord 4 5)))
              (list (Coord 3 5)))
(check-expect (grader-sort-coords (flips grader-b8x8-2 (Move 'white (Coord 1 7))))  
              (list (Coord 1 2) (Coord 1 3) (Coord 1 4) (Coord 1 5) (Coord 1 6)))
(check-expect (grader-sort-coords (flips grader-b8x8-2 (Move 'white (Coord 0 2))))
              (list (Coord 1 2) (Coord 1 3)))

;; apply-move
(check-expect
 (apply-move grader-g6x6-1 (Move 'black (Coord 1 2)))
 (local
   {(define bb 'black) (define ww 'white)}
   (Game (Board 6
                (list '_ '_ '_ '_ '_ '_
                      '_ '_ bb '_ '_ '_
                      '_ '_ bb bb '_ '_
                      '_ '_ bb ww '_ '_
                      '_ '_ '_ '_ '_ '_
                      '_ '_ '_ '_ '_ '_))
         ww)))
(check-expect
 (apply-move grader-g8x8-2 (Move 'black (Coord 3 4)))
 (local
   {(define bb 'black) (define ww 'white)}
   (Game (Board 8
                (list '_ '_ '_ '_ '_ '_ '_ '_
                      '_ ww bb bb bb bb bb '_
                      '_ bb ww bb bb bb ww '_
                      '_ bb bb bb bb bb '_ '_
                      '_ ww '_ '_ '_ '_ '_ '_
                      '_ bb '_ '_ '_ '_ '_ '_
                      '_ ww '_ '_ '_ '_ '_ '_
                      '_ '_ '_ '_ '_ '_ '_ '_))
         'white)))
(check-expect
 (apply-move (Game grader-b8x8-2 'white) (Move 'white (Coord 1 7))) 
 (local
   {(define bb 'black) (define ww 'white)}
   (Game (Board 8
                (list '_ '_ '_ '_ '_ '_ '_ '_
                      '_ ww ww ww ww ww ww ww
                      '_ bb ww ww ww ww ww '_
                      '_ bb bb bb '_ bb '_ '_
                      '_ ww '_ '_ '_ '_ '_ '_
                      '_ bb '_ '_ '_ '_ '_ '_
                      '_ ww '_ '_ '_ '_ '_ '_
                      '_ '_ '_ '_ '_ '_ '_ '_))
         'black)))
(check-expect 
 (apply-move
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black '_     'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'white)
  (Move 'white (Coord 3 3)))
 (Game (Board 8
              (list 'white '_     '_     'white '_     '_     'white '_
                    '_     'white '_     'white '_     'white '_     '_
                    '_     '_     'white 'white 'white '_     '_     '_
                    'white 'white 'white 'white 'white 'white 'white 'white
                    '_     '_     'white 'white 'white '_     '_     '_
                    '_     'white '_     'white '_     'white '_     '_
                    'white '_     '_     'white '_     '_     'white '_
                    '_     '_     '_     'white '_     '_     '_     'white))
       'black))


