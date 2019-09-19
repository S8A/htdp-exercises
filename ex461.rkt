;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex461) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.01)
 
; [Number -> Number] Number Number -> Number
; computes the area under the graph of f between a and b
; assume (< a b) holds 
(define (integrate-adaptive f a b)
  (local (; Number Number Number Number -> Number
          (define (area-trapezoid l r fl fr)
            (* 1/2 (- r l) (+ fl fr)))
          ; Number Number Number Number -> Number
          (define (kepler l r fl fr)
            (local ((define mid (/ (+ l r) 2))
                    (define fmid (f mid))
                    (define area-left (area-trapezoid l mid fl fmid))
                    (define area-right (area-trapezoid mid r fmid fr)))
              (cond
                [(<= (abs (- area-left area-right)) (* ε (- r l)))
                 (+ area-left area-right)]
                [else
                 (+ (kepler l mid fl fmid)
                    (kepler mid r fmid fr))]))))
    (kepler a b (f a) (f b))))

(check-within (integrate-adaptive (lambda (x) 20) 12 22) 200 ε)
(check-within (integrate-adaptive (lambda (x) (* 2 x)) 0 10) 100 ε)
(check-within (integrate-adaptive (lambda (x) (* 3 (sqr x))) 0 10) 1000 ε)
(check-within (integrate-adaptive (lambda (x)
                                    (if (>= x (* 2 pi))
                                        (+ 2 (sin (* 10 x)))
                                        2))
                                  0 10)
              20.01376 ε)
(check-within (integrate-adaptive (lambda (x)
                                    (if (>= x (* 2 pi))
                                        (+ 2 (sin (* 10 x)))
                                        2))
                                  0 10)
              20.01376 ε)

; Q: Does integrate-adaptive always compute a better answer than either
; integrate-kepler or integrate-rectangles? Which aspect is
; integrate-adaptive guaranteed to improve?
; A: It is almost always more accurate than all previous functions using
; the same epsilon. Notable exceptions are the fourth and fifth test cases;
; both functions are at least partly sinusoidal and in both cases
; integrate-adaptive is slightly less accurate than integrate-rect and
; integrate-dc. Nevertheless, integrate-adaptive is guaranteed to require
; less steps than those in functions whose lines are straight instead of
; curved.