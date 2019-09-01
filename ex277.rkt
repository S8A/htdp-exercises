;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex277) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
; Constants :.

(define BASE-UNIT 3) ; 1 bu = 3px

(define HEIGHT 100) ; bu
(define WIDTH HEIGHT) ; bu
(define X-CENTER (/ WIDTH 2)) ; bu

(define GROUND-HEIGHT 1)
(define WIDTH-PX (* WIDTH BASE-UNIT)) ; px
(define HEIGHT-PX (* HEIGHT BASE-UNIT)) ; px
(define GROUND-HEIGHT-PX (* GROUND-HEIGHT BASE-UNIT)) ; px
(define BACKG
  (overlay/align "center" "bottom"
                 (rectangle WIDTH-PX GROUND-HEIGHT-PX "solid" "brown")
                 (empty-scene WIDTH-PX HEIGHT-PX "darkblue")))

(define UFO-RADIUS 2) ; bu
(define UFO-WIDTH 8) ; bu
(define UFO-HALF-WIDTH (/ UFO-WIDTH 2)) ; bu
(define UFO-RADIUS-PX (* UFO-RADIUS BASE-UNIT)) ; px
(define UFO-WIDTH-PX (* UFO-WIDTH BASE-UNIT)) ; px
(define UFO
  (overlay (rectangle UFO-WIDTH-PX BASE-UNIT "solid" "green")
           (circle UFO-RADIUS-PX "solid" "green")))

(define TANK-HEIGHT 2) ; bu 
(define TANK-WIDTH 4) ; bu
(define TANK-HALF-WIDTH (/ TANK-WIDTH 2)) ; bu
(define TANK-HALF-HEIGHT (/ TANK-HEIGHT 2)) ; bu
(define Y-TANK (- HEIGHT TANK-HALF-HEIGHT GROUND-HEIGHT)) ; bu
(define TANK-HEIGHT-PX (* TANK-HEIGHT BASE-UNIT)) ; px
(define TANK-WIDTH-PX (* TANK-WIDTH BASE-UNIT)) ; px
(define TANK (rectangle TANK-WIDTH-PX TANK-HEIGHT-PX "solid" "darkgreen"))

(define MISSILE-SIZE 2) ; bu
(define MISSILE-HALF-SIZE (/ MISSILE-SIZE 2)) ; bu
(define MISSILE-LAUNCH-Y (- HEIGHT TANK-HEIGHT MISSILE-HALF-SIZE GROUND-HEIGHT))
(define MISSILE-SIZE-PX (* MISSILE-SIZE BASE-UNIT))
(define MISSILE (triangle MISSILE-SIZE-PX "solid" "red"))

(define EXPLOSION-INNER 2) ; bu
(define EXPLOSION-OUTER 4) ; bu
(define EXPLOSION-POINTS (* 3 BASE-UNIT)) ; number
(define EXPLOSION-INNER-PX (* EXPLOSION-INNER BASE-UNIT)) ; px
(define EXPLOSION-OUTER-PX (* EXPLOSION-OUTER BASE-UNIT)) ; px
(define EXPLOSION
  (overlay (radial-star EXPLOSION-POINTS EXPLOSION-INNER-PX EXPLOSION-OUTER-PX
                        "outline" "red")
           (radial-star EXPLOSION-POINTS EXPLOSION-INNER-PX EXPLOSION-OUTER-PX
                        "solid" "yellow")))

(define MESSAGE-HEIGHT 20) ; bu
(define MESSAGE-HEIGHT-PX (* MESSAGE-HEIGHT BASE-UNIT)) ; px
(define MESSAGE-TEXT-SIZE 16)
(define MESSAGE-VICTORY "VICTORY!")
(define MESSAGE-DEFEAT "GAME OVER!")
(define MESSAGE-BACKG
  (rectangle WIDTH-PX MESSAGE-HEIGHT-PX "solid" (color 0 0 0 200)))

(define VX-TANK 0.5) ; bu/tick
(define VY-UFO 0.5) ; bu/tick
(define VY-MISSILE (* 2 VY-UFO)) ; bu/tick



; Data definitions :.

; A UFO is a Posn
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention) in a
; base unit denominated coordinate system.


(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x v) specifies the position:
; (x, Y-TANK) and the tank's speed: v base units/tick


; A Missile is a Posn
; interpretation (make-posn x y) is the missile's position
; (using the top-down, left-to-right convention) in a
; base unit denominated coordinate system.


; A ListOfMissiles is one of the following:
; - '()
; - (cons Missile ListOfMissiles)


(define-struct sigs [ufo tank missiles])
; A Space Invader Game State (SIGS) is a structure:
;   (make-sigs UFO Tank ListOfMissiles)
; interpretation (make-sigs u t lom) represents the state
; of a space invader game instance with the UFO located at
; the position u, a tank with a position and velocity
; specified by t, and zero or more missiles at the positions
; specified by lom.



; Data examples :.

(define ufo0 (make-posn X-CENTER UFO-RADIUS))
(define ufo1 (make-posn 30 50))
(define ufo2 (make-posn 70 20))
(define ufo3 (make-posn UFO-HALF-WIDTH 40))
(define ufo4 (make-posn (- WIDTH UFO-HALF-WIDTH) 60))
(define ufo5 (make-posn 69 (- HEIGHT GROUND-HEIGHT UFO-RADIUS)))

(define tank0 (make-tank X-CENTER VX-TANK))
(define tank1 (make-tank 30 (- VX-TANK)))
(define tank2 (make-tank 70 VX-TANK))
(define tank3 (make-tank TANK-HALF-WIDTH VX-TANK))
(define tank4 (make-tank (- WIDTH TANK-HALF-WIDTH) (- VX-TANK)))

(define missile0 (make-posn X-CENTER MISSILE-LAUNCH-Y))
(define missile1 (make-posn 69 19)) ; hits ufo2
(define missile2 (make-posn 5 40)) ; hits ufo3
(define missile3 (make-posn 30 49)) ; hits ufo1
(define missile4 (make-posn 95 61)) ; hits ufo4

(define lom0 '())
(define lom1 (list missile0))
(define lom2 (list missile1 missile0)) ; hits ufo2
(define lom3 (list missile2 missile1 missile0)) ; + hits ufo3
(define lom4 (list missile3 missile2 missile1 missile0)) ; + hits ufo1
(define lom5 (list missile4 missile3 missile2 missile1 missile0)) ; + hits ufo4

(define sigs0 (make-sigs ufo0 tank0 lom0))
(define sigs1 (make-sigs ufo1 tank1 lom1))
(define sigs2 (make-sigs ufo2 tank2 lom2)) ; hits ufo2
(define sigs3 (make-sigs ufo3 tank3 lom3)) ; hits ufo3
(define sigs4 (make-sigs ufo4 tank4 lom4))
(define sigs5 (make-sigs ufo1 tank0 lom5)) ; hits ufo1
(define sigs6 (make-sigs ufo2 tank1 lom3)) ; hits ufo2
(define sigs7 (make-sigs ufo3 tank2 lom4)) ; hits ufo3
(define sigs8 (make-sigs ufo4 tank3 lom5)) ; hits ufo4
(define sigs9 (make-sigs ufo0 tank4 lom1))
(define sigs10 (make-sigs ufo5 tank1 lom2)) ; ufo5 landed



; Main ::..
; Runs the space invader game with a clock that ticks every x seconds
(define (sigs-main x)
  (big-bang sigs0
    [to-draw sigs-render]
    [on-tick sigs-tock x]
    [on-key sigs-control]
    [stop-when sigs-stop? sigs-render-end]))



; Functions :.

; SIGS -> Image
; Renders the current state of the space invader game.
(define (sigs-render gs)
  (tank-render (sigs-tank gs)
               (ufo-render (sigs-ufo gs)
                           (missiles-render (sigs-missiles gs)
                                            BACKG))))

(check-expect (sigs-render sigs0)
              (tank-render tank0 (ufo-render ufo0 BACKG)))
(check-expect (sigs-render sigs1)
              (tank-render tank1
                           (ufo-render ufo1
                                       (missiles-render lom1 BACKG))))
(check-expect (sigs-render sigs2)
              (tank-render tank2
                           (ufo-render ufo2
                                       (missiles-render lom2 BACKG))))
(check-expect (sigs-render sigs3)
              (tank-render tank3
                           (ufo-render ufo3
                                       (missiles-render lom3 BACKG))))
(check-expect (sigs-render sigs4)
              (tank-render tank4
                           (ufo-render ufo4
                                       (missiles-render lom4 BACKG))))
(check-expect (sigs-render sigs5)
              (tank-render tank0
                           (ufo-render ufo1
                                       (missiles-render lom5 BACKG))))
(check-expect (sigs-render sigs6)
              (tank-render tank1
                           (ufo-render ufo2
                                       (missiles-render lom3 BACKG))))
(check-expect (sigs-render sigs7)
              (tank-render tank2
                           (ufo-render ufo3
                                       (missiles-render lom4 BACKG))))
(check-expect (sigs-render sigs8)
              (tank-render tank3
                           (ufo-render ufo4
                                       (missiles-render lom5 BACKG))))
(check-expect (sigs-render sigs9)
              (tank-render tank4
                           (ufo-render ufo0
                                       (missiles-render lom1 BACKG))))


; SIGS -> SIGS
; After each tick, move UFO, move tank in its corresponding direction, and
; move all missiles up.
(define (sigs-tock gs)
  (make-sigs (move-ufo (sigs-ufo gs))
             (move-tank (sigs-tank gs))
             (move-missiles (sigs-missiles gs))))

(check-random (sigs-tock sigs0)
              (make-sigs (move-ufo ufo0)
                         (move-tank tank0)
                         (move-missiles lom0)))
(check-random (sigs-tock sigs1)
              (make-sigs (move-ufo ufo1)
                         (move-tank tank1)
                         (move-missiles lom1)))
(check-random (sigs-tock sigs2)
              (make-sigs (move-ufo ufo2)
                         (move-tank tank2)
                         (move-missiles lom2)))
(check-random (sigs-tock sigs3)
              (make-sigs (move-ufo ufo3)
                         (move-tank tank3)
                         (move-missiles lom3)))
(check-random (sigs-tock sigs4)
              (make-sigs (move-ufo ufo4)
                         (move-tank tank4)
                         (move-missiles lom4)))
(check-random (sigs-tock sigs5)
              (make-sigs (move-ufo ufo1)
                         (move-tank tank0)
                         (move-missiles lom5)))
(check-random (sigs-tock sigs9)
              (make-sigs (move-ufo ufo0)
                         (move-tank tank4)
                         (move-missiles lom1)))


; SIGS KeyEvent -> SIGS
; Controls the tank's direction with the arrow keys and launches missiles
; with the space bar, if possible.
(define (sigs-control gs ke)
  (cond
    [(key=? ke "left")
     (make-sigs (sigs-ufo gs)
                (tank-shift (sigs-tank gs) #false)
                (sigs-missiles gs))]
    [(key=? ke "right")
     (make-sigs (sigs-ufo gs)
                (tank-shift (sigs-tank gs) #true)
                (sigs-missiles gs))]
    [(key=? ke " ")
     (make-sigs (sigs-ufo gs)
                (sigs-tank gs)
                (missile-launch (sigs-tank gs) (sigs-missiles gs)))]
    [else gs]))

(check-expect (sigs-control sigs0 "left")
              (make-sigs ufo0 (tank-shift tank0 #false) lom0))
(check-expect (sigs-control sigs1 "right")
              (make-sigs ufo1 (tank-shift tank1 #true) lom1))
(check-expect (sigs-control sigs2 "w") sigs2)
(check-expect (sigs-control sigs3 "\r") sigs3)
(check-expect (sigs-control sigs4 " ")
              (make-sigs ufo4 tank4 (missile-launch tank4 lom4)))
(check-expect (sigs-control sigs5 "left")
              (make-sigs ufo1 (tank-shift tank0 #false) lom5))
(check-expect (sigs-control sigs6 "right")
              (make-sigs ufo2 (tank-shift tank1 #true) lom3))
(check-expect (sigs-control sigs7 "m") sigs7)
(check-expect (sigs-control sigs8 "\t") sigs8)
(check-expect (sigs-control sigs9 " ")
              (make-sigs ufo0 tank4 (missile-launch tank4 lom1)))


; SIGS -> Boolean
; Ends the game if the UFO is hit with a missile or if the UFO hits
; the ground.
(define (sigs-stop? gs)
  (or (ufo-hit? (sigs-ufo gs) (sigs-missiles gs))
      (ufo-landed? (sigs-ufo gs))))

(check-expect (sigs-stop? sigs0) #false)
(check-expect (sigs-stop? sigs1) #false)
(check-expect (sigs-stop? sigs2) #true)
(check-expect (sigs-stop? sigs3) #true)
(check-expect (sigs-stop? sigs4) #false)
(check-expect (sigs-stop? sigs5) #true)
(check-expect (sigs-stop? sigs6) #true)
(check-expect (sigs-stop? sigs7) #true)
(check-expect (sigs-stop? sigs8) #true)
(check-expect (sigs-stop? sigs9) #false)
(check-expect (sigs-stop? sigs10) #true)


; SIGS -> Image
; Renders the final image of the game, with a text indicating victory or defeat.
(define (sigs-render-end gs)
  (cond
    [(ufo-hit? (sigs-ufo gs) (sigs-missiles gs))
     (overlay-text MESSAGE-VICTORY "white"
                   (explosion-render (sigs-ufo gs) (sigs-render gs)))]
    [(ufo-landed? (sigs-ufo gs))
     (overlay-text MESSAGE-DEFEAT "red" (sigs-render gs))]))

(check-expect (sigs-render-end sigs2)
              (overlay-text MESSAGE-VICTORY "white"
                            (explosion-render ufo2 (sigs-render sigs2))))
(check-expect (sigs-render-end sigs3)
              (overlay-text MESSAGE-VICTORY "white"
                            (explosion-render ufo3 (sigs-render sigs3))))
(check-expect (sigs-render-end sigs5)
              (overlay-text MESSAGE-VICTORY "white"
                            (explosion-render ufo1 (sigs-render sigs5))))
(check-expect (sigs-render-end sigs6)
              (overlay-text MESSAGE-VICTORY "white"
                            (explosion-render ufo2 (sigs-render sigs6))))
(check-expect (sigs-render-end sigs7)
              (overlay-text MESSAGE-VICTORY "white"
                            (explosion-render ufo3 (sigs-render sigs7))))
(check-expect (sigs-render-end sigs8)
              (overlay-text MESSAGE-VICTORY "white"
                            (explosion-render ufo4 (sigs-render sigs8))))
(check-expect (sigs-render-end sigs10)
              (overlay-text MESSAGE-DEFEAT "red" (sigs-render sigs10)))


; Auxilliary functions

; Tank Image -> Image
; Renders the tank at its current position over the image im
(define (tank-render t im)
  (place-image TANK
               (* (tank-loc t) BASE-UNIT)
               (* Y-TANK BASE-UNIT)
               im))

(check-expect (tank-render tank0 BACKG)
              (place-image TANK
                           (* X-CENTER BASE-UNIT)
                           (* Y-TANK BASE-UNIT)
                           BACKG))
(check-expect (tank-render tank1 BACKG)
              (place-image TANK
                           (* 30 BASE-UNIT)
                           (* Y-TANK BASE-UNIT)
                           BACKG))
(check-expect (tank-render tank2 BACKG)
              (place-image TANK
                           (* 70 BASE-UNIT)
                           (* Y-TANK BASE-UNIT)
                           BACKG))
(check-expect (tank-render tank3 BACKG)
              (place-image TANK
                           (* TANK-HALF-WIDTH BASE-UNIT)
                           (* Y-TANK BASE-UNIT)
                           BACKG))
(check-expect (tank-render tank4 BACKG)
              (place-image TANK
                           (* (- WIDTH TANK-HALF-WIDTH) BASE-UNIT)
                           (* Y-TANK BASE-UNIT)
                           BACKG))


; UFO Image -> Image
; Renders the UFO at its current position over the image im.
(define (ufo-render u im)
  (place-image UFO
               (* (posn-x u) BASE-UNIT)
               (* (posn-y u) BASE-UNIT)
               im))

(check-expect (ufo-render ufo0 BACKG)
              (place-image UFO
                           (* X-CENTER BASE-UNIT)
                           (* UFO-RADIUS BASE-UNIT)
                           BACKG))
(check-expect (ufo-render ufo1 BACKG)
              (place-image UFO
                           (* 30 BASE-UNIT)
                           (* 50 BASE-UNIT)
                           BACKG))
(check-expect (ufo-render ufo2 BACKG)
              (place-image UFO
                           (* 70 BASE-UNIT)
                           (* 20 BASE-UNIT)
                           BACKG))
(check-expect (ufo-render ufo3 BACKG)
              (place-image UFO
                           (* UFO-HALF-WIDTH BASE-UNIT)
                           (* 40 BASE-UNIT)
                           BACKG))
(check-expect (ufo-render ufo4 BACKG)
              (place-image UFO
                           (* (- WIDTH UFO-HALF-WIDTH) BASE-UNIT)
                           (* 60 BASE-UNIT)
                           BACKG))


; ListOfMissiles Image -> Image
; Renders the missiles from the list at their corresponding positions over the
; image im.
(define (missiles-render lom im)
  (foldr missile-render im lom))

(check-expect (missiles-render lom0 BACKG) BACKG)
(check-expect (missiles-render lom1 BACKG)
              (missile-render missile0 BACKG))
(check-expect (missiles-render lom2 BACKG)
              (missile-render missile1
                              (missile-render missile0 BACKG)))
(check-expect (missiles-render lom3 BACKG)
              (missile-render missile2
                              (missile-render missile1
                                              (missile-render missile0 BACKG))))


; Missile Image -> Image
; Renders the missile at its corresponding position over the image im.
(define (missile-render m im)
  (place-image MISSILE
               (* (posn-x m) BASE-UNIT)
               (* (posn-y m) BASE-UNIT)
               im))

(check-expect (missile-render missile0 BACKG)
              (place-image MISSILE
                           (* X-CENTER BASE-UNIT)
                           (* MISSILE-LAUNCH-Y BASE-UNIT)
                           BACKG))
(check-expect (missile-render missile1 BACKG)
              (place-image MISSILE
                           (* 69 BASE-UNIT)
                           (* 19 BASE-UNIT)
                           BACKG))
(check-expect (missile-render missile2 BACKG)
              (place-image MISSILE
                           (* 5 BASE-UNIT)
                           (* 40 BASE-UNIT)
                           BACKG))
(check-expect (missile-render missile3 BACKG)
              (place-image MISSILE
                           (* 30 BASE-UNIT)
                           (* 49 BASE-UNIT)
                           BACKG))
(check-expect (missile-render missile4 BACKG)
              (place-image MISSILE
                           (* 95 BASE-UNIT)
                           (* 61 BASE-UNIT)
                           BACKG))


; UFO -> UFO
; Moves the UFO down at a constant speed with random horizontal jumps.
(define (move-ufo u)
  (make-posn (random-jump (posn-x u) UFO-HALF-WIDTH) (+ (posn-y u) VY-UFO)))

(check-random (move-ufo ufo0)
              (make-posn (random-jump X-CENTER UFO-HALF-WIDTH)
                         (+ UFO-RADIUS VY-UFO)))
(check-random (move-ufo ufo1)
              (make-posn (random-jump 30 UFO-HALF-WIDTH)
                         (+ 50 VY-UFO)))
(check-random (move-ufo ufo2)
              (make-posn (random-jump 70 UFO-HALF-WIDTH)
                         (+ 20 VY-UFO)))
(check-random (move-ufo ufo3)
              (make-posn (random-jump UFO-HALF-WIDTH UFO-HALF-WIDTH)
                         (+ 40 VY-UFO)))
(check-random (move-ufo ufo4)
              (make-posn (random-jump (- WIDTH UFO-HALF-WIDTH) UFO-HALF-WIDTH)
                         (+ 60 VY-UFO)))


; Tank -> Tank
; Moves the tank according to its velocity (speed and direction).
(define (move-tank t)
  (make-tank (+ (tank-loc t) (tank-vel t)) (tank-vel t)))

(check-expect (move-tank tank0)
              (make-tank (+ X-CENTER VX-TANK) VX-TANK))
(check-expect (move-tank tank1)
              (make-tank (- 30 VX-TANK) (- VX-TANK)))
(check-expect (move-tank tank2)
              (make-tank (+ 70 VX-TANK) VX-TANK))
(check-expect (move-tank tank3)
              (make-tank (+ TANK-HALF-WIDTH VX-TANK) VX-TANK))
(check-expect (move-tank tank4)
              (make-tank (- WIDTH TANK-HALF-WIDTH VX-TANK) (- VX-TANK)))


; ListOfMissiles -> ListOfMissiles
; Moves all missiles in the list at a constant speed upwards, eliminating
; those that exit the frame.
(define (move-missiles lom)
  (local (; Missile -> Boolean
          (define (not-out-of-frame? m) (> (posn-y m) (- MISSILE-HALF-SIZE))))
    (map move-missile (filter not-out-of-frame? lom))))

(check-expect (move-missiles lom0) '())
(check-expect (move-missiles lom1) (list (move-missile missile0)))
(check-expect (move-missiles lom2)
              (list (move-missile missile1) (move-missile missile0)))
(check-expect (move-missiles lom3)
              (list (move-missile missile2)
                    (move-missile missile1)
                    (move-missile missile0)))
(check-expect (move-missiles (list (make-posn X-CENTER (- MISSILE-HALF-SIZE))
                                   missile0))
              (list (move-missile missile0)))


; Missile -> Missile
; Moves the missile upwards at a constant speed.
(define (move-missile m)
  (make-posn (posn-x m) (- (posn-y m) VY-MISSILE)))

(check-expect (move-missile missile0)
              (make-posn X-CENTER (- MISSILE-LAUNCH-Y VY-MISSILE)))
(check-expect (move-missile missile1)
              (make-posn 69 (- 19 VY-MISSILE)))
(check-expect (move-missile missile2)
              (make-posn 5 (- 40 VY-MISSILE)))
(check-expect (move-missile missile3)
              (make-posn 30 (- 49 VY-MISSILE)))
(check-expect (move-missile missile4)
              (make-posn 95 (- 61 VY-MISSILE)))


; Number -> Number
; Moves x coordinate a random number between -2 and 2 base units, without
; leaving the frame (given a threshold)
(define (random-jump x threshold)
  (if (or (<= x threshold) (>= x (- WIDTH threshold)))
      x
      (+ x (random-interval-n 2))))

(check-expect (random-jump UFO-HALF-WIDTH UFO-HALF-WIDTH)
              UFO-HALF-WIDTH)
(check-expect (random-jump (- WIDTH UFO-HALF-WIDTH) UFO-HALF-WIDTH)
              (- WIDTH UFO-HALF-WIDTH))
(check-random (random-jump 20 UFO-HALF-WIDTH) (+ 20 (random-interval-n 2)))
(check-random (random-jump 55 UFO-HALF-WIDTH) (+ 55 (random-interval-n 2)))


; Number -> Number
; Produces random number in the interval [-n,n]
(define (random-interval-n n)
  (- (random (+ (* 2 n) 1)) n))

(check-random (random-interval-n 5) (- (random 11) 5))
(check-random (random-interval-n 4) (- (random 9) 4))


; Tank Boolean -> Tank
; Shifts the tank's direction to the right if r is true or to the left
; if it's false.
(define (tank-shift t r)
  (make-tank (tank-loc t)
             (if (equal? r #true)
                 (abs (tank-vel t))
                 (- (abs (tank-vel t))))))

(check-expect (tank-shift tank0 #false)
              (make-tank X-CENTER (- VX-TANK)))
(check-expect (tank-shift tank1 #true)
              (make-tank 30 VX-TANK))
(check-expect (tank-shift tank2 #false)
              (make-tank 70 (- VX-TANK)))
(check-expect (tank-shift tank3 #true) tank3)
(check-expect (tank-shift tank4 #false) tank4)


; Tank ListOfMissiles -> ListOfMissiles
; Launches a missile from the position of the tank and adds it to the list.
(define (missile-launch t lom)
  (cons (make-posn (tank-loc t) MISSILE-LAUNCH-Y) lom))

(check-expect (missile-launch tank0 lom0) lom1)
(check-expect (missile-launch tank1 lom1)
              (cons (make-posn (tank-loc tank1) MISSILE-LAUNCH-Y) lom1))
(check-expect (missile-launch tank2 lom2)
              (cons (make-posn (tank-loc tank2) MISSILE-LAUNCH-Y) lom2))
(check-expect (missile-launch tank3 lom3)
              (cons (make-posn (tank-loc tank3) MISSILE-LAUNCH-Y) lom3))
(check-expect (missile-launch tank4 lom4)
              (cons (make-posn (tank-loc tank4) MISSILE-LAUNCH-Y) lom4))


; UFO ListOfMissiles-> Boolean
; Checks if the UFO was hit by any of the missiles from the list.
(define (ufo-hit? u lom)
  (local (; Posn Posn -> Number
          (define (distance-posns p q)
            (sqrt (+ (sqr (- (posn-x p) (posn-x q)))
                     (sqr (- (posn-y p) (posn-y q))))))
          ; Missile -> Boolean
          (define (missile-hit-ufo? m) (<= (distance-posns m u) UFO-RADIUS)))
    (ormap missile-hit-ufo? lom)))

(check-expect (ufo-hit? ufo1 lom1) #false)
(check-expect (ufo-hit? ufo2 lom2) #true)
(check-expect (ufo-hit? ufo3 lom3) #true)
(check-expect (ufo-hit? ufo4 lom4) #false)
(check-expect (ufo-hit? ufo1 lom5) #true)
(check-expect (ufo-hit? ufo2 lom3) #true)
(check-expect (ufo-hit? ufo3 lom4) #true)
(check-expect (ufo-hit? ufo4 lom5) #true)
(check-expect (ufo-hit? ufo0 lom1) #false)
(check-expect (ufo-hit? ufo5 lom2) #false)


; UFO -> Boolean
; Checks if the UFO has landed on the ground.
(define (ufo-landed? u)
  (>= (posn-y u) (- HEIGHT GROUND-HEIGHT UFO-RADIUS)))

(check-expect (ufo-landed? ufo0) #false)
(check-expect (ufo-landed? ufo1) #false)
(check-expect (ufo-landed? ufo2) #false)
(check-expect (ufo-landed? ufo3) #false)
(check-expect (ufo-landed? ufo4) #false)
(check-expect (ufo-landed? ufo5) #true)


; String Color Image -> Image
; Overlays text str of color c over the image im.
(define (overlay-text str c im)
  (overlay (text str MESSAGE-TEXT-SIZE c) MESSAGE-BACKG im))

(check-expect (overlay-text MESSAGE-VICTORY "white" BACKG)
              (overlay (text MESSAGE-VICTORY MESSAGE-TEXT-SIZE "white")
                       MESSAGE-BACKG BACKG))
(check-expect (overlay-text MESSAGE-DEFEAT "red" BACKG)
              (overlay (text MESSAGE-DEFEAT MESSAGE-TEXT-SIZE "red")
                       MESSAGE-BACKG BACKG))


; UFO Image -> Image
; Places explosion on the UFO's position over image im
(define (explosion-render u im)
  (place-image EXPLOSION
               (* (posn-x u) BASE-UNIT)
               (* (posn-y u) BASE-UNIT)
               im))

(check-expect (explosion-render ufo0 BACKG)
              (place-image EXPLOSION
                           (* X-CENTER BASE-UNIT)
                           (* UFO-RADIUS BASE-UNIT)
                           BACKG))
(check-expect (explosion-render ufo1 BACKG)
              (place-image EXPLOSION
                           (* 30 BASE-UNIT)
                           (* 50 BASE-UNIT)
                           BACKG))
(check-expect (explosion-render ufo2 BACKG)
              (place-image EXPLOSION
                           (* 70 BASE-UNIT)
                           (* 20 BASE-UNIT)
                           BACKG))
(check-expect (explosion-render ufo3 BACKG)
              (place-image EXPLOSION
                           (* UFO-HALF-WIDTH BASE-UNIT)
                           (* 40 BASE-UNIT)
                           BACKG))
(check-expect (explosion-render ufo4 BACKG)
              (place-image EXPLOSION
                           (* (- WIDTH UFO-HALF-WIDTH) BASE-UNIT)
                           (* 60 BASE-UNIT)
                           BACKG))
