#lang typed/racket

;; CMSC15100 Winter 2018
;; Lab 2
;; Sam Schwartz

;; include CS151-specific definitions
(require "../include/cs151-core.rkt")

;; include testing framework
(require typed/test-engine/racket-tests)

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

(: valid-date? : Integer Integer Integer -> Boolean)
;; determine whether a given combination is valid, month day year
(define (valid-date? x y z)
  (cond
    [(and (< z 2100) (> z 1899) (= x 2) (leap-year? z) (> y 0) (< y 30)) #t]
    [(and (< z 2100) (> z 1899) (= x 2) (> y 0) (< y 29)) #t]
    [(and (< z 2100) (> z 1899) (= x 1) (> y 0) (< y 32)) #t]
    [(and (< z 2100) (> z 1899) (= x 3) (> y 0) (< y 32)) #t]
    [(and (< z 2100) (> z 1899) (= x 5) (> y 0) (< y 32)) #t]
    [(and (< z 2100) (> z 1899) (= x 7) (> y 0) (< y 32)) #t]
    [(and (< z 2100) (> z 1899) (= x 8) (> y 0) (< y 32)) #t]
    [(and (< z 2100) (> z 1899) (= x 10) (> y 0) (< y 32)) #t]
    [(and (< z 2100) (> z 1899) (= x 12) (> y 0) (< y 32)) #t]
    [(and (< z 2100) (> z 1899) (= x 4) (> y 0) (< y 31)) #t]
    [(and (< z 2100) (> z 1899) (= x 6) (> y 0) (< y 31)) #t]
    [(and (< z 2100) (> z 1899) (= x 9) (> y 0) (< y 31)) #t]
    [(and (< z 2100) (> z 1899) (= x 11) (> y 0) (< y 31)) #t]
    [else #f]))
(check-expect (valid-date? 2 29 2000) #t)
(check-expect (valid-date? 2 29 2001) #f)
(check-expect (valid-date? 1 29 2000) #t)
(check-expect (valid-date? 4 31 2000) #f)
(check-expect (valid-date? 4 30 2000) #t)

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

(: day-of-week : Integer Integer Integer -> String)
;; translate number day of week to name of day
(define (day-of-week x y z)
  (cond
    [(= (number-day-of-week x y z) 0) "Sun"]
    [(= (number-day-of-week x y z) 1) "Mon"]
    [(= (number-day-of-week x y z) 2) "Tues"]
    [(= (number-day-of-week x y z) 3) "Weds"]
    [(= (number-day-of-week x y z) 4) "Thurs"]
    [(= (number-day-of-week x y z) 5) "Fri"]
    [(= (number-day-of-week x y z) 6) "Sat"]
    [else "error"]))
(check-expect (day-of-week 1 12 2018) "Fri")
(check-expect (day-of-week 1 13 2018) "Sat")
(check-expect (day-of-week 1 14 2018) "Sun")
(check-expect (day-of-week 1 15 2018) "Mon")
(check-expect (day-of-week 1 16 2018) "Tues")

(: name-of-month : Integer -> String)
;; convert number of month to name of month
(define (name-of-month x)
  (cond
    [(= x 1) "Jan"]
    [(= x 2) "Feb"]
    [(= x 3) "Mar"]
    [(= x 4) "Apr"]
    [(= x 5) "May"]
    [(= x 6) "Jun"]
    [(= x 7) "Jul"]
    [(= x 8) "Aug"]
    [(= x 9) "Sept"]
    [(= x 10) "Oct"]
    [(= x 11) "Nov"]
    [(= x 12) "Dec"]
    [else "error"]))

(: date->string : Integer Integer Integer -> String)
;; convert numerical date to more convenient representation
(define (date->string x y z)
  (if (valid-date? x y z)
     (string-append (day-of-week x y z) " " (name-of-month x) " "
                    (number->string y) ", " (number->string z))
     "[invalid date]"))
(check-expect (date->string 1 1 2000) "Sat Jan 1, 2000")
(check-expect (date->string 7 8 1980) "Tues Jul 8, 1980")
(check-expect (date->string 10 9 2013) "Weds Oct 9, 2013")
(check-expect (date->string 9 32 2013) "[invalid date]")
      
;; run tests
;;
(test)
