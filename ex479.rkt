;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex479) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define QUEENS 8)
; A QP is a structure:
;   (make-posn CI CI)
; A CI is an N in [0,QUEENS).
; interpretation (make-posn c r) denotes the square at 
; the r-th row and c-th column


; QP QP -> Boolean
; determines whether two queens placed on the given squares would
; threaten each other
(define (threatening? qp1 qp2)
  (local ((define qp1x (posn-x qp1))
          (define qp1y (posn-y qp1))
          (define qp2x (posn-x qp2))
          (define qp2y (posn-y qp2))
          (define same-row? (= qp1y qp2y))
          (define same-col? (= qp1x qp2x))
          (define same-first-diagonal?
            (= (- qp1x qp1y) (- qp2x qp2y)))
          (define same-second-diagonal?
            (= (+ qp1x qp1y) (+ qp2x qp2y))))
    (or same-row? same-col? same-first-diagonal? same-second-diagonal?)))

(check-expect (threatening? (make-posn 0 0) (make-posn 1 2)) #false)
(check-expect (threatening? (make-posn 1 0) (make-posn 1 2)) #true)
(check-expect (threatening? (make-posn 0 2) (make-posn 1 2)) #true)
(check-expect (threatening? (make-posn 3 0) (make-posn 1 2)) #true)
