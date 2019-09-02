;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex282) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define (f-plain x) (* 10 x))
(define f-lambda (lambda (x) (* 10 x)))

; Number -> Boolean
(define (compare x)
  (= (f-plain x) (f-lambda x)))

; N -> Boolena
; Checks if compare returns true for all n tries.
(define (compare-times n)
  (andmap (lambda (i) (compare (random 100000))) (build-list n add1)))

(check-expect (compare-times 100000) #true)
