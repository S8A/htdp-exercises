;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex102) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define BASE-UNIT 3) ; 1 bu = 3 px

(define HEIGHT (* 200/3 BASE-UNIT))
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
(define EXPLOSION-POINTS (* 3 BASE-UNIT))
(define EXPLOSION
  (overlay (radial-star EXPLOSION-POINTS EXPLOSION-INNER EXPLOSION-OUTER
                        "outline" "red")
           (radial-star EXPLOSION-POINTS EXPLOSION-INNER EXPLOSION-OUTER
                        "solid" "yellow")))

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
(define u106xly (make-posn 106 (- HEIGHT BASE-UNIT UFO-RADIUS)))

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
(define ur106xly
  (place-image UFO 106 (- HEIGHT BASE-UNIT UFO-RADIUS) BACKGROUND))

(define mr56xly (place-image MISSILE 56 MISSILE-LAUNCH-Y BACKGROUND))
(define mr56x112y (place-image MISSILE 56 112 BACKGROUND))


; Example states
(define s1 (make-sigs u10x50y t75 mnot))
(define s2 (make-sigs u56x10y t56 mnot))
(define s3 (make-sigs u56x10y t56 m56xly))
(define s4 (make-sigs u56x112y t56 m56x112y))
(define s5 (make-sigs u106xly t125 m56x112y))


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
                           (ufo-render u106xly
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
(check-expect (ufo-render u106xly BACKGROUND) ur106xly)


; MissileOrNot Image -> Image 
; adds an image of missile m to scene s 
(define (missile-render.v2 m s)
  (cond
    [(boolean? m) s]
    [(posn? m)
     (place-image MISSILE (posn-x m) (posn-y m) s)]))

(check-expect (missile-render.v2 mnot BACKGROUND) BACKGROUND)
(check-expect (missile-render.v2 m56xly BACKGROUND)
              (place-image MISSILE (posn-x m56xly) (posn-y m56xly) BACKGROUND))


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
  (and (posn? (sigs-missile s))
       (<= (distance-points (sigs-ufo s) (sigs-missile s))
           UFO-RADIUS)))

(check-expect (hit-ufo? s1) #false)
(check-expect (hit-ufo? s2) #false)
(check-expect (hit-ufo? s3) #false)
(check-expect (hit-ufo? s4) #true)
(check-expect (hit-ufo? s5) #false)


; SIGS -> Boolean
; checks if the UFO landed
(define (ufo-landed? s)
  (<= (- HEIGHT BASE-UNIT (posn-y (sigs-ufo s)))
      UFO-RADIUS))

(check-expect (ufo-landed? s1) #false)
(check-expect (ufo-landed? s2) #false)
(check-expect (ufo-landed? s3) #false)
(check-expect (ufo-landed? s4) #false)
(check-expect (ufo-landed? s5) #true)


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
                (cond [(hit-ufo? s)
                       (ufo-explosion (sigs-ufo s) (si-render.v2 s))]
                      [(ufo-landed? s) (si-render.v2 s)])))


(check-expect (si-render-final s4)
              (overlay (overlay (text MESSAGE-VICTORY MESSAGE-TEXT-SIZE "white")
                                (rectangle WIDTH MESSAGE-HEIGHT
                                           "solid" (color 0 0 0 128)))
                       (ufo-explosion u56x112y (si-render.v2 s4))))
(check-expect (si-render-final s5)
              (overlay (overlay (text MESSAGE-DEFEAT MESSAGE-TEXT-SIZE "red")
                                (rectangle WIDTH MESSAGE-HEIGHT
                                           "solid" (color 0 0 0 128)))
                       (si-render.v2 s5)))


; UFO -> Boolean
; checks if the UFO is close to the right and left edges of the frame
(define (ufo-close-to-edges? u)
  (or (<= (posn-x u) UFO-RADIUS)
      (>= (posn-x u) (- WIDTH UFO-RADIUS))))

(check-expect (ufo-close-to-edges? (make-posn UFO-RADIUS 50)) #true)
(check-expect (ufo-close-to-edges? (make-posn (- WIDTH UFO-RADIUS) 200)) #true)
(check-expect (ufo-close-to-edges? u56x10y) #false)
(check-expect (ufo-close-to-edges? u56x112y) #false)
(check-expect (ufo-close-to-edges? u106xly) #false)


; UFO Number Number -> UFO
; moves UFO to the right dx pixels and down dy pixels, ensuring
; it doesn't move out of frame horizontally
(define (move-ufo u dx dy)
  (make-posn (if (ufo-close-to-edges? u)
                 (posn-x u)
                 (+ (posn-x u) dx))
             (+ (posn-y u) dy)))

(check-expect (move-ufo u56x10y 0 102)
              u56x112y)
(check-expect (move-ufo u56x112y -2 3)
              (make-posn (- 56 2) (+ 112 3)))
(check-expect (move-ufo (make-posn UFO-RADIUS 50) -1 3)
              (make-posn UFO-RADIUS (+ 50 3)))
(check-expect (move-ufo (make-posn (- WIDTH UFO-RADIUS) 100) 3 5)
              (make-posn (- WIDTH UFO-RADIUS) (+ 100 5)))


; Missile Number -> Missile
; moves missile dy pixels upward
(define (move-missile m dy)
  (cond
    [(equal? m #false) m]
    [(posn? m) (make-posn (posn-x m) (- (posn-y m) dy))]))

(check-expect (move-missile mnot 2)
              mnot)
(check-expect (move-missile m56xly 5)
              (make-posn 56 (- MISSILE-LAUNCH-Y 5)))
(check-expect (move-missile m56x112y 3)
              (make-posn 56 (- 112 3)))


; Tank Number Number -> Tank
; moves tank to the left or right, according to its velocity
(define (move-tank t)
  (make-tank (+ (tank-loc t) (tank-vel t)) (tank-vel t)))

(check-expect (move-tank t56)
              (make-tank (+ 56 3) 3))
(check-expect (move-tank t75)
              (make-tank (+ 75 3) 3))
(check-expect (move-tank t125)
              (make-tank (- 125 3) -3))
(check-expect (move-tank t170)
              (make-tank (- 170 3) -3))


; SIGS Number -> SIGS 
; moves the space-invader objects; UFO moves horizontally by dx-u
(define (si-move-proper s dx-u)
  (make-sigs (move-ufo (sigs-ufo s) dx-u VY-UFO)
             (move-tank (sigs-tank s))
             (move-missile (sigs-missile s) VY-MISSILE)))

(check-expect (si-move-proper s1 3)
              (make-sigs (move-ufo u10x50y 3 VY-UFO)
                         (move-tank t75)
                         (move-missile mnot VY-MISSILE)))
(check-expect (si-move-proper s2 3)
              (make-sigs (move-ufo u56x10y 3 VY-UFO)
                         (move-tank t56)
                         (move-missile mnot VY-MISSILE)))
(check-expect (si-move-proper s3 -2)
              (make-sigs (move-ufo u56x10y -2 VY-UFO)
                         (move-tank t56)
                         (move-missile m56xly VY-MISSILE)))
(check-expect (si-move-proper (make-sigs u56x112y t125 mnot) 5)
              (make-sigs (move-ufo u56x112y 5 VY-UFO)
                         (move-tank t125)
                         (move-missile mnot VY-MISSILE)))


; Number -> Number
; produces random number in the interval [-n,n]
(define (random-interval-n n)
  (- (random (+ (* 2 n) 1)) n))

(check-random (random-interval-n 5)
              (- (random 11) 5))
(check-random (random-interval-n BASE-UNIT)
              (- (random (+ (* 2 BASE-UNIT) 1)) BASE-UNIT))


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

(check-expect (tank-set-direction t56 #t) t56)
(check-expect (tank-set-direction t75 #t) t75)
(check-expect (tank-set-direction t125 #f) t125)
(check-expect (tank-set-direction t170 #f) t170)
(check-expect (tank-set-direction t56 #f) (make-tank 56 -3))
(check-expect (tank-set-direction t75 #f) (make-tank 75 -3))
(check-expect (tank-set-direction t125 #t) (make-tank 125 3))
(check-expect (tank-set-direction t170 #t) (make-tank 170 3))


; SIGS KeyEvent -> SIGS
; controls the tank through keystrokes: left or right arrow to shift the
; tank's direction, and space to fire the missile if it hasn't been fired yet
(define (si-control s ke)
  (cond
    [(or (key=? ke "left") (key=? ke "right"))
     (make-sigs (sigs-ufo s)
                (tank-set-direction (sigs-tank s) (key=? ke "right"))
                (sigs-missile s))]
    [(and (key=? ke " ") (equal? (sigs-missile s) #false))
     (make-sigs (sigs-ufo s)
                (sigs-tank s)
                (make-posn (tank-loc (sigs-tank s)) MISSILE-LAUNCH-Y))]
    [else s]))

(check-expect (si-control s1 "right") s1)
(check-expect (si-control s2 "right") s2)
(check-expect (si-control s3 "right") s3)
(check-expect (si-control s4 "right") s4)
(check-expect (si-control s5 "left") s5)
(check-expect (si-control s1 "left")
              (make-sigs u10x50y (make-tank 75 -3) mnot))
(check-expect (si-control s2 "left")
              (make-sigs u56x10y (make-tank 56 -3) mnot))
(check-expect (si-control s3 "left")
              (make-sigs u56x10y (make-tank 56 -3) m56xly))
(check-expect (si-control s4 "left")
              (make-sigs u56x112y (make-tank 56 -3) m56x112y))
(check-expect (si-control s5 "right")
              (make-sigs u106xly (make-tank 125 3) m56x112y))
(check-expect (si-control s2 "w") s2)
(check-expect (si-control s2 " ") s3)
(check-expect (si-control s4 " ") s4)


; SIGS -> SIGS
; Launches the space invader program with a starting position for the tank
(define (si-main x)
  (big-bang (make-sigs (make-posn X-CENTER (- UFO-RADIUS))
                       (make-tank x VX-TANK)
                       mnot)
    [to-draw si-render.v2]
    [on-tick si-move]
    [on-key si-control]
    [stop-when si-game-over? si-render-final]))
