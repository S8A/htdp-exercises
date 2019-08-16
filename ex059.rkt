;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex059) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define RADIUS 15)
(define MARGIN (/ RADIUS 3))
(define HEIGHT (* 3 RADIUS))
(define WIDTH (* 2.5 HEIGHT))
(define FRAME (overlay (rectangle WIDTH HEIGHT "outline" "blue")
                       (rectangle WIDTH HEIGHT "solid" "black")))
(define SPACER (rectangle MARGIN HEIGHT "solid" "transparent"))


; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume


; TrafficLight -> TrafficLight
; Yields the next state given current state cs

(check-expect (tl-next "red") "green")
(check-expect (tl-next "green") "yellow")
(check-expect (tl-next "yellow") "red")

(define (tl-next cs)
  (cond
    [(string=? "red" cs) "green"]
    [(string=? "green" cs) "yellow"]
    [(string=? "yellow" cs) "red"]))


; TrafficLight Boolean -> Image
; draws a lightbulb of the given color

(check-expect (light "red" #false) (circle RADIUS "outline" "red"))
(check-expect (light "yellow" #true) (circle RADIUS "solid" "yellow"))
(check-expect (light "green" #false) (circle RADIUS "outline" "green"))

(define (light color on?)
  (circle RADIUS (if on? "solid" "outline") color))


; TrafficLight -> Image
; renders the current state cs as an image

(check-expect (tl-render "red")
              (overlay (beside SPACER (light "red" #t)
                               SPACER (light "yellow" #f)
                               SPACER (light "green" #f) SPACER)
                       FRAME))
(check-expect (tl-render "yellow")
              (overlay (beside SPACER (light "red" #f)
                               SPACER (light "yellow" #t)
                               SPACER (light "green" #f) SPACER)
                       FRAME))
(check-expect (tl-render "green")
              (overlay (beside SPACER (light "red" #f)
                               SPACER (light "yellow" #f)
                               SPACER (light "green" #t) SPACER)
                       FRAME))

(define (tl-render cs)
  (overlay (beside SPACER (light "red" (string=? cs "red"))
                   SPACER (light "yellow" (string=? cs "yellow"))
                   SPACER (light "green" (string=? cs "green")) SPACER)
           FRAME))


; TrafficLight -> TrafficLight
; simulates a clock-based American traffic light
(define (traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render]
    [on-tick tl-next 1]))
