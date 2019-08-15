;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname car) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
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

; Velocity of the car (number of pixels travelled per tick)
(define V 3)


; ..:: Functions ::..

; Distance after t ticks at velocity V
(define (distance t) (* V t))

; A WorldState is a Number.
; interpretation the number of ticks passed since the start of the program

; WorldState -> Image
; Renders the image of the car after ws ticks.
(check-expect (render 10) (place-image CAR 30 Y-CAR BACKGROUND))
(check-expect (render 50) (place-image CAR 150 Y-CAR BACKGROUND))
(define (render ws)
  (place-image CAR (distance ws) Y-CAR BACKGROUND))
 
; WorldState -> WorldState
; Increments the tick counter (cw) one unit.
(define (tock cw) (add1 cw))
 
; WorldState KeyEvent -> WorldState 
; Changes the state of the world according to the key (ke) pressed.
; If "space" is pressed, restart. Otherwise, continue.
(define (keystroke-handler cw ke) (if (key=? ke " ") 0 cw))
 
; WorldState -> Boolean
; Ends the program if the car exits the world.
(check-expect (end? 0) #false)
(check-expect (end? 75) #false)
(check-expect (end? 109) #true)
(check-expect (end? 110) #true)
(define (end? cw) (>= (distance cw) (+  WIDTH-OF-WORLD (/ BODY-LENGTH 2))))


; ..:: World ::..
; WorldState -> WorldState
; Launches the program from some initial state (ws).
(define (main ws)
   (big-bang ws
     [on-tick tock]
     [to-draw render]
     [stop-when end?]
     [on-key keystroke-handler]))