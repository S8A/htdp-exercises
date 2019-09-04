;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex318) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.
; An Atom is one of: 
; – Number
; – String
; – Symbol

; An S-expr is one of: 
; – Atom
; – SL

; An SL is one of: 
; – '()
; – (cons S-expr SL)

; .: Data examples :.
(define a1 'hello)
(define a2 20.12)
(define a3 "world")
(define se1 '())
(define se2 '(hello 20.12 "world"))
(define se3 '((hello 20.12 "world")))



; S-expr -> N
; Calculates the depth of the given s-expression
(define (depth sexp)
  (local (; SL -> N
          (define (depth-sl sl)
            (+ 1 (foldr max 0 (map depth sl)))))
    (cond
      [(atom? sexp) 1]
      [else (depth-sl sexp)])))

(check-expect (depth se1) 1)
(check-expect (depth se2) 2)
(check-expect (depth se3) 3)
(check-expect (depth 'world) 1)
(check-expect (depth '(world hello)) 2)
(check-expect (depth '(((world) hello) hello)) 4)


; Any -> Boolean
; Checks if x is an Atom
(define (atom? x)
  (or (number? x) (string? x) (symbol? x)))

(check-expect (atom? 69420) #true)
(check-expect (atom? "Meshuggah") #true)
(check-expect (atom? 'x) #true)
(check-expect (atom? '()) #false)
(check-expect (atom? #true) #false)
