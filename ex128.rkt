;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex128) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(check-member-of "green" "red" "yellow" "grey")
; "green" is not equal to any of the three given expect results.

(check-within (make-posn #i1.0 #i1.1)
              (make-posn #i0.9 #i1.2)  0.01)
; The expression's inexact numbers differ from the expected's by more than ±0.01

(check-range #i0.9 #i0.6 #i0.8)
; #i0.9 is outside the given range

(check-random (make-posn (random 3) (random 9))
              (make-posn (random 9) (random 3)))
; The random numbers of the given expression can't match the expected ones
; because their ranges differ when comparing in order. In other words:
; the actual expression has (random 3) then (random 9), while the expected
; order is (random 9) then (random 3).

(check-satisfied 4 odd?)
; 4 is not an odd number.
