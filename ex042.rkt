;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex042) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
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

; Velocity of the car (number of pixels travelled per tick)
(define V 3)

; Distance after t ticks at velocity V
(define (distance t) (* V t))

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

; A WorldState is a Number.
; interpretation the number of pixels between
; the right border of the scene and the car

; WorldState -> Image
; Places the image of the car with its right-most edge x pixels from 
; the left margin of the BACKGROUND image 
(check-expect (render 30) (place-image CAR 55 Y-CAR BACKGROUND))
(check-expect (render 150) (place-image CAR 175 Y-CAR BACKGROUND))
(define (render x)
  (place-image CAR (+ x (/ BODY-LENGTH 2)) Y-CAR BACKGROUND))
 
; WorldState -> WorldState
; Adds 3 to x to move the car right.
(check-expect (tock 20) 23)
(check-expect (tock 78) 81)
(define (tock x) (+ x 3))
 
; WorldState -> Boolean
; Ends the program if the car exits the world.
(check-expect (end? 0) #false)
(check-expect (end? 75) #false)
(check-expect (end? 325) #true)
(check-expect (end? 326) #true)
(define (end? x) (>= x (+  WIDTH-OF-WORLD (/ BODY-LENGTH 2))))


; ..:: World ::..
; WorldState -> WorldState
; Launches the program from some initial state (ws).
(define (main ws)
   (big-bang ws
     [on-tick tock]
     [to-draw render]
     [stop-when end?]))