;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex111) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct vec [x y])
; A Vec is
;   (make-vec PositiveNumber PositiveNumber)
; interpretation represents a velocity vector

; Any Any -> Vec
; creates a velocity vector (x,y) if x and y are positive numbers
(define (checked-make-vec x y)
  (cond
    [(and (number? x) (number? y) (>= x 0) (>= y 0)) (make-vec x y)]
    [else (error "make-vec: x and y must be positive numbers")]))

(check-expect (checked-make-vec 3 4) (make-vec 3 4))
(check-error (checked-make-vec -1 1))
(check-error (checked-make-vec 4 "pingu"))
