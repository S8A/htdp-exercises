;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex144) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Will sum and how-many work for NEList-of-temperatures even though
; they are designed for inputs from List-of-temperatures? If you think
; they don’t work, provide counter-examples. If you think they would,
; explain why.

; Yes, they will work with any NEList-of-temperatures, because the set
; of NEList-of-temperatures is just a subset of List-of-temperatures
; that excludes the empty list. Since both functions are designed to
; work with any List-of-temperatures, they will work with any instance
; of its subset NEList-of-temperatures.

