;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex243) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
(define (f x) x)

; Identify the values among the following expressions:

(cons f '())
; It's a value because it's a list that contains a function name,
; which is a value.

(f f)
; => f
; It's a value because the result of applying f to argument f is f,
; which is a function, therefore a value.

(cons f (cons 10 (cons (f 10) '())))
; => (cons f (cons 10 (cons 10 '())))
; It's a value because it's a list of three values: a function name,
; a number, and a number produced as the result of a function application.
