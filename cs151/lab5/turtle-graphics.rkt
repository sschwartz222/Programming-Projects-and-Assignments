#lang typed/racket

;; CMSC15100 Winter 2018
;; Lab 4
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; A pixel location in an image
(define-struct Point
  ([x : Integer]
   [y : Integer]))

(: point+ : Point Point -> Point)
;; given point1 and point2, returns the summed values of x and y (invididually)
;; as a new point
(define (point+ point1 point2)
  (Point (+ (Point-x point1) (Point-x point2))
         (+ (Point-y point1) (Point-y point2))))
(check-expect (point+ (Point 2 2) (Point -4 6)) (Point -2 8))
(check-expect (point+ (Point 2 -7) (Point 30 0)) (Point 32 -7))
(check-expect (point+ (Point 2 2) (Point 0 0)) (Point 2 2))
(check-expect (point+ (Point -1 -18) (Point 17 -6)) (Point 16 -24))

(: point- : Point Point -> Point)
;; given point1 and point2, returns the subtracted values of x and y (invididually)
;; as a new point
(define (point- point1 point2)
  (Point (- (Point-x point1) (Point-x point2))
         (- (Point-y point1) (Point-y point2))))
(check-expect (point- (Point 2 2) (Point -4 6)) (Point 6 -4))
(check-expect (point- (Point 2 -7) (Point 30 0)) (Point -28 -7))
(check-expect (point- (Point 2 2) (Point 0 0)) (Point 2 2))
(check-expect (point- (Point -1 -18) (Point 17 -6)) (Point -18 -12))

;; An direction is clockwise rotation from the X axis
;; measured in degrees and should be in the interval [0,360)
(define-type Direction Real)

(: make-direction : Real -> Direction)
;; normalize a rotation angle to the interval [0,360).
(define (make-direction theta)
  (local
    {(: inc : Real -> Real)
     ;; increment an angle by 360 until it is in the interval [0,360).
     (define (inc theta)
       (if (< theta 0) (inc (+ theta 360)) theta))
     (: dec : Real -> Real)
     (define (dec theta)
       (if (<= 360 theta) (dec (- theta 360)) theta))}
    ;; decrement an angle by 360 until it is in the interval [0,360).
    (cond
      [(< theta 0) (inc (+ theta 360))]
      [(<= 360 theta) (dec (- theta 360))]
      [else theta])))

(: direction-rotate : Direction Real -> Direction)
;; rotate the direction clockwise by the specified number of degrees
;; The result will be in the interval [0,360).
(define (direction-rotate direction offset)
  (make-direction (+ direction offset)))
(check-expect (direction-rotate 80 523) 243)
(check-expect (direction-rotate -63 -253) 44)
(check-expect (direction-rotate 360 0) 0)

(: point-move : Point Direction Integer -> Point)
;; given a point, direction, and distance, it will move the point
;; to a new location (this can be negative, as it will just be flipped)
(define (point-move point direction distance)
  (Point (+ (Point-x point) (exact-round (* distance (cos (degrees->radians direction)))))
  (+ (Point-y point) (exact-round (* distance (sin (degrees->radians direction)))))))
(check-expect (point-move (Point 1 2) 45 5) (Point 5 6))
(check-expect (point-move (Point -1 -4) 180 7) (Point -8 -4))
(check-expect (point-move (Point 5 5) -135 7) (Point 0 0))

;; a 2D drawing surface that supports negative coordinates
(define-struct Surface
  ([offset : Point]     ;; value to subtract from points to account for negative coords
   [img : Image]))

;; A blank surface
(define empty-surface : Surface
  (Surface (Point 0 0) empty-image))

(: draw-line : Surface Point Point (U Image-Color Pen) -> Surface)
;; draw a line on the surface from p1 to p2 using the given color or pen
(define (draw-line surf p1 p2 color-or-pen)
  (local
    {(define offset : Point (Surface-offset surf))
     ;; adjust points by current offset
     (define q1 : Point (point- p1 offset))
     (define q2 : Point (point- p2 offset))
     ;; compute new offset
     (define new-offset : Point
       (Point (min (Point-x offset) (Point-x p1) (Point-x p2))
              (min (Point-y offset) (Point-y p1) (Point-y p2))))}
    (Surface
     new-offset
     (add-line (Surface-img surf)
               (Point-x q1) (Point-y q1)
               (Point-x q2) (Point-y q2)
               color-or-pen))))

;; The representation of a turtle
(define-struct Turtle
  ([pos : Point]                 ;; the turtle's position
   [dir : Direction]             ;; the turtle's orientation
   [pen : (U Image-Color Pen)])) ;; the color/pen used to draw lines

(: make-turtle : (U Image-Color Pen) -> Turtle)
;; make a turtle with the given color/pen at the origin
(define (make-turtle color-or-pen)
  (Turtle (Point 0 0) 0 color-or-pen))

(: turtle-set-pos : Turtle Point -> Turtle)
;; given a turtle and a point, sets the turtle's new position
(define (turtle-set-pos turtle point)
  (Turtle point (Turtle-dir turtle) (Turtle-pen turtle)))
(check-expect (turtle-set-pos (make-turtle "blue") (Point 3 3))
              (Turtle (Point 3 3) 0 "blue"))
(check-expect (turtle-set-pos (make-turtle "blue") (Point -3 -3))
              (Turtle (Point -3 -3) 0 "blue"))

(: turtle-set-dir : Turtle Direction -> Turtle)
;; given a turtle and a direction, sets the turtle's new direction
(define (turtle-set-dir turtle direction)
  (Turtle (Turtle-pos turtle) direction (Turtle-pen turtle)))
(check-expect (turtle-set-dir (make-turtle "blue") 45)
              (Turtle (Point 0 0) 45 "blue"))
(check-expect (turtle-set-dir (make-turtle "blue") 190)
              (Turtle (Point 0 0) 190 "blue"))

(: turtle-set-pen : Turtle (U Image-Color Pen) -> Turtle)
;; given a turtle and a pen color, sets the turtle's new pen color
(define (turtle-set-pen turtle pen)
  (Turtle (Turtle-pos turtle) (Turtle-dir turtle) pen))
(check-expect (turtle-set-pen (make-turtle "blue") "red")
              (Turtle (Point 0 0) 0 "red"))
(check-expect (turtle-set-pen (make-turtle "red") "blue")
              (Turtle (Point 0 0) 0 "blue"))

;; the world consists of the turtle, the drawing surface, and a stack of
;; saved turtles
(define-struct World
  ([turtle : Turtle]             ;; the turtle
   [surf : Surface]              ;; the surface on which the turtle draws lines
   [stack : (Listof Turtle)]))   ;; stack of saved turtles

(: make-world : Turtle -> World)
;; make a world from a turtle and an empty drawing surface
(define (make-world turtle)
  (World turtle empty-surface '()))

(: set-pen : World (U Image-Color Pen) -> World)
;; set the pen of the world's turtle
(define (set-pen wrld pen)
  (World
   (turtle-set-pen (World-turtle wrld) pen)
   (World-surf wrld)
   (World-stack wrld)))

(: forward : Integer World -> World)
;; makes a turtle move forward, draw a line behind it, and set its new position
;; at the end of the line
(define (forward d world)
  (World
   (turtle-set-pos (World-turtle world) (point-move (Turtle-pos (World-turtle world))
                                                    (Turtle-dir (World-turtle world)) d))
   (draw-line (World-surf world) (Turtle-pos (World-turtle world))
                    (point-move (Turtle-pos (World-turtle world))
                                (Turtle-dir (World-turtle world)) d)
                    (Turtle-pen (World-turtle world)))
   (World-stack world)))
;; eyeball tests for forward, turn, move-to, move-by, and get-image are at the bottom

(: turn : Direction World -> World)
;; rotates the world's turtle in a clockwise direction by the given angle
(define (turn d world)
  (World
   (Turtle
    (Turtle-pos (World-turtle world))
    (direction-rotate (Turtle-dir (World-turtle world)) d)
    (Turtle-pen (World-turtle world)))
   (World-surf world)
   (World-stack world)))

(: move-to : Point World -> World)
;; move the world's turtle to the given point without drawing anything
(define (move-to p world)
  (World
   (turtle-set-pos (World-turtle world) p)
   (World-surf world)
   (World-stack world)))

(: move-by : Point World -> World)
;; move the world's turtle by the relative offset without drawing anything
(define (move-by p world)
  (World
   (turtle-set-pos (World-turtle world) (point+ (Turtle-pos (World-turtle world)) p))
   (World-surf world)
   (World-stack world)))

(: get-image : World -> Image)
;; returns the image that the turtle has drawn
(define (get-image world)
  (Surface-img (World-surf world)))

(: save-turtle : World -> World)
;; save the current turtle on the save stack
;;
(define (save-turtle wrld)
  (match wrld
   [(World turtle surf stk) (World turtle surf (cons turtle stk))]))

(: restore-turtle : World -> World)
;; pop the topmost turtle from the stack and make it the current turtle
;;
(define (restore-turtle wrld)
  (match wrld
   [(World _ _ '()) (error "restore-turtle: empty stack")]
   [(World _ surf (cons turtle stk)) (World turtle surf stk)]))
  
;; type exports
;;
(provide
  (struct-out Point)
  Direction
  Turtle
  World)

;; operations on points
(provide
  point+
  point-)

;; operations on turtles
(provide
  Turtle?
  make-turtle)

;; operations on worlds
(provide
  World?
  make-world
  set-pen
  forward
  turn
  move-to
  move-by
  get-image
  save-turtle
  restore-turtle)

;; run tests
;;


