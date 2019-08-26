;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex218) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; Graphical constants
(define RADIUS 5)
(define BASE-UNIT (* 2 RADIUS))
(define DISK (circle RADIUS "solid" "red"))

(define COORD-WIDTH 20) ; width in base units
(define WIDTH (* (+ COORD-WIDTH 1) BASE-UNIT))
(define HEIGHT WIDTH)
(define COORD-CENTER (floor (/ COORD-WIDTH 2)))
(define BACKG (empty-scene WIDTH HEIGHT "black"))

(define TEXT-SIZE 12)
(define TEXT-COLOR "white")
(define TEXT-HIT-WALL "worm hit wall")
(define TEXT-HIT-SELF "worm ran over itself")


; A Direction is one of the following:
(define UP "up")
(define DOWN "down")
(define RIGHT "right")
(define LEFT "left")


; A ListOfSegments is one of the following:
; - (list Posn)
; - (cons Posn ListOfSegments)
; interpretation the positions of each segment of
; a worm's body, each 1 base unit apart in any direction


(define-struct worm [direction segments])
; A WormState is a structure:
;   (make-worm Direction ListOfSegments)
; interpretation combines direction in which the worm is moving
; with the positions of its segments
(define w0 (make-worm RIGHT (list (make-posn COORD-CENTER COORD-CENTER))))
(define w1 (make-worm UP (list (make-posn 15 10)
                               (make-posn 15 11)
                               (make-posn 15 12)
                               (make-posn 16 12))))
(define w2 (make-worm DOWN (list (make-posn 11 2)
                                 (make-posn 11 1)
                                 (make-posn 10 1)
                                 (make-posn 9 1)
                                 (make-posn 8 1))))
(define w3 (make-worm RIGHT (list (make-posn 4 18)
                                  (make-posn 3 18)
                                  (make-posn 2 18)
                                  (make-posn 2 17)
                                  (make-posn 2 16)
                                  (make-posn 2 15)
                                  (make-posn 2 14))))
(define w4 (make-worm LEFT (list (make-posn 12 7)
                                 (make-posn 13 7)
                                 (make-posn 13 6)
                                 (make-posn 13 5)
                                 (make-posn 13 4)
                                 (make-posn 13 3))))
(define w5 (make-worm UP (list (make-posn 15 -1)
                               (make-posn 15 0)
                               (make-posn 15 1)
                               (make-posn 15 2)
                               (make-posn 15 3)
                               (make-posn 15 4))))
(define w6 (make-worm DOWN (list (make-posn 11 21)
                                 (make-posn 11 20)
                                 (make-posn 11 19))))
(define w7 (make-worm RIGHT (list (make-posn 21 18)
                                  (make-posn 20 18)
                                  (make-posn 19 18)
                                  (make-posn 18 18)
                                  (make-posn 17 18)
                                  (make-posn 16 18)
                                  (make-posn 16 19)
                                  (make-posn 15 19))))
(define w8 (make-worm LEFT (list (make-posn -1 7)
                                 (make-posn 0 7)
                                 (make-posn 1 7)
                                 (make-posn 2 7)
                                 (make-posn 2 6)
                                 (make-posn 2 5)
                                 (make-posn 3 5)
                                 (make-posn 4 5)
                                 (make-posn 4 6)
                                 (make-posn 4 7)
                                 (make-posn 5 7)
                                 (make-posn 6 7)
                                 (make-posn 6 6)
                                 (make-posn 6 5))))
(define w9 (make-worm DOWN (list ;(make-posn 8 12)
                                 (make-posn 8 11)
                                 (make-posn 8 10)
                                 (make-posn 9 10)
                                 (make-posn 10 10)
                                 (make-posn 10 11)
                                 (make-posn 10 12)
                                 (make-posn 9 12)
                                 (make-posn 8 12)
                                 (make-posn 7 12)
                                 (make-posn 6 12))))
(define w10 (make-worm LEFT (list ;(make-posn 7 14)
                                  (make-posn 8 14)
                                  (make-posn 8 15)
                                  (make-posn 8 16)
                                  (make-posn 7 16)
                                  (make-posn 6 16)
                                  (make-posn 6 15)
                                  (make-posn 6 14)
                                  (make-posn 7 14))))


; main: Number -> WormState
; runs a worm game with a clock that ticks every x seconds
(define (worm-main x)
  (big-bang w0
    [to-draw worm-render]
    [on-tick worm-tock x]
    [on-key worm-control]
    [stop-when worm-stop? worm-render-end]))


; WormState -> Image
; renders the worm at its current position
(define (worm-render w)
  (place-segments (worm-segments w) BACKG))

(check-expect (worm-render w0) (place-segments (worm-segments w0) BACKG))
(check-expect (worm-render w1) (place-segments (worm-segments w1) BACKG))
(check-expect (worm-render w2) (place-segments (worm-segments w2) BACKG))
(check-expect (worm-render w3) (place-segments (worm-segments w3) BACKG))
(check-expect (worm-render w4) (place-segments (worm-segments w4) BACKG))


; WormState -> WormState
; moves the worm 1 base unit in its current direction after each tick
(define (worm-tock w)
  (cond
    [(equal? (worm-direction w) UP) (move-worm w 0 -1)]
    [(equal? (worm-direction w) DOWN) (move-worm w 0 1)]
    [(equal? (worm-direction w) RIGHT) (move-worm w 1 0)]
    [(equal? (worm-direction w) LEFT) (move-worm w -1 0)]))

(check-expect (worm-tock w1) (move-worm w1 0 -1))
(check-expect (worm-tock w2) (move-worm w2 0 1))
(check-expect (worm-tock w3) (move-worm w3 1 0))
(check-expect (worm-tock w4) (move-worm w4 -1 0))


; WormState KeyEvent -> WormState
; changes the direction of movement of the worm with the arrow keys
(define (worm-control w ke)
  (cond
    [(key=? ke "up") (redirect-worm w UP)]
    [(key=? ke "down") (redirect-worm w DOWN)]
    [(key=? ke "right") (redirect-worm w RIGHT)]
    [(key=? ke "left") (redirect-worm w LEFT)]
    [else w]))

(check-expect (worm-control w1 "up") w1)
(check-expect (worm-control w2 "down") w2)
(check-expect (worm-control w3 "right") w3)
(check-expect (worm-control w4 "left") w4)
(check-expect (worm-control w1 "left") (redirect-worm w1 LEFT))
(check-expect (worm-control w2 "right") (redirect-worm w2 RIGHT))
(check-expect (worm-control w3 "down") (redirect-worm w3 DOWN))
(check-expect (worm-control w4 "up") (redirect-worm w4 UP))
(check-expect (worm-control w1 "a") w1)
(check-expect (worm-control w2 "\r") w2)
(check-expect (worm-control w3 " ") w3)
(check-expect (worm-control w4 "\t") w4)


; WormState -> Boolean
; ends the game if the worm reaches any of the borders of the frame
(define (worm-stop? w)
  (or (hit-wall? w)
      (hit-self? w)))

(check-expect (worm-stop? w1) #false)
(check-expect (worm-stop? w2) #false)
(check-expect (worm-stop? w3) #false)
(check-expect (worm-stop? w4) #false)
(check-expect (worm-stop? w5) #true)
(check-expect (worm-stop? w6) #true)
(check-expect (worm-stop? w7) #true)
(check-expect (worm-stop? w8) #true)
(check-expect (worm-stop? w9) #true)
(check-expect (worm-stop? w10) #true)


; WormState -> Image
; renders the final state of the game with a message
(define (worm-render-end w)
  (overlay/align "left" "bottom"
                 (render-end-text w)
                 (worm-render w)))

(check-expect (worm-render-end w5)
              (overlay/align "left" "bottom"
                             (render-end-text w5)
                             (worm-render w5)))
(check-expect (worm-render-end w6)
              (overlay/align "left" "bottom"
                             (render-end-text w6)
                             (worm-render w6)))
(check-expect (worm-render-end w7)
              (overlay/align "left" "bottom"
                             (render-end-text w7)
                             (worm-render w7)))
(check-expect (worm-render-end w8)
              (overlay/align "left" "bottom"
                             (render-end-text w8)
                             (worm-render w8)))
(check-expect (worm-render-end w9)
              (overlay/align "left" "bottom"
                             (render-end-text w9)
                             (worm-render w9)))
(check-expect (worm-render-end w10)
              (overlay/align "left" "bottom"
                             (render-end-text w10)
                             (worm-render w10)))


; ListOfSegments Image -> Image
; places each segment on its corresponding position over the given image
(define (place-segments los im)
  (cond
    [(empty? (rest los))
     (place-segment (first los) im)]
    [(cons? (rest los))
     (place-segment (first los) (place-segments (rest los) im))]))

(check-expect (place-segments (list (make-posn 1 2)) BACKG)
              (place-segment (make-posn 1 2) BACKG))
(check-expect (place-segments (list (make-posn 3 4) (make-posn 1 2)) BACKG)
              (place-segment (make-posn 3 4)
                             (place-segment (make-posn 1 2) BACKG)))


; Posn Image -> Image
; places the worm segment at position p over the given image
(define (place-segment p im)
  (place-image DISK
               (+ (* (posn-x p) BASE-UNIT) RADIUS)
               (+ (* (posn-y p) BASE-UNIT) RADIUS)
               im))

(check-expect (place-segment (make-posn 0 0) BACKG)
              (place-image DISK RADIUS RADIUS BACKG))
(check-expect (place-segment (make-posn 3 4) BACKG)
              (place-image DISK
                           (+ (* 3 BASE-UNIT) RADIUS)
                           (+ (* 4 BASE-UNIT) RADIUS)
                           BACKG))


; WormState Number Number -> WormState
; moves the worm dx to the right and dy down from where it is
(define (move-worm w dx dy)
  (make-worm (worm-direction w)
             (remove-last (add-new-first dx dy (worm-segments w)))))

(check-expect (move-worm w0 1 0)
              (make-worm RIGHT
                         (remove-last (add-new-first 1 0 (worm-segments w0)))))
(check-expect (move-worm w1 0 -1)
              (make-worm UP
                         (remove-last (add-new-first 0 -1 (worm-segments w1)))))
(check-expect (move-worm w2 0 1)
              (make-worm DOWN
                         (remove-last (add-new-first 0 1 (worm-segments w2)))))
(check-expect (move-worm w3 1 0)
              (make-worm RIGHT
                         (remove-last (add-new-first 1 0 (worm-segments w3)))))
(check-expect (move-worm w4 -1 0)
              (make-worm LEFT
                         (remove-last (add-new-first -1 0 (worm-segments w4)))))


; WormState Direction -> WormState
; changes the worm's direction to dir
(define (redirect-worm w dir)
  (make-worm dir (worm-segments w)))

(check-expect (redirect-worm w1 LEFT)
              (make-worm LEFT (worm-segments w1)))
(check-expect (redirect-worm w2 RIGHT)
              (make-worm RIGHT (worm-segments w2)))
(check-expect (redirect-worm w3 DOWN)
              (make-worm DOWN (worm-segments w3)))
(check-expect (redirect-worm w4 UP)
              (make-worm UP (worm-segments w4)))


; ListOfSegments -> ListOfSegments
; removes the last item in a list of segments
(define (remove-last los)
  (cond
    [(empty? (rest los)) '()]
    [(cons? (rest los))
     (cons (first los) (remove-last (rest los)))]))

(check-expect (remove-last (list (make-posn 1 2))) '())
(check-expect (remove-last (list (make-posn 3 4) (make-posn 1 2)))
              (list (make-posn 3 4)))


; Number Number ListOfSegments -> ListOfSegments
; prepends new segment to the list, dx to the right and dy down from the
; position of the first one
(define (add-new-first dx dy los)
  (cons (make-posn (+ (posn-x (first los)) dx)
                   (+ (posn-y (first los)) dy))
        los))

(check-expect (add-new-first 0 -1 (list (make-posn 1 2)))
              (list (make-posn (+ 1 0) (+ 2 -1)) (make-posn 1 2)))
(check-expect (add-new-first 1 0 (list (make-posn 3 4) (make-posn 1 2)))
              (list (make-posn (+ 3 1) (+ 4 0))
                    (make-posn 3 4)
                    (make-posn 1 2)))


; WormState -> Boolean
; did the worm run into one of the borders of the game frame
(define (hit-wall? w)
  (or (< (posn-x (first (worm-segments w))) 0)
      (< (posn-y (first (worm-segments w))) 0)
      (> (posn-x (first (worm-segments w))) COORD-WIDTH)
      (> (posn-y (first (worm-segments w))) COORD-WIDTH)))

(check-expect (hit-wall? w1) #false)
(check-expect (hit-wall? w2) #false)
(check-expect (hit-wall? w3) #false)
(check-expect (hit-wall? w4) #false)
(check-expect (hit-wall? w5) #true)
(check-expect (hit-wall? w6) #true)
(check-expect (hit-wall? w7) #true)
(check-expect (hit-wall? w8) #true)
(check-expect (hit-wall? w9) #false)
(check-expect (hit-wall? w10) #false)


; WormState -> Boolean
; did the worm run into one of its other segments
(define (hit-self? w)
  (member? (first (worm-segments (worm-tock w))) (rest (worm-segments w))))

(check-expect (hit-self? w1) #false)
(check-expect (hit-self? w2) #false)
(check-expect (hit-self? w3) #false)
(check-expect (hit-self? w4) #false)
(check-expect (hit-self? w5) #false)
(check-expect (hit-self? w6) #false)
(check-expect (hit-self? w7) #false)
(check-expect (hit-self? w8) #false)
(check-expect (hit-self? w9) #true)
(check-expect (hit-self? w10) #true)


; WormState -> Image
; renders the text explanation of why the game ended: the worm hit a wall or
; itself
(define (render-end-text w)
  (text (cond
          [(hit-wall? w) TEXT-HIT-WALL]
          [(hit-self? w) TEXT-HIT-SELF]
          [else ""])
        TEXT-SIZE TEXT-COLOR))

(check-expect (render-end-text w5) (text TEXT-HIT-WALL TEXT-SIZE TEXT-COLOR))
(check-expect (render-end-text w6) (text TEXT-HIT-WALL TEXT-SIZE TEXT-COLOR))
(check-expect (render-end-text w7) (text TEXT-HIT-WALL TEXT-SIZE TEXT-COLOR))
(check-expect (render-end-text w8) (text TEXT-HIT-WALL TEXT-SIZE TEXT-COLOR))
(check-expect (render-end-text w9) (text TEXT-HIT-SELF TEXT-SIZE TEXT-COLOR))
(check-expect (render-end-text w10) (text TEXT-HIT-SELF TEXT-SIZE TEXT-COLOR))
