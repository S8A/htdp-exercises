;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex485) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Number Tree (NT) is one of:
; - Number
; - (list NT NT)


; NT -> Number
; determines the sum of the numbers in a tree
(define (sum-tree nt)
  (cond
    [(number? nt) nt]
    [else
     (+ (sum-tree (first nt)) (sum-tree (second nt)))]))

(check-expect (sum-tree 69) 69)
(check-expect (sum-tree (list 7 4)) 11)
(check-expect (sum-tree (list (list 7 4) (list 3 (list 1 28)))) 43)


; Q: What is its abstract running time?
; A: 2^n
; Q: What is an acceptable measure of the size of such a tree?
; A: The maximum depth of the tree, i.e. the first tree has depth 0
; while the third tree has depth 3.
; Q: What is the worst possible shape of the tree?
; A: A tree of minimum depth equal to its maximum depth, i.e.
; a tree that consists of pairs until the last level.
; Q: What’s the best possible shape?
; A: A tree consisting of a single number.
