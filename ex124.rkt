;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex124) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Evaluate the following program, step-by-step:

(define PRICE 5)
(define SALES-TAX (* 0.08 PRICE))
(define TOTAL (+ PRICE SALES-TAX))

;(define PRICE 5)
;(define SALES-TAX (* 0.08 5))
;(define TOTAL (+ 5 SALES-TAX))

;(define PRICE 5)
;(define SALES-TAX 0.4)
;(define TOTAL (+ 5 0.4))

;(define PRICE 5)
;(define SALES-TAX 0.4)
;(define TOTAL 5.4)


; Q: Does the evaluation of the following program signal an error?
; A: Yes

(define COLD-F 32)
(define COLD-C (fahrenheit->celsius COLD-F)) ; => this function is not defined
(define (fahrenheit->celsius f)
 (* 5/9 (- f 32)))


; Q: How about the next one?
; A: No

(define LEFT -100)
(define RIGHT 100)
(define (f x) (+ (* 5 (expt x 2)) 10))
(define f@LEFT (f LEFT))
(define f@RIGHT (f RIGHT))

;(define LEFT -100)
;(define RIGHT 100)
;(define (f x) (+ (* 5 (expt x 2)) 10))
;(define f@LEFT (f -100))
;(define f@RIGHT (f 100))

;(define LEFT -100)
;(define RIGHT 100)
;(define (f x) (+ (* 5 (expt x 2)) 10))
;(define f@LEFT (+ (* 5 (expt -100 2)) 10))
;(define f@RIGHT (+ (* 5 (expt 100 2)) 10))

;(define LEFT -100)
;(define RIGHT 100)
;(define (f x) (+ (* 5 (expt x 2)) 10))
;(define f@LEFT (+ (* 5 10000) 10))
;(define f@RIGHT (+ (* 5 10000) 10))

;(define LEFT -100)
;(define RIGHT 100)
;(define (f x) (+ (* 5 (expt x 2)) 10))
;(define f@LEFT (+ 50000 10))
;(define f@RIGHT (+ 50000 10))

;(define LEFT -100)
;(define RIGHT 100)
;(define (f x) (+ (* 5 (expt x 2)) 10))
;(define f@LEFT 50010)
;(define f@RIGHT 50010)
