;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex138) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A List-of-amounts is one of: 
; – '()
; – (cons PositiveNumber List-of-amounts)
(define ex1 '())
(define ex2 (cons 2 '()))
(define ex3 (cons 3.50 (cons 2 '())))
(define ex4 (cons 420 (cons 3.50 (cons 2 '()))))
(define ex5 (cons 69 (cons 420 (cons 3.50 (cons 2 '())))))


; List-of-amounts -> PositiveNumber
; sums the amounts of money in the list loa
(define (sum loa)
  (cond
    [(empty? loa) 0]
    [(cons? loa)
     (+ (first loa) (sum (rest loa)))]))

(check-expect (sum ex1) 0)
(check-expect (sum ex2) 2)
(check-expect (sum ex3) 5.50)
(check-expect (sum ex4) 425.50)
(check-expect (sum ex5) 494.50)
