;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex459) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.01)
 
; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
(define (integrate-rect f a b)
  (local ((define R 1000)
          (define W (/ (- b a) R))
          (define S (/ W 2))
          ; N -> Number
          (define (ith-rectangle i)
            (* W (f (+ a (* i W) S)))))
    (foldr + 0 (build-list R ith-rectangle))))

(check-within (integrate-rect (lambda (x) 20) 12 22) 200 ε)
(check-within (integrate-rect (lambda (x) (* 2 x)) 0 10) 100 ε)
(check-within (integrate-rect (lambda (x) (* 3 (sqr x))) 0 10) 1000 ε)
