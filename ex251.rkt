;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex251) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; [Number Number -> Number] Number [List-of Number] -> [List-of Number]
; accumulates the elements of l with f, using neutral element n
(define (fold1 f n l)
  (cond
    [(empty? l) n]
    [else
     (f (first l) (fold1 f n (rest l)))]))    


; [List-of Number] -> Number
; computes the sum of 
; the numbers on l
(define (sum l)
  (fold1 + 0 l))

(check-expect (sum '()) 0)
(check-expect (sum '(10 7 5)) 22)
(check-expect (sum '(1 2 3 4)) 10)


; [List-of Number] -> Number
; computes the product of 
; the numbers on l
(define (product l)
  (fold1 * 1 l))

(check-expect (product '()) 1)
(check-expect (product '(10 7 5)) 350)
(check-expect (product '(1 2 3 4)) 24)
