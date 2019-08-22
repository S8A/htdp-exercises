;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex156) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define HEIGHT 80) ; distances in terms of pixels 
(define WIDTH 100)
(define XSHOTS (/ WIDTH 2))
 
; graphical constants 
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SHOT (triangle 3 "solid" "red"))


; A List-of-numbers is one of:
; - '()
; - (cons Number List-of-nombers)


; A Shot is a Number.
; interpretation represents the shot's y-coordinate


; A ShotWorld is List-of-numbers. 
; interpretation each number on such a list
; represents the y-coordinate of a shot
(define sw1 '())
(define sw2 (cons 9 '()))
(define sw3 (cons 25 (cons 9 '())))


; ShotWorld -> ShotWorld
; runs a simulation of firing shots initialised with the list w0
(define (main w0)
  (big-bang w0
    [on-tick tock]
    [on-key keyh]
    [to-draw to-image]))


; ShotWorld -> Image
; adds the image of a shot for each  y on w 
; at (MID,y} to the background image 
(define (to-image w)
  (cond
    [(empty? w) BACKGROUND]
    [(cons? w)
     (place-image SHOT XSHOTS (first w) (to-image (rest w)))]))

(check-expect (to-image sw1) BACKGROUND)
(check-expect (to-image sw2)
              (place-image SHOT XSHOTS 9 BACKGROUND))
(check-expect (to-image sw3)
              (place-image SHOT XSHOTS 25
                           (place-image SHOT XSHOTS 9 BACKGROUND)))


; ShotWorld -> ShotWorld
; moves each shot on w up by one pixel 
(define (tock w)
  (cond
    [(empty? w) '()]
    [(cons? w)
     (cons (sub1 (first w)) (tock (rest w)))]))

(check-expect (tock sw1) sw1)
(check-expect (tock sw2) (cons 8 '()))
(check-expect (tock sw3) (cons 24 (cons 8 '())))


; ShotWorld KeyEvent -> ShotWorld 
; adds a shot to the world 
; if the player presses the space bar
(define (keyh w ke)
  (if (key=? ke " ") (cons HEIGHT w) w))

(check-expect (keyh sw1 " ") (cons HEIGHT '()))
(check-expect (keyh sw2 "r") sw2)
(check-expect (keyh sw3 " ") (cons HEIGHT (cons 25 (cons 9 '()))))
