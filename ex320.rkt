;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex320) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.
; An S-expr is one of: 
; – Number
; – String
; – Symbol
; – [List-of S-expr]


; .: Data examples :.
(define a1 'hello)
(define a2 20.12)
(define a3 "world")
(define se1 '())
(define se2 '(hello 20.12 "world"))
(define se3 '((hello 20.12 "world")))



; S-expr Symbol -> N 
; counts all occurrences of sy in sexp 
(define (count sexp sy)
  (cond
    [(number? sexp) 0]
    [(string? sexp) 0]
    [(symbol? sexp) (if (symbol=? sexp sy) 1 0)]
    [else
     (foldr + 0 (map (lambda (s) (count s sy)) sexp))]))

(check-expect (count 'world 'hello) 0)
(check-expect (count '(world hello) 'hello) 1)
(check-expect (count '(((world) hello) hello) 'hello) 2)
