;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex096) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Constants
(define BASE-UNIT 5) ; 1 bu = 5 px

(define HEIGHT (* 40 BASE-UNIT))
(define WIDTH HEIGHT)
(define FRAME
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


; Example/exercise scenes
(define EX1
  (place-image UFO 20 10
               (place-image TANK 28 Y-TANK FRAME)))
(define EX2
  (place-image MISSILE 28 MISSILE-LAUNCH-Y
               (place-image UFO 20 10
                            (place-image TANK 28 Y-TANK FRAME))))
(define EX3 ; 25 ticks after launch
  (place-image MISSILE 22 103
               (place-image UFO 20 100
                            (place-image TANK 100 Y-TANK FRAME))))
