;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex499) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> Number
; computes the product of the list of numbers
(define (product l0)
  (local (; [List-of Number] Number -> Number
          ; computes the product of the given list of numbers
          ; accumulator r is the product of the numbers in
          ; l0 that are not in l
          (define (product/a l r)
            (cond
              [(empty? l) r]
              [(cons? l)
               (product/a (rest l) (* (first l) r))])))
    (product/a l0 1)))

(check-expect (product '(2 4 36 7)) 2016)

; Q: The performance of product is O(n) where n is the length of the list.
; Does the accumulator version improve on this?
; A: No, because it still has to traverse the entire list item by item
; to do the multiplications.
