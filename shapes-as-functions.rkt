;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname shapes-as-functions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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


; Number Number Posn -> Number
; Calculates the distance between posn p and (x,y)
(define (distance-between x y p)
  (sqrt (+ (sqr (- x (posn-x p))) (sqr (- y (posn-y p))))))

(check-expect (distance-between 0 0 (make-posn 3 4)) 5)
(check-expect (distance-between -3 -4 (make-posn 3 4)) 10)


; Number Number Number Number -> Shape
; represents a width by height rectangle whose 
; upper-left corner is located at (ul-x, ul-y) 
(define (mk-rect ul-x ul-y width height)
  (lambda (p)
    (and (<= ul-x (posn-x p) (+ ul-x width))
         (<= ul-y (posn-y p) (+ ul-y height)))))

(check-expect (inside? (mk-rect 0 0 10 3)
                       (make-posn 0 0))
              #true)
(check-expect (inside? (mk-rect 2 3 10 3)
                       (make-posn 4 5))
              #true)
(check-expect (inside? (mk-rect 2 3 10 3)
                       (make-posn 0 0))
              #false)


; Shape Shape -> Shape
; combines two shapes into one 
(define (mk-combination s1 s2)
  (lambda (p) (or (inside? s1 p) (inside? s2 p))))

(define circle1 (mk-circle 3 4 5))
(define rectangle1 (mk-rect 0 3 10 3))
(define union1 (mk-combination circle1 rectangle1))

(check-expect (inside? union1 (make-posn 0 0)) #true)
(check-expect (inside? union1 (make-posn 0 9)) #false)
(check-expect (inside? union1 (make-posn -1 3)) #true)
