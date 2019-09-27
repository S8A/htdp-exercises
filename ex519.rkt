;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex519) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Q: Is it acceptable to impose the extra cost on cons for all programs to turn
; length into a constant-time function?
; A: No, because there aren't many cases in which we would need to know the
; length of a list that can't be solved in another way. In other words, it's
; more likely that the extra cost of the new cons will be higher than the
; cost of traversing a list to know its length, considering how often each
; one is really needed.
