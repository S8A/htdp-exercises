;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex432) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define MAX 20)

; A Food is a Posn
; interpretation the position of the food instance on the game frame

; Food -> Food
; creates a food instance at some random point different from the given one
(define (food-create p)
  (local ((define (food-check-create candidate)
            (if (equal? p candidate) (food-create p) candidate)))
    (food-check-create (make-posn (random MAX) (random MAX)))))

(check-satisfied (food-create (make-posn 1 1)) not=-1-1?)

; Food -> Boolean
; use for testing only 
(define (not=-1-1? p)
  (not (and (= (posn-x p) 1) (= (posn-y p) 1))))


; Q: Justify the design of food-create
; A: The main problem is creating a food instance at some point different from
; the given one (p). This can be broken down into two problems: creating a
; random food position and checking if it's different from p. The first
; problem is trivially solved with (make-posn (random MAX) (random MAX)).
; To solve the second problem we need a function that takes the newly created
; posn (candidate) and checks if it's equal to p. If it is, food-create is
; called again; otherwise, the candidate is a valid result and is returned.
