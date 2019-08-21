;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex154) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct layer [color doll])

; An RD (short for Russian doll) is one of: 
; – String
; – (make-layer String RD)

(define doll1 "red")
(define doll2 (make-layer "green" "red"))
(define doll3 (make-layer "yellow" (make-layer "green" "red")))
(define doll4 (make-layer "pink" (make-layer "black" "white")))


; RD -> Number
; how many dolls are a part of an-rd 
(define (depth an-rd)
  (cond
    [(string? an-rd) 1]
    [(layer? an-rd)
     (+ 1 (depth (layer-doll an-rd)))]))

(check-expect (depth doll1) 1)
(check-expect (depth doll2) 2)
(check-expect (depth doll3) 3)
(check-expect (depth doll4) 3)


; RD -> String
; produces a string of all colors of a Russian doll
(define (colors doll)
  (cond
    [(string? doll) doll]
    [(layer? doll)
     (string-append (layer-color doll) ", " (colors (layer-doll doll)))]))

(check-expect (colors doll1) "red")
(check-expect (colors doll2) "green, red")
(check-expect (colors doll3) "yellow, green, red")
(check-expect (colors doll4) "pink, black, white")
