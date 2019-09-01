;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex273) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; [X Y] [X -> Y] [List-of X] -> [List-of Y]
; Constructs a list by applying f to each item on lx
(define (map-from-foldr f lx)
  (local (; X Y -> Y
          ; Applies f to the current item and cons it to the
          ; next one.
          (define (cons-f curr next) (cons (f curr) next)))
    (foldr cons-f '() lx)))

(check-expect (map-from-foldr add1 '(1 3 4 7))
              (map add1 '(1 3 4 7)))
(check-expect (map-from-foldr string-length '("lol" "What" "is" "this?"))
              (map string-length '("lol" "What" "is" "this?")))
