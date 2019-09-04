;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex305) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; Constants :.
(define USD-PER-EURO 1.06) ; on April 13th, 2017

; Data definitions :.
; A EuroAmount is a PositiveNumber.
; A DollarAmount is a PositiveNumber.

; [List-of EuroAmount] -> [List-of DollarAmount]
; Converts a list of USD amounts into a list of euro amounts.
(define (convert-euro l)
  (for/list ([x l]) (/ x USD-PER-EURO)))

(check-expect (convert-euro '()) '())
(check-expect (convert-euro '(106 3.18 74.2)) '(100 3 70))
