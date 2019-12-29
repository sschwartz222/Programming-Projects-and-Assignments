#lang typed/racket

;; CMSC15100 Winter 2018
;; Homework 2
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

;; The days of the week
(define-type Weekday (U 'Sun 'Mon 'Tue 'Wed 'Thu 'Fri 'Sat))

;; Representation of dates
(define-struct Date
  ([month : Integer]    ;; value from 1..12 that represents January, ...
   [day : Integer]      ;; value from 1..31 that represents the day of the month
   [year : Integer]))   ;; value from 1900..2199 that represents the year

;; find the value in the trinomial triangle in row x, element y
(: trinomial : Integer Integer -> Integer)
(define (trinomial x y)
  (cond
    [(or (< x 0) (< y 0) (>= y ( + (* x 2) 1))) 0]  
    [(or (= x 0) (= x 1) (= y 0) (= y ( + (* x 2) 1))) 1]
    [else ( + (trinomial ( - x 1) y)
              (trinomial ( - x 1) ( - y 1))
              (trinomial ( - x 1) (- y 2)))]))
(check-expect (trinomial 1 4) 0)
(check-expect (trinomial -1 1) 0)
(check-expect (trinomial 4 3) 16)
(check-expect (trinomial 3 4) 6)
(check-expect (trinomial 2 1) 2)

;; helper function for trinomial-row that determines # of elements in a row
;; and converts the elements to strings
(: row-aux : Integer Integer -> String)
(define (row-aux max i)
  (cond
    [(< i (* 2 max))
     (string-append (number->string (trinomial max i)) " " (row-aux max (+ i 1)))]
    [(= i (* 2 max))
     (string-append "1")]
    [else ""]))
(check-expect (row-aux 1 0) "1 1 1")
(check-expect (row-aux 3 0) "1 3 6 7 6 3 1")
      
;; prints the nth row of the trinomial triangle
(: trinomial-row : Integer -> String)
   (define (trinomial-row n)
     (if (< n 0) (number->string 0) (row-aux n 0)))
(check-expect (trinomial-row -1) "0")
(check-expect (trinomial-row 0) "1")
(check-expect (trinomial-row 3) "1 3 6 7 6 3 1")

;; problem 2

(: leap-year? : Integer -> Boolean)
;; determine whether a year is a leap year
(define (leap-year? z)
  (cond
    [(=(remainder z 400) 0) #t]
    [(=(remainder z 100) 0) #f]
    [(=(remainder z 4) 0) #t]
    [else #f]))
(check-expect (leap-year? 2000) #t)
(check-expect (leap-year? 2004) #t)
(check-expect (leap-year? 2100) #f)
(check-expect (leap-year? 988) #t)
(check-expect (leap-year? 2018) #f)

;; checks whether a given date exists
(: valid-date? : Date -> Boolean)
(define (valid-date? date)
  (or
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 2)
         (leap-year? (Date-year date)) (> (Date-day date) 0) (< (Date-day date) 30))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 2)
         (> (Date-day date) 0) (< (Date-day date) 29))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 1)
         (> (Date-day date) 0) (< (Date-day date) 32))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 3)
         (> (Date-day date) 0) (< (Date-day date) 32))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 5)
         (> (Date-day date) 0) (< (Date-day date) 32))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 7)
         (> (Date-day date) 0) (< (Date-day date) 32))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 8)
         (> (Date-day date) 0) (< (Date-day date) 32))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 10)
         (> (Date-day date) 0) (< (Date-day date) 32))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 12)
         (> (Date-day date) 0) (< (Date-day date) 32))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 4)
         (> (Date-day date) 0) (< (Date-day date) 31))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 6)
         (> (Date-day date) 0) (< (Date-day date) 31))
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 9)
         (> (Date-day date) 0) (< (Date-day date) 31)) 
    (and (< (Date-year date) 2100) (> (Date-year date) 1899) (= (Date-month date) 11)
         (> (Date-day date) 0) (< (Date-day date) 31))))
(check-expect (valid-date? (Date 2 29 2000)) #t)
(check-expect (valid-date? (Date 2 29 2001)) #f)
(check-expect (valid-date? (Date 1 29 2000)) #t)
(check-expect (valid-date? (Date 4 31 2000)) #f)
(check-expect (valid-date? (Date 4 30 2000)) #t)

;; turns a set of three integers into the date form
(: make-date : Integer Integer Integer -> Date)
(define (make-date x y z)
  (if (valid-date? (Date x y z))
  (Date x y z)
  (error "make-date: invalid date")))
(check-expect (make-date 1 23 2018) (Date 1 23 2018))
(check-expect (make-date 2 29 2018) (error "make-date: invalid date"))
(check-expect (make-date 2 29 2016) (Date 2 29 2016))


(: number-day-of-week : Integer Integer Integer -> Integer)
;; find the number day of the week
(define (number-day-of-week x y z)
  (cond
    [(and (= x 1) (leap-year? z))
    (remainder (+ (- z 1900) y (exact-floor ( / z 4))) 7)]
    [(and (= x 2) (leap-year? z))
    (remainder (+ (- z 1900) y 3 (exact-floor ( / z 4))) 7)]
    [(= x 1)
    (remainder (+ (- z 1900) y 1 (exact-floor ( / z 4))) 7)]
    [(= x 2)
    (remainder (+ (- z 1900) y 4 (exact-floor ( / z 4))) 7)]
    [(= x 3)
    (remainder (+ (- z 1900) y 4 (exact-floor ( / z 4))) 7)]
    [(= x 4)
    (remainder (+ (- z 1900) y (exact-floor ( / z 4))) 7)]
    [(= x 5)
    (remainder (+ (- z 1900) y 2 (exact-floor ( / z 4))) 7)]
    [(= x 6)
    (remainder (+ (- z 1900) y 5 (exact-floor ( / z 4))) 7)]
    [(= x 7)
    (remainder (+ (- z 1900) y (exact-floor ( / z 4))) 7)]
    [(= x 8)
    (remainder (+ (- z 1900) y 3 (exact-floor ( / z 4))) 7)]
    [(= x 9)
    (remainder (+ (- z 1900) y 6 (exact-floor ( / z 4))) 7)]
    [(= x 10)
    (remainder (+ (- z 1900) y 1 (exact-floor ( / z 4))) 7)]
    [(= x 11)
    (remainder (+ (- z 1900) y 4 (exact-floor ( / z 4))) 7)]
    [(= x 12)
    (remainder (+ (- z 1900) y 6 (exact-floor ( / z 4))) 7)]
    [else remainder (+ (- z 1900) y 6 (exact-floor ( / z 4))) 7]))

;; enter a date to output the day of the week
(: weekday : Date -> Weekday)
(define (weekday date)
  (if (valid-date? date)
      (cond
    [(= (number-day-of-week (Date-month date) (Date-day date) (Date-year date)) 0) 'Sun]
    [(= (number-day-of-week (Date-month date) (Date-day date) (Date-year date)) 1) 'Mon]
    [(= (number-day-of-week (Date-month date) (Date-day date) (Date-year date)) 2) 'Tue]
    [(= (number-day-of-week (Date-month date) (Date-day date) (Date-year date)) 3) 'Wed]
    [(= (number-day-of-week (Date-month date) (Date-day date) (Date-year date)) 4) 'Thu]
    [(= (number-day-of-week (Date-month date) (Date-day date) (Date-year date)) 5) 'Fri]
    [(= (number-day-of-week (Date-month date) (Date-day date) (Date-year date)) 6) 'Sat]
    [else (error "no")])
  (error "no")))
(check-expect (weekday (Date 1 12 2018)) 'Fri)
(check-expect (weekday (Date 1 13 2018)) 'Sat)
(check-expect (weekday (Date 1 14 2018)) 'Sun)
(check-expect (weekday (Date 1 15 2018)) 'Mon)
(check-expect (weekday (Date 1 16 2018)) 'Tue)

;; checks if date1 is before date2
(: date<? : Date Date -> Boolean)
(define (date<? date1 date2)
  (or
    ( < (Date-year date1) (Date-year date2))
    (and ( = (Date-year date1) (Date-year date2)) ( < (Date-month date1) (Date-month date2)))
    (and ( = (Date-year date1) (Date-year date2)) ( = (Date-month date1) (Date-month date2))
         ( < (Date-day date1) (Date-day date2)))))
(check-expect (date<? (Date 1 23 2018) (Date 1 24 2018)) #t)
(check-expect (date<? (Date 1 23 2018) (Date 1 23 2018)) #f)
(check-expect (date<? (Date 1 23 2018) (Date 1 22 2018)) #f)
(check-expect (date<? (Date 1 23 2018) (Date 1 1 2019)) #t)

;; checks if date1 is after date2
(: date>? : Date Date -> Boolean)
(define (date>? date1 date2)
  (cond
    [(and ( = (Date-year date1) (Date-year date2)) ( = (Date-month date1) (Date-month date2))
         ( = (Date-day date1) (Date-day date2))) #f]
    [(date<? date1 date2) #f]
    [else #t]))
(check-expect (date>? (Date 1 23 2018) (Date 1 24 2018)) #f)
(check-expect (date>? (Date 1 23 2018) (Date 1 23 2018)) #f)
(check-expect (date>? (Date 1 23 2018) (Date 1 22 2018)) #t)
(check-expect (date>? (Date 1 23 2018) (Date 1 1 2019)) #f)

;; checks if date1 is the same as date2
(: date=? : Date Date -> Boolean)
(define (date=? date1 date2)
  (and ( = (Date-year date1) (Date-year date2)) ( = (Date-month date1) (Date-month date2))
         ( = (Date-day date1) (Date-day date2))))
(check-expect (date=? (Date 1 23 2018) (Date 1 24 2018)) #f)
(check-expect (date=? (Date 1 23 2018) (Date 1 23 2018)) #t)
(check-expect (date=? (Date 1 23 2018) (Date 1 22 2018)) #f)
(check-expect (date=? (Date 1 23 2018) (Date 1 1 2019)) #f)

;; Problem 3

(define-struct Cubic
  ([a : Exact-Rational]
   [b : Exact-Rational]
   [c : Exact-Rational]
   [d : Exact-Rational]))

;; input x will be evaluated in the cubic formula according to the cubic coefficients 
(: eval-cubic : Cubic Real -> Real)
(define (eval-cubic f x)
  (+ (* (Cubic-a f) (expt x 3)) (* (Cubic-b f) (expt x 2)) (* (Cubic-c f) x) (Cubic-d f)))
(check-expect (eval-cubic (Cubic 2 2 2 2) 3) 80)
(check-expect (eval-cubic (Cubic 6 5 4 3) 2) 79)
(check-expect (eval-cubic (Cubic -2 -2 -2 -2) -3) 40)

;; displays the cubic formula in a string with numerical values as coefficients
(: cubic->string : Cubic -> String)
(define (cubic->string f)
  (string-append (number->string (Cubic-a f)) "*x^3 + " (number->string (Cubic-b f))
                 "*x^2 + " (number->string (Cubic-c f)) "*x + " (number->string (Cubic-d f))))
(check-expect (cubic->string (Cubic 2 2 2 2)) "2*x^3 + 2*x^2 + 2*x + 2")
(check-expect (cubic->string (Cubic 6 5 4 3)) "6*x^3 + 5*x^2 + 4*x + 3")
(check-expect (cubic->string (Cubic -2 -2 -2 -2)) "-2*x^3 + -2*x^2 + -2*x + -2")

;; finds the coefficients of the derivative of a cubic function
(define-struct Quadratic
  ([a : Exact-Rational]
   [b : Exact-Rational]
   [c : Exact-Rational]))
(: derivative : Cubic -> Quadratic)
(define (derivative cubic)
  (Quadratic (* 3 (Cubic-a cubic)) (* 2 (Cubic-b cubic)) (Cubic-c cubic)))
(check-expect (derivative (Cubic 2 2 2 2)) (Quadratic 6 4 2))
(check-expect (derivative (Cubic -2 -2 -2 -2)) (Quadratic -6 -4 -2))
(check-expect (derivative (Cubic 6 5 4 3)) (Quadratic 18 10 4))

;; run tests
;;
(test)
