;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex416) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N -> N
; determines the integer n such that (expt #i10.0 n) is an
; inexact number while (expt #i10.0 (+ n 1)) is approximated with +inf.0
(define (find-highest-exponent n)
  (est-exponent n + +inf.0))


; N -> N
; determines the smallest integer n such that (expt #i10.0 n) is still an
; inexact number and (expt #i10.0 (- n 1)) is approximated with #i0.0
(define (find-smallest-exponent n)
  (est-exponent n - #i0.0))


; N -> N
; determines the integer n such that (expt #i10.0 n) is an inexact number
; and (expt #i10.0 (f n 1)) is approximated with approx starting from n
(define (est-exponent n f approx)
  (local ((define expf (expt #i10.0 (f n 1))))
    (cond
      [(= expf approx) n]
      [else (est-exponent (f n 1) f approx)])))
