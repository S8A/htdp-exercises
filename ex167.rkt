;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex167) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ListOfPosns -> Number
; sums the x-coordinates of all the posns in the list
(define (sum list)
  (cond
    [(empty? list) 0]
    [(cons? list)
     (+ (posn-x (first list)) (sum (rest list)))]))

(check-expect (sum '()) 0)
(check-expect (sum (cons (make-posn 52 11) (cons (make-posn 7.4 3) '())))
              (+ 52 7.4))
