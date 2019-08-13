;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ufo-landing) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; constants 
(define WIDTH  500)
(define HEIGHT  400)
(define X (/ WIDTH 2))
(define V 3)
(define ROCK-HEIGHT 10)
(define ROCK-CENTER-TO-TOP (- HEIGHT (/ ROCK-HEIGHT 2)))
(define ROCK (rectangle WIDTH ROCK-HEIGHT "solid" "brown"))
(define MTSCN
  (place-image ROCK X ROCK-CENTER-TO-TOP (overlay (rectangle WIDTH HEIGHT "solid" "blue") (empty-scene WIDTH HEIGHT))))
(define ROCKET
  (overlay (circle 10 "solid" "green") (rectangle 40 4 "solid" "green")))
(define ROCKET-CENTER-TO-TOP
  (- HEIGHT (/ (image-height ROCKET) 2) ROCK-HEIGHT))
 
; functions
(define (ufo t)
  (cond
    [(<= (distance t) ROCKET-CENTER-TO-TOP)
     (place-image ROCKET X (distance t) MTSCN)]
    [(> (distance t) ROCKET-CENTER-TO-TOP)
     (place-image ROCKET X ROCKET-CENTER-TO-TOP MTSCN)]))

(define (distance t) (* V t))