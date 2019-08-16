;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex061) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define RADIUS 15)
(define MARGIN (/ RADIUS 3))
(define HEIGHT (* 3 RADIUS))
(define WIDTH (* 2.5 HEIGHT))
(define FRAME (overlay (rectangle WIDTH HEIGHT "outline" "blue")
                       (rectangle WIDTH HEIGHT "solid" "black")))
(define SPACER (rectangle MARGIN HEIGHT "solid" "transparent"))


(define RED 0)
(define GREEN 1)
(define YELLOW 2)
 
; An S-TrafficLight is one of:
; – RED
; – GREEN
; – YELLOW


; S-TrafficLight -> S-TrafficLight
; Yields the next state given current state cs
(define (tl-next cs)
  (cond
    [(equal? cs RED) GREEN]
    [(equal? cs GREEN) YELLOW]
    [(equal? cs YELLOW) RED]))

(check-expect (tl-next RED) GREEN)
(check-expect (tl-next GREEN) YELLOW)
(check-expect (tl-next YELLOW) RED)


; N-TrafficLight -> N-TrafficLight
; yields the next state, given current state cs
(define (tl-next-numeric cs) (modulo (+ cs 1) 3))

(check-expect (tl-next-numeric 0) 1)
(check-expect (tl-next-numeric 1) 2)
(check-expect (tl-next-numeric 2) 0)


; S-TrafficLight Boolean -> Image
; draws a lightbulb of the given color
(define (light color on?)
  (circle RADIUS (if on? "solid" "outline")
          (cond
            [(equal? color RED) "red"]
            [(equal? color GREEN) "green"]
            [(equal? color YELLOW) "yellow"])))

(check-expect (light RED #false) (circle RADIUS "outline" "red"))
(check-expect (light YELLOW #true) (circle RADIUS "solid" "yellow"))
(check-expect (light GREEN #false) (circle RADIUS "outline" "green"))


; S-TrafficLight -> Image
; renders the current state cs as an image
(define (tl-render cs)
  (overlay (beside SPACER (light RED (equal? cs RED))
                   SPACER (light YELLOW (equal? cs YELLOW))
                   SPACER (light GREEN (equal? cs GREEN)) SPACER)
           FRAME))

(check-expect (tl-render RED)
              (overlay (beside SPACER (light RED #t)
                               SPACER (light YELLOW #f)
                               SPACER (light GREEN #f) SPACER)
                       FRAME))
(check-expect (tl-render YELLOW)
              (overlay (beside SPACER (light RED #f)
                               SPACER (light YELLOW #t)
                               SPACER (light GREEN #f) SPACER)
                       FRAME))
(check-expect (tl-render GREEN)
              (overlay (beside SPACER (light RED #f)
                               SPACER (light YELLOW #f)
                               SPACER (light GREEN #t) SPACER)
                       FRAME))


; S-TrafficLight -> S-TrafficLight
; simulates a clock-based American traffic light
(define (traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render]
    [on-tick tl-next 1])) ;Properly designed. Works either way.
;    [on-tick tl-next-numeric 1])) ;Works if constants are numbers, not strings.
