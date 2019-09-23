;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex496) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Q: What should the value of a be when n0 is 3 and n is 1? How about when
; n0 is 10 and n is 8?
; A: In the first case, a should be 6, because that's the product of the
; natural numbers in the interval [3,1) i.e. 3 and 2. In the second case,
; a should be 90, because that's the product of the natural numbers in the
; interval [10,8) i.e. 10 and 9.
