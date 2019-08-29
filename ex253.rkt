;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex253) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; [Number -> Boolean]
(positive? 10)

; [Boolean String -> Boolean]
(define (useless b s)
  (or b (= (string-length s) 2)))

; [Number Number Number -> Number]
(< 1 2 3)

; [Number -> [List-of Number]]
(define (tab-sin n)
  (cond
    [(= n 0) (list (sin 0))]
    [else
     (cons (sin n) (tab-sin (sub1 n)))]))

; [[List-of Number] -> Boolean]
(define (all-positive? lon)
  (cond
    [(empty? lon) #true]
    [(cons? lon)
     (and (positive? (first lon)) (all-positive? (rest lon)))]))
