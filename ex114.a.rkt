;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex114.a) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Constants
(define BASE-UNIT 5) ; 1 bu = 5 px

(define HEIGHT (* 40 BASE-UNIT))
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


; Any -> Boolean
; is a an element of the SIGS collection
(define (sigs? a)
  (or (aim? a) (fired? a)))

(check-expect (sigs? s1) #true)
(check-expect (sigs? s2) #true)
(check-expect (sigs? s3) #true)
(check-expect (sigs? s4) #true)
(check-expect (sigs? s5) #true)
(check-expect (sigs? t56) #false)
(check-expect (sigs? u56x10y) #false)
(check-expect (sigs? m56xly) #false)
(check-expect (sigs? 33) #false)
(check-expect (sigs? "example") #false)


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


; Posn Posn -> Number
; calculates the distance between two positions
(define (distance-points a b)
  (sqrt (+ (sqr (- (posn-x a) (posn-x b)))
           (sqr (- (posn-y a) (posn-y b))))))

(check-expect (distance-points (make-posn 0 0) (make-posn 3 4)) 5)
(check-expect (distance-points (make-posn -2 -3) (make-posn 4 5)) 10)


; SIGS -> Boolean
; checks if the missile hit the UFO
(define (hit-ufo? s)
  (and (fired? s) (<= (distance-points (fired-ufo s) (fired-missile s))
                      UFO-RADIUS)))


; SIGS -> Boolean
; checks if the UFO landed
(define (ufo-landed? s)
  (or (and (fired? s) (<= (- HEIGHT BASE-UNIT (posn-y (fired-ufo s)))
                        UFO-RADIUS))
      (and (aim? s) (<= (- HEIGHT BASE-UNIT (posn-y (aim-ufo s)))
                        UFO-RADIUS))))


; SIGS -> SIGS
; stops the game if the UFO lands or if the missile hits the UFO
(define (si-game-over? s)
  (or (hit-ufo? s) (ufo-landed? s)))

(check-expect (si-game-over? s1) #false)
(check-expect (si-game-over? s2) #false)
(check-expect (si-game-over? s3) #false)
(check-expect (si-game-over? s4) #true)
(check-expect (si-game-over? s5) #true)


; String Color Image -> Image
; overlays text str of color c over the image im
(define (overlay-text str c im)
  (overlay (overlay (text str MESSAGE-TEXT-SIZE c)
                    (rectangle WIDTH MESSAGE-HEIGHT "solid" (color 0 0 0 128)))
           im))


; UFO Image -> Image
; places explosion on the UFO's position over image im
(define (ufo-explosion u im)
  (place-image EXPLOSION (posn-x u) (posn-y u) im))



; SIGS -> Image
; renders the final image of the game, indicating victory or defeat
(define (si-render-final s)
  (overlay-text (cond [(hit-ufo? s) MESSAGE-VICTORY]
                      [(ufo-landed? s) MESSAGE-DEFEAT])
                (cond [(hit-ufo? s) "white"]
                      [(ufo-landed? s) "red"])
                (cond [(hit-ufo? s) (ufo-explosion (fired-ufo s) (si-render s))]
                      [(ufo-landed? s) (si-render s)])))


(check-expect (si-render-final s4)
              (overlay (overlay (text MESSAGE-VICTORY MESSAGE-TEXT-SIZE "white")
                                (rectangle WIDTH MESSAGE-HEIGHT
                                           "solid" (color 0 0 0 128)))
                       (ufo-explosion u56x112y (si-render s4))))
(check-expect (si-render-final s5)
              (overlay (overlay (text MESSAGE-DEFEAT MESSAGE-TEXT-SIZE "red")
                                (rectangle WIDTH MESSAGE-HEIGHT
                                           "solid" (color 0 0 0 128)))
                       (si-render s5)))


; UFO -> Boolean
; checks if the UFO is close to the right and left edges of the frame
(define (ufo-close-to-edges? u)
  (or (<= (posn-x u) UFO-RADIUS) (>= (posn-x u) (- WIDTH UFO-RADIUS))))


; UFO Number Number -> UFO
; moves UFO to the right dx pixels and down dy pixels, ensuring
; it doesn't move out of frame horizontally
(define (move-ufo u dx dy)
  (make-posn (if (ufo-close-to-edges? u)
                 (posn-x u)
                 (+ (posn-x u) dx))
             (+ (posn-y u) dy)))


; Missile Number -> Missile
; moves missile dy pixels upward
(define (move-missile m dy)
  (make-posn (posn-x m) (- (posn-y m) dy)))


; Tank Number Number -> Tank
; moves tank to the left or right, according to its velocity
(define (move-tank t)
  (make-tank (+ (tank-loc t) (tank-vel t)) (tank-vel t)))


; SIGS Number -> SIGS 
; moves the space-invader objects; UFO moves horizontally by dx-u
(define (si-move-proper s dx-u)
  (cond
    [(aim? s)
     (make-aim (move-ufo (aim-ufo s) dx-u VY-UFO)
               (move-tank (aim-tank s)))]
    [(fired? s)
     (make-fired (move-ufo (fired-ufo s) dx-u VY-UFO)
                 (move-tank (fired-tank s))
                 (move-missile (fired-missile s) VY-MISSILE))]))

(check-expect (si-move-proper s1 3)
              (make-aim (make-posn 10 51)
                        (make-tank 78 3)))
(check-expect (si-move-proper s2 3)
              (make-aim (make-posn 59 11)
                        (make-tank 59 3)))
(check-expect (si-move-proper s3 -2)
              (make-fired (make-posn 54 11)
                          (make-tank 59 3)
                          (make-posn 56 173)))
(check-expect (si-move-proper (make-aim u56x112y t125) 5)
              (make-aim (make-posn 61 113)
                        (make-tank 122 -3)))


; Number -> Number
; produces random number in the interval [-n,n]
(define (random-interval-n n)
  (- (random (+ (* 2 n) 1)) n))


; SIGS -> SIGS
; moves the space-invader objects after each tick; UFO makes random jumps
; to the left or right of at most 1 BASE-UNIT
(define (si-move s)
  (si-move-proper s (random-interval-n BASE-UNIT)))


; Tank Boolean -> Tank
; makes tank direction positive (#true) or negative (#false)
(define (tank-set-direction t positive?)
  (make-tank (tank-loc t)
             (if positive?
                 (abs (tank-vel t))
                 (- (abs (tank-vel t))))))


; SIGS KeyEvent -> SIGS
; controls the tank through keystrokes: left or right arrow to shift the
; tank's direction, and space to fire the missile if it hasn't been fired yet
(define (si-control s ke)
  (cond
    [(or (key=? ke "left") (key=? ke "right"))
     (cond
       [(aim? s) (make-aim (aim-ufo s)
                           (tank-set-direction (aim-tank s)
                                               (key=? ke "right")))]
       [(fired? s) (make-fired (fired-ufo s)
                               (tank-set-direction (fired-tank s)
                                                   (key=? ke "right"))
                               (fired-missile s))])]
    [(and (key=? ke " ") (aim? s))
     (make-fired (aim-ufo s)
                 (aim-tank s)
                 (make-posn (tank-loc (aim-tank s)) MISSILE-LAUNCH-Y))]
    [else s]))

(check-expect (si-control s1 "right") s1)
(check-expect (si-control s2 "right") s2)
(check-expect (si-control s3 "right") s3)
(check-expect (si-control s4 "right") s4)
(check-expect (si-control s5 "left") s5)
(check-expect (si-control s1 "left")
              (make-aim u10x50y (make-tank 75 -3)))
(check-expect (si-control s2 "left")
              (make-aim u56x10y (make-tank 56 -3)))
(check-expect (si-control s3 "left")
              (make-fired u56x10y (make-tank 56 -3) m56xly))
(check-expect (si-control s4 "left")
              (make-fired u56x112y (make-tank 56 -3) m56x112y))
(check-expect (si-control s5 "right")
              (make-fired u106x185y (make-tank 125 3) m56x112y))
(check-expect (si-control s2 "w") s2)
(check-expect (si-control s2 " ") s3)
(check-expect (si-control s4 " ") s4)


; SIGS -> SIGS
; Launches the space invader program with a starting position for the tank
(define (si-main x)
  (big-bang (make-aim (make-posn X-CENTER (- UFO-RADIUS)) (make-tank x VX-TANK))
    [check-with sigs?]
    [to-draw si-render]
    [on-tick si-move]
    [on-key si-control]
    [stop-when si-game-over? si-render-final]))
