;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex039) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Wheels of the car
(define WHEEL-RADIUS 20) ; Single point of control
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))
(define WHEEL
  (circle WHEEL-RADIUS "solid" "black"))
(define BOTH-WHEELS
  (overlay/xy WHEEL WHEEL-DISTANCE 0 WHEEL))

; Chassis of the car
(define COLOR "red")

(define BODY-LENGTH (* 10 WHEEL-RADIUS))
(define BODY-HEIGHT (* 2 WHEEL-RADIUS))
(define BODY (rectangle BODY-LENGTH BODY-HEIGHT "solid" COLOR))

(define TOP-LENGTH (/ BODY-LENGTH 2))
(define TOP-HEIGHT (/ BODY-HEIGHT 2))
(define TOP (rectangle TOP-LENGTH TOP-HEIGHT "solid" COLOR))

(define CHASSIS
  (overlay/align/offset "middle" "top" TOP 0 TOP-HEIGHT BODY))

; Car
(define CAR
  (underlay/align/offset "middle" "bottom" CHASSIS 0 WHEEL-RADIUS BOTH-WHEELS))
