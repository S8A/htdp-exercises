;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex348) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp")) #f)))
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



; .: Functions :.

; BSL-expr -> BSL-eval
; computes the value of the given BSL expression
(define (eval-expression be)
  (cond
    [(number? be) be]
    [(add? be) (+ (eval-expression (add-left be))
                  (eval-expression (add-right be)))]
    [(mul? be) (* (eval-expression (mul-left be))
                  (eval-expression (mul-right be)))]))

(check-expect (eval-expression be1) 0)
(check-expect (eval-expression be2) 93)
(check-expect (eval-expression be3) 47.1)
(check-expect (eval-expression be4) 1)
(check-expect (eval-expression be5) 39)
(check-expect (eval-expression be6) 21.98)


; BSL-bool -> BSL-eval
; computes the value of the given BSL Boolean expression
(define (eval-bool-expression bb)
  (cond
    [(boolean? bb) bb]
    [(not*? bb) (not (eval-bool-expression (not*-p bb)))]
    [(and*? bb) (and (eval-bool-expression (and*-left bb))
                     (eval-bool-expression (and*-right bb)))]
    [(or*? bb) (or (eval-bool-expression (or*-left bb))
                   (eval-bool-expression (or*-right bb)))]))

(check-expect (eval-bool-expression bb1) #true)
(check-expect (eval-bool-expression bb2) #true)
(check-expect (eval-bool-expression bb3) #false)
(check-expect (eval-bool-expression bb4) #true)
(check-expect (eval-bool-expression bb5) #true)
(check-expect (eval-bool-expression bb1) #true)
