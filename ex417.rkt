;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex417) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(expt 1.001 1e-12)

; Evaluate the expression above in Racket and in ISL+. Explain what you see.

; In ISL+: #i1.000000000000001
; Explanation: An inexact number very close to 1.

; In Racket: 1.000000000000001
; Explanation: Racket interprets all decimal numbers as inexact numbers.
