#lang typed/racket

;; CMSC15100 Winter 2018
;; Labratory 5
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; load turtle library
(require "turtle-graphics.rkt")

;; An L-system symbol is represented by a Symbol, where
;; the following symbols have special interpretation:
;;    '<<     -- push/save turtle state
;;    '>>     -- pop/restore turtle state
;;    'F, 'f  -- forward
;;    '-      -- turn left
;;    '+      -- turn right
;;
(define-type LSym Symbol)

;; An L-system string is a list of L-system symbols
;;
(define-type LString (Listof LSym))

;; An L-system rule describes an expansion 'lhs --> rhs'
;;
(define-struct LRule
  ([lhs : Symbol]    ;; left-hand-side symbol to expand
   [rhs : LString])) ;; right-hand-side string to substitute for the lhs symbol

;; An L-system is represented as an initial string, a default turning angle,
;; and a list of rules
;;
(define-struct LSystem
  ([initial : LString]
   [angle : Direction]
   [rules : (Listof LRule)]))

(: lsys-expand-symbol : LSystem Symbol -> LString)
;; Given an L-System and a Symbol, return the expansion of the symbol.
;; Return a singleton list of the symbol itself if it is not the
;; left-hand-side of any rule in the system
(define (lsys-expand-symbol sys sym)
  (local
    {(: lsys-expand-symbol-aux : (Listof LRule) -> LString)
     ;; helper function for expanding a symbol according to the rule
     (define (lsys-expand-symbol-aux lrule)
       (match lrule
         ['() (list sym)]
         [(cons lrule lruler) (if (symbol=? sym (LRule-lhs lrule))
                                  (LRule-rhs lrule)
                                  (lsys-expand-symbol-aux lruler))]))}
    (lsys-expand-symbol-aux (LSystem-rules sys))))
(check-expect (lsys-expand-symbol
               (LSystem (list 'F 'X) 0
                        (list (LRule 'X (list 'X '+ 'Y 'F '+))
                              (LRule 'Y (list '- 'F 'X '- 'Y)))) 'X)
              '(X + Y F +))
(check-expect (lsys-expand-symbol
               (LSystem (list 'F 'X) 0
                        (list (LRule 'X (list 'X '+ 'Y 'F '+))
                              (LRule 'Y (list '- 'F 'X '- 'Y)))) 'Y)
              '(- F X - Y))
(check-expect (lsys-expand-symbol
               (LSystem (list 'F 'X) 0
                        (list (LRule 'X (list 'X '+ 'Y 'F '+))
                              (LRule 'Y (list '- 'F 'X '- 'Y)))) 'F)
              '(F))

(: lsys-expand-string : LSystem LString -> LString)
;; Given an L-System and a string, expand the string's symbols by the
;; rules of the system
(define (lsys-expand-string sys str)
  (match str
    ['() str]
    [(cons sym symr) (append (lsys-expand-symbol sys sym)
                             (lsys-expand-string sys symr))]))
(check-expect (lsys-expand-string
               (LSystem (list 'F 'X) 0
                        (list (LRule 'X (list 'X '+ 'Y 'F '+))
                              (LRule 'Y (list '- 'F 'X '- 'Y))))
               (list 'X 'X 'X))
              '(X + Y F + X + Y F + X + Y F +))
(check-expect (lsys-expand-string
               (LSystem (list 'F 'X) 0
                        (list (LRule 'X (list 'X '+ 'Y 'F '+))
                              (LRule 'Y (list '- 'F 'X '- 'Y))))
               (list 'Y 'Y 'Y))
              '(- F X - Y - F X - Y - F X - Y))
(check-expect (lsys-expand-string
               (LSystem (list 'F 'X) 0
                        (list (LRule 'X (list 'X '+ 'Y 'F '+))
                              (LRule 'Y (list '- 'F 'X '- 'Y))))
               (list 'F 'Y 'X))
              '(F - F X - Y X + Y F +))

(: lsys-expand-to-depth : LSystem Integer -> LString)
;; repeatedly expand the L-system starting from its initial string
;; to the specified depth.  If the depth is <= 0, then return the
;; L-system's initial string
(define (lsys-expand-to-depth sys int)
  (local
    {(: depth-aux : Integer LSystem LString -> LString)
     ;; helper function for counting from the depth to 0 while expanding
     (define (depth-aux int sys str)
       (if (> int 0)
           (depth-aux (- int 1) sys
                      (lsys-expand-string sys str)) str))}
    (depth-aux int sys (LSystem-initial sys))))
(check-expect (lsys-expand-to-depth
               (LSystem (list 'F 'X) 0
                        (list (LRule 'X (list 'X '+ 'Y 'F '+))
                              (LRule 'Y (list '- 'F 'X '- 'Y))))
               2)
              '(F X + Y F + + - F X - Y F +))
(check-expect (lsys-expand-to-depth
               (LSystem (list 'F 'X) 0
                        (list (LRule 'X (list 'X '+ 'Y 'F '+))
                              (LRule 'Y (list '- 'F 'X '- 'Y))))
               1)
              '(F X + Y F +))
(check-expect (lsys-expand-to-depth
               (LSystem (list 'F 'X) 0
                        (list (LRule 'X (list 'X '+ 'Y 'F '+))
                              (LRule 'Y (list '- 'F 'X '- 'Y))))
               0)
              '(F X))

(: lsys-draw : LString Integer Direction (U Image-Color Pen) -> Image)
;; takes a string, an integer distance, an angle theta, and a color/pen as inputs
;; and runs a turtle over the commands in the string to produce an image
(define (lsys-draw str int theta pen)
  (local
    {(: draw-aux : LString World -> World)
     ;; helper function to define the directions
     ;; that should be taken for every symbol
     (define (draw-aux str wrld)
       (match str
         ['() wrld]
         [(cons '- symr) (draw-aux symr (turn (* -1 theta) wrld))]
         [(cons '+ symr) (draw-aux symr (turn theta wrld))]
         [(cons 'F symr) (draw-aux symr (forward int wrld))]
         [(cons 'f symr) (draw-aux symr (forward int wrld))]
         [(cons '<< symr) (draw-aux symr (save-turtle wrld))]
         [(cons '>> symr) (draw-aux symr (restore-turtle wrld))]
         [(cons sym symr) (draw-aux symr wrld)]))}
    (get-image (draw-aux str (make-world (make-turtle pen))))))
;; eyeball tests below

(: lsys-render : LSystem Integer Integer (U Image-Color Pen) -> Image)
;; combines the expansion of an Lsystem with the drawing operation
;; to produce an image for an Lsystem expanded to a certain depth
(define (lsys-render sys depth dist pen)
  (lsys-draw (lsys-expand-to-depth sys depth) dist (LSystem-angle sys) pen))
;; eyeball tests below

;; definitions for eyeball tests below
(define moore-curve
  (LSystem
   '(L F L + F + L F L)
   90
   (list
    (LRule 'L '(- R F + L F L + F R -))
    (LRule 'R '(+ L F - R F R - F L +)))))

(define pythagoras-tree
  (LSystem
   '(f)
   45
   (list
    (LRule 'f '(F << + f >> - f))
    (LRule 'F '(F F)))))

(define koch-curve
  (LSystem
   '(F)
   90
   (list
    (LRule 'F '(F + F - F - F + F)))))
           
;; run tests
;;
(test)
;; eyeball tests for draw
(lsys-draw (list 'F 'F '+ 'f 'X '- 'F) 50 90 "blue")
(lsys-draw (list 'F 'F '+ 'f 'X '- 'F) 50 100 "blue")
(lsys-draw (list 'F 'F '+ 'f 'X '- 'F) 50 -90 "blue")
;; draw a crimson square
(lsys-draw (list 'F '+ 'f '+ 'F '+ 'f) 50 90 "crimson")
;; draw a silver triangle
(lsys-draw (list 'f '+ 'f '+ 'F) 100 120 "silver")
;; eyeball tests for render
(lsys-render moore-curve 4 10 "red")
(lsys-render pythagoras-tree 6 10 "darkgreen")
(lsys-render koch-curve 4 10 "blue")