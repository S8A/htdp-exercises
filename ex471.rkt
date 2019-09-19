;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex471) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Node is a Symbol.

; A Graph is a [List-of [List Node [List-of Node]]]

(define sample-graph
  (list (list 'A (list 'B 'E))
        (list 'B (list 'E 'F))
        (list 'C (list 'D))
        (list 'D '())
        (list 'E (list 'C 'F))
        (list 'F (list 'D 'G))
        (list 'G '())))


; Node Graph -> [List-of Node]
; produces the list of immediate neighbors of n in g
(define (neighbors n g)
  (cond
    [(empty? g) (error 'neighbors n " not found")]
    [(cons? g)
     (local ((define fst (first g)))
       (if (symbol=? (first fst) n)
           (first (rest fst))
           (neighbors n (rest g))))]))

(check-expect (neighbors 'A sample-graph) '(B E))
(check-expect (neighbors 'D sample-graph) '())
(check-expect (neighbors 'F sample-graph) '(D G))
(check-error (neighbors 'Z sample-graph))
