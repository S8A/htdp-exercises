;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex261) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct ir [name price])
; An IR is a structure:
;   (make-ir String Number)


; An Inventory is a [List-of IR]


; Inventory -> Inventory
; creates an Inventory from an-inv for all
; those items that cost less than a dollar
(define (extract1 an-inv)
  (cond
    [(empty? an-inv) '()]
    [else
     (cond
       [(<= (ir-price (first an-inv)) 1.0)
        (cons (first an-inv) (extract1 (rest an-inv)))]
       [else (extract1 (rest an-inv))])]))


; Inventory -> Inventory
; creates an Inventory from an-inv for all
; those items that cost less than a dollar
(define (extract1-fast an-inv)
  (cond
    [(empty? an-inv) '()]
    [else
     (local ((define extract-from-rest (extract1-fast (rest an-inv))))
       (cond
         [(<= (ir-price (first an-inv)) 1.0)
          (cons (first an-inv) extract-from-rest)]
         [else extract-from-rest]))]))



; Number -> IR
; Creates example inventory record from a number.
(define (ir-example n)
  (make-ir (string-ith "abcdefghijklmnopqrstuvwxyz" (modulo n 26))
           (random-price n)))


; Number -> Number
; Generates a random price between 0.01 and 11.00
(define (random-price n)
  (+ (abs (inexact->exact (round (* 10 (sin (random (add1 n)))))))
     (* 0.01 (add1 (modulo (sqr n) 100)))))



; ..:: Time test ::..
(define testlist (build-list 1000000 ir-example))
;(extract1 testlist)
;(extract1-fast testlist)


; Q: Does this [change] help increase the speed at which the function
; computes its result? Significantly? A little bit? Not at all?
; A: It improves perfomance only a little bit.
