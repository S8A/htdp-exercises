;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex155) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct layer [color doll])

; An RD (short for Russian doll) is one of: 
; – String
; – (make-layer String RD)

(define doll1 "red")
(define doll2 (make-layer "green" "red"))
(define doll3 (make-layer "yellow" (make-layer "green" "red")))
(define doll4 (make-layer "pink" (make-layer "black" "white")))


; RD -> String
; produces the (color of the) innermost doll of rd
(define (inner rd)
  (cond
    [(string? rd) rd]
    [(layer? rd) (inner (layer-doll rd))]))

(check-expect (inner doll1) "red")
(check-expect (inner doll2) "red")
(check-expect (inner doll3) "red")
(check-expect (inner doll4) "white")
