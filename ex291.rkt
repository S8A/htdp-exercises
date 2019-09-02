;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex291) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [X Y] [X -> Y] [List-of X] -> [List-of Y]
; Constructs a list by applying f to each item on lx
(define (map-via-fold f lx)
  (foldr (lambda (curr next) (cons (f curr) next)) '() lx))

(check-expect (map-via-fold add1 '(1 3 4 7))
              (map add1 '(1 3 4 7)))
(check-expect (map-via-fold string-length '("lol" "What" "is" "this?"))
              (map string-length '("lol" "What" "is" "this?")))
