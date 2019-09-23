;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex491) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> [List-of Number]
; converts a list of relative to absolute distances
; the first number represents the distance to the origin
(define (relative->absolute l)
 (reverse
   (foldr (lambda (f l) (cons (+ f (first l)) l))
          (list (first l))
          (reverse (rest l)))))


; Q: Does your friend’s solution mean there is no need for our complicated
; design in this motivational section?
; A: No, because their solution is hard to read and design in the first place.
; Besides, its perfomance depends on the implementation of foldr and reverse,
; i.e. if they are defined as recursive functions the perfomance of the function
; will probably be O(n³). This can be illustrated by actually implementing
; these alternative definitions and comparing its perfomance to the original:


; [List-of Number] -> [List-of Number]
; converts a list of relative to absolute distances
; the first number represents the distance to the origin
(define (relative->absolute.own l)
 (reverse.own
   (foldr.own (lambda (f l) (cons (+ f (first l)) l))
          (list (first l))
          (reverse.own (rest l)))))

; [List-of X] -> [List-of X]
; reverses the given list
(define (reverse.own l)
  (cond
    [(empty? l) '()]
    [else (append (reverse.own (rest l)) (list (first l)))]))

; [X Y -> Y] Y [List-of X] -> Y
(define (foldr.own f r l)
  (cond
    [(empty? l) r]
    [else (f (first l) (foldr.own f r (rest l)))]))


; ..:: Perfomance tests ::..
(define testlist (build-list 10000 add1))
(define original (time (relative->absolute testlist)))
(define own (time (relative->absolute.own testlist)))
; Results: September 23th, 2019
;cpu time: 13 real time: 14 gc time: 9           ; original
;cpu time: 2480 real time: 2482 gc time: 1217    ; own

