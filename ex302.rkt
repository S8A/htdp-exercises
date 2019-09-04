;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex302) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define x (cons 1 x))
;                 ^ error: x not defined yet
; Q: Where is the shaded occurrence of x bound?
; A: To the x right after "define".
; Q: What should be the value of the right-hand side according to our rules?
; A: Illegal expression, x referenced before its definition.
