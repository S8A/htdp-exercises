;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex139) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A List-of-amounts is one of: 
; – '()
; – (cons PositiveNumber List-of-amounts)
(define ex1 '())
(define ex2 (cons 2 '()))
(define ex3 (cons 3.50 (cons 2 '())))
(define ex4 (cons 420 (cons 3.50 (cons 2 '()))))
(define ex5 (cons 69 (cons 420 (cons 3.50 (cons 2 '())))))


; A List-of-numbers is one of: 
; – '()
; – (cons Number List-of-numbers)
(define ex6 (cons -1 '()))
(define ex7 (cons 11 (cons -1 '())))
(define ex8 (cons 42 (cons 11 (cons -1 '()))))
(define ex9 (cons -10.9 (cons -33 (cons -45 '()))))


; List-of-numbers -> Boolean
; determines whether all the numbers of the list are positive numbers
(define (pos? list)
  (cond
    [(empty? list) #true]
    [(cons? list)
     (and (>= (first list) 0) (pos? (rest list)))]))

(check-expect (pos? ex1) #true)
(check-expect (pos? ex2) #true)
(check-expect (pos? ex3) #true)
(check-expect (pos? ex4) #true)
(check-expect (pos? ex5) #true)
(check-expect (pos? ex6) #false)
(check-expect (pos? ex7) #false)
(check-expect (pos? ex8) #false)
(check-expect (pos? ex9) #false)

(pos? (cons 5 '()))
(pos? (cons -1 '()))


; List-of-amounts -> PositiveNumber
; sums the amounts of money in the list loa
(define (checked-sum loa)
  (if (pos? loa)
      (cond
        [(empty? loa) 0]
        [(cons? loa)
         (+ (first loa) (checked-sum (rest loa)))])
      (error "checked-sum expects a list of positive amounts")))

(check-expect (checked-sum ex1) 0)
(check-expect (checked-sum ex2) 2)
(check-expect (checked-sum ex3) 5.50)
(check-expect (checked-sum ex4) 425.50)
(check-expect (checked-sum ex5) 494.50)
(check-error (checked-sum ex6))
(check-error (checked-sum ex7))
(check-error (checked-sum ex8))
(check-error (checked-sum ex9))


; Q: What does sum compute for an element of List-of-numbers?
; A: The sum of all its elements if they're all positive, or an
; error otherwise.
