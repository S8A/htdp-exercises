;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex117) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Explain why these sentences are syntactically illegal:

; (3 + 4)
; It consists of three elements within parentheses, but the first one
; is neither a primitive nor a variable, therefore it's not an expression.

; number?
; It's the name of a primitive function, but it's not between parentheses
; nor applied to any arguments, so it's not an expression.

; (x)
; It's a single variable within parentheses, so it's not an expression
; (it would need another variable within the parentheses to be a
; function application).
