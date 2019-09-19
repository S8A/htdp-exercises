;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex460) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.01)
 
; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
(define (integrate-dc f a b)
  (local (; Number Number Number Number -> Number
          (define (area-trapezoid l r fl fr)
            (* 1/2 (- r l) (+ fl fr)))
          ; Number Number Number Number -> Number
          (define (kepler l r fl fr)
            (local ((define mid (/ (+ l r) 2))
                    (define fmid (f mid)))
              (cond
                [(<= (- r l) ε)
                 (+ (area-trapezoid l mid fl fmid)
                    (area-trapezoid mid r fmid fr))]
                [else
                 (+ (kepler l mid fl fmid)
                    (kepler mid r fmid fr))]))))
    (kepler a b (f a) (f b))))

(check-within (integrate-dc (lambda (x) 20) 12 22) 200 ε)
(check-within (integrate-dc (lambda (x) (* 2 x)) 0 10) 100 ε)
(check-within (integrate-dc (lambda (x) (* 3 (sqr x))) 0 10) 1000 ε)
