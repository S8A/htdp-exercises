;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex398) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A LinearCombination is a [List-of Number]
; interpretation each element is the coefficient of the
; variable x_i (x_0, x_1, x_2 aliased to x, y, z)
(define lc1 (list 5)) ; 5x
(define lc2 (list 5 17)) ; 5x + 17y
(define lc3 (list 5 17 3)) ; 5x + 17y + 3z


; LinearCombination [List-of Number] -> Number
; Produces the value of the given linear combination using the
; given values for each variable. Assumtion: equally long lists.
(define (value lcomb values)
  (cond
    [(empty? lcomb) 0]
    [(cons? lcomb)
     (+ (* (first lcomb) (first values)) (value (rest lcomb) (rest values)))]))

(check-expect (value '() '()) 0)
(check-expect (value lc1 '(10)) 50)
(check-expect (value lc2 '(10 1)) 67)
(check-expect (value lc3 '(10 1 2)) 73)
