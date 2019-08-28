;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex236) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; Lon -> Lon
; adds 1 to each item on l
(define (add1* l)
  (add-each l 1))

(check-expect (add1* '()) '())
(check-expect (add1* '(100)) '(101))
(check-expect (add1* '(1 3 4 6)) '(2 4 5 7))

	
; Lon -> Lon
; adds 5 to each item on l
(define (plus5 l)
  (add-each l 5))

(check-expect (plus5 '()) '())
(check-expect (plus5 '(100)) '(105))
(check-expect (plus5 '(1 3 4 6)) '(6 8 9 11))


; Lon -> Lon
; substracts 2 from each item on l
(define (sub2* l)
  (add-each l -2))

(check-expect (sub2* '()) '())
(check-expect (sub2* '(100)) '(98))
(check-expect (sub2* '(1 3 4 6)) '(-1 1 2 4))


; Lon Number -> Lon
; adds n to each item on l
(define (add-each l n)
  (cond
    [(empty? l) '()]
    [else
     (cons (+ (first l) n)
           (add-each (rest l) n))]))
