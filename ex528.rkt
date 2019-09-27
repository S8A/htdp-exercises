;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex528) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define MT (empty-scene 400 400))
(define A (make-posn 200  50))
(define B (make-posn  27 350))
(define C (make-posn 373 350))
(define LINE-COLOR "red")


; Image Posn Posn Posn Number -> Image
; Draws a Bezier curve over the scene s, given foci a and c,
; and observer point b.
; generative: Finds the midpoint between the midpoints of each
; observer line and draws the Bezier curves of each half; stops
; when the distance between the observer point and the midpoint
; of the foci is smaller than the threshold t
    ; termination: is never reached if t is 0.
(define (bezier s a b c t)
  (cond
    [(too-small? a b c t)
     (scene+line s (posn-x a) (posn-y a) (posn-x c) (posn-y c) LINE-COLOR)]
    [else
     (local ((define mid-ab (mid-point a b))
             (define mid-bc (mid-point b c))
             (define mid-abc (mid-point mid-ab mid-bc))
             (define draw-left (bezier s a mid-ab mid-abc t))
             (define draw-right (bezier draw-left mid-abc mid-bc c t)))
       draw-right)]))

; (bezier MT A B C 0.01)


; Posn Posn Posn Number -> Boolean
; determines if the distance between b and the midpoint of a and c is
; smaller than the given threshold
(define (too-small? a b c threshold)
  (< (distance b (mid-point a c)) threshold))

(define tri1 (list (make-posn 0 0) (make-posn 3 4) (make-posn 3 0)))
(define tri2 (list (make-posn -3 3) (make-posn 3 -5) (make-posn -3 -5)))
(define tri3 (list (make-posn 2 0) (make-posn 0 -0.2) (make-posn -1.5 0)))
(check-expect (too-small? (first tri1) (second tri1) (third tri1) 0.5) #false)
(check-expect (too-small? (first tri2) (second tri2) (third tri2) 0.5) #false)
(check-expect (too-small? (first tri3) (second tri3) (third tri3) 0.5) #true)


; Posn Posn -> Posn 
; determines the midpoint between a and b
(define (mid-point a b)
  (make-posn (/ (+ (posn-x a) (posn-x b)) 2)
             (/ (+ (posn-y a) (posn-y b)) 2)))

(check-expect (mid-point (make-posn 0 0) (make-posn 3 4))
              (make-posn 1.5 2))
(check-expect (mid-point (make-posn -3 3) (make-posn 3 -5))
              (make-posn 0 -1))


; Posn Posn -> Number
; determines the distance between a and b
(define (distance a b)
  (sqrt (+ (sqr (- (posn-x a) (posn-x b)))
           (sqr (- (posn-y a) (posn-y b))))))

(check-expect (distance (make-posn 0 0) (make-posn 3 4)) 5)
(check-expect (distance (make-posn -3 3) (make-posn 3 -5)) 10)
