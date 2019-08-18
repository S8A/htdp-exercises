;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex094) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Constants
(define BASE-UNIT 5) ; 1 bu = 5 px

(define HEIGHT (* 100 BASE-UNIT))
(define WIDTH (* 50 BASE-UNIT))
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


; Example scenes
(define EXSC1
  (place-image UFO 100 50
               (place-image TANK 75 Y-TANK FRAME)))
(define EXSC2
  (place-image UFO 95 75
               (place-image TANK 125 Y-TANK FRAME)))
(define EXSC3
  (place-image UFO 113 100
               (place-image TANK 112 Y-TANK FRAME)))
(define EXSC4 ; missile launch
  (place-image MISSILE 113 MISSILE-LAUNCH-Y
               (place-image UFO 113 101
                            (place-image TANK 113 Y-TANK FRAME))))
(define EXSC5 ; 25 ticks after launch
  (place-image MISSILE 113 225
               (place-image UFO 113 226
                            (place-image TANK 113 Y-TANK FRAME))))
(define EXSC6 ; explosion (victory) => (render-text str color scene)
  (overlay (overlay (text "VICTORY!" 16 "white")
                    (rectangle WIDTH MESSAGE-HEIGHT "solid" (color 0 0 0 128)))
           (place-image EXPLOSION 113 226
                              (place-image TANK 113 Y-TANK FRAME))))
(define EXSC7 ; landing (defeat) => (render-text str color scene)
  (overlay (overlay (text "DEFEAT!" 16 "red")
                    (rectangle WIDTH MESSAGE-HEIGHT "solid" (color 0 0 0 128)))
           (place-image UFO 212 476
                        (place-image TANK 170 Y-TANK FRAME))))
