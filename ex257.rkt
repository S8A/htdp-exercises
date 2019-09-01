;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex257) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; [X] N [N -> X] -> [List-of X]
; constructs a list by applying f to 0, 1, ..., (sub1 n)
; (build-l*st n f) == (list (f 0) ... (f (- n 1)))
(define (build-l*st n f)
  (cond
    [(zero? n) '()]
    [else
     (add-at-end (f (sub1 n)) (build-l*st (sub1 n) f))]))

(check-expect (build-l*st 6 add1) '(1 2 3 4 5 6))
(check-expect (build-l*st 5 sqr) '(0 1 4 9 16))


; [X] X [List-of X] -> [List-of X]
; Adds x to the end of l.
(define (add-at-end x l)
  (append l (list x)))
