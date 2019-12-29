#lang typed/racket

;; CMSC15100 Winter 2018
;; Lab 3
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; the length of a triangle's edge
(define tri-side : Integer 30)

;; a Pen for drawing the border of a triangle
(define border-pen : Pen (pen 'black 1 'solid 'round 'round))

(: tile : Image-Color -> Image)
;; draw a triangular tile of the given color
(define (tile c)
  (overlay
   (triangle tri-side 'outline border-pen)
   (triangle tri-side 'solid c)))

;; find x-center of an image
(: center-x : Image -> Integer)
(define (center-x image)
  (exact-round ( / (image-width image) 2)))

;; find y-center of an image
(: center-y : Image -> Integer)
(define (center-y image)
  (exact-round ( / (image-height image) 2)))

(: above-offset : Image Real Real Image -> Image)
;; place image i1 above image i2 and then adjust the position
;; of i2 by (x-offset, y-offset). If the images overlap, then
;; i1 will be in front of i2
(define (above-offset i1 x-offset y-offset i2)
  (overlay/offset
   i1
   x-offset
   ( + y-offset (center-y i1) (center-y i2))
   i2))

;;make a diamond by combining two triangles
(: diamond : Image -> Image)
(define (diamond triangle1)
  (above
   triangle1
  (flip-vertical triangle1)))

;; make a pair of diamonds side by side of a certain distance apart
(: tile-pair : Image Integer -> Image)
(define (tile-pair diamond1 n)
  (overlay/offset
   diamond1
   ( * 30 n)
   0
   diamond1))

;; make a v-shape with the diamond pairs
(: draw-v : Image Integer -> Image)
(define (draw-v diamond2 n)
  (if (= n 0)
      diamond2
      (above-offset
       (tile-pair diamond2 n)
       0
       -25.981
       (draw-v diamond2 ( - n 1)))))

;; combine v-shapes to make arms of star
(: draw-arm : Integer Image Image -> Image)
(define (draw-arm n i1 i2)
  (if (= n 0)
      (draw-v i1 0)
      (above-offset
       (if (odd? n) (flip-vertical (draw-v i2 n)) (flip-vertical(draw-v i1 n)))
       0
       ( * -25.981 n)
       (draw-arm ( - n 1) i1 i2))))

;; draw a six-pointed star mosaic using triangular tiles, where the first
;; argument is the inner radius of the star and the other two arguments
;; are the alternating colors of the star.
(: draw-star : Integer Image-Color Image-Color -> Image)
(define (draw-star n color1 color2)
  (if (< n 0) (text "draw-star: star radius must be greater than 0" 30 "indigo") (let ([diamond (put-pinhole
                  (round ( / (image-width (draw-arm n (diamond (tile color1)) (diamond (tile color2)))) 2))
                  0
                  (flip-vertical(draw-arm n (diamond (tile color1)) (diamond (tile color2)))))])
    (clear-pinhole
     (overlay/pinhole
      (rotate (* 60 0) diamond)
      (rotate (* 60 1) diamond)
      (rotate (* 60 2) diamond)
      (rotate (* 60 3) diamond)
      (rotate (* 60 4) diamond)
      (rotate (* 60 5) diamond))))))
   


;; run tests
;;
(test)
;;(draw-arm 4 (diamond (tile "crimson")) (diamond (tile "silver")))
(draw-star 4 "crimson" "silver")
(draw-star -1 "crimson" "silver")

