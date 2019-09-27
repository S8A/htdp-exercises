;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex527) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define MT (empty-scene 400 400 "white"))
(define LINE-COLOR "black")

; Image Number Number Number Number -> Image
; adds a fractal Savannah tree to the given image
; generative adds the line that starts at (xb,yb) and grows upwards a
; given length at the given angle, then adds two subtrees corresponding
; to the left and right branches; stops if line-length is smaller
; than the threshold t
; termination is never reachd if t equals 0
(define (add-savannah im xb yb line-length angle t)
  (local ((define dl-left 0.33)
          (define da-left 15)
          (define dl-right 0.20)
          (define da-right -20))
    (cond
      [(< line-length t) im]
      [else
       (local (; 1. Add the given line to the image (Image)
               (define line1 (line-add im xb yb line-length angle))
               ; 2. Find the midpoint of the given line (Posn)
               (define mid1 (line-endpoint xb yb (* 1/2 line-length) angle))
               (define mid1-x (posn-x mid1))
               (define mid1-y (posn-y mid1))
               ; 3. Find the midpoint of the upper half of the line (Posn)
               (define mid2 (line-endpoint xb yb (* 3/4 line-length) angle))
               (define mid2-x (posn-x mid2))
               (define mid2-y (posn-y mid2))
               ; 4. Calculate the length of the left branch and its angle
               (define len-l (* line-length (- 1 dl-left)))
               (define angle-l (+ angle da-left))
               ; 5. Add the left branch starting from the 1st midpoint (Image)
               (define left (add-savannah line1 mid1-x mid1-y len-l angle-l t))
               ; 6. Calculate the length of the right branch and its angle
               (define len-r (* line-length (- 1 dl-right)))
               (define angle-r (+ angle da-right))
               ; 7. Add the right branch starting from the 2nd midpoint (Image)
               (define right (add-savannah left mid2-x mid2-y len-r angle-r t)))
         right)])))

; (add-savannah MT 100 390 150 0 5)


; Image Number Number Number Number -> Image
; Adds a line starting from the point (xb,yb) with a length l and inclined
; a degrees to the left of the vertical over the given image
(define (line-add im xb yb l a)
  (local ((define end (line-endpoint xb yb l a)))
    (scene+line im xb yb (posn-x end) (posn-y end) LINE-COLOR)))

(define rect15 (rectangle 15 15 "solid" "white"))
(check-expect (line-add rect15 7 12 12 15)
              (scene+line rect15 7 12 3.8942 0.4089 LINE-COLOR))
(check-expect (line-add rect15 7 12 12 -20)
              (scene+line rect15 7 12 11.1042 0.7237 LINE-COLOR))


; Number Number Number Number -> Posn
; Produces the position of the endpoint of a line that starts from (xb,yb)
; and grows upwards a length of l with an inclination of a degrees to the left
(define (line-endpoint xb yb l a)
  (make-posn (- xb (* l (sin (degrees->radians a))))
             (- yb (* l (cos (degrees->radians a))))))

(check-within (line-endpoint 7 12 12 15) (make-posn 3.8942 0.4089) 0.001)
(check-within (line-endpoint 7 12 12 -20) (make-posn 11.1042 0.7237) 0.001)


; Number -> Number
; converts the given angle from degrees to radians
(define (degrees->radians a)
  (* (/ a 180) pi))

(check-within (degrees->radians 30) (* 1/6 pi) 0.00001)
(check-within (degrees->radians 120) (* 2/3 pi) 0.00001)
