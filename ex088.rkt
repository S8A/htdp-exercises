;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex088) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A Happiness is a Number
; interpretation the "level of happiness" measured by the gauge,
; The level of happiness is in the range [0,100]


(define-struct vcat [x happiness])
; A VCat is a structure:
;   (make-vcat Number Happiness)
; interpretation (make-vcat x h) is a virtual pet cat
; whose horizontal position is x pixels from the left margin
; and whose happiness level is h in a scale from 0 to 100 inclusive
