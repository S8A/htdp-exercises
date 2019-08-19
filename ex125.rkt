;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex125) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Discriminate the legal from the illegal sentences:

(define-struct oops [])
; It's a legal structure definition: "(define-struct " followed by
; the name of the structure, then a sequence of zero or more variables
; between square parentheses, finally closed by a right parenthesis.

(define-struct child [parents dob date])
; It's a legal structure definition: "(define-struct " followed by
; the name of the structure, then a sequence of zero or more variables
; between square parentheses, finally closed by a right parenthesis.

(define-struct (child person) [dob date])
; It's not a legal structure definition, because after the define-struct
; keyword there should be a name for the structure, not an expression or
; anything else.
