;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex115) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Any -> Boolean
; is the given value an element of TrafficLight
(define (light? x)
  (cond
    [(string? x) (or (string=? "red" x)
                     (string=? "green" x)
                     (string=? "yellow" x))]
    [else #false]))


(define MESSAGE1
  "traffic light expected as 1st argument, given some other value")
(define MESSAGE2
  "traffic light expected as 2nd argument, given some other value")

; Any Any -> Boolean
; are the two values elements of TrafficLight and, 
; if so, are they equal 
(define (light=? a-value another-value)
  (cond
    [(not (light? a-value)) (error MESSAGE1)]
    [(not (light? another-value)) (error MESSAGE2)]
    [else (string=? a-value another-value)]))

(check-expect (light=? "red" "red") #true)
(check-expect (light=? "red" "green") #false)
(check-expect (light=? "green" "green") #true)
(check-expect (light=? "yellow" "yellow") #true)
(check-error (light=? "salad" "greens") MESSAGE1)
(check-error (light=? "red" "perico") MESSAGE2)
