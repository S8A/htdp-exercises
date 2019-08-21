;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex150) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; N -> Number
; computes (+ n pi) without using +
(define (add-to-pi n)
  (cond
    [(zero? n) pi]
    [(positive? n)
     (add1 (add-to-pi (sub1 n)))]))
 
(check-within (add-to-pi 3) (+ 3 pi) 0.001)
(check-within (add-to-pi 50) (+ 50 pi) 0.001)


; Number N -> Number
; computes (+ a b) without using +
(define (add a b)
  (cond
    [(zero? b) a]
    [(positive? b)
     (add1 (add a (sub1 b)))]))

(check-expect (add 42 28) 70)
(check-expect (add 3.5 69) 72.5)
(check-within (add pi 3) (+ 3 pi) 0.001)
(check-within (add pi 50) (+ 50 pi) 0.001)
