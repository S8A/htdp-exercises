;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex119) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Explain why these sentences are syntactically illegal:

; (define (f "x") x)
; It starts with "(define (", followed by one variable and one
; string constant, where it should be a sequence of at least
; two variables. Therefore, it's not a legal definition.

; (define (f x y z) (x))
; It starts with "(define (", followed by more than two variables
; then a right parenthesis, but it's followed by an illegal expression
; (see exercise 117), so it's not a legal definition.
