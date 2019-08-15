;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex036) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Image -> Number
; Counts the number of pixels in image img.
; given: (circle 10 "solid" "blue"), expected: 400
; given: (rectangle 12 20 "outline" "red"), expected: 240
; given: (circle 0 "solid" "white"), expected: 0
(define (image-area img)
  (* (image-width img) (image-height img)))