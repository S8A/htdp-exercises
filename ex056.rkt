;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex056) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
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
(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)
(define (launch y ke)
  (cond
    [(and (string? y) (string=? y "resting")) (if (key=? " " ke) -3 y)]
    [else y]))
 
; LRCD -> LRCD
; raises the rocket by YDELTA if it is moving already 
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) HEIGHT)
(check-expect (fly 10) (- 10 YDELTA))
(check-expect (fly 22) (- 22 YDELTA))
(define (fly y)
  (cond
    [(and (string? y) (string=? y "resting")) y]
    [(<= -3 y -1) (if (= y -1) HEIGHT (+ y 1))]
    [(>= y 0) (- y YDELTA)]))

; LRCD -> Boolean
; stops the program when the rocket dissappears
(check-expect (stop? "resting") #false)
(check-expect (stop? -2) #false)
(check-expect (stop? 10) #false)
(check-expect (stop? 0) #true)
(define (stop? y) (and (number? y) (= y 0)))


; LRCD -> LRCD
(define (main2 s)
  (big-bang s
    [on-tick fly 1]
    [to-draw show]
    [on-key launch]
    [stop-when stop?]))
