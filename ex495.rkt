;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex495) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> Number
; adds up the numbers from the given list
(define (sum.v1 alon)
  (cond
    [(empty? alon) 0]
    [else (+ (first alon) (sum.v1 (rest alon)))]))

(check-expect (sum.v1 '(10 4)) 14)


; [List-of Number] -> Number
; adds up the numbers from the given list
(define (sum.v2 alon0)
  (local (; [List-of Number] Number -> Number
          ; computes the sum of the numbers on alon
          ; accumulator a is the sum of the numbers 
          ; that alon lacks from alon0
          (define (sum/a alon a)
            (cond
              [(empty? alon) a]
              [else (sum/a (rest alon)
                           (+ (first alon) a))])))
    (sum/a alon0 0)))

(check-expect (sum.v2 '(10 4)) 14)


; Manual evaluation: sum.v1
(sum.v1 '(10 4))
(+ 10 (sum.v1 '(4)))
(+ 10 (+ 4 (sum.v1 '())))
(+ 10 (+ 4 0))
14

; Manual evaluation: sum.v2
(sum.v2 '(10 4))
(sum/a '(10 4) 0)
(sum/a '(4) (+ 10 0))
(sum/a '() (+ 4 (+ 10 0)))
(+ 4 (+ 10 0))
14
