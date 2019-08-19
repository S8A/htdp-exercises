;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex120) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Discriminate the legal from the illegal sentences:
; Explain why the sentences are legal or illegal.
; Determine whether the legal ones belong to the category expr or def.

; (x)
; It's a single variable within parentheses, so it's not a legal expression.
; If it had another variable within the parentheses it would be a function
; application, therefore being an expression.

; (+ 1 (not x))
; It's an expression because it consists of a primitive application
; applied to a constant (i.e. an expression) and another primitive application
; (i.e. another expression).

; (+ 1 2 3)
; It's an expression because it consists of a primitive application applied
; to three constants (i.e. three expressions).
