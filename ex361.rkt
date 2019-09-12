;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex361) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp")) #f)))
; .: Constants :.
(define WRONG "invalid BSL-expr")

; .: Data definitions :.

(define-struct add [left right])
(define-struct mul [left right])

; A BSL-fun-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-fun-expr BSL-fun-expr)
; – (make-mul BSL-fun-expr BSL-fun-expr)
; – (make-fa Symbol BSL-fun-expr)

(define-struct fa [name arg])
; A BSL-fun-appl (FA) is a structure:
;   (make-fa Symbol BSL-fun-expr)
; interpretation (make-fa f e) applies function f to argument e
; equivalent to (f e)

(define-struct const [name value])
(define-struct fd [name arg body])
; A BSL-def is one of:
; - (make-const Symbol BSL-fun-expr)
; - (make-fd Symbol Symbol BSL-fun-expr)
; interpretation a BSL constant or function definition

; A BSL-da-all is a [List-of BSL-def]


; .: Data examples :.

; Basic BSL expressions
(define be1 (make-add 10 -10))
(define be2 (make-add (make-mul 20 3) 33))
(define be3 (make-add (make-mul 3.14 (make-mul 2 3))
                      (make-mul 3.14 (make-mul -1 -9))))
(define be4 (make-add -1 2))
(define be5 (make-add (make-mul -2 -3) 33))
(define be6 (make-mul (make-add 1 (make-mul 2 3)) 3.14))

; BSL expressions with variables
(define bv1 'x)
(define bv2 (make-add 'x 3))
(define bv3 (make-mul 1/2 (make-mul 'x 3)))
(define bv4 (make-add (make-mul 'x 'x) (make-mul 'y 'y)))

; BSL expressions with function applications
(define bfe1 ; (k (+ 1 1)) => (k 2)
  (make-fa 'k (make-add 1 1)))
(define bfe2 ; (* 5 (k (+ 1 1))) => (* 5 (k 2))
  (make-mul 5 (make-fa 'k (make-add 1 1))))
(define bfe3 ; (* (i 5) (k (+ 1 1))) => (* (i 5) (k 2))
  (make-mul (make-fa 'i 5) (make-fa 'k (make-add 1 1))))
(define bfe4 ; => (+ (* 3 (f (* 2 5))) (+ (h (+ 2 (* 2 3))) (g (* 7 (+ 1 4)))))
             ; => (+ (* 3 (f 10)) (+ (h 8) (g 35)))
  (make-add (make-mul 3 (make-fa 'f (make-mul 2 5)))
            (make-add (make-fa 'h (make-add 2 (make-mul 2 3)))
                      (make-fa 'g (make-mul 7 (make-add 1 4))))))
(define bfe5 ; (area-of-circle 1) => #i3.14
  (make-fa 'area-of-circle 1))
(define bfe6 ; (volume-of-10-cylinder 1) => #i31.400000000000002
  (make-fa 'volume-of-10-cylinder 1))
(define bfe7 ; (* 3 close-to-pi) => #i9.42
  (make-mul 3 'close-to-pi))

; BSL constant definitions
(define al1 (list (make-const 'x 5) (make-const 'y 3)))
(define al2 (list (make-const 'x 2) (make-const 'y 4)))
(define al3 (list (make-const 'x 5)))

; BSL function definitions
(define fdk (make-fd 'k 'x (make-mul 3 'x)))
(define fdi (make-fd 'i 'x (make-mul 'x (make-add 'x 1))))
(define fdf (make-fd 'f 'x (make-add 3 'x)))
(define fdg (make-fd 'g 'y (make-fa 'f (make-mul 2 'y))))
(define fdh (make-fd 'h 'v (make-add (make-fa 'f 'v) (make-fa 'g 'v))))

; BSL definition areas
(define da-ik (append al1 (list fdi fdk)))
(define da-fgh (append al2 (list fdf fdg fdh)))
(define da-ike (append al3 (list fdi fdk)))
(define da-example
  (list (make-const 'close-to-pi 3.14)
        (make-fd 'area-of-circle 'r
                 (make-mul 'close-to-pi (make-mul 'r 'r)))
        (make-fd 'volume-of-10-cylinder 'r
                 (make-mul 10 (make-fa 'area-of-circle 'r)))))



; .: Functions :.

; BSL-fun-expr BSL-da-all -> Number
; tries to evaluate the expression ex using the definitions contained in da
(define (eval-all ex da)
  (cond
    [(number? ex) ex]
    [(symbol? ex) (eval-all (const-value (lookup-con-def da ex)) da)]
    [(add? ex) (+ (eval-all (add-left ex) da)
                  (eval-all (add-right ex) da))]
    [(mul? ex) (* (eval-all (mul-left ex) da)
                  (eval-all (mul-right ex) da))]
    [(fa? ex)
     (local (; Evaluate the function's argument
             (define value (eval-all (fa-arg ex) da))
             ; Look up the function's definition
             (define fdef (lookup-fun-def da (fa-name ex)))
             ; Substitute the value of the argument for the function parameter
             ; in the function's body
             (define substituted (subst (fd-body fdef) (fd-arg fdef) value)))
       ; Evaluate the new expression
       (eval-all substituted da))]))

(check-expect (eval-all bfe1 da-ik) 6)
(check-expect (eval-all bfe2 da-ik) 30)
(check-expect (eval-all bfe3 da-ik) 180)
(check-expect (eval-all bfe4 da-fgh) 142)
(check-within (eval-all bfe5 da-example) #i3.14 0.00001)
(check-within (eval-all bfe6 da-example) #i31.400000000000002 0.00001)
(check-within (eval-all bfe7 da-example) #i9.42 0.00001)
(check-error (eval-all bfe1 da-example))
(check-error (eval-all bfe4 da-ik))
(check-error (eval-all bfe7 da-fgh))


; BSL-da-all Symbol -> BSL-def
; tries to find the representation of a constant definition named x
; in the given definition area
(define (lookup-con-def da x)
  (local ((define search
            (filter (lambda (def)
                      (and (const? def) (symbol=? x (const-name def)))) da)))
    (if (empty? search)
        (error "constant definition not found")
        (first search))))

(check-expect (lookup-con-def da-ik 'x) (make-const 'x 5))
(check-expect (lookup-con-def da-fgh 'y) (make-const 'y 4))
(check-error (lookup-con-def da-ike 'y))
(check-error (lookup-con-def da-example 'x))
(check-error (lookup-con-def da-example 'area-of-circle))
(check-expect (lookup-con-def da-example 'close-to-pi)
              (make-const 'close-to-pi 3.14))


; BSL-da-all Symbol -> BSL-def
; tries to find the representation of a constant definition named f
; in the given definition area
(define (lookup-fun-def da f)
  (local ((define search
            (filter (lambda (def) (and (fd? def) (symbol=? f (fd-name def))))
                    da)))
    (if (empty? search)
        (error "function definition not found")
        (first search))))

(check-expect (lookup-fun-def da-ik 'i) fdi)
(check-expect (lookup-fun-def da-fgh 'g) fdg)
(check-error (lookup-fun-def da-ike 'h))
(check-expect (lookup-fun-def da-example 'area-of-circle)
              (make-fd 'area-of-circle 'r
                       (make-mul 'close-to-pi (make-mul 'r 'r))))
(check-error (lookup-fun-def da-example 'close-to-pi))


; BSL-fun-expr Symbol Number -> BSL-fun-expr
; replaces all occurrences of x with v in the given expression
(define (subst ex x v)
  (cond
    [(number? ex) ex]
    [(symbol? ex) (if (symbol=? ex x) v ex)]
    [(add? ex) (make-add (subst (add-left ex) x v)
                         (subst (add-right ex) x v))]
    [(mul? ex) (make-mul (subst (mul-left ex) x v)
                         (subst (mul-right ex) x v))]
    [(fa? ex) (make-fa (fa-name ex) (subst (fa-arg ex) x v))]))

(check-expect (subst bv1 'x 5) 5)
(check-expect (subst bv2 'x 5) (make-add 5 3))
(check-expect (subst bv3 'x 5) (make-mul 1/2 (make-mul 5 3)))
(check-expect (subst bv4 'x 5) (make-add (make-mul 5 5) (make-mul 'y 'y)))
(check-expect (subst (subst bv4 'x 5) 'y 3)
              (make-add (make-mul 5 5) (make-mul 3 3)))
(check-expect (subst (make-add (make-fa 'f 'v) (make-fa 'g 'v)) 'v 5)
              (make-add (make-fa 'f 5) (make-fa 'g 5)))
