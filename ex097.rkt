;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex097) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Constants
(define BASE-UNIT 5) ; 1 bu = 5 px

(define HEIGHT (* 40 BASE-UNIT))
(define WIDTH HEIGHT)
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

(define V-UFO BASE-UNIT) ; The UFO descends at a speed of 1 bu/tick
(define V-MISSILE (* 2 V-UFO)) ; The missile ascends at 2x the speed of the UFO


; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)


(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, Y-TANK) and the tank's speed: dx pixels/tick 


; A Missile is a Posn. 
; interpretation (make-posn x y) is the missile's place


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


(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])
; A SIGS is one of: 
; – (make-aim UFO Tank)
; – (make-fired UFO Tank Missile)
; interpretation represents the complete state of a 
; space invader game


; Example states
(define s1 (make-aim u10x50y t75))
(define s2 (make-aim u56x10y t56))
(define s3 (make-fired u56x10y t56 m56xly))
(define s4 (make-fired u56x112y t56 m56x112y))
(define s5 (make-fired u106x185y t125 m56x112y))


; SIGS -> Image
; renders the given game state on top of BACKGROUND 
; for examples see figure 32
(define (si-render s)
  (cond
    [(aim? s)
     (tank-render (aim-tank s)
                  (ufo-render (aim-ufo s) BACKGROUND))]
    [(fired? s)
     (tank-render
       (fired-tank s)
       (ufo-render (fired-ufo s)
                   (missile-render (fired-missile s)
                                   BACKGROUND)))]))

(check-expect (si-render s1)
              (tank-render t75 (ufo-render u10x50y BACKGROUND)))
(check-expect (si-render s2)
              (tank-render t56 (ufo-render u56x10y BACKGROUND)))
(check-expect (si-render s3)
              (tank-render t56
                           (ufo-render u56x10y
                                       (missile-render m56xly BACKGROUND))))
(check-expect (si-render s4)
              (tank-render t56
                           (ufo-render u56x112y
                                       (missile-render m56x112y BACKGROUND))))
(check-expect (si-render s5)
              (tank-render t125
                           (ufo-render u106x185y
                                       (missile-render m56x112y BACKGROUND))))


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


; Missile Image -> Image 
; adds m to the given image im
(define (missile-render m im)
  (place-image MISSILE (posn-x m) (posn-y m) im))

(check-expect (missile-render m56xly BACKGROUND) mr56xly)
(check-expect (missile-render m56x112y BACKGROUND) mr56x112y)


; Compare this expression:
;   (tank-render (fired-tank s)
;                (ufo-render (fired-ufo s)
;                            (missile-render (fired-missile s) BACKGROUND)))
; with this one:
;   (ufo-render (fired-ufo s)
;               (tank-render (fired-tank s)
;                            (missile-render (fired-missile s) BACKGROUND)))
; Q: When do the two expressions produce the same result?
; A: When TANK and UFO are not overlapping.
