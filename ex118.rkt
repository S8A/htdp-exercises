;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex118) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Explain why these sentences are syntactically legal definitions:

; (define (f x) x)
; It consists of an opening parenthesis, followed by the keyword define,
; followed by another opening parenthesis, followed by two variables,
; followed by a closing parenthesis, followed by a variable (therefore, an
; expression), and closed by a right parenthesis.

; (define (f x) y)
; It consists of an opening parenthesis, followed by the keyword define,
; followed by another opening parenthesis, followed by two variables,
; followed by a closing parenthesis, followed by a variable (therefore, an
; expression), and closed by a right parenthesis.

; (define (f x y) 3)
; It consists of an opening parenthesis, followed by the keyword define,
; followed by another opening parenthesis, followed by more than two variables,
; followed by a closing parenthesis, followed by a constant (therefore, an
; expression), and closed by a right parenthesis.
