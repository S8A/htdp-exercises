;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex225) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; Base unit
(define UNIT 5) ; 1 u = 5 px



; Graphical aux functions :.

; Number -> Number
; Converts the given distance in base units to pixels
(define (pixel-distance x) (* x UNIT))

(check-expect (pixel-distance 0) 0)
(check-expect (pixel-distance 100) (* 100 UNIT))


; Number -> Image
; Renders n trees one beside the other.
(define (generate-trees n)
  (cond
    [(= n 1) TREE]
    [else (beside TREE (generate-trees (sub1 n)))]))

(check-expect (generate-trees 1) TREE)
(check-expect (generate-trees 2) (beside TREE TREE))
(check-expect (generate-trees 3) (beside TREE TREE TREE))



; Constants :.


(define WIDTH 100)
(define HEIGHT WIDTH)
(define WIDTH-PX (pixel-distance WIDTH))
(define HEIGHT-PX (pixel-distance HEIGHT))

(define PLANE-TIP-SIZE 3)
(define PLANE-TIP-SIZE-PX (pixel-distance PLANE-TIP-SIZE))
(define PLANE-TIP
  (right-triangle PLANE-TIP-SIZE-PX PLANE-TIP-SIZE-PX "solid" "slategray"))
(define PLANE-BACK-WING
  (rotate 180
          (right-triangle PLANE-TIP-SIZE-PX PLANE-TIP-SIZE-PX "solid" "gray")))
(define PLANE-BODY-LENGTH 12)
(define PLANE-BODY-HEIGHT 3)
(define PLANE-BODY-LENGTH-PX (pixel-distance PLANE-BODY-LENGTH))
(define PLANE-BODY-HEIGHT-PX (pixel-distance PLANE-BODY-HEIGHT))
(define PLANE-BODY
  (rectangle PLANE-BODY-LENGTH-PX PLANE-BODY-HEIGHT-PX "solid" "gray"))
(define PLANE-WING-LENGTH 4)
(define PLANE-WING-HEIGHT 1)
(define PLANE-WING-LENGTH-PX (pixel-distance PLANE-WING-LENGTH))
(define PLANE-WING-HEIGHT-PX (pixel-distance PLANE-WING-HEIGHT))
(define PLANE-WING
  (rectangle PLANE-WING-LENGTH-PX PLANE-WING-HEIGHT-PX "solid" "dimgray"))
(define PLANE-RIGHT
  (beside PLANE-BACK-WING
          (overlay/align "middle" "bottom" PLANE-WING PLANE-BODY)
          PLANE-TIP))
(define PLANE-LEFT
  (flip-horizontal PLANE-RIGHT))
(define PLANE-HALF-LENGTH (/ (image-width PLANE-RIGHT) 2))

(define WATERLOAD-WIDTH 4)
(define WATERLOAD-HEIGHT (* 2 WATERLOAD-WIDTH))
(define WATERLOAD-WIDTH-PX (pixel-distance WATERLOAD-WIDTH))
(define WATERLOAD-HEIGHT-PX (pixel-distance WATERLOAD-HEIGHT))
(define WATERLOAD
  (rectangle WATERLOAD-WIDTH-PX WATERLOAD-HEIGHT-PX
             "solid" (color 0 0 255 200)))
(define WATERLOAD-HALF-HEIGHT (/ WATERLOAD-HEIGHT 2))

(define FIRE-SMALL-TIP-SIZE 1)
(define FIRE-SMALL-TIP-SIZE-PX (pixel-distance FIRE-SMALL-TIP-SIZE))
(define FIRE-SMALL-TIP
  (triangle FIRE-SMALL-TIP-SIZE-PX "solid" "orange"))
(define FIRE-BIG-TIP-SIZE 2)
(define FIRE-BIG-TIP-SIZE-PX (pixel-distance FIRE-BIG-TIP-SIZE))
(define FIRE-BIG-TIP
  (triangle FIRE-BIG-TIP-SIZE-PX "solid" "orange"))
(define FIRE-BODY-LENGTH (+ FIRE-BIG-TIP-SIZE (* 2 FIRE-SMALL-TIP-SIZE)))
(define FIRE-BODY-HEIGHT FIRE-BIG-TIP-SIZE)
(define FIRE-BODY-LENGTH-PX (pixel-distance FIRE-BODY-LENGTH))
(define FIRE-BODY-HEIGHT-PX (pixel-distance FIRE-BODY-HEIGHT))
(define FIRE-BODY
  (rectangle FIRE-BODY-LENGTH-PX FIRE-BODY-HEIGHT-PX "solid" "orange"))
(define FIRE
  (above (beside/align "bottom"
                       FIRE-SMALL-TIP FIRE-BIG-TIP FIRE-SMALL-TIP)
         FIRE-BODY))
(define FIRE-HALF-WIDTH (/ FIRE-BODY-LENGTH 2))
(define FIRE-HALF-HEIGHT (/ (+ FIRE-BODY-HEIGHT FIRE-BIG-TIP-SIZE) 2))

(define LEAVES-WIDTH 4)
(define LEAVES-RADIUS-PX (pixel-distance (/ LEAVES-WIDTH 2)))
(define LEAVES (circle LEAVES-RADIUS-PX "solid" "forestgreen"))
(define TRUNK-WIDTH 1)
(define TRUNK-HEIGHT (* 6 TRUNK-WIDTH))
(define TRUNK-WIDTH-PX (pixel-distance TRUNK-WIDTH))
(define TRUNK-HEIGHT-PX (pixel-distance TRUNK-HEIGHT))
(define TRUNK (rectangle TRUNK-WIDTH-PX TRUNK-HEIGHT-PX "solid" "brown"))
(define TREE
  (overlay/align/offset "middle" "top"
                        LEAVES 0 LEAVES-RADIUS-PX
                        TRUNK))

(define FOREST (generate-trees (quotient WIDTH LEAVES-WIDTH)))

(define GROUND-HEIGHT 1)
(define GROUND-HEIGHT-PX (pixel-distance GROUND-HEIGHT))
(define GROUND (rectangle WIDTH-PX GROUND-HEIGHT-PX "solid" "olive"))
(define SKY (empty-scene WIDTH-PX HEIGHT-PX "cornflowerblue"))

(define BACKG (overlay/align "middle" "bottom" (above FOREST GROUND) SKY))

(define FIRE-GROUND-LEVEL (- HEIGHT GROUND-HEIGHT FIRE-HALF-HEIGHT))
(define WATERLOAD-GROUND-LEVEL (- HEIGHT GROUND-HEIGHT WATERLOAD-HALF-HEIGHT))

(define FLY-HEIGHT 20)
(define WATERLOAD-DROP-HEIGHT (+ FLY-HEIGHT WATERLOAD-HALF-HEIGHT))

(define VX-PLANE 1) ; bu/tick
(define VY-WATER 2) ; bu/tick

(define INFO-TEXT-SIZE 16)
(define INFO-TEXT-SEPARATOR
  (rectangle (pixel-distance 10) 1 "solid" "transparent"))
(define FINAL-TEXT-SIZE 24)
(define TEXT-SUCCESS "SUCCESS! FIRES PUT OUT")
(define TEXT-FAILURE "FAILURE! RAN OUT OF WATER")
(define TEXT-COLOR-SUCCESS "green")
(define TEXT-COLOR-FAILURE "red")
(define FINAL-TEXT-BACKG-HEIGHT 20)
(define FINAL-TEXT-BACKG-HEIGHT-PX (pixel-distance FINAL-TEXT-BACKG-HEIGHT))
(define FINAL-TEXT-BACKG
  (rectangle WIDTH-PX FINAL-TEXT-BACKG-HEIGHT-PX "solid" (color 0 0 0 200)))


; Data definitions :.

; A Direction is one of the following:
(define RIGHT "right")
(define LEFT "left")


(define-struct plane [x direction loads])
; A Plane is a structure:
;   (make-plane Number Direction Number)
; interpretation (make-plane x d w) represents the horizontal position
; of the plane in base units, the direction of its movement and the
; number of waterloads left in its tank, respectively.


; A Fire is a Number
; interpretation the horizontal position of the fire


; A ListOfFires (LoF) is one of the following:
; - '()
; - (cons Fire LoF)


; A WaterLoad is a Posn
; interpretation the bidimensional position of a load of
; water falling.


; A ListOfWaterLoads (LoWL) is one of the following:
; - '()
; - (cons WaterLoad LoWL)


(define-struct gs [plane waterloads fires])
; A GameState is a structure:
;   (make-gs Plane LoF LoWL)
; interpretation (make-gs p lof lowl) combines the plane's representation,
; the list of waterloads currently falling through the air, and the list
; of fires on the ground, respectively.



; Data examples :.

(define plane0 (make-plane PLANE-HALF-LENGTH RIGHT 10))
(define plane1 (make-plane 30 LEFT 7))
(define plane2 (make-plane 60 RIGHT 4))
(define plane3 (make-plane (- WIDTH PLANE-HALF-LENGTH) LEFT 0))

(define fire0 FIRE-HALF-WIDTH)
(define fire1 39)
(define fire2 67)
(define fire3 (- WIDTH FIRE-HALF-WIDTH))

(define lof0 '())
(define lof1 (list fire0))
(define lof2 (list fire1 fire0))
(define lof3 (list fire2 fire1 fire0))
(define lof4 (list fire3 fire2 fire1 fire0))

(define wl0 (make-posn 10 WATERLOAD-DROP-HEIGHT))
(define wl1 (make-posn 70 37))
(define wl2 (make-posn 67 64))
(define wl3 (make-posn 40 WATERLOAD-GROUND-LEVEL))

(define lowl0 '())
(define lowl1 (list wl0))
(define lowl2 (list wl1 wl0))
(define lowl3 (list wl2 wl1 wl0))
(define lowl4 (list wl3 wl2 wl1 wl0))

(define gs0 (make-gs plane0 lowl0 lof0))
(define gs1 (make-gs plane1 lowl1 lof2))
(define gs2 (make-gs plane2 lowl2 lof4))
(define gs3 (make-gs plane3 lowl3 lof1))
(define gs4 (make-gs plane0 lowl4 lof3))
(define gs5 (make-gs plane3 lowl0 lof1))



; Main ::..
; Runs the fire-fighting game with n fires.
(define (ff-main n)
  (big-bang (make-gs plane0 lowl0 (create-random-fires n 0))
    [to-draw ff-render]
    [on-tick ff-tock]
    [on-key ff-control]
    [stop-when ff-stop? ff-render-end]))



; Functions :.

; GameState -> Image
; Renders the current state of the game.
(define (ff-render gs)
  (render-info-text (gs-plane gs)
                    (gs-fires gs)
                    (plane-render (gs-plane gs)
                                  (waterloads-render (gs-waterloads gs)
                                  (fires-render (gs-fires gs) BACKG)))))

(check-expect (ff-render gs0)
              (render-info-text plane0
                                lof0
                                (plane-render plane0
                                              (waterloads-render lowl0
                                              (fires-render lof0 BACKG)))))
(check-expect (ff-render gs1)
              (render-info-text plane1
                                lof2
                                (plane-render plane1
                                              (waterloads-render lowl1
                                              (fires-render lof2 BACKG)))))
(check-expect (ff-render gs2)
              (render-info-text plane2
                                lof4
                                (plane-render plane2
                                              (waterloads-render lowl2
                                              (fires-render lof4 BACKG)))))
(check-expect (ff-render gs3)
              (render-info-text plane3
                                lof1
                                (plane-render plane3
                                              (waterloads-render lowl3
                                              (fires-render lof1 BACKG)))))
(check-expect (ff-render gs4)
              (render-info-text plane0
                                lof3
                                (plane-render plane0
                                              (waterloads-render lowl4
                                              (fires-render lof3 BACKG)))))


; GameState -> GameState
; After each tick, move the plane in its corresponding direction, 
; make waterloads fall, and put out fires that get soaked.
(define (ff-tock gs)
  (make-gs (move-plane (gs-plane gs))
           (move-waterloads (gs-waterloads gs))
           (soak-fires (gs-fires gs) (gs-waterloads gs))))

(check-expect (ff-tock gs0)
              (make-gs (move-plane plane0)
                       (move-waterloads lowl0)
                       (soak-fires lof0 lowl0)))
(check-expect (ff-tock gs1)
              (make-gs (move-plane plane1)
                       (move-waterloads lowl1)
                       (soak-fires lof2 lowl1)))
(check-expect (ff-tock gs2)
              (make-gs (move-plane plane2)
                       (move-waterloads lowl2)
                       (soak-fires lof4 lowl2)))
(check-expect (ff-tock gs3)
              (make-gs (move-plane plane3)
                       (move-waterloads lowl3)
                       (soak-fires lof1 lowl3)))
(check-expect (ff-tock gs4)
              (make-gs (move-plane plane0)
                       (move-waterloads lowl4)
                       (soak-fires lof3 lowl4)))


; GameState KeyEvent -> GameState
; Controls the direction of the plane with the "left" and "right" arrow keys
; and drops waterloads with the space bar if possible.
(define (ff-control gs ke)
  (cond
    [(key=? ke "right")
     (make-gs (plane-shift (gs-plane gs) RIGHT)
              (gs-waterloads gs)
              (gs-fires gs))]
    [(key=? ke "left")
     (make-gs (plane-shift (gs-plane gs) LEFT)
              (gs-waterloads gs)
              (gs-fires gs))]
    [(key=? ke " ")
     (if (plane-empty-tank? (gs-plane gs))
         gs
         (make-gs (plane-reduce-loads (gs-plane gs))
                  (drop-waterload (gs-waterloads gs) (gs-plane gs))
                  (gs-fires gs)))]
    [else gs]))

(check-expect (ff-control gs0 "right")
              (make-gs (plane-shift plane0 RIGHT) lowl0 lof0))
(check-expect (ff-control gs1 "left")
              (make-gs (plane-shift plane1 LEFT) lowl1 lof2))
(check-expect (ff-control gs2 " ")
              (make-gs (plane-reduce-loads plane2)
                       (drop-waterload lowl2 plane2)
                       lof4))
(check-expect (ff-control gs3 " ") gs3)
(check-expect (ff-control gs4 "a") gs4)


; GameState -> Boolean
; Ends the game if all the fires have been put out or if the plane runs out
; of waterloads to drop.
(define (ff-stop? gs)
  (or (empty? (gs-fires gs))
      (and (empty? (gs-waterloads gs))
           (plane-empty-tank? (gs-plane gs)))))

(check-expect (ff-stop? gs0) #true)
(check-expect (ff-stop? gs1) #false)
(check-expect (ff-stop? gs2) #false)
(check-expect (ff-stop? gs3) #false)
(check-expect (ff-stop? gs4) #false)
(check-expect (ff-stop? gs5) #true)


; GameState -> Image
; Renders the final image of the game, with a text showing success or failure.
(define (ff-render-end gs)
  (cond
    [(empty? (gs-fires gs))
     (overlay-big-text TEXT-SUCCESS TEXT-COLOR-SUCCESS (ff-render gs))]
    [else
     (overlay-big-text TEXT-FAILURE TEXT-COLOR-FAILURE (ff-render gs))]))

(check-expect (ff-render-end gs0)
              (overlay-big-text TEXT-SUCCESS TEXT-COLOR-SUCCESS
                                (ff-render gs0)))
(check-expect (ff-render-end gs5)
              (overlay-big-text TEXT-FAILURE TEXT-COLOR-FAILURE
                                (ff-render gs5)))



; Auxiliary functions

; Plane LoF Image -> Image
; Overlays a text indicating the number of remaining waterloads on the plane
; and the number of fires to put out.
(define (render-info-text p lof im)
  (overlay/align "middle" "top"
                 (beside (text (string-append "Remaining waterloads: "
                                              (number->string (plane-loads p)))
                               INFO-TEXT-SIZE "black")
                         INFO-TEXT-SEPARATOR
                         (text (string-append "Remaining fires: "
                                              (number->string (length lof)))
                               INFO-TEXT-SIZE "black"))
                 im))

(check-expect (render-info-text plane0 lof0 BACKG)
              (overlay/align "middle" "top"
                             (beside (text "Remaining waterloads: 10"
                                           INFO-TEXT-SIZE "black")
                                     INFO-TEXT-SEPARATOR
                                     (text "Remaining fires: 0"
                                           INFO-TEXT-SIZE "black"))
                             BACKG))
(check-expect (render-info-text plane1 lof2 BACKG)
              (overlay/align "middle" "top"
                             (beside (text "Remaining waterloads: 7"
                                           INFO-TEXT-SIZE "black")
                                     INFO-TEXT-SEPARATOR
                                     (text "Remaining fires: 2"
                                           INFO-TEXT-SIZE "black"))
                             BACKG))
(check-expect (render-info-text plane2 lof4 BACKG)
              (overlay/align "middle" "top"
                             (beside (text "Remaining waterloads: 4"
                                           INFO-TEXT-SIZE "black")
                                     INFO-TEXT-SEPARATOR
                                     (text "Remaining fires: 4"
                                           INFO-TEXT-SIZE "black"))
                             BACKG))
(check-expect (render-info-text plane3 lof1 BACKG)
              (overlay/align "middle" "top"
                             (beside (text "Remaining waterloads: 0"
                                           INFO-TEXT-SIZE "black")
                                     INFO-TEXT-SEPARATOR
                                     (text "Remaining fires: 1"
                                           INFO-TEXT-SIZE "black"))
                             BACKG))
(check-expect (render-info-text plane0 lof3 BACKG)
              (overlay/align "middle" "top"
                             (beside (text "Remaining waterloads: 10"
                                           INFO-TEXT-SIZE "black")
                                     INFO-TEXT-SEPARATOR
                                     (text "Remaining fires: 3"
                                           INFO-TEXT-SIZE "black"))
                             BACKG))


; Plane Image -> Image
; Renders the plane at its current position over the image im.
(define (plane-render p im)
  (place-image (cond
                 [(equal? (plane-direction p) RIGHT) PLANE-RIGHT]
                 [(equal? (plane-direction p) LEFT) PLANE-LEFT])
               (pixel-distance (plane-x p))
               (pixel-distance FLY-HEIGHT)
               im))

(check-expect (plane-render plane0 BACKG)
              (place-image PLANE-RIGHT
                           (pixel-distance PLANE-HALF-LENGTH)
                           (pixel-distance FLY-HEIGHT)
                           BACKG))
(check-expect (plane-render plane1 BACKG)
              (place-image PLANE-LEFT
                           (pixel-distance 30)
                           (pixel-distance FLY-HEIGHT)
                           BACKG))
(check-expect (plane-render plane2 BACKG)
              (place-image PLANE-RIGHT
                           (pixel-distance 60)
                           (pixel-distance FLY-HEIGHT)
                           BACKG))
(check-expect (plane-render plane3 BACKG)
              (place-image PLANE-LEFT
                           (pixel-distance (- WIDTH PLANE-HALF-LENGTH))
                           (pixel-distance FLY-HEIGHT)
                           BACKG))


; LoWL Image -> Image
; Renders the waterloads in the list at their corresponding position over im.
(define (waterloads-render lowl im)
  (cond
    [(empty? lowl) im]
    [(cons? lowl)
     (waterload-render (first lowl) (waterloads-render (rest lowl) im))]))

(check-expect (waterloads-render lowl0 BACKG) BACKG)
(check-expect (waterloads-render lowl1 BACKG) (waterload-render wl0 BACKG))
(check-expect (waterloads-render lowl2 BACKG)
              (waterload-render wl1 (waterload-render wl0 BACKG)))
(check-expect (waterloads-render lowl3 BACKG)
              (waterload-render wl2
                                (waterload-render wl1
                                                  (waterload-render wl0
                                                                    BACKG))))


; LoF Image -> Image
; Renders the fires in the list at their corresponding position over im.
(define (fires-render lof im)
  (cond
    [(empty? lof) im]
    [(cons? lof)
     (fire-render (first lof) (fires-render (rest lof) im))]))

(check-expect (fires-render lof0 BACKG) BACKG)
(check-expect (fires-render lof1 BACKG) (fire-render fire0 BACKG))
(check-expect (fires-render lof2 BACKG)
              (fire-render fire1 (fire-render fire0 BACKG)))
(check-expect (fires-render lof3 BACKG)
              (fire-render fire2
                           (fire-render fire1
                                        (fire-render fire0 BACKG))))


; String Color Image -> Image
; Overlays a big text string over the given image.
(define (overlay-big-text str text-color im)
  (overlay (text str FINAL-TEXT-SIZE text-color) im))

(check-expect (overlay-big-text TEXT-SUCCESS TEXT-COLOR-SUCCESS BACKG)
              (overlay (text TEXT-SUCCESS FINAL-TEXT-SIZE TEXT-COLOR-SUCCESS)
                       BACKG))
(check-expect (overlay-big-text TEXT-FAILURE TEXT-COLOR-FAILURE BACKG)
              (overlay (text TEXT-FAILURE FINAL-TEXT-SIZE TEXT-COLOR-FAILURE)
                       BACKG))


; WaterLoad Image -> Image
; Renders the waterload at its current position over the image im.
(define (waterload-render wl im)
  (place-image WATERLOAD
               (pixel-distance (posn-x wl))
               (pixel-distance (posn-y wl))
               im))

(check-expect (waterload-render wl0 BACKG)
              (place-image WATERLOAD
                           (pixel-distance 10)
                           (pixel-distance WATERLOAD-DROP-HEIGHT)
                           BACKG))
(check-expect (waterload-render wl1 BACKG)
              (place-image WATERLOAD
                           (pixel-distance 70)
                           (pixel-distance 37)
                           BACKG))
(check-expect (waterload-render wl2 BACKG)
              (place-image WATERLOAD
                           (pixel-distance 67)
                           (pixel-distance 64)
                           BACKG))
(check-expect (waterload-render wl3 BACKG)
              (place-image WATERLOAD
                           (pixel-distance 40)
                           (pixel-distance WATERLOAD-GROUND-LEVEL)
                           BACKG))


; Fire Image -> Image
; Renders the fire at its current position over the image im.
(define (fire-render f im)
  (place-image FIRE
               (pixel-distance f)
               (pixel-distance FIRE-GROUND-LEVEL)
               im))

(check-expect (fire-render fire0 BACKG)
              (place-image FIRE
                           (pixel-distance FIRE-HALF-WIDTH)
                           (pixel-distance FIRE-GROUND-LEVEL)
                           BACKG))
(check-expect (fire-render fire1 BACKG)
              (place-image FIRE
                           (pixel-distance 39)
                           (pixel-distance FIRE-GROUND-LEVEL)
                           BACKG))
(check-expect (fire-render fire2 BACKG)
              (place-image FIRE
                           (pixel-distance 67)
                           (pixel-distance FIRE-GROUND-LEVEL)
                           BACKG))
(check-expect (fire-render fire3 BACKG)
              (place-image FIRE
                           (pixel-distance (- WIDTH FIRE-HALF-WIDTH))
                           (pixel-distance FIRE-GROUND-LEVEL)
                           BACKG))


; Plane -> Plane
; Moves the plane at a constant speed in the direction it's facing.
(define (move-plane p)
  (make-plane (+ (plane-x p)
                 (cond
                   [(equal? (plane-direction p) RIGHT) VX-PLANE]
                   [(equal? (plane-direction p) LEFT) (- VX-PLANE)]))
              (plane-direction p)
              (plane-loads p)))

(check-expect (move-plane plane0)
              (make-plane (+ PLANE-HALF-LENGTH VX-PLANE) RIGHT 10))
(check-expect (move-plane plane1)
              (make-plane (- 30 VX-PLANE) LEFT 7))
(check-expect (move-plane plane2)
              (make-plane (+ 60 VX-PLANE) RIGHT 4))
(check-expect (move-plane plane3)
              (make-plane (- WIDTH PLANE-HALF-LENGTH VX-PLANE) LEFT 0))


; LoWL -> LoWL
; Makes all waterloads in the list fall at a constant speed.
(define (move-waterloads lowl)
  (cond
    [(empty? lowl) '()]
    [(cons? lowl)
     (if (waterload-landed? (first lowl))
         (move-waterloads (rest lowl))
         (cons (move-waterload (first lowl)) (move-waterloads (rest lowl))))]))

(check-expect (move-waterloads lowl0) '())
(check-expect (move-waterloads lowl1) (list (move-waterload wl0)))
(check-expect (move-waterloads lowl2)
              (list (move-waterload wl1) (move-waterload wl0)))
(check-expect (move-waterloads lowl3)
              (list (move-waterload wl2)
                    (move-waterload wl1)
                    (move-waterload wl0)))
(check-expect (move-waterloads lowl4)
              (list (move-waterload wl2)
                    (move-waterload wl1)
                    (move-waterload wl0)))


; WaterLoad -> WaterLoad
; Makes the waterload fall at a constant speed.
(define (move-waterload wl)
  (make-posn (posn-x wl) (+ (posn-y wl) VY-WATER)))

(check-expect (move-waterload wl0)
              (make-posn 10 (+ WATERLOAD-DROP-HEIGHT VY-WATER)))
(check-expect (move-waterload wl1)
              (make-posn 70 (+ 37 VY-WATER)))
(check-expect (move-waterload wl2)
              (make-posn 67 (+ 64 VY-WATER)))
(check-expect (move-waterload wl3)
              (make-posn 40 (+ WATERLOAD-GROUND-LEVEL VY-WATER)))


; LoF LoWL -> LoF
; Removes any fires from the list that get soaked with water.
(define (soak-fires lof lowl)
  (cond
    [(empty? lof) '()]
    [(cons? lof)
     (if (soaked-fire? (first lof) lowl)
         (soak-fires (rest lof) lowl)
         (cons (first lof) (soak-fires (rest lof) lowl)))]))

(check-expect (soak-fires lof0 lowl0) lof0)
(check-expect (soak-fires lof2 lowl1) lof2)
(check-expect (soak-fires lof4 lowl2) lof4)
(check-expect (soak-fires lof1 lowl3) lof1)
(check-expect (soak-fires lof3 lowl4) (list fire2 fire0))


; Fire LoWL -> Boolean
; Checks if the fire gets soaked by any of the waterloads in the list.
(define (soaked-fire? f lowl)
  (cond
    [(empty? lowl) #false]
    [(cons? lowl)
     (or (soaks-fire? (first lowl) f) (soaked-fire? f (rest lowl)))]))

(check-expect (soaked-fire? fire0 lowl0) #false)
(check-expect (soaked-fire? fire1 lowl4) #true)
(check-expect (soaked-fire? fire2 lowl1) #false)
(check-expect (soaked-fire? fire3 lowl3) #false)


; WaterLoad Fire -> Boolean
; Checks if the waterload soaks the fire.
(define (soaks-fire? wl f)
  (and (<= (abs (- (posn-x wl) f)) (* 1/2 WATERLOAD-WIDTH))
       (>= (posn-y wl) (- WATERLOAD-GROUND-LEVEL FIRE-HALF-HEIGHT))))

(check-expect (soaks-fire? wl0 fire1) #false)
(check-expect (soaks-fire? wl1 fire1) #false)
(check-expect (soaks-fire? wl2 fire1) #false)
(check-expect (soaks-fire? wl3 fire1) #true)


; WaterLoad -> Boolean
; Checks if the waterload has fully landed.
(define (waterload-landed? wl)
  (>= (posn-y wl) WATERLOAD-GROUND-LEVEL))

(check-expect (waterload-landed? wl0) #false)
(check-expect (waterload-landed? wl1) #false)
(check-expect (waterload-landed? wl2) #false)
(check-expect (waterload-landed? wl3) #true)


; Plnae -> Boolean
; Checks if the plane doesn't have any waterloads left to drop.
(define (plane-empty-tank? p)
  (= (plane-loads p) 0))

(check-expect (plane-empty-tank? plane0) #false)
(check-expect (plane-empty-tank? plane1) #false)
(check-expect (plane-empty-tank? plane2) #false)
(check-expect (plane-empty-tank? plane3) #true)


; Plane Direction -> Plane
; Shifts the plane's direction to d.
(define (plane-shift p d)
  (make-plane (plane-x p) d (plane-loads p)))

(check-expect (plane-shift plane0 LEFT)
              (make-plane PLANE-HALF-LENGTH LEFT 10))
(check-expect (plane-shift plane1 LEFT) plane1)
(check-expect (plane-shift plane2 RIGHT) plane2)
(check-expect (plane-shift plane3 RIGHT)
              (make-plane (- WIDTH PLANE-HALF-LENGTH) RIGHT 0))


; Plane -> Plane
; Reduces the number of remaining loads on the plane by one.
(define (plane-reduce-loads p)
  (make-plane (plane-x p) (plane-direction p) (sub1 (plane-loads p))))

(check-expect (plane-reduce-loads plane0)
              (make-plane PLANE-HALF-LENGTH RIGHT (- 10 1)))
(check-expect (plane-reduce-loads plane1)
              (make-plane 30 LEFT (- 7 1)))
(check-expect (plane-reduce-loads plane2)
              (make-plane 60 RIGHT (- 4 1)))


; LoWL Plane -> LoWL
; Drops a new waterload from the position of the plane and adds it to the list.
(define (drop-waterload lowl p)
  (cons (make-posn (plane-x p) WATERLOAD-DROP-HEIGHT) lowl))

(check-expect (drop-waterload lowl0 plane0)
              (cons (make-posn (plane-x plane0) WATERLOAD-DROP-HEIGHT) lowl0))
(check-expect (drop-waterload lowl1 plane1)
              (cons (make-posn (plane-x plane1) WATERLOAD-DROP-HEIGHT) lowl1))
(check-expect (drop-waterload lowl2 plane2)
              (cons (make-posn (plane-x plane2) WATERLOAD-DROP-HEIGHT) lowl2))
(check-expect (drop-waterload lowl4 plane0)
              (cons (make-posn (plane-x plane0) WATERLOAD-DROP-HEIGHT) lowl4))


; Number Fire -> LoF
; Creates n fires at random positions different from the given one.
(define (create-random-fires n f)
  (cond
    [(zero? n) '()]
    [else
     (cons (create-random-fire f)
           (create-random-fires (sub1 n) (create-random-fire f)))]))

(check-random (create-random-fires 1 0)
              (list (random WIDTH)))


; Fire -> Fire
; Creates a fire at some random position different from the given one.
(define (create-random-fire f)
  (check-random-fire f (random WIDTH)))

(check-satisfied (create-random-fire 42) not42?)


; Fire Fire -> Fire
; generative recursion
; Checks if the generated fire is different from f, otherwise tries again.
(define (check-random-fire f candidate)
  (if (= f candidate) (create-random-fire f) candidate))


; Fire -> Boolean
; use for testing only
(define (not42? f)
  (not (= f 42)))

