;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex027) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define original-price 5.0)
(define attendance-original-price 120)
(define std-price-change 0.1)
(define std-attendance-change 15)

(define (attendees ticket-price)
  (- attendance-original-price
     (* (- ticket-price original-price)
        (/ std-attendance-change std-price-change))))

(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

(define fixed-cost 180)
(define variable-cost 0.04)
(define (cost ticket-price)
  (+ fixed-cost
     (* variable-cost (attendees ticket-price))))

(define (profit ticket-price)
  (- (revenue ticket-price) (cost ticket-price)))
