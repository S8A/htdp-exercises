;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex244) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; Argue why the following sentences are now legal:

(define (f x) (x 10))
; It's legal because it defines a function f that takes an argument x,
; which must be a function because it its applied in the body of f with
; a number argument.

(define (f x) (x f))
; It's legal because it defines a function f that takes an argument x,
; which must be a function because the body of f applies x with f as an
; argument.

(define (f x y) (x 'a y 'b))
; It's legal because it defines a function f that takes two arguments x and y.
; x must be a function because in the body of f it is applied to three
; arguments: a symbol, the argument y which can be anything, and another symbol.
