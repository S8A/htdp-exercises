;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ufo-landing2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A WorldState falls into one of three intervals: 
; – between 0 and CLOSE
; – between CLOSE and LANDED-POSITION
; – below LANDED-POSITION
; interpretation number of pixels between the top and the UFO
 
(define WIDTH 300) ; distances in terms of pixels 
(define HEIGHT 500)
(define MID-WIDTH (/ WIDTH 2))
(define CLOSE (/ HEIGHT 3))
(define MTSCN (empty-scene WIDTH HEIGHT))
(define UFO
  (overlay (circle 10 "solid" "green") (rectangle 30 5 "solid" "green")))
(define UFO-HEIGHT (image-height UFO))
(define LANDED-POSITION (- HEIGHT (/ UFO-HEIGHT 2)))
 
; WorldState -> WorldState
(define (main y0)
  (big-bang y0
     [on-tick nxt 1/7]
     [to-draw render]))
 
; WorldState -> WorldState
; computes next location of UFO 
(check-expect (nxt 11) 14)
(define (nxt y)
  (if (< y LANDED-POSITION) (+ y 3) y))

; WorldState -> Image
; shows status of UFO according to its position
(define (status y)
  (text (cond
          [(>= y LANDED-POSITION) "landed"]
          [(< CLOSE y LANDED-POSITION) "closing in"]
          [else "descending"])
        12
        "black"))
 
; WorldState -> Image
; places UFO at given height into the center of MTSCN
(check-expect (render 11)
              (place-image (status 11)
                           MID-WIDTH 12
                           (place-image UFO 150 11 MTSCN)))
(define (render y)
  (place-image (status y)
               MID-WIDTH 12
               (place-image UFO MID-WIDTH y MTSCN)))
