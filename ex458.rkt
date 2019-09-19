;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex458) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.1)
 
; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
(define (integrate-kepler f a b)
  (local ((define fa (f a))
          (define fb (f b))
          (define mid (/ (+ a b) 2))
          (define fmid (f mid))
          ; Number Number Number Number -> Number
          (define (area-trapezoid l r fl fr)
            (* 1/2 (- r l) (+ fl fr))))
    (+ (area-trapezoid a mid fa fmid)
       (area-trapezoid mid b fmid fb))))

(check-within (integrate-kepler (lambda (x) 20) 12 22) 200 ε)
(check-within (integrate-kepler (lambda (x) (* 2 x)) 0 10) 100 ε)
;(check-within (integrate-kepler (lambda (x) (* 3 (sqr x))) 0 10) 1000 ε)
; test fails; actual result: 1125
