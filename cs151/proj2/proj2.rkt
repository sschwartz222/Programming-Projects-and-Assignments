#lang typed/racket

;; CMSC15100 Winter 2018
;; Project 2
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; include util.rkt
(require "util.rkt")

;; include board.rkt
(require "board.rkt")

;; include moves.rkt
(require "moves.rkt")

;; include render.rkt
(require "render.rkt")

;; include ai.rkt
(require "ai.rkt")

;; include gui.rkt
(require "gui.rkt")

(: play-game : Boolean Natural Strategy Strategy -> (Listof (U Move 'Skip)))
;; (play-game show-moves size black-player white-player) plays the game of the
;; given size using the specified strategies as computer players.  If show-moves
;; is true, then each move is shown along with the resulting board.  This
;; function returns the list of moves made in the game
;;
(define (play-game show-moves sz black-player white-player)
  (local
    {;; a layout for displaying the board
     (define layout (make-layout 3 sz 30))
     (: lp : Game Strategy Strategy (Listof (U Move 'Skip))
        -> (Listof (U Move 'Skip)))
     ;; loop until the game is done
     (define (lp game player1 player2 moves)
       (local
         {(define mv (player1 game))}
         (cond
           [(Move? mv) (next (apply-move game mv) mv player2 player1 moves)]
           [(game-over? game) (reverse moves)]
           [(next (skip-move game) 'Skip player2 player1 moves)])))
     (: next : Game (U Move 'Skip) Strategy Strategy (Listof (U Move 'Skip))
        -> (Listof (U Move 'Skip)))
     ;; display the move and board if show-moves is true and then continue the game
     (define (next game mv player1 player2 moves)
       (begin
         (if show-moves
             (begin
               (display (match mv
                          ['Skip
                           (string-append (player->string
                                           (Game-next game)) ": skips\n")]
                          [(Move player (Coord r c))
                           (string-append
                            (player->string player)
                            ": (" (number->string r) ", "
                            (number->string c) ")\n")]))
               (display (board-image (Game-board game) layout))
               (newline)
               (lp game player1 player2 (cons mv moves)))
             (lp game player1 player2 (cons mv moves)))))
     ;; the initial game state
     (define game0 : Game (make-game sz))}
    (begin
      (if show-moves
          (begin
            (display (board-image (Game-board game0) layout))
            (newline))
          (void))
      (lp game0 black-player white-player '()))))

;; run tests
(test)
