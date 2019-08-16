;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex051) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Constants
(define RADIUS 100)

; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume

; TrafficLight -> TrafficLight
; Yields the next state given current state s
(check-expect (traffic-light-next "red") "green")
(check-expect (traffic-light-next "green") "yellow")
(check-expect (traffic-light-next "yellow") "red")
(define (traffic-light-next s)
  (cond
    [(string=? "red" s) "green"]
    [(string=? "green" s) "yellow"]
    [(string=? "yellow" s) "red"]))

; TrafficLight -> Image
; Shows the traffic light for the current state
(check-expect (render "red") (circle RADIUS "solid" "red"))
(check-expect (render "green") (circle RADIUS "solid" "green"))
(check-expect (render "yellow") (circle RADIUS "solid" "yellow"))
(define (render tl)
  (circle RADIUS "solid" tl))

; TrafficLight -> TrafficLight
; Launches the traffic light program initially showing yellow, for safety.
(define traffic-light
  (big-bang "yellow"
    [on-tick traffic-light-next 5 12]
    [to-draw render]))
