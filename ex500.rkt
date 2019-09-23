;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex500) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] -> N
; counts the items in the list
(define (how-many l)
  (cond
    [(empty? l) 0]
    [(cons? l) (+ 1 (how-many (rest l)))]))


; [List-of X] -> N
; counts the items in the list
(define (how-many.v2 l0)
  (local (; [List-of X] N -> N
          ; counts the items in l
          ; accumulator c is the number of items in l0 that
          ; are not in l
          (define (hm/a l c)
            (cond
              [(empty? l) c]
              [(cons? l)
               (hm/a (rest l) (+ c 1))])))
    (hm/a l0 0)))

; Q: The performance of how-many is O(n) where n is the length of the list.
; Does the accumulator version improve on this?
; A: No, because it still has to traverse the entire list item by item to
; increase the count.

; Q: Computer scientists sometime say that how-many needs O(n) space to
; represent these pending function applications. Does the accumulator reduce
; the amount of space needed to compute the result?
; A: Yes, because now the accumulator argument tracks the running count without
; relying on deferred calls to the function itself. Therefore, the space needed
; by this version of the function is always constant i.e. O(1) space.
