;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex402) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; .: Data definitions :.
(define-struct add [left right])
(define-struct mul [left right])

; A BSL-var-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-var-expr BSL-var-expr)
; – (make-mul BSL-var-expr BSL-var-expr)

; An AL (short for association list) is [List-of Association].
; An Association is a list of two items:
;   (cons Symbol (cons Number '())).


; Q: Reread exercise 354. Explain the reasoning behind our hint to
; think of the given expression as an atomic value at first.
; A: The function to create was (eval-variable* ex da), a function
; that takes a BSL-var-expr and a [List-of Association] and tries
; to evaluate the given expression after substituting all constants
; defined in the association list. The hint was to treat ex as an
; atomic value and iterate over the association list - i.e. apply
; subst to the expression with each association and trying to
; evaluate only after substituting all known constants. This is a
; natural way to think about the process and makes it easy to
; create the function.


; BSL-var-expr AL -> Number
(define (eval-variable* ex da)
  (cond
    [(empty? da) (eval-variable ex)]
    [(cons? da)
     (local ((define assoc (first da)))
       (eval-variable* (subst ex (first assoc) (second assoc))
                       (rest da)))]))

(check-expect (eval-variable* bv1 al1) 5)
(check-expect (eval-variable* bv1 al2) 2)
(check-expect (eval-variable* bv2 al1) 8)
(check-expect (eval-variable* bv2 al2) 5)
(check-expect (eval-variable* bv3 al1) 15/2)
(check-expect (eval-variable* bv3 al2) 3)
(check-expect (eval-variable* bv4 al1) 34)
(check-expect (eval-variable* bv4 al2) 20)
(check-error (eval-variable* bv4 al3))



; .: Data examples :.

(define be1 (make-add 10 -10))
(define be2 (make-add (make-mul 20 3) 33))
(define be3 (make-add (make-mul 3.14 (make-mul 2 3))
                      (make-mul 3.14 (make-mul -1 -9))))
(define be4 (make-add -1 2))
(define be5 (make-add (make-mul -2 -3) 33))
(define be6 (make-mul (make-add 1 (make-mul 2 3)) 3.14))

(define bv1 'x)
(define bv2 (make-add 'x 3))
(define bv3 (make-mul 1/2 (make-mul 'x 3)))
(define bv4 (make-add (make-mul 'x 'x) (make-mul 'y 'y)))

(define al1 '((x 5) (y 3)))
(define al2 '((x 2) (y 4)))
(define al3 '((x 5)))


; .: Auxiliary functions :.

; BSL-var-expr -> Number
; if the BSL-var-expr is also a BSL-expr, evaluates it
(define (eval-variable bve)
  (if (numeric? bve)
      (eval-expression bve)
      (error "not a numeric expression")))

(check-expect (eval-variable be3) (eval-expression be3))
(check-expect (eval-variable be4) (eval-expression be4))
(check-error (eval-variable bv3))
(check-expect (eval-variable (subst bv3 'x 5))
              (eval-expression (subst bv3 'x 5)))
(check-error (eval-variable (subst bv4 'x 5)))
(check-expect (eval-variable (subst (subst bv4 'x 5) 'y 3))
              (eval-expression (subst (subst bv4 'x 5) 'y 3)))


; BSL-var-expr -> BSL-expr
; determines whether the given BSL-var-expr is also a BSL-expr
(define (numeric? bve)
  (cond
    [(number? bve) #true]
    [(symbol? bve) #false]
    [(add? bve) (and (numeric? (add-left bve)) (numeric? (add-right bve)))]
    [(mul? bve) (and (numeric? (mul-left bve)) (numeric? (mul-right bve)))]))

(check-expect (numeric? be3) #true)
(check-expect (numeric? be4) #true)
(check-expect (numeric? bv3) #false)
(check-expect (numeric? (subst bv3 'x 5)) #true)
(check-expect (numeric? (subst bv4 'x 5)) #false)
(check-expect (numeric? (subst (subst bv4 'x 5) 'y 3)) #true)


; BSL-var-expr Symbol Number -> BSL-var-expr
; replaces all occurrences of x with v in the given expression
(define (subst ex x v)
  (cond
    [(number? ex) ex]
    [(symbol? ex) (if (symbol=? ex x) v ex)]
    [(add? ex) (make-add (subst (add-left ex) x v)
                         (subst (add-right ex) x v))]
    [(mul? ex) (make-mul (subst (mul-left ex) x v)
                         (subst (mul-right ex) x v))]))

(check-expect (subst bv1 'x 5) 5)
(check-expect (subst bv2 'x 5) (make-add 5 3))
(check-expect (subst bv3 'x 5) (make-mul 1/2 (make-mul 5 3)))
(check-expect (subst bv4 'x 5) (make-add (make-mul 5 5) (make-mul 'y 'y)))
(check-expect (subst (subst bv4 'x 5) 'y 3)
              (make-add (make-mul 5 5) (make-mul 3 3)))


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
