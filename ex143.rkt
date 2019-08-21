;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex143) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; List-of-temperatures -> Number
; computes the average temperature 
(define (average alot)
  (/ (sum alot) (how-many alot)))

(check-expect (average (cons 1 (cons 2 (cons 3 '())))) 2)
 
; List-of-temperatures -> Number 
; adds up the temperatures on the given list 
(define (sum alot)
  (cond
    [(empty? alot) 0]
    [else (+ (first alot) (sum (rest alot)))]))

(check-expect (sum (cons 1 (cons 2 (cons 3 '())))) 6)
 
; List-of-temperatures -> Number 
; counts the temperatures on the given list 
(define (how-many alot)
  (cond
    [(empty? alot) 0]
    [(cons? alot)
     (+ 1 (how-many (rest alot)))]))

(check-expect (how-many (cons 1 (cons 2 (cons 3 '())))) 3)


; (average '()) => error /: division by zero


; List-of-temperatures -> Number
; computes the average temperature of a non-empty list
(define (checked-average alot)
  (if (empty? alot)
      (error "can't calculate the average of an empty list")
      (/ (sum alot) (how-many alot))))

(check-expect (checked-average (cons 1 (cons 2 (cons 3 '())))) 2)
(check-error (checked-average '()))

