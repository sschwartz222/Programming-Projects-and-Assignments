#lang typed/racket

;; CMSC15100 Winter 2018
;; Project 2 -- ai.rkt
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; include board.rkt
(require "board.rkt")

;; include moves.rkt
(require "moves.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS

;; A Strategy is a function for determining a move; it returns
;; 'Skip when there is no move available for the current player
;;
(define-type Strategy (Game -> (U Move 'Skip)))

;; A evaluator evaluates the state of a game for the next player
;; and returns a signed integer value, where zero is neutral, positive
;; values are favorable for the next player, and negative values
;; mean a favorable position for the other player
;;
(define-type Evaluator (Game -> Integer))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STRATEGIES

(: first-move : Strategy)
;; pick the first valid move on the board in order of increasing index
;;
(define (first-move game)
  (local
    {(define brd : Board (Game-board game))
     (define player : Player (Game-next game))
     (: find : Integer (Listof Cell) -> (U Move 'Skip))
     ;; find the first valid move or else return 'Skip
     (define (find ix cells)
       (match cells
         ['() 'Skip]
         [(cons '_ cellr)
          (local {(define mv (Move player (index->coord brd ix)))}
            (if (outflanks? brd mv)
                mv
                (find (+ ix 1) cellr)))]
         [(cons _ cellr) (find (+ ix 1) cellr)]))}
    (find 0 (Board-cells brd))))

(: max-finder : Game (Listof Move) Move -> Move)
;; helper that finds the move that gives the most flips
(define (max-finder g mvs m)
  (match mvs
    [(cons move mover) (if (< (count-flips (Game-board g) m)
                              (count-flips (Game-board g) move))
                           (max-finder g mover move)
                           (max-finder g mover m))]
    ['() m]))
(check-expect (max-finder (Game grader-b8x8-2 'white)
                          (possible-moves (Game grader-b8x8-2 'white))
                          (first (possible-moves (Game grader-b8x8-2 'white))))
              (Move 'white (Coord 1 7)))
(check-expect (max-finder (Game grader-b8x8-2 'black)
                          (possible-moves (Game grader-b8x8-2 'black))
                          (first (possible-moves (Game grader-b8x8-2 'black))))
              (Move 'black (Coord 2 7)))

(: maximize-flips : Strategy)
;; Pick the valid move that causes the maximum number of flips.  If there is more
;; than one move that maximizes flips, then pick the first in cell-index order.
(define (maximize-flips g)
  (local
    {(define possmoves : (Listof Move) (possible-moves g))}
    (if (move-possible? g)
        (max-finder g possmoves (first possmoves))
        'Skip)))
(check-expect (maximize-flips (Game grader-b8x8-2 'white)) (Move 'white (Coord 1 7)))
(check-expect (maximize-flips (Game grader-b8x8-2 'black)) (Move 'black (Coord 2 7)))

(: immediate-tactics : Strategy)
;; if corner is available, then choose it
;; otherwise, if non-corner edge is available, then choose it
;; otherwise choose an interior move
(define (immediate-tactics g)
  (local
    {(define possmoves : (Listof Move) (possible-moves g))
     (define sz : Integer (- (Board-size (Game-board g)) 1))
     (: corner : (Listof Move) -> (Listof Move))
     ;; helper function that checks if a corner move exists
     (define (corner lst)
       (match lst
         [(cons mv mvr)
          (match mv
            [(Move play (Coord y x))
             (if (and (or (= y 0) (= y sz))
                      (or (= x 0) (= x sz)))
                 (cons mv (corner mvr))
                 (corner mvr))])]
         ['() '()]))
     (: edge : (Listof Move) -> (Listof Move))
     ;; helper function that checks if an edge move exists
     (define (edge lst2)
       (match lst2
         [(cons mv mvr)
          (match mv
            [(Move play (Coord y x))
             (if (or (= y 0) (= y sz)
                     (= x 0) (= x sz))
                 (cons mv (edge mvr))
                 (edge mvr))])]
         ['() '()]))}
    (match (corner possmoves)
      ['() (match (edge possmoves)
             ['() (maximize-flips g)]
             [lst (max-finder g lst (first lst))])]
      [lst2 (max-finder g lst2 (first lst2))])))
(check-expect (immediate-tactics
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
                       'black))) (Move 'black (Coord 0 0)))
(check-expect (immediate-tactics
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
                       'white))) (Move 'white (Coord 2 0)))

(: winner : Evaluator)
;; simple evaluator that returns +1 for next player winning, -1 for
;; the other player winning, and 0 otherwise
(define (winner game)
  (if (game-over? game)
      (match game
        [(Game brd player)
         (max -1 (min 1 (- (count-pieces brd player)
                           (count-pieces brd (other-player player)))))])
      0))

(: piece-counting : Evaluator)
;; evaluator that evaulates the board based on number of pieces for each player
(define (piece-counting g)
  (cond
    [(= 1 (winner g)) (* (Board-size (Game-board g))
                         (Board-size (Game-board g)))]
    [(= -1 (winner g)) (* (Board-size (Game-board g))
                          (Board-size (Game-board g)) -1)]
    [else (- (count-pieces (Game-board g) (Game-next g))
             (count-pieces (Game-board g) (Game-next (skip-move g))))]))
(check-expect
 (piece-counting
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
          'black))) -8)
(check-expect
 (piece-counting
  (Game
   (Board 8
          (list 'white '_     '_     'white '_     '_     'white '_
                '_     'white '_     'white '_     'white '_     '_
                '_     '_     'white 'white 'white '_     '_     '_
                'white 'white 'white 'white 'white 'white 'white 'white
                '_     '_     'white 'white 'white '_     '_     '_
                '_     'white '_     'white '_     'white '_     '_
                'white '_     '_     'white '_     '_     'white '_
                '_     '_     '_     'white '_     '_     '_     'white))
   'black)) -64)


(: prefer-edges : Integer -> Evaluator)
;; evaluator similar to piece-counting but gives more weight to edges
(define (prefer-edges i)
  (lambda ([g : Game])
    (local
      {(define sz : Integer (Board-size (Game-board g)))
       (define win : Integer (+ (* 4 (- sz 1) i) (* (- sz 2) (- sz 2))))
       (: help : (Listof Cell) Integer Integer -> Integer)
       ;; runs through a list of cells and their indicies, checking if
       ;; the position is an edge
       (define (help cel pos acc)
         (match cel
           ['() acc]
           [(cons cell cellr)
            (cond
              [(empty-cell? cell) (help cellr (+ 1 pos) acc)]
              [((cell-is-player? (Game-next g)) cell)
               (if
                (or (< pos (- sz 1))
                    (< (- (* sz sz) sz) pos)
                    (= 0 (remainder pos sz))
                    (= (- sz 1) (remainder pos sz)))
                (help cellr (+ 1 pos) (+ acc i))
                (help cellr (+ 1 pos) (+ acc 1)))]
              [else (if
                     (or (< pos (- sz 1))
                         (< (- (* sz sz) sz) pos)
                         (= 0 (remainder pos sz))
                         (= (- sz 1) (remainder pos sz)))
                     (help cellr (+ 1 pos) (- acc i))
                     (help cellr (+ 1 pos) (- acc 1)))])]))}
      (cond
        [(= 1 (winner g)) win]
        [(= -1 (winner g)) (* -1 win)]
        [else (help (Board-cells (Game-board g)) 0 0)]))))
(check-expect
 ((prefer-edges 10)
  (local
    {(define bb 'black) (define ww 'white)}
    (Game (Board 8
                 (list '_ '_ '_ '_ '_ '_ '_ '_
                       '_ ww ww ww ww ww ww ww
                       '_ bb ww ww ww ww ww '_
                       '_ bb bb bb '_ bb '_ '_
                       '_ ww '_ '_ '_ '_ '_ '_
                       '_ bb '_ '_ '_ '_ '_ '_
                       '_ ww '_ '_ '_ '_ '_ ww
                       '_ '_ '_ '_ '_ '_ '_ ww))
          'black))) -37)
(check-expect
 ((prefer-edges 10)
  (Game
   (Board 8
          (list 'white '_     '_     'white '_     '_     'white '_
                '_     'white '_     'white '_     'white '_     '_
                '_     '_     'white 'white 'white '_     '_     '_
                'white 'white 'white 'white 'white 'white 'white 'white
                '_     '_     'white 'white 'white '_     '_     '_
                '_     'white '_     'white '_     'white '_     '_
                'white '_     '_     'white '_     '_     'white '_
                '_     '_     '_     'white '_     '_     '_     'white))
   'black)) -316)

(: prefer-corners-and-edges : Integer Integer -> Evaluator)
;; evaluator that acts like piece-counting but puts more weight on
;; corners and edges
(define (prefer-corners-and-edges c e)
  (lambda ([g : Game])
    (local
      {(define sz : Integer (Board-size (Game-board g)))
       (define win : Integer (+ (* 4 c) (* 4 e (- sz 2)) (* (- sz 2) (- sz 2))))
       (: help : (Listof Cell) Integer Integer -> Integer)
       ;; runs through a list of cells and indicies, checking if the position is
       ;; a corner and then edge
       (define (help cel pos acc)
         (match cel
           ['() acc]
           [(cons cell cellr)
            (cond
              [(empty-cell? cell) (help cellr (+ 1 pos) acc)]
              [((cell-is-player? (Game-next g)) cell)
               (cond
                 [(and (or (<= pos (- sz 1))
                           (<= (- (* sz sz) sz) pos))
                       (or
                        (= 0 (remainder pos sz))
                        (= (- sz 1) (remainder pos sz))))
                  (help cellr (+ 1 pos) (+ acc c))]
                 [(or (< pos (- sz 1))
                      (< (- (* sz sz) sz) pos)
                      (= 0 (remainder pos sz))
                      (= (- sz 1) (remainder pos sz)))
                  (help cellr (+ 1 pos) (+ acc e))]
                 [else (help cellr (+ 1 pos) (+ acc 1))])]
              [else
               (cond
                 [(and (or (<= pos (- sz 1))
                           (<= (- (* sz sz) sz) pos))
                       (or
                        (= 0 (remainder pos sz))
                        (= (- sz 1) (remainder pos sz))))
                  (help cellr (+ 1 pos) (- acc c))]
                 [(or (< pos (- sz 1))
                      (< (- (* sz sz) sz) pos)
                      (= 0 (remainder pos sz))
                      (= (- sz 1) (remainder pos sz)))
                  (help cellr (+ 1 pos) (- acc e))]
                 [else (help cellr (+ 1 pos) (- acc 1))])])]))}
      (cond
        [(= 1 (winner g)) win]
        [(= -1 (winner g)) (* -1 win)]
        [else (help (Board-cells (Game-board g)) 0 0)]))))
(check-expect
 ((prefer-corners-and-edges 10 2)
  (local
    {(define bb 'black) (define ww 'white)}
    (Game (Board 8
                 (list '_ '_ '_ '_ '_ '_ '_ bb
                       '_ ww ww ww ww ww ww ww
                       '_ bb ww ww ww ww ww '_
                       '_ bb bb bb '_ bb '_ '_
                       '_ ww '_ '_ '_ '_ '_ '_
                       '_ bb '_ '_ '_ '_ '_ '_
                       '_ ww '_ '_ '_ '_ '_ bb
                       '_ '_ '_ '_ '_ '_ '_ ww))
          'black))) -7)
(check-expect
 ((prefer-corners-and-edges 10 2)
  (Game
   (Board 8
          (list 'white '_     '_     'white '_     '_     'white '_
                '_     'white '_     'white '_     'white '_     '_
                '_     '_     'white 'white 'white '_     '_     '_
                'white 'white 'white 'white 'white 'white 'white 'white
                '_     '_     'white 'white 'white '_     '_     '_
                '_     'white '_     'white '_     'white '_     '_
                'white '_     '_     'white '_     '_     'white '_
                '_     '_     '_     'white '_     '_     '_     'white))
   'black)) -124)

(: minimax-eval : Evaluator Natural -> Evaluator)
;; helper for minimax that takes an evaluator eval and a maximum search depth d
;; and returns an evaluator that scores boards by peforming a minimax search on them
;; upto d plys and then uses eval to evaulate boards at the leaves of the search
(define (minimax-eval eval d)
  (local
    {(: minimax-help : Game Integer -> Integer)
     ;; implements the actual minimax search
     (define (minimax-help g ply)
       (if (< ply d)
           (match (possible-moves g)
             [(cons mv mvr)
              (foldl (lambda ([m : Move] [min : Integer])
                       (match (- 0 (minimax-help (apply-move g m) (+ ply 1)))
                         [x (if (< x min) x min)]))
                     (- 0 (minimax-help (apply-move g mv) (+ ply 1)))
                     mvr)]
             ['() (- 0 (eval g))])
           (- 0 (eval g))))}
    (lambda ([g : Game]) (- 0 (minimax-help g 0)))))
(check-expect
 ((minimax-eval winner 2)
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black '_     'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'white)) 1)

(: minimax-strategy : Evaluator -> Natural -> Strategy)
;; ((minimax-strategy eval) max-depth) returns a strategy
;; that picks moves by doing a minimax search of max-depth plys
;; and uses the evaluator eval to evaluate the leaves of the search tree.
(define (minimax-strategy eval)
  (lambda ([ply : Natural])
    (lambda ([g : Game])
      (match (possible-moves g)
        ['() 'Skip]
        [(cons mv mvr)
         (local
           {(: choose-best : (Listof Move) Integer Move -> Move)
            ;; choose the best move from a list of moves
            (define (choose-best mvs best-score best-mv)
              (match mvs
                ['() best-mv]
                [(cons move mover)
                 (local
                   {(define next-game : Game (apply-move g move))
                    (define score : Integer ((minimax-eval eval ply) next-game))}
                   (if (< score best-score)
                       (choose-best mover score move)
                       (choose-best mover best-score best-mv)))]))}
           (choose-best mvr ((minimax-eval eval ply) (apply-move g mv)) mv))]))))
(check-expect
 (((minimax-strategy winner) 2)
  (Game (Board 8
               (list 'white '_     '_     'white '_     '_     'white '_
                     '_     'black '_     'black '_     'black '_     '_
                     '_     '_     'black 'black 'black '_     '_     '_
                     'white 'black 'black '_     'black 'black 'black 'white
                     '_     '_     'black 'black 'black '_     '_     '_
                     '_     'black '_     'black '_     'black '_     '_
                     'white '_     '_     'black '_     '_     'black '_
                     '_     '_     '_     'white '_     '_     '_     'white))
        'white)) (Move 'white (Coord 3 3)))
(check-expect
 (((minimax-strategy (prefer-corners-and-edges 5 2)) 0)
  (Game (Board 6
               (list '_ '_ '_ '_ '_ '_
                     '_ '_ '_ 'white 'black '_
                     '_ '_ 'black 'white 'white 'black
                     '_ '_ 'white 'white '_ 'black
                     '_ '_ 'black '_ '_ '_
                     '_ '_ '_ '_ '_ '_))
        'black))
 (Move 'black (Coord 0 2)))

;;;;; ai.rkt API

;; type exports
;;
(provide
 Strategy
 Evaluator)

;; strategies and evaluators
;;
(provide
 first-move
 maximize-flips
 immediate-tactics
 winner
 piece-counting
 prefer-edges
 prefer-corners-and-edges
 minimax-strategy)
              



  
              
     
         
     
     
                             
