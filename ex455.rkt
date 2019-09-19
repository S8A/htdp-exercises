;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex455) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define eps 0.000000001)

; [Number -> Number] Number -> Number
; produces the approximate slope of f at r1
(define (slope f r1)
  (/ (- (f (+ r1 eps)) (f (- r1 eps))) (* 2 eps)))

(check-expect (slope (lambda (x) 5) 7) 0)
(check-expect (slope (lambda (x) (- (* 3/2 x) 2)) 3) 3/2)
(check-expect (slope (lambda (x) (sqr x)) 1) 2)
(check-expect (slope (lambda (x) (sqr x)) 5) 10)
