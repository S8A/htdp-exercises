;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex047) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ..:: Constants ::..

(define HEIGHT 30)
(define WIDTH (* 10 HEIGHT))
(define FRAME (rectangle WIDTH HEIGHT "solid" "black"))

(define MIN-SCORE 0)
(define MAX-SCORE 100)
(define DECREASE 0.1)
(define SMALL-INCREASE (* 1/5 MAX-SCORE))
(define BIG-INCREASE (* 1/3 MAX-SCORE))

; ..:: Functions ::..

; A Happiness is a Number
; interpretation the "level of happiness" measured by the gauge,
; The level of happiness is in the range [0,100]

; Happiness -> Number
; Converts happiness to a number representing the width of the
; happiness bar of the gauge.
(check-expect (hl-bar-width 0) 0)
(check-expect (hl-bar-width 25) 75)
(check-expect (hl-bar-width 50) 150)
(check-expect (hl-bar-width 75) 225)
(check-expect (hl-bar-width 100) 300)
(define (hl-bar-width hl) (* WIDTH (/ hl MAX-SCORE)))

; Happiness -> Image
; Displays the gauge of happiness for a given happiness level.
(check-expect (render 0)
              (overlay/align "left" "middle"
                             (rectangle 0 HEIGHT "solid" "red")
                             FRAME))
(check-expect (render 25)
              (overlay/align "left" "middle"
                             (rectangle 75 HEIGHT "solid" "red")
                             FRAME))
(check-expect (render 50)
              (overlay/align "left" "middle"
                             (rectangle 150 HEIGHT "solid" "red")
                             FRAME))
(check-expect (render 75)
              (overlay/align "left" "middle"
                             (rectangle 225 HEIGHT "solid" "red")
                             FRAME))
(check-expect (render 100)
              (overlay/align "left" "middle"
                             (rectangle 300 HEIGHT "solid" "red")
                             FRAME))
(define (render hl)
  (overlay/align "left" "middle"
                     (rectangle (hl-bar-width hl) HEIGHT "solid" "red")
                     FRAME))

; Happiness -> Happiness
; Decreases the happiness level by -0.1 with each clock tick,
; unless happiness is at zero.
(check-expect (tock 0) 0)
(check-expect (tock 0.05) 0)
(check-expect (tock 25) 24.9)
(check-expect (tock 50) 49.9)
(check-expect (tock 75) 74.9)
(check-expect (tock 100) 99.9)
(define (tock hl)
  (if (>= (- hl DECREASE) MIN-SCORE)
      (- hl DECREASE)
      0))

; Happiness Number -> Happiness
; Increases happiness by some amount without exceeding the limit.
(check-expect (increase-happiness 0 20) 20)
(check-expect (increase-happiness 80 20) 100)
(check-expect (increase-happiness 90 30) 100)
(define (increase-happiness hl increase)
  (if (> (+ hl increase) MAX-SCORE)
      MAX-SCORE
      (+ hl increase)))

; Happiness String -> Happiness
; Increases happiness by 1/5 if the down arrow key is pressed,
; or by 1/3 if the up arrow is pressed; otherwise, ignore keystrokes.
(check-expect (keystroke-handler 0 "down") 20)
(check-expect (keystroke-handler 25 "up") 175/3)
(check-expect (keystroke-handler 50 " ") 50)
(check-expect (keystroke-handler 75 "down") 95)
(check-expect (keystroke-handler 100 "up") 100)
(define (keystroke-handler hl ke)
  (cond
    [(string=? ke "down") (increase-happiness hl SMALL-INCREASE)]
    [(string=? ke "up") (increase-happiness hl BIG-INCREASE)]
    [else hl]))

; ..:: Happiness Gauge ::..
; Happiness -> Happiness
; Launches the program with some initial level of happiness
(define (happiness-gauge hl)
  (if (and (>= hl MIN-SCORE) (<= hl MAX-SCORE))
      (big-bang hl
        [to-draw render]
        [on-tick tock]
        [on-key keystroke-handler])
      #false))

