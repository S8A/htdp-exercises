;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex256) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; Q: Explain the following abstract function:

; [X] [X -> Number] [NEList-of X] -> X 
; finds the (first) item in lx that maximizes f
; if (argmax f (list x-1 ... x-n)) == x-i, 
; then (>= (f x-i) (f x-1)), (>= (f x-i) (f x-2)), ...
;(define (argmax f lx) ...)

; A: argmax finds the item in the list for which f returns the highest value,
; returning the first one found if there are two such values or more.
(check-expect (argmax sqr '(1 4 2 5 14 54 7)) 54)
(check-expect (argmax sqrt '(1 4 2 5 14 54 7)) 54)
(check-expect (argmax sin '(1 4 2 5 14 54 7)) 14)


; Q: Can you articulate an analogous purpose statement for argmin?

; [X] [X -> Number] [NEList-of X] -> X
; finds the (first) item in lx that minimizes f
; if (argmax f (list x-1 ... x-n)) == x-i,
; then (<= (f x-i) (f x-1)), (<= (f x-i) (f x-2)), ...
;(define (argmin f lx) ...)
(check-expect (argmin sqr '(1 4 2 5 14 54 7)) 1)
(check-expect (argmin sqrt '(1 4 2 5 14 54 7)) 1)
(check-expect (argmin sin '(1 4 2 5 14 54 7)) 5)
