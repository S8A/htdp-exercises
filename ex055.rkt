;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex055) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define HEIGHT 300) ; distances in pixels 
(define WIDTH  100)
(define YDELTA 3)
 
(define BACKG  (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))
 
(define CENTER (/ (image-height ROCKET) 2))


; An LRCD (for launching rocket countdown) is one of:
; – "resting"
; – a Number between -3 and -1
; – a NonnegativeNumber 
; interpretation a grounded rocket; in countdown mode;
; a number denotes the number of pixels between the
; top of the canvas and the rocket (its height)

; LRCD -> Image
; renders the state as a resting or flying rocket
(check-expect (show-rocket "resting")
              (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))
(check-expect (show-rocket -2)
              (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))
(check-expect (show-rocket 0)
              (place-image ROCKET 10 (- CENTER) BACKG))
(check-expect (show-rocket 53)
              (place-image ROCKET 10 (- 53 CENTER) BACKG))
(define (show-rocket y)
  (place-image ROCKET
               10 (- (if (and (number? y) (>= y 0)) y HEIGHT) CENTER)
               BACKG))

; LRCD -> Image
; renders the state as a resting or flying rocket with/out countdown
(check-expect (show "resting")
              (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))
(check-expect (show -2)
              (place-image (text "-2" 20 "red")
                           10 (* 3/4 WIDTH)
                           (place-image ROCKET 10 (- HEIGHT CENTER) BACKG)))
(check-expect (show 0)
              (place-image ROCKET 10 (- CENTER) BACKG))
(check-expect (show 53)
              (place-image ROCKET 10 (- 53 CENTER) BACKG))
(define (show y)
  (if (and (number? y) (<= -3 y -1))
      (place-image (text (number->string y) 20 "red")
                   10 (* 3/4 WIDTH)
                   (show-rocket y))
      (show-rocket y)))
 
; LRCD KeyEvent -> LRCD
; starts the countdown when space bar is pressed, 
; if the rocket is still resting 
(define (launch x ke)
  x)
 
; LRCD -> LRCD
; raises the rocket by YDELTA,
;  if it is moving already 
(define (fly x)
  x)
