;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex245) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; Number -> Number
; Squares a number x.
(define (altsqr x)
  (* x x))


; (Number->Number) (Number->Number) -> Boolean
; Determines whether the given functions produce the same result
; for each of the following parameters: 1.2, 3, -5.775
(define (function=at-1.2-3-and-5.775? f1 f2)
  (and (= (f1 1.2) (f2 1.2))
       (= (f1 3) (f2 3))
       (= (f1 -5.775) (f2 -5.775))))

(check-expect (function=at-1.2-3-and-5.775? sqr sqrt) #false)
(check-expect (function=at-1.2-3-and-5.775? sqr altsqr) #true)


; Q: Can we hope to define function=?, which determines whether two
; functions from numbers to numbers are equal?
; A: I don't think so, at least not with ISL. To do so we would need a way
; of finding out the value of (= (f1 x) (f2 x)) for ALL numbers, which is
; not possible to do recursively because there is no start or stop condition,
; and no way of checking absolutely all real numbers since between any two
; of them are infinitely many numbers that differ by small fractions, not to
; mention irrational numbers which we have no way to reach by adding or
; substracting iteratively.
