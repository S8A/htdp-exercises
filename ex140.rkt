;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex140) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A List-of-booleans is one of:
; - '()
; - (cons Boolean List-of-booleans)
(define ex1 '())
(define ex2 (cons #f '()))
(define ex3 (cons #t (cons #f '())))
(define ex4 (cons #t (cons #t (cons #f '()))))
(define ex5 (cons #f (cons #t (cons #t (cons #f '())))))
(define ex6 (cons #t '()))
(define ex7 (cons #t (cons #t '())))
(define ex8 (cons #t (cons #t (cons #t '()))))


; List-of-booleans -> Boolean
; determines whether all the elements of the list are #true
(define (all-true list)
  (cond
    [(empty? list) #true]
    [(cons? list)
     (and (first list) (all-true (rest list)))]))

(check-expect (all-true ex1) #true)
(check-expect (all-true ex2) #false)
(check-expect (all-true ex3) #false)
(check-expect (all-true ex4) #false)
(check-expect (all-true ex5) #false)
(check-expect (all-true ex6) #true)
(check-expect (all-true ex7) #true)
(check-expect (all-true ex8) #true)


; List-of-booleans -> Boolean
; determines whether at least one element of the list is #true
(define (one-true list)
  (cond
    [(empty? list) #false]
    [(cons? list)
     (or (first list) (one-true (rest list)))]))

(check-expect (one-true ex1) #false)
(check-expect (one-true ex2) #false)
(check-expect (one-true ex3) #true)
(check-expect (one-true ex4) #true)
(check-expect (one-true ex5) #true)
(check-expect (one-true ex6) #true)
(check-expect (one-true ex7) #true)
(check-expect (one-true ex8) #true)


(all-true ex6)
(all-true ex2)
(all-true ex3)
(one-true ex6)
(one-true ex2)
(one-true ex3)
