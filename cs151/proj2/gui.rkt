#lang typed/racket

;; CMSC15100 Winter 2018
;; Project 2 -- gui.rkt
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")
(require "../include/cs151-universe.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; include util.rkt
(require "util.rkt")

;; include board.rkt
(require "board.rkt")

;; include moves.rkt
(require "moves.rkt")

;; include ai.rkt
(require "ai.rkt")

;; include render.rkt
(require "render.rkt")

(define-type Strategy (Game -> (U Move 'Skip)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA DEFINITIONS

;; The state of the world, which tracks both the state of the game and the
;; state of the GUI.
;;
(define-struct World
  ([game : Game]                ;; current game state
   [layout : Layout]            ;; the layout used to render the game state
   [mode : UI-Mode]             ;; current GUI mode
   [message : String]           ;; the current message to display
   [human : Player]             ;; which color is the human playing?
   [computer : Strategy]))      ;; the computer player

;; the various GUI modes (or states)
;;
(define-type UI-Mode
  (U 'quit                      ;; mode when the user has quit the game
     'waiting-for-human         ;; mode when it is the human player's turn
     'waiting-for-computer      ;; mode when it is the computer's turn
     Winner))                   ;; mode when the game is over

;; GUI state when the game is over; either there is a winner or
;; it is a draw
;;
(define-type Winner (U Player 'draw))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GUI

(: default-message : Player UI-Mode -> String)
;; map a human player and mode to a default message
;;
(define (default-message human mode)
  (match mode
    ['quit ""]
    ['waiting-for-human "Your turn... "]
    ['waiting-for-computer "I'm thinking... "]
    ['draw "It's a draw... "]
    [_ (if (symbol=? mode human)"You win! " "I win!  ")]))

;; cell size for interactive game
(define cell-size : Natural 50)

;; padding value for interactive game
(define pad-width : Natural 5)

(: make-world : Natural Player Strategy -> World)
;; make an initial world with a board of the specified size.  The specified
;; player will be the human.
;;
(define (make-world board-sz human computer)
  (local
    {(define mode : UI-Mode (if (symbol=? human 'black)
                                'waiting-for-human
                                'waiting-for-computer))}
    (World (make-game board-sz)
           (make-layout pad-width board-sz cell-size)
           mode
           (default-message human mode)
           human
           computer)))

(define testworld : World (make-world 6 'black first-move))

(: render-world : World -> Image)
;; renders the world
(define (render-world w)
  (game-image (World-game w)
              (World-layout w)
              (World-message w)))
;; eyeball tests
"starting game of size 6"
(render-world (World (make-game 6)
                     (make-layout 10 6 40)
                     'waiting-for-human
                     (default-message 'black 'waiting-for-human)
                     'black
                     maximize-flips))
"starting game of size 8"
(render-world (World (make-game 8)
                     (make-layout 10 8 40)
                     'waiting-for-human
                     (default-message 'black 'waiting-for-human)
                     'black
                     maximize-flips))

(: handle-key : World String -> World)
;; handles the pressing of r and q
(define (handle-key w cmd)
  (match cmd
    ["r" (make-world (cast (Board-size (Game-board (World-game w))) Natural)
                     'black (World-computer w))]
    ["q" (World (World-game w)
                (World-layout w)
                'quit
                (default-message (World-human w) 'quit)
                (World-human w)
                (World-computer w))]
    [_ w]))
(check-expect (symbol=? (World-mode (handle-key testworld "q")) 'quit) #t)
(check-expect (World-game (handle-key testworld "r"))
              (Game grader-b6x6-1 'black))

(: handle-mouse : World Integer Integer String -> World)
;; handles the clicking of a tile
(define (handle-mouse w y x cmd)
  (if (symbol=? (World-mode w) 'waiting-for-human)
      (match cmd
        ["button-down"
         (local
           {(define click-coord (loc->coord (World-layout w) y x))}
           (match click-coord
             ['None (World (World-game w)
                           (World-layout w)
                           (World-mode w)
                           "Invalid move. "
                           (World-human w)
                           (World-computer w))]
             [(Some coord)
              (if ((valid-move? (World-game w)) coord)
                  (World
                   (apply-move
                    (World-game w)
                    (Move (World-human w) coord))
                   (World-layout w)
                   'waiting-for-computer
                   (default-message (World-human w) 'waiting-for-computer)
                   (World-human w)
                   (World-computer w))
                  (World
                   (World-game w)
                   (World-layout w)
                   (World-mode w)
                   "Invalid move. "
                   (World-human w)
                   (World-computer w)))]))]
        [_ w])
      w))
(check-expect
 (World-message (handle-mouse testworld 0 0 "button-down"))
 "Invalid move. ")
(check-expect (World-message (handle-mouse testworld 125 175 "button-down"))
              "I'm thinking... ")

(: movestring : Move -> String)
;; helper for handle tick so the computer's move can be displayed
(define (movestring mv)
  (string-append " My move: (Coord " (number->string (Coord-row (Move-coord mv)))
                 " " (number->string (Coord-col (Move-coord mv))) ") "))

(: handle-tick : World -> World)
;; handles the computer processes during the computer's turn
(define (handle-tick w)
  (local
    {(define mv : (U 'Skip Move) ((World-computer w) (World-game w)))}
    (if (symbol=? (World-mode w) 'waiting-for-computer)
        (if (and (not (symbol? mv)) (move-possible? (World-game w)))
            (if (move-possible? (apply-move (World-game w) mv))
                (World
                 (apply-move (World-game w) mv)
                 (World-layout w)
                 'waiting-for-human
                 (string-append (default-message (World-human w) 'waiting-for-human)
                                (movestring mv)) 
                 (World-human w)
                 (World-computer w))
                (World
                 (skip-move
                  (apply-move (World-game w) mv))
                 (World-layout w)
                 'waiting-for-computer
                 (string-append (default-message
                                  (World-human w) 'waiting-for-computer)
                                (movestring mv))
                 (World-human w)
                 (World-computer w)))
            (if (move-possible? (skip-move (World-game w)))
                (World
                 (skip-move (World-game w))
                 (World-layout w)
                 'waiting-for-human
                 "Go again! "
                 (World-human w)
                 (World-computer w))
                (cond
                  [(< (count-pieces (Game-board (World-game w))
                                    (World-human w))
                      (count-pieces (Game-board (World-game w))
                                    (other-player (World-human w))))
                   (World
                    (World-game w)
                    (World-layout w)
                    (other-player (World-human w))
                    "I win! "
                    (World-human w)
                    (World-computer w))]
                  [(> (count-pieces (Game-board (World-game w))
                                    (World-human w))
                      (count-pieces (Game-board (World-game w))
                                    (other-player (World-human w))))
                   (World
                    (World-game w)
                    (World-layout w)
                    (World-human w)
                    "You win! "
                    (World-human w)
                    (World-computer w))]
                  [else
                   (World
                    (World-game w)
                    (World-layout w)
                    'draw
                    "Draw "
                    (World-human w)
                    (World-computer w))]))) w)))
(check-expect (handle-tick testworld) testworld)
(check-expect
 (World-message
  (handle-tick
   (handle-tick
    (World
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
     (make-layout 5 6 50)
     'waiting-for-computer
     "I'm thinking... "
     'black
     first-move))))
  "I win! ")
                

 (: run : Natural Player Strategy -> World)
 ;; run the game of the given size, human-player color, and computer
 ;; strategy
 ;;
 (define (run board-sz human computer-player)
   (big-bang (make-world board-sz human computer-player) : World
     [name "Othello"]
     [to-draw render-world]
     [on-tick handle-tick]
     [on-mouse handle-mouse]
     [on-key handle-key]
     [stop-when (lambda ([w : World]) (symbol=? (World-mode w) 'quit))]))

 (provide
  run)
               
                  
   
        


 