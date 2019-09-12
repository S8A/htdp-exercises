;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex358) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp")) #f)))
; .: Constants :.
(define WRONG "invalid BSL-expr")

; .: Data definitions :.

(define-struct add [left right])
(define-struct mul [left right])

; An AL (short for association list) is [List-of Association].
; An Association is a list of two items:
;   (cons Symbol (cons Number '())).

; A BSL-fun-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-fun-expr BSL-fun-expr)
; – (make-mul BSL-fun-expr BSL-fun-expr)
; – (make-fa Symbol BSL-fun-expr)
; – (make-fd Symbol Symbol BSL-fun-expr)

(define-struct fa [name arg])
; A BSL-fun-appl (FA) is a structure:
;   (make-fa Symbol BSL-fun-expr)
; interpretation (make-fa f e) applies function f to argument e
; equivalent to (f e)

(define-struct fd [name arg body])
; A BSL-fun-def (FD) is a structure:
;   (make-fd Symbol Symbol BSL-fun-expr)
; interpretation (make-fd f x b) represents (define (f x) b)


; A BSL-fun-def* is a [List-of BSL-fun-def]


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

(define bfe1 ; (k (+ 1 1)) => (k 2)
  (make-fa 'k (make-add 1 1)))
(define bfe2 ; (* 5 (k (+ 1 1))) => (* 5 (k 2))
  (make-mul 5 (make-fa 'k (make-add 1 1))))
(define bfe3 ; (* (i 5) (k (+ 1 1))) => (* (i 5) (k 2))
  (make-mul (make-fa 'i 5) (make-fa 'k (make-add 1 1))))

(define kfuncbody (make-mul 3 'x))
(define ifuncbody (make-mul 'x (make-add 'x 1)))

(define fdk (make-fd 'k 'x kfuncbody))
(define fdi (make-fd 'i 'x ifuncbody))
(define fdf (make-fd 'f 'x (make-add 3 'x)))
(define fdg (make-fd 'g 'y (make-fa 'f (make-mul 2 'y))))
(define fdh (make-fd 'h 'v (make-add (make-fa 'f 'v) (make-fa 'g 'v))))

(define da-fgh (list fdf fdg fdh))



; .: Functions :.

; BSL-fun-def* Symbol -> BSL-fun-def
; retrieves the definition of f in da
; signals an error if there is none
(define (lookup-def da f)
  (local ((define search (filter (lambda (def) (symbol=? f (fd-name def))) da)))
    (if (empty? search)
        (error "function definition not found")
        (first search))))

(check-expect (lookup-def da-fgh 'g) fdg)
(check-error (lookup-def da-fgh 'i))


; BSL-fun-expr Symbol Symbol BSL-fun-expr -> BSL-eval
; tries to evaluate the given BSL-fun-expr using the function definition
; (define (f x) b) if necessary
(define (eval-definition1 ex f x b)
  (cond
    [(number? ex) ex]
    [(symbol? ex) (error "symbol not found")]
    [(add? ex) (+ (eval-definition1 (add-left ex) f x b)
                  (eval-definition1 (add-right ex) f x b))]
    [(mul? ex) (* (eval-definition1 (mul-left ex) f x b)
                  (eval-definition1 (mul-right ex) f x b))]
    [(fa? ex)
     (if (symbol=? f (fa-name ex))
         (local ((define value (eval-definition1 (fa-arg ex) f x b))
                 (define plugd (subst b x value)))
           (eval-definition1 plugd f x b))
         (error "function not defined"))]))

(check-expect (eval-definition1 bfe1 'k 'x kfuncbody) 6)
(check-error (eval-definition1 bfe1 'i 'x ifuncbody))
(check-expect (eval-definition1 bfe2 'k 'x kfuncbody) 30)
(check-error (eval-definition1 bfe2 'i 'x ifuncbody))
(check-error (eval-definition1 bfe3 'k 'x kfuncbody))
(check-error (eval-definition1 bfe3 'i 'x ifuncbody))
(check-error (eval-definition1 'y 'i 'x ifuncbody))


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

