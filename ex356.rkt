;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex356) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp")) #f)))
; .: Constants :.
(define WRONG "invalid BSL-expr")

; .: Data definitions :.

(define-struct add [left right])
; An Addition is a structure:
;   (make-add BSL-expr BSL-expr)
; interpretation (make-add a b) is the sum of a and b

(define-struct mul [left right])
; A Multiplication is a structure:
;   (make-mul BSL-expr BSL-expr)
; interpretation (make-mul a b) is the product of a and b

(define-struct and* [left right])
; A Conjunction (AND) is a structure:
;   (make-and* BSL-bool BSL-bool)
; interpretation (make-and* a b) is the conjunction of a and b

(define-struct or* [left right])
; A Disjunction (OR) is a structure:
;   (make-or* BSL-bool BSL-bool)
; interpretation (make-or* a b) is the disjunction of a and b

(define-struct not* [p])
; A Negation (NOT) is a structure:
;   (make-not* BSL-bool)
; interpretation (make-not* p) is the negation of p

; A BSL-bool is one of the following:
; - Boolean
; - Conjunction
; - Disjunction
; - Negation

; A BSL-expr is one of the following:
; - Number
; - Addition
; - Multiplication

; A BSL-eval is a Number
; interpretation the result of evaluating a BSL-expr

; A BSL-var-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-var-expr BSL-var-expr)
; – (make-mul BSL-var-expr BSL-var-expr)

; An AL (short for association list) is [List-of Association].
; An Association is a list of two items:
;   (cons Symbol (cons Number '())).

; A BSL-fun-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-fun-expr BSL-fun-expr)
; – (make-mul BSL-fun-expr BSL-fun-expr)
; – (make-fa Symbol BSL-fun-expr)

(define-struct fa [name arg])
; A Function Application (FA) is a structure:
;   (make-fa Symbol BSL-fun-expr)
; interpretation (make-fa s e) applies function s to argument e
; equivalent to (s e)


; .: Data examples :.

(define be1 (make-add 10 -10))
(define be2 (make-add (make-mul 20 3) 33))
(define be3 (make-add (make-mul 3.14 (make-mul 2 3))
                      (make-mul 3.14 (make-mul -1 -9))))
(define be4 (make-add -1 2))
(define be5 (make-add (make-mul -2 -3) 33))
(define be6 (make-mul (make-add 1 (make-mul 2 3)) 3.14))

(define bb1 (make-or* #true (make-not* #true)))
(define bb2 (make-or* (make-and* #true #true) #true))
(define bb3 (make-or* (make-and* #false (make-and* #true #true))
                      (make-and* #false (make-and* (make-not* #true)
                                                   (make-not* #true)))))
(define bb4 (make-or* (make-not* #true) #true))
(define bb5 (make-or* (make-and* (make-not* #true) (make-not* #false)) #true))
(define bb6 (make-and* (make-or* #true (make-and* #true #true)) #true))

(define bv1 'x)
(define bv2 (make-add 'x 3))
(define bv3 (make-mul 1/2 (make-mul 'x 3)))
(define bv4 (make-add (make-mul 'x 'x) (make-mul 'y 'y)))

(define al1 '((x 5) (y 3)))
(define al2 '((x 2) (y 4)))
(define al3 '((x 5)))

(define bfe1 ; (k (+ 1 1))
  (make-fa 'k (make-add 1 1)))
(define bfe2 ; (* 5 (k (+ 1 1)))
  (make-mul 5 (make-fa 'k (make-add 1 1))))
(define bfe3 ; (* (i 5) (k (+ 1 1)))
  (make-mul (make-fa 'i 5) (make-fa 'k (make-add 1 1))))

