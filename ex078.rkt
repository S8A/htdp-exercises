;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex078) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A LLorF is one of:
; - 1String "a" through "z"
; - #false
; interpretation a lowercase letter or the boolean false value


(define-struct 3word [first second third])
; A 3Word is a structure:
;   (make-3word LLorF LLorF LLorF)
; interpretation (make-3word f s t) is a three-letter word
; "fst" where each character is a lowercase letter or the
; boolean false value
