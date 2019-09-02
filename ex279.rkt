;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex279) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Decide which of the following phrases are legal lambda expressions:

(lambda (x y) (x y y))
; It's a legal lambda function with two arguments x and y, assuming
; x is a function that takes two arguments.

;(lambda () 10)
; It's not a legal lambda function because it doesn't take any arguments.

(lambda (x) x)
; It's a legal lambda function with one argument that just returns its
; value.

(lambda (x y) x)
; It's a legal lambda function with two arguments x and y, and
; just returns the first one without doing anything to it or using
; the other one.

;(lambda x 10)
; It's not a legal lambda function because there are no arguments
; between parentheses, just a variable and a constant.
