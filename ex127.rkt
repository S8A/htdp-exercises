;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex127) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct ball [x y speed-x speed-y])

; Predict the results of evaluating the following expression:

(number? (make-ball 1 2 3 4))
; #false

(ball-speed-y (make-ball (+ 1 2) (+ 3 3) 2 3))
; 3

(ball-y (make-ball (+ 1 2) (+ 3 3) 2 3))
; 6

(ball-x (make-posn 1 2))
; error: not a ball

(ball-speed-y 5)
; error: not a ball
