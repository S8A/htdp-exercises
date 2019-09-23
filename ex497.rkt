;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex497) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N -> N 
; computes (* n (- n 1) (- n 2) ... 1)
(define (!.v1 n)
  (cond
    [(zero? n) 1]
    [else (* n (!.v1 (sub1 n)))]))

(check-expect (!.v1 3) 6)


; N -> N
; computes (* n0 (- n0 1) (- n0 2) ... 1)
(define (!.v2 n0)
  (local (; N N -> N
          ; computes (* n (- n 1) (- n 2) ... 1)
          ; accumulator a is the product of the 
          ; natural numbers in the interval [n0,n)
          (define (!/a n a)
            (cond
              [(zero? n) a]
              [else (!/a (sub1 n) (* n a))])))
    (!/a n0 1)))

(check-expect (!.v2 3) 6)


; ..:: Perfomance comparison ::..
(define v1 (time (build-list 10000 (lambda (n) (!.v1 20)))))
(define v2 (time (build-list 10000 (lambda (n) (!.v2 20)))))
