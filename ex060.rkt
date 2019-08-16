;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex060) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define RADIUS 15)
(define MARGIN (/ RADIUS 3))
(define HEIGHT (* 3 RADIUS))
(define WIDTH (* 2.5 HEIGHT))
(define FRAME (overlay (rectangle WIDTH HEIGHT "outline" "blue")
                       (rectangle WIDTH HEIGHT "solid" "black")))
(define SPACER (rectangle MARGIN HEIGHT "solid" "transparent"))


; An N-TrafficLight is one of:
; – 0 interpretation the traffic light shows red
; – 1 interpretation the traffic light shows green
; – 2 interpretation the traffic light shows yellow


; N-TrafficLight -> N-TrafficLight
; yields the next state, given current state cs
(define (tl-next-numeric cs) (modulo (+ cs 1) 3))

(check-expect (tl-next-numeric 0) 1)
(check-expect (tl-next-numeric 1) 2)
(check-expect (tl-next-numeric 2) 0)

; Q: Does the tl-next function convey its intention more clearly 
; than the tl-next-numeric function?
; A: Yes, because using numbers is not as intuitive.


; N-TrafficLight Boolean -> Image
; draws a lightbulb of the given color
(define (light-numeric color on?)
  (circle RADIUS (if on? "solid" "outline")
          (cond
            [(= color 0) "red"]
            [(= color 1) "green"]
            [(= color 2) "yellow"])))

(check-expect (light-numeric 0 #false) (circle RADIUS "outline" "red"))
(check-expect (light-numeric 2 #true) (circle RADIUS "solid" "yellow"))
(check-expect (light-numeric 1 #false) (circle RADIUS "outline" "green"))


; N-TrafficLight -> Image
; renders the current state cs as an image
(define (tl-render-numeric cs)
  (overlay (beside SPACER (light-numeric 0 (= cs 0))
                   SPACER (light-numeric 2 (= cs 2))
                   SPACER (light-numeric 1 (= cs 1)) SPACER)
           FRAME))

(check-expect (tl-render-numeric 0)
              (overlay (beside SPACER (light-numeric 0 #t)
                               SPACER (light-numeric 2 #f)
                               SPACER (light-numeric 1 #f) SPACER)
                       FRAME))
(check-expect (tl-render-numeric 2)
              (overlay (beside SPACER (light-numeric 0 #f)
                               SPACER (light-numeric 2 #t)
                               SPACER (light-numeric 1 #f) SPACER)
                       FRAME))
(check-expect (tl-render-numeric 1)
              (overlay (beside SPACER (light-numeric 0 #f)
                               SPACER (light-numeric 2 #f)
                               SPACER (light-numeric 1 #t) SPACER)
                       FRAME))


; N-TrafficLight -> N-TrafficLight
; simulates a clock-based American traffic light
(define (numeric-traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render-numeric]
    [on-tick tl-next-numeric 1]))
