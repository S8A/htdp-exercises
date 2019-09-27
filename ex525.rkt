;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex525) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define MT (empty-scene 400 400))
(define A (make-posn 200  50))
(define B (make-posn  27 350))
(define C (make-posn 373 350))

(define tri1 (list (make-posn 0 0) (make-posn 3 4) (make-posn 3 0)))
(define tri2 (list (make-posn -3 3) (make-posn 3 -5) (make-posn -3 -5)))
(define tri3 (list (make-posn 1.5 2) (make-posn 0 -1) (make-posn -3 0)))


; Image Posn Posn Posn N -> Image 
; generative adds the triangle (a, b, c) to s, 
; subdivides it into three triangles by taking the 
; midpoints of its sides; stop if (a, b, c) is too small
; using threshold t
; accumulator the function accumulates the triangles scene0
; termination is never reached if t equals 0
(define (add-sierpinski scene0 a b c t)
  (cond
    [(too-small? a b c t) scene0]
    [else
     (local
       ((define scene1 (add-triangle scene0 a b c))
        (define mid-a-b (mid-point a b))
        (define mid-b-c (mid-point b c))
        (define mid-c-a (mid-point c a))
        (define scene2
          (add-sierpinski scene1 a mid-a-b mid-c-a t))
        (define scene3
          (add-sierpinski scene2 b mid-b-c mid-a-b t)))
       ; —IN—
       (add-sierpinski scene3 c mid-c-a mid-b-c t))]))

; (add-sierpinski MT A B C 5)


; Image Posn Posn Posn -> Image 
; adds the black triangle a, b, c to scene
(define (add-triangle scene a b c)
  (local (; Image Posn Posn -> Image
          ; adds a black line from p to q to the given scene
          (define (add-line s p q)
            (scene+line s (posn-x p) (posn-y p) (posn-x q) (posn-y q) "black"))
          ; 1. Add line from a to b
          (define ab (add-line scene a b))
          ; 2. Add line from a to c
          (define ac (add-line ab a c))
          ; 3. Add line from b to c
          (define bc (add-line ac b c)))
    bc))

(check-expect (add-triangle (rectangle 5 5 "solid" "white")
                            (first tri1) (second tri1) (third tri1))
              (scene+line
               (scene+line
                (scene+line (rectangle 5 5 "solid" "white") 0 0 3 4 "black")
                0 0 3 0 "black")
               3 4 3 0 "black"))


; Posn Posn Posn -> Boolean 
; is the triangle a, b, c too small to be divided
(define (too-small? a b c threshold)
  (or (< (distance a b) threshold)
      (< (distance a c) threshold)
      (< (distance b c) threshold)))

(check-expect (too-small? (first tri1) (second tri1) (third tri1) 5) #true)
(check-expect (too-small? (first tri2) (second tri2) (third tri2) 5) #false)
(check-expect (too-small? (first tri3) (second tri3) (third tri3) 5) #true)


; Posn Posn -> Posn 
; determines the midpoint between a and b
(define (mid-point a b)
  (make-posn (* 1/2 (+ (posn-x a) (posn-x b)))
             (* 1/2 (+ (posn-y a) (posn-y b)))))

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
