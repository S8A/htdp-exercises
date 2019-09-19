;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex457) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Number Number -> Number
; computes how many months it takes to double a given amount of money
; when the savings account pays interest at a fixed rate on a
; monthly basis
(define (double-amount amount rate)
  (local ((define r (/ rate 100)))
    (ceiling (/ (inexact->exact (log 2)) (inexact->exact (log (+ 1 r)))))))

(check-expect (double-amount 3412 3) 24)
(check-expect (double-amount 5615 1) 70)
(check-expect (double-amount 56464345 3) 24)
(check-expect (double-amount 956548515 2) 36)
