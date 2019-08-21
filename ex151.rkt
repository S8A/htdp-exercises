;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex151) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; N Number -> Number
; multiplies n times x without using *
(define (multiply n x)
  (cond
    [(zero? n) 0]
    [(positive? n)
     (+ x (multiply (sub1 n) x))]))

(check-expect (multiply 3 21) 63)
(check-expect (multiply 3 252) 756)
(check-expect (multiply 11 12) 132)
