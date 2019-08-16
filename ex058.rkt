;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex058) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define LOW-PRICE-THRESHOLD 1000)
(define LUXURY-PRICE-THRESHOLD 10000)
(define LOW-PRICE-TAX-RATE 0.05)
(define LUXURY-PRICE-TAX-RATE 0.08)

; A Price falls into one of three intervals: 
; — 0 through LOW-PRICE-THRESHOLD
; — LOW-PRICE-THRESHOLD through LUXURY-PRICE-THRESHOLD
; — LUXURY-PRICE-THRESHOLD and above.
; interpretation the price of an item

; Price -> Number
; computes the amount of tax charged for p
(check-expect (sales-tax 0) 0)
(check-expect (sales-tax 537) 0)
(check-expect (sales-tax 1000) (* 0.05 1000))
(check-expect (sales-tax 10000) (* 0.08 10000))
(check-expect (sales-tax 12017) (* 0.08 12017))
(define (sales-tax p)
  (* p (cond
         [(and (>= p 0) (< p LOW-PRICE-THRESHOLD))
          0]
         [(and (>= p LOW-PRICE-THRESHOLD) (< p LUXURY-PRICE-THRESHOLD))
          LOW-PRICE-TAX-RATE]
         [(>= p LUXURY-PRICE-THRESHOLD) LUXURY-PRICE-TAX-RATE])))
