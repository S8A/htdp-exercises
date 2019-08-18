;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex101) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define BASE-UNIT 3) ; 1 bu = 3 px

(define HEIGHT 200)
(define WIDTH HEIGHT)
(define X-CENTER (/ WIDTH 2))
(define BACKGROUND
  (overlay/align "center" "bottom"
                 (rectangle WIDTH BASE-UNIT "solid" "brown")
                 (empty-scene WIDTH HEIGHT "darkblue")))

(define UFO-RADIUS (* 2 BASE-UNIT))
(define UFO-WIDTH (* 4 UFO-RADIUS))
(define UFO-X-CENTER (/ UFO-WIDTH 2))
(define UFO
  (overlay (rectangle UFO-WIDTH BASE-UNIT "solid" "green")
           (circle UFO-RADIUS "solid" "green")))

(define TANK-HEIGHT (* 3 BASE-UNIT))
(define TANK-WIDTH (* 2 TANK-HEIGHT))
(define TANK-X-CENTER (/ TANK-WIDTH 2))
(define TANK-Y-CENTER (/ TANK-HEIGHT 2))
(define Y-TANK (- HEIGHT TANK-Y-CENTER BASE-UNIT))
(define TANK (rectangle TANK-WIDTH TANK-HEIGHT "solid" "darkgreen"))

(define MISSILE-SIZE (* 2 BASE-UNIT))
(define MISSILE-CENTER (/ MISSILE-SIZE 2))
(define MISSILE-LAUNCH-Y (- Y-TANK TANK-Y-CENTER MISSILE-CENTER))
(define MISSILE (triangle MISSILE-SIZE "solid" "red"))

(define EXPLOSION-INNER (* 2 BASE-UNIT))
(define EXPLOSION-OUTER (* 2 EXPLOSION-INNER))
(define EXPLOSION
  (overlay (radial-star 15 EXPLOSION-INNER EXPLOSION-OUTER "outline" "red")
           (radial-star 15 EXPLOSION-INNER EXPLOSION-OUTER "solid" "yellow")))

(define MESSAGE-HEIGHT (* 10 BASE-UNIT))
(define MESSAGE-TEXT-SIZE 16)
(define MESSAGE-VICTORY "VICTORY!")
(define MESSAGE-DEFEAT "GAME OVER!")

(define VX-TANK 1) ; The UFO moves at a speed of 1 px/tick
(define VY-UFO 1) ; The UFO descends at a speed of 1 px/tick
(define VY-MISSILE (* 2 VY-UFO)) ; The missile ascends at 2x the UFO's speed


; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)


(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, Y-TANK) and the tank's speed: dx pixels/tick 


; A MissileOrNot is one of: 
; – #false
; – Posn
; interpretation#false means the missile is in the tank;
; Posn says the missile is at that location


(define-struct sigs [ufo tank missile])
; A SIGS.v2 (short for SIGS version 2) is a structure:
;   (make-sigs UFO Tank MissileOrNot)
; interpretation represents the complete state of a
; space invader game


; Example structures
(define t75 (make-tank 75 3))
(define t56 (make-tank 56 3))
(define t125 (make-tank 125 -3))
(define t170 (make-tank 170 -3))

(define u10x50y (make-posn 10 50))
(define u56x112y (make-posn 56 112))
(define u56x10y (make-posn 56 10))
(define u106x185y (make-posn 106 190))

(define m56xly (make-posn 56 MISSILE-LAUNCH-Y))
(define m56x112y (make-posn 56 112))
(define mnot #false)


; Example images
(define tr75 (place-image TANK 75 Y-TANK BACKGROUND))
(define tr56 (place-image TANK 56 Y-TANK BACKGROUND))
(define tr125 (place-image TANK 125 Y-TANK BACKGROUND))
(define tr170 (place-image TANK 170 Y-TANK BACKGROUND))

(define ur10x50y (place-image UFO 10 50 BACKGROUND))
(define ur56x112y (place-image UFO 56 112 BACKGROUND))
(define ur56x10y (place-image UFO 56 10 BACKGROUND))
(define ur106x185y (place-image UFO 106 190 BACKGROUND))

(define mr56xly (place-image MISSILE 56 MISSILE-LAUNCH-Y BACKGROUND))
(define mr56x112y (place-image MISSILE 56 112 BACKGROUND))


; Example states
(define s1 (make-sigs u10x50y t75 mnot))
(define s2 (make-sigs u56x10y t56 mnot))
(define s3 (make-sigs u56x10y t56 m56xly))
(define s4 (make-sigs u56x112y t56 m56x112y))
(define s5 (make-sigs u106x185y t125 m56x112y))


; SIGS.v2 -> Image 
; renders the given game state on top of BACKGROUND 
(define (si-render.v2 s)
  (tank-render
    (sigs-tank s)
    (ufo-render (sigs-ufo s)
                (missile-render.v2 (sigs-missile s)
                                   BACKGROUND))))

(check-expect (si-render.v2 s1)
              (tank-render t75
                           (ufo-render u10x50y
                                       (missile-render.v2 mnot BACKGROUND))))
(check-expect (si-render.v2 s2)
              (tank-render t56
                           (ufo-render u56x10y
                                       (missile-render.v2 mnot BACKGROUND))))
(check-expect (si-render.v2 s3)
              (tank-render t56
                           (ufo-render u56x10y
                                       (missile-render.v2 m56xly BACKGROUND))))
(check-expect (si-render.v2 s4)
              (tank-render t56
                           (ufo-render u56x112y
                                       (missile-render.v2 m56x112y
                                                          BACKGROUND))))
(check-expect (si-render.v2 s5)
              (tank-render t125
                           (ufo-render u106x185y
                                       (missile-render.v2 m56x112y
                                                          BACKGROUND))))


; Tank Image -> Image 
; adds t to the given image im
(define (tank-render t im)
  (place-image TANK (tank-loc t) Y-TANK im))

(check-expect (tank-render t75 BACKGROUND) tr75)
(check-expect (tank-render t56 BACKGROUND) tr56)
(check-expect (tank-render t125 BACKGROUND) tr125)
(check-expect (tank-render t170 BACKGROUND) tr170)


; UFO Image -> Image 
; adds u to the given image im
(define (ufo-render u im)
  (place-image UFO (posn-x u) (posn-y u) im))

(check-expect (ufo-render u10x50y BACKGROUND) ur10x50y)
(check-expect (ufo-render u56x112y BACKGROUND) ur56x112y)
(check-expect (ufo-render u56x10y BACKGROUND) ur56x10y)
(check-expect (ufo-render u106x185y BACKGROUND) ur106x185y)


; MissileOrNot Image -> Image 
; adds an image of missile m to scene s 
(define (missile-render.v2 m s)
  s)

(check-expect (missile-render.v2 mnot BACKGROUND) BACKGROUND)
(check-expect (missile-render.v2 m56xly BACKGROUND)
              (place-image MISSILE (posn-x m56xly) (posn-y m56xly) BACKGROUND))
