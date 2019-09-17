;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex444) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N[>= 1] N[>= 1] -> N
; finds the greatest common divisor of S and L
(define (gcd-structural S L)
  (largest-common (divisors S S) (divisors S L)))

(check-expect (gcd-structural 6 25) 1)
(check-expect (gcd-structural 18 24) 6)
 
; N[>= 1] N[>= 1] -> [List-of N]
; computes the divisors of l smaller or equal to k
(define (divisors k l)
  (filter (lambda (n) (= (remainder l n) 0))
          (build-list k add1)))
 
; [List-of N] [List-of N] -> N
; finds the largest number common to both k and l
(define (largest-common k l)
  (apply max (filter (lambda (divisor) (member? divisor l)) k)))


; Q: Why do you think divisors consumes two numbers? Why does it consume S
; as the first argument in both uses?
; A: Because we only care about the divisors of a number that can also be the
; divisors of the other one. Therefore, we specifically want the divisors that
; are smaller or equal to the smallest of the two (hence we use S).

