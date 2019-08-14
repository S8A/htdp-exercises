;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex029) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
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

(define fixed-cost 0)
(define variable-cost 1.5)
(define (cost ticket-price)
  (+ fixed-cost
     (* variable-cost (attendees ticket-price))))

(define (profit ticket-price)
  (- (revenue ticket-price) (cost ticket-price)))


; Compact, write-only formula
(define (profit-alt price)
  (- (* (+ 120
           (* (/ 15 0.1)
              (- 5.0 price)))
        price)
     (+ 0
        (* 1.5
           (+ 120
              (* (/ 15 0.1)
                 (- 5.0 price)))))))

; Compare profits at $1, $2, $3, $4, $5 using
; both formulas
(define (profit-iter price res)
  (if (> price 5)
      res
      (profit-iter (add1 price)
                   (string-append res
                                  " "
                                  (number->string (profit price))))))

(define (profit-alt-iter price res)
  (if (> price 5)
      res
      (profit-alt-iter (add1 price)
                   (string-append res
                                  " "
                                  (number->string (profit-alt price))))))
  

; Iteratively determine the profit maximizing price
; down to the nearest dime.
(define dime 0.1)
(define (max-profit-price current-price prev-price)
  (if (< (profit current-price) (profit prev-price))
      prev-price
      (max-profit-price (+ current-price dime) current-price)))
