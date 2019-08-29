;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex252) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; [X Y] [X Y -> Y] Y [List-of X] -> [List-of Y]
(define (fold2 f n l)
  (cond
    [(empty? l) n]
    [(cons? l)
     (f (first l) (fold2 f n (rest l)))]))


; [List-of Number] -> Number
(define (product l)
  (fold2 * 1 l))

(check-expect (product '()) 1)
(check-expect (product '(10 7 5)) 350)
(check-expect (product '(1 2 3 4)) 24)


; graphical constants:    
(define emt (empty-scene 100 100))
(define dot (circle 3 "solid" "red"))

; Posn Image -> Image 
(define (place-dot p img)
  (place-image dot (posn-x p) (posn-y p) img))

; [List-of Posn] -> Image
(define (image* l)
  (fold2 place-dot emt l))

(check-expect (image* '()) emt)
(check-expect (image* `(,(make-posn 1 2) ,(make-posn 3 4)))
              (place-dot (make-posn 1 2)
                         (place-dot (make-posn 3 4) emt)))
