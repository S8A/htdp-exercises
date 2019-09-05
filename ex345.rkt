;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex345) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp")) #f)))
; .: Data definitions :.

(define-struct add [left right])
; An Addition is a structure:
;   (make-add BSL-expr BSL-expr)
; interpretation (make-add a b) is the sum of a and b


(define-struct mul [left right])
; A Multiplication is a structure:
;   (make-mul BSL-expr BSL-expr)
; interpretation (make-mul a b) is the product of a and b


; A BSL-expr is one of the following:
; - Number
; - Addition
; - Multiplication



; Translate the following expressions into data:

; (+ 10 -10)
(make-add 10 -10)

; (+ (* 20 3) 33)
(make-add (make-mul 20 3) 33)

; (+ (* 3.14 (* 2 3)) (* 3.14 (* -1 -9)))
(make-add (make-mul 3.14 (make-mul 2 3)) (make-mul 3.14 (make-mul -1 -9)))



; Interpret the following data as expressions:

; (make-add -1 2)
(+ -1 2)

; (make-add (make-mul -2 -3) 33)
(+ (* -2 -3) 33)

; (make-mul (make-add 1 (make-mul 2 3)) 3.14)
(* (+ 1 (* 2 3)) 3.14)
