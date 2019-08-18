;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex105) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A Coordinate is one of: 
; – a NegativeNumber 
; interpretation on the y axis, distance from top
; – a PositiveNumber 
; interpretation on the x axis, distance from left
; – a Posn
; interpretation an ordinary Cartesian point

(define x0yn5 -5) ; Coordinate (0, -5)
(define x0yn10 -10) ; Coordinate (0, -10)
(define x4y0 4) ; Coordinate (4, 0)
(define x100y0 100) ; Coordinate (100, 0)
(define xn5y10 (make-posn -5 10)) ; Coordinate (-5, 10)
(define x3yn4 (make-posn 3 -4)) ; Coordinate (3, -4)
