;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex456) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define eps 0.000000001)

; [Number -> Number] Number -> Number
; finds a number r such that (<= (abs (f r)) eps)
(define (newton f r1)
  (cond
    [(<= (abs (f r1)) eps) r1]
    [else (newton f (root-of-tangent f r1))]))

(check-within (newton poly 1) 2 eps)
(check-within (newton poly 3.5) 4 eps)


; [Number -> Number] Number -> Number
; produces the approximate slope of f at r1
(define (slope f r1)
  (/ (- (f (+ r1 eps)) (f (- r1 eps))) (* 2 eps)))

(check-expect (slope (lambda (x) 5) 7) 0)
(check-expect (slope (lambda (x) (- (* 3/2 x) 2)) 3) 3/2)
(check-expect (slope (lambda (x) (sqr x)) 1) 2)
(check-expect (slope (lambda (x) (sqr x)) 5) 10)


; [Number -> Number] Number -> Number
; produces the root of the tangent through (r1, (f r1))
(define (root-of-tangent f r1)
  (- r1 (/ (f r1) (slope f r1))))

(check-error (root-of-tangent (lambda (x) 5) 7))
(check-expect (root-of-tangent (lambda (x) (- (* 3/2 x) 2)) 3) 4/3)
(check-expect (root-of-tangent (lambda (x) (sqr x)) 1) 1/2)
(check-expect (root-of-tangent (lambda (x) (sqr x)) 5) 5/2)


; Number -> Number
(define (poly x)
  (* (- x 2) (- x 4)))
