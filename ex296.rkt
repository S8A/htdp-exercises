;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex296) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Shape is a function: 
;   [Posn -> Boolean]
; interpretation if s is a shape and p a Posn, (s p) 
; produces #true if p is in s, #false otherwise


; Shape Posn -> Boolean
; Checks whether posn p is inside shape s
(define (inside? s p) (s p))


; Number Number -> Shape
; Creates a single point (x,y)
(define (mk-point x y)
  (lambda (p) (and (= (posn-x p) x) (= (posn-y p) y))))
 
(check-expect (inside? (mk-point 3 4) (make-posn 3 4))
              #true)
(check-expect (inside? (mk-point 3 4) (make-posn 3 0))
              #false)


; Number Number Number -> Shape
; Creates a circle of center (center-x, center-y) with radius r
(define (mk-circle center-x center-y r)
  (lambda (p) (<= (distance-between center-x center-y p) r)))

(check-expect
  (inside? (mk-circle 3 4 5) (make-posn 0 0)) #true)
(check-expect
  (inside? (mk-circle 3 4 5) (make-posn 0 9)) #false)
(check-expect
  (inside? (mk-circle 3 4 5) (make-posn -1 3)) #true)


; Exercise 296. Use compass-and-pencil drawings to check the tests.
; Done in my head.
