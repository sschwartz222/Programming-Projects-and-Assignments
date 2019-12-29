#lang typed/racket

;; CMSC15100 Winter 2017
;; Lab 6
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")
(require "../include/cs151-universe.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Utility types and functions
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; a position on the board is referenced by its row and column
;;
(define-struct Pos
  ([row : Integer]
   [col : Integer]))

;; a direction is one of 'Left, 'Right, 'Up, or 'Down
;;
(define-type Direction (U 'Left 'Right 'Up 'Down))

;; a Snake is represented by its current direction, a list of the positions
;; that comprise its body, and a boolean flag that marks if it is alive
;;
(define-struct Snake
  ([dir : Direction]       ;; the direction in which the snake is moving
   [body : (Listof Pos)]   ;; the body of the snake, which is the list
                           ;; of cells that it occupies
   [alive? : Boolean]))    ;; #t when the snake is alive, #f when dead

;; a board is a snake, a list of positions containing food, and the
;; number of ticks.
;; A board should satisfy the invariant that the snake segments do
;; not overlap with the food and that there is at most one piece of
;; food per cell
;;
(define-struct Board
  ([snake : Snake]
   [food : (Listof Pos)]
   [ticks : Integer]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Size parameters
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; the size of a cell in pixels
;;
(define cell-sz : Integer 16)
(define cell-radius : Integer (quotient cell-sz 2))

;; the font size for the score
;;
(define score-font-sz : Integer 18)

;; the size of the board in cells
;;
(define num-rows : Integer 41)
(define num-cols : Integer 41)

;; the center location of the board
;;
(define center-cell : Pos (Pos 20 20))

;; the size of the board in pixels
;;
(define board-wid : Integer (* num-cols cell-sz))
(define board-ht : Integer (* num-rows cell-sz))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Utility types and functions
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; An (Option T) is either 'None or (Some v), where v has type T
(define-type (Option T) (U 'None (Some T)))
(define-struct (Some T) ([value : T]))

(: pos=? : Pos Pos -> Boolean)
;; test two positions for equalkity
;;
(define (pos=? p1 p2)
  (and (= (Pos-col p1) (Pos-col p2)) (= (Pos-row p1) (Pos-row p2))))

(: pos-in-list? : Pos (Listof Pos) -> Boolean)
;; Is a value a member of a list of values?
;;
(define (pos-in-list? p ps)
  (match ps
    ['() #f]
    [(cons q pr) (or (pos=? p q) (pos-in-list? p pr))]))

(: remove-pos : Pos (Listof Pos) -> (Listof Pos))
;; remove an item from a list (if present).  If the item occurs multiple
;; times, only the first occurrence is removed.
;;
(define (remove-pos x xs)
  (local
    {(: rmv : (Listof Pos) (Listof Pos) -> (Listof Pos))
     ;; try to remove the item from the list.  prefix is the list of
     ;; items seen so far (in reverse order) and ys are the items to
     ;; be searched.
     (define (rmv prefix ys)
       (match ys
         ['() xs] ;; item not in list, so return original list
         [(cons y ys)
          (if (pos=? x y)
              (append (reverse prefix) ys)  ;; remove item
              (rmv (cons y prefix) ys))]))}  ;; keep searching
    (rmv '() xs)))

(: remove-last : (Listof Pos) -> (Listof Pos))
;; remove the last element of a list; returns '() for empty lists
;;
(define (remove-last l)
  (match l
    ['() '()]
    [(list x) '()]
    [(cons x xs) (cons x (remove-last xs))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Board and Snake operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(: kill : Snake -> Snake)
;; kill the snake
;;
(define (kill s) (Snake (Snake-dir s) (Snake-body s) #f))

(: place-food : Snake (Listof Pos) -> (Listof Pos))
;; pick a random location for a new food item, while avoiding cells that are
;; already occupied by the snake or food, and add it to the food list.
;;
(define (place-food snake food)
  (local
    {(define cell (Pos (random num-rows) (random num-cols)))}
    (cond [(or (pos-in-list? cell (Snake-body snake)) (pos-in-list? cell food))
           (place-food snake food)]
          [else (cons cell food)])))

(: neighbor : Pos Direction -> (Option Pos))
;; given a cell c and a direction d, return (Some c2), where c2 is c's neighbor
;; in direction d. If c2 is off the board, then return 'None.
;;
(define (neighbor cell dir)
  (local
    {(: check-cell : Integer Integer -> (Option Pos))
     (define (check-cell r c)
       (if (and (<= 0 r) (< r num-rows) (<= 0 c) (< c num-cols))
           (Some (Pos r c))
           'None))}
    (match dir
      ['Left  (check-cell (Pos-row cell) (- (Pos-col cell) 1))]
      ['Right (check-cell (Pos-row cell) (+ (Pos-col cell) 1))]
      ['Up    (check-cell (- (Pos-row cell) 1) (Pos-col cell))]
      ['Down  (check-cell (+ (Pos-row cell) 1) (Pos-col cell))])))

(check-expect (neighbor (Pos 0 0) 'Up) 'None)
(check-expect (neighbor (Pos 0 0) 'Down) (Some (Pos 1 0)))
(check-expect (neighbor (Pos 0 0) 'Left) 'None)
(check-expect (neighbor (Pos 0 0) 'Right) (Some (Pos 0 1)))

(: set-direction : Board Direction -> Board)
;; set the snake's direction
;;
(define (set-direction b dir)
  (Board
   (Snake dir (Snake-body (Board-snake b)) (Snake-alive? (Board-snake b)))
   (Board-food b)
   (Board-ticks b)))

(: new-board : Integer -> Board)
;; create a new board with the specified amount of food.
;;
(define (new-board food-amount)
  (local
    {(define segs (list center-cell))
     (define snake (Snake 'Up segs true))
     (: make-food : Integer (Listof Pos) -> (Listof Pos))
     (define (make-food n food)
       (cond
         [(= n 0) food]
         [else (make-food (- n 1) (place-food snake food))]))}
    (Board snake (make-food food-amount '()) 0)))

(: score : Board -> Integer)
;; compute the score of the board
;;
(define (score b)
  (max 0
       (- (* 100 (length (Snake-body (Board-snake b)))) (Board-ticks b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Render the board
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; a Y offset to provide room for the score at the top of the window
(define y-offset (+ score-font-sz 2))

(: render-board : Board -> Image)
;; render the board
;;
(define (render-board b)
  (match b
    [(Board (Snake dir body #t) food ticks)
     (foldl (place-circle 'green)
            (foldl (place-circle 'yellow)
                   (place-image (score-text b)
                                (- board-wid
                                   (+ 1 (image-width (score-text b))))
                                10
                                board-background)
                   food)
            body)]))
;; eyeball tests for this at bottom of code
                                   
(: score-text : Board -> Image)
;; render the current score as an image
;;
(define (score-text b)
  (text (number->string (score b)) score-font-sz "white"))

(: place-circle : Image-Color -> Pos Image -> Image)
;; place a circle in a cell
;;
(define (place-circle color)
  (local
    {(define c (circle cell-radius 'solid color))}
    (lambda ([cell : Pos] [scene : Image])
      (local
        {(define x (+ cell-radius (* (Pos-col cell) cell-sz)))
         (define y (+ cell-radius (* (Pos-row cell) cell-sz) y-offset))}
        (place-image c x y scene)))))

;; the background for the board
;;
(define board-background : Image
  (empty-scene board-wid (+ board-ht y-offset) "black"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Simulation
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(: handle-tick : Board -> Board)
;; advance the state of the board by one step
;;
(define (handle-tick b)
  (match b
    [(Board (Snake dir body #t) food tick)
     (match (neighbor (first body) dir)
       ['None (Board (Snake dir body #f) food (+ 1 tick))]
       [(Some p) (if (pos-in-list? p body) (Board (Snake dir body #f)
                                                  food (+ 1 tick))
                     (if (pos-in-list? p food)
                         (Board
                          (Snake dir (cons p body) #t)
                          (place-food (Snake dir (cons p body) #t)
                                      (remove-pos p food)) (+ 1 tick))
                         (Board (Snake dir (cons p (remove-last body)) #t)
                                food (+ 1 tick))))])]))
(check-expect (handle-tick (Board
                            (Snake 'Right (list (Pos 30 30) (Pos 31 30) (Pos 32 30))
                                   #t)
                            (list (Pos 20 20) (Pos 25 25) (Pos 30 37)) 0))
              (Board (Snake 'Right (list (Pos 30 31) (Pos 30 30) (Pos 31 30)) #t)
                     (list (Pos 20 20) (Pos 25 25) (Pos 30 37)) 1))
(check-expect (handle-tick (Board
                            (Snake 'Right (list (Pos 40 40) (Pos 41 40) (Pos 42 40))
                                   #t)
                            (list (Pos 20 20) (Pos 25 25) (Pos 30 37)) 0))
              (Board (Snake 'Right (list (Pos 40 40) (Pos 41 40) (Pos 42 40)) #f)
                     (list (Pos 20 20) (Pos 25 25) (Pos 30 37)) 1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; User controls
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(: handle-key : Board String -> Board)
;; update the direction of the snake based on user input.
;;
(define (handle-key b cmd)
  (match cmd
    ["up" (set-direction b 'Up)]
    ["down" (set-direction b 'Down)]
    ["right" (set-direction b 'Right)]
    ["left" (set-direction b 'Left)]
    [_ b]))

(check-expect (handle-key (Board
                            (Snake 'Right (list (Pos 30 30) (Pos 31 30) (Pos 32 30))
                                   #t)
                            (list (Pos 20 20) (Pos 25 25) (Pos 30 37)) 0) "up")
              (Board
               (Snake 'Up (list (Pos 30 30) (Pos 31 30) (Pos 32 30))
                      #t)
               (list (Pos 20 20) (Pos 25 25) (Pos 30 37)) 0))
(check-expect (handle-key (Board
                            (Snake 'Right (list (Pos 30 30) (Pos 31 30) (Pos 32 30))
                                   #t)
                            (list (Pos 20 20) (Pos 25 25) (Pos 30 37)) 0) "j")
              (Board
               (Snake 'Right (list (Pos 30 30) (Pos 31 30) (Pos 32 30))
                      #t)
               (list (Pos 20 20) (Pos 25 25) (Pos 30 37)) 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Running the program
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(: run : Natural Positive-Real -> Board)
;; run the game with the specified amount of food and the given time between
;; ticks
;;
(define (run food-amount time-per-frame)
  (big-bang (new-board food-amount) : Board
            [name "Snake"]
            [to-draw render-board]
            [on-tick handle-tick time-per-frame]
            [on-key handle-key]
            [stop-when (lambda ([b : Board]) (not (Snake-alive? (Board-snake b))))]))

(: step : Natural -> Board)
;; run the game step by step with the specified amount of food.  This function
;; can be used to test the to-draw, on-key, and handle-tick handlers
;;
(define (step food-amount)
  (big-bang (new-board food-amount) : Board
            [name "Snake"]
            [to-draw render-board]
            [on-key step-update]
            [stop-when (lambda ([b : Board]) (not (Snake-alive? (Board-snake b))))]))

(: step-update : Board String -> Board)
;; update the board state based on user input.  For the arrow keys, set the direction
;; and move the snake one step.  For the <SPACE> key, move the snake one step in its
;; current direction.
;;
(define (step-update b cmd)
  (match cmd
    [" " (handle-tick b)]
    [_ (handle-tick (handle-key b cmd))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Testing
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; run tests
;;
(test)

;; these are eyeball tests for render-board
"new board with no food"
(render-board (new-board 0))
"new board with 100 food"
(render-board (new-board 100))
"new board with 10 food"
(render-board (new-board 10))
"new board with snake of length 3 and some food"
(render-board (Board (Snake 'Right (list (Pos 30 30) (Pos 31 30) (Pos 32 30)) #t)
                     (list (Pos 20 20) (Pos 25 25) (Pos 30 37))
                     0))

;; a relatively real game of snake with a fast moving snake
;; and 1 food on the board at a time
(run 1 .05)

