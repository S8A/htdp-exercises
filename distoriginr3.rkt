;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname distoriginr3) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct r3 [x y z])
; An R3 is a structure:
;   (make-r3 Number Number Number)
; interpretation (make-r3 x y z) represents the position of
; an object in 3-dimensional space (x,y,z)
 
(define ex1 (make-r3 1 2 13))
(define ex2 (make-r3 -1 0 3))


; R3 -> Number
; calculates the distance of p to the origin (0,0,0)
(define (distance-to-0 p)
  (sqrt (+ (sqr (r3-x p)) (sqr (r3-y p)) (sqr (r3-z p)))))

(check-within (distance-to-0 ex1) (sqrt 174) 0.0000000001)
(check-within (distance-to-0 ex2) (sqrt 10) 0.0000000001)
(check-expect (distance-to-0 (make-r3 45 0 0)) 45)
(check-expect (distance-to-0 (make-r3 0 -38 0)) 38)
(check-expect (distance-to-0 (make-r3 0 0 234)) 234)
