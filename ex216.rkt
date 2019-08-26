;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex216) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
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


; A Direction is one of the following:
(define UP "up")
(define DOWN "down")
(define RIGHT "right")
(define LEFT "left")


(define-struct worm [direction position])
; A WormState is a structure:
;   (make-worm Direction Posn)
; interpretation combines the position of the worm in a grid
; of squares of side length 1 base unit and the direction
; in which it's moving
(define wsu15x10y (make-worm UP (make-posn 15 10)))
(define wsd11x2y (make-worm DOWN (make-posn 11 2)))
(define wsr4x18y (make-worm RIGHT (make-posn 4 18)))
(define wsl12x7y (make-worm LEFT (make-posn 12 7)))
(define wsu15x0y (make-worm UP (make-posn 15 0)))
(define wsd11x20y (make-worm DOWN (make-posn 11 20)))
(define wsr20x18y (make-worm RIGHT (make-posn 20 18)))
(define wsl0x7y (make-worm LEFT (make-posn 0 7)))


; main: Number -> WormState
; runs a worm game with a clock that ticks every x seconds
(define (worm-main x)
  (big-bang (make-worm RIGHT (make-posn COORD-CENTER COORD-CENTER))
    [to-draw worm-render]
    [on-tick worm-tock x]
    [on-key worm-control]
    [stop-when worm-stop? worm-render-end]))


; WormState -> Image
; renders the worm at its current position
(define (worm-render w)
  (place-image DISK
               (+ (* (posn-x (worm-position w)) BASE-UNIT) RADIUS)
               (+ (* (posn-y (worm-position w)) BASE-UNIT) RADIUS)
               BACKG))

(check-expect (worm-render wsu15x10y)
              (place-image DISK
                           (+ (* 15 BASE-UNIT) RADIUS)
                           (+ (* 10 BASE-UNIT) RADIUS)
                           BACKG))
(check-expect (worm-render wsd11x2y)
              (place-image DISK
                           (+ (* 11 BASE-UNIT) RADIUS)
                           (+ (* 2 BASE-UNIT) RADIUS)
                           BACKG))
(check-expect (worm-render wsr4x18y)
              (place-image DISK
                           (+ (* 4 BASE-UNIT) RADIUS)
                           (+ (* 18 BASE-UNIT) RADIUS)
                           BACKG))
(check-expect (worm-render wsl12x7y)
              (place-image DISK
                           (+ (* 12 BASE-UNIT) RADIUS)
                           (+ (* 7 BASE-UNIT) RADIUS)
                           BACKG))


; WormState -> WormState
; moves the worm 1 base unit in its current direction after each tick
(define (worm-tock w)
  (cond
    [(equal? (worm-direction w) UP) (move-worm w 0 -1)]
    [(equal? (worm-direction w) DOWN) (move-worm w 0 1)]
    [(equal? (worm-direction w) RIGHT) (move-worm w 1 0)]
    [(equal? (worm-direction w) LEFT) (move-worm w -1 0)]))

(check-expect (worm-tock wsu15x10y) (move-worm wsu15x10y 0 -1))
(check-expect (worm-tock wsd11x2y) (move-worm wsd11x2y 0 1))
(check-expect (worm-tock wsr4x18y) (move-worm wsr4x18y 1 0))
(check-expect (worm-tock wsl12x7y) (move-worm wsl12x7y -1 0))


; WormState KeyEvent -> WormState
; changes the direction of movement of the worm with the arrow keys
(define (worm-control w ke)
  (cond
    [(key=? ke "up") (redirect-worm w UP)]
    [(key=? ke "down") (redirect-worm w DOWN)]
    [(key=? ke "right") (redirect-worm w RIGHT)]
    [(key=? ke "left") (redirect-worm w LEFT)]
    [else w]))

(check-expect (worm-control wsu15x10y "up") wsu15x10y)
(check-expect (worm-control wsd11x2y "down") wsd11x2y)
(check-expect (worm-control wsr4x18y "right") wsr4x18y)
(check-expect (worm-control wsl12x7y "left") wsl12x7y)
(check-expect (worm-control wsu15x10y "left") (redirect-worm wsu15x10y LEFT))
(check-expect (worm-control wsd11x2y "right") (redirect-worm wsd11x2y RIGHT))
(check-expect (worm-control wsr4x18y "down") (redirect-worm wsr4x18y DOWN))
(check-expect (worm-control wsl12x7y "up") (redirect-worm wsl12x7y UP))
(check-expect (worm-control wsu15x10y "a") wsu15x10y)
(check-expect (worm-control wsd11x2y "\r") wsd11x2y)
(check-expect (worm-control wsr4x18y " ") wsr4x18y)
(check-expect (worm-control wsl12x7y "\t") wsl12x7y)


; WormState -> Boolean
; ends the game if the worm reaches any of the borders of the frame
(define (worm-stop? w)
  (or (= (posn-x (worm-position w)) 0)
      (= (posn-y (worm-position w)) 0)
      (= (posn-x (worm-position w)) COORD-WIDTH)
      (= (posn-y (worm-position w)) COORD-WIDTH)))

(check-expect (worm-stop? wsu15x10y) #false)
(check-expect (worm-stop? wsd11x2y) #false)
(check-expect (worm-stop? wsr4x18y) #false)
(check-expect (worm-stop? wsl12x7y) #false)
(check-expect (worm-stop? wsu15x0y) #true)
(check-expect (worm-stop? wsd11x20y) #true)
(check-expect (worm-stop? wsr20x18y) #true)
(check-expect (worm-stop? wsl0x7y) #true)


; WormState -> Image
; renders the final state of the game with a message
(define (worm-render-end w)
  (overlay/align "left" "bottom"
                 (text "worm hit border" TEXT-SIZE TEXT-COLOR)
                 (worm-render w)))

(check-expect (worm-render-end wsu15x0y)
              (overlay/align "left" "bottom"
                             (text "worm hit border" TEXT-SIZE TEXT-COLOR)
                             (worm-render wsu15x0y)))
(check-expect (worm-render-end wsd11x20y)
              (overlay/align "left" "bottom"
                             (text "worm hit border" TEXT-SIZE TEXT-COLOR)
                             (worm-render wsd11x20y)))
(check-expect (worm-render-end wsr20x18y)
              (overlay/align "left" "bottom"
                             (text "worm hit border" TEXT-SIZE TEXT-COLOR)
                             (worm-render wsr20x18y)))
(check-expect (worm-render-end wsl0x7y)
              (overlay/align "left" "bottom"
                             (text "worm hit border" TEXT-SIZE TEXT-COLOR)
                             (worm-render wsl0x7y)))


; WormState Number Number -> WormState
; adds dx and dy to the worm's x and y coordinates, respectively
(define (move-worm w dx dy)
  (make-worm (worm-direction w)
             (make-posn (+ (posn-x (worm-position w)) dx)
                        (+ (posn-y (worm-position w)) dy))))

(check-expect (move-worm wsu15x10y 0 -1)
              (make-worm UP (make-posn 15 (- 10 1))))
(check-expect (move-worm wsd11x2y 0 1)
              (make-worm DOWN (make-posn 11 (+ 2 1))))
(check-expect (move-worm wsr4x18y 1 0)
              (make-worm RIGHT (make-posn (+ 4 1) 18)))
(check-expect (move-worm wsl12x7y -1 0)
              (make-worm LEFT (make-posn (- 12 1) 7)))


; WormState Direction -> WormState
; changes the worm's direction to dir
(define (redirect-worm w dir)
  (make-worm dir (worm-position w)))

(check-expect (redirect-worm wsu15x10y LEFT)
              (make-worm LEFT (make-posn 15 10)))
(check-expect (redirect-worm wsd11x2y RIGHT)
              (make-worm RIGHT (make-posn 11 2)))
(check-expect (redirect-worm wsr4x18y DOWN)
              (make-worm DOWN (make-posn 4 18)))
(check-expect (redirect-worm wsl12x7y UP)
              (make-worm UP (make-posn 12 7)))
