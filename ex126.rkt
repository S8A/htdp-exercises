;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex126) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct point [x y z])
(define-struct none [])

; Identify the values among the following expressions:

(make-point 1 2 3)
; It's a value because it's a structure value of type point,
; with three structure components (three constants) as defined above.

(make-point (make-point 1 2 3) 4 5)
; It's a value because it's a structure value of type point,
; with three structure components (another structure value of type point 
; and two constants) as defined above.

(make-point (+ 1 2) 3 4)
; It's a value because it's a structure value of type point,
; with three structure components (one primitive application and
; two constants) as defined above.

(make-none)
; It's a value because it's a structure value of type none,
; with no components as defined above.

(make-point (point-x (make-point 1 2 3)) 4 5)
; It's a value because it's a structure value of type point,
; with three structure components (one selector function application
; applied on another point and two constants) as defined above.
