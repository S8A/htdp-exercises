;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex501) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N -> Number 
; adds n to pi without using +
(define (add-to-pi n)
  (cond
    [(zero? n) pi]
    [else (add1 (add-to-pi (sub1 n)))]))

(check-within (add-to-pi 2) (+ 2 pi) 0.001)


; N -> Number
; adds n0 to pi without using +
(define (add-to-pi.v2 n0)
  (local (; N N -> Number
          ; adds n to a
          ; accumulator a is pi plus n0 - n
          (define (atp n a)
            (cond
              [(zero? n) a]
              [else (atp (sub1 n) (add1 a))])))
    (atp n0 pi)))

(check-within (add-to-pi.v2 2) (+ 2 pi) 0.001)
