;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex240) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct layer [stuff])

; An LStr is one of: 
; – String
; – (make-layer LStr)
(define lstr0 "hey")
(define lstr1 (make-layer "you"))
(define lstr2 (make-layer (make-layer "what do you see?")))

; An LNum is one of: 
; – Number
; – (make-layer LNum)
(define lnum0 4)
(define lnum1 (make-layer 2))
(define lnum2 (make-layer (make-layer 0)))


; A [Layers-of ITEM] is one of:
; - ITEM
; - (make-layer [Layers-of ITEM])

; [Layers-of String]
; A Layers-of-String is one of:
; - String
; - (make-layer Layers-of-String)

; [Layers-of Number]
; A Layers-of-Number is one of:
; - Number
; - (make-layer Layers-of-Number)
