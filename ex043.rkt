;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex043) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ..:: Constants ::..

; Wheels of the car
(define WHEEL-RADIUS 5) ; Single point of control
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

; Tree
(define TREE-LEAVES
  (circle (* 2 WHEEL-RADIUS) "solid" "green"))
(define TREE-TRUNK
  (rectangle (/ WHEEL-RADIUS 2) (* 4 WHEEL-RADIUS) "solid" "brown"))
(define TREE
  (underlay/align/offset "middle" "top"
                         TREE-LEAVES
                         0 (* 3 WHEEL-RADIUS)
                         TREE-TRUNK))

; World scene
(define WIDTH-OF-WORLD (* 60 WHEEL-RADIUS))
(define HEIGHT-OF-WORLD (* 8 WHEEL-RADIUS))
(define Y-TREE (- HEIGHT-OF-WORLD (/ (image-height TREE) 2)))
(define BACKGROUND
  (place-image TREE 100 Y-TREE (empty-scene WIDTH-OF-WORLD HEIGHT-OF-WORLD)))
(define Y-CAR (- HEIGHT-OF-WORLD (/ (image-height CAR) 2)))


; ..:: Functions ::..

; Distance after t ticks using formula d(t) = sin(t) + t
(define (distance t) (+ (* 10 (sin t)) t))

; An AnimationState is a Number.
; interpretation the number of clock ticks 
; since the animation started

; AnimationState -> Image
; Renders the image of the car after t ticks.
(check-expect (render 10)
              (place-image CAR (+ (* 10 (sin 10)) 10) Y-CAR BACKGROUND))
(check-expect (render 50)
              (place-image CAR (+ (* 10 (sin 50)) 50) Y-CAR BACKGROUND))
(define (render t)
  (place-image CAR (distance t) Y-CAR BACKGROUND))
 
; AnimationState -> AnimationState
; Increments the tick counter (t) one unit.
(define (tock t) (add1 t))

 
; AnimationState -> Boolean
; Ends the program if the car exits the world.
(check-expect (end? 0) #false)
(check-expect (end? 75) #false)
(check-expect (end? 315) #false)
(check-expect (end? 316) #true)
(define (end? t) (>= (distance t) (+  WIDTH-OF-WORLD (/ BODY-LENGTH 2))))


; ..:: World ::..
; AnimationState -> AnimationState
; Launches the program from some initial state (ws).
(define (main ws)
   (big-bang ws
     [on-tick tock]
     [to-draw render]
     [stop-when end?]))