;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex414) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N -> Number
; adds up n copies of #i1/185
(define (add n)
  (cond
    [(= n 0) 0]
    [(> n 0)
     (+ #i1/185 (add (sub1 n)))]))

(check-expect (add 0) 0)
(check-within (add 1) #i1/185 0.0001)


; Q: What is the result for (add 185)?
; A: #i0.9999999999999949
; Q: What would you expect?
; A: 1
; Q: What happens if you multiply the result with a large number?
; A: It produces a new number with a relatively small but significant
; difference from the original. Also, the result will be an inexact number.


; N -> Number
; counts how many times 1/185 can be substracted from n until it's 0
(define (sub n)
  (cond
    [(= n 0) 0]
    [else ; weaker than (> n 0)
     (+ 1 (sub (- n 1/185)))]))

(check-expect (sub 0) 0)
(check-expect (sub 1/185) 1)

; Q: What are the results for (sub 1) and (sub #i1.0)?
; A: For (sub 1) the result is 185, as expected. For (sub #i1.0)
; there's no result, however.
; Q: What happens in the second case? Why?
; A: Using (> n 0) in the second condition, all question results are
; #false and an error message appears. Weakening that condition to an
; else clause allows the function to run, but it never stops, since
; there's no way to accurately substract from an inexact number,
; so the result never reaches zero.
