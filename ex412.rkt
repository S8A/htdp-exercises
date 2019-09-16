;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex412) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct inex [mantissa sign exponent])
; An Inex is a structure: 
;   (make-inex N99 S N99)
; An S is one of:
; – 1
; – -1
; An N99 is an N between 0 and 99 (inclusive).

; N Number N -> Inex
; makes an instance of Inex after checking the arguments
(define (create-inex m s e)
  (cond
    [(and (<= 0 m 99) (<= 0 e 99) (or (= s 1) (= s -1)))
     (make-inex m s e)]
    [else (error "bad values given")]))
 
; Inex -> Number
; converts an inex into its numeric equivalent 
(define (inex->number an-inex)
  (* (inex-mantissa an-inex)
     (expt 10 (* (inex-sign an-inex) (inex-exponent an-inex)))))


; N N N Symbol String -> Inex
; Checks if the given mantissa, sign and exponent form a valid inex instance,
; and otherwise produces an error with symbol s and text msg
(define (check-inex mantissa sign exp s msg)
  (cond
    [(and (<= 0 mantissa 99) (<= 0 exp 99) (or (= sign 1) (= sign -1)))
     (make-inex mantissa sign exp)]
    [else (error s msg)]))


; Inex Inex -> Inex
; adds two inex numbers that have the same exponent
(define (inex+ x y)
  (local ((define exponent (inex-exponent x))
          (define sign (inex-sign x))
          (define sum (+ (inex-mantissa x) (inex-mantissa y)))
          (define mantissa
            (if (> sum 99) (round (/ sum 10)) sum))
          (define exp
            (if (> sum 99) (add1 exponent) exponent)))
    (check-inex mantissa sign exp 'inex+ "sum out of range")))

(check-expect (inex+ (create-inex 1 1 0) (create-inex 2 1 0))
              (create-inex 3 1 0))
(check-expect (inex+ (create-inex 55 1 0) (create-inex 55 1 0))
              (create-inex 11 1 1))
(check-expect (inex+ (create-inex 56 1 0) (create-inex 56 1 0))
              (create-inex 11 1 1))
(check-error (inex+ (create-inex 99 1 99) (create-inex 1 1 99)))
