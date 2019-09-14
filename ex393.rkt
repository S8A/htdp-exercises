;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex393) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Son.R is one of: 
; – empty 
; – (cons Number Son.R)
; 
; Constraint If s is a Son.R, 
; no number occurs twice in s

; Son
(define es '())
 
; Number Son -> Boolean
; is x in s
(define (in? x s) (member? x s))


; Son Son -> Son
; Produces a set that contains all the elements of set1 and set2
(define (union set1 set2)
  (cond
;    [(and (empty? set1) (empty? set2)) '()]
;    [(and (empty? set1) (cons? set2)) set2]
;    [(and (cons? set1) (empty? set2)) set1]
;    [(and (cons? set1) (cons? set2))
    [(empty? set1) set2]
    [(cons? set1)
     (local ((define first-set1 (first set1)))
       (if (in? first-set1 set2)
           (union (rest set1) set2)
           (cons first-set1 (union (rest set1) set2))))]))

(check-expect (union '() '()) '())
(check-expect (union '() '(0 2 4 6)) '(0 2 4 6))
(check-expect (union '(0 1 3 5 6 7 9) '()) '(0 1 3 5 6 7 9))
(check-expect (union '(0 1 3 5 6 7 9) '(0 2 4 6)) '(1 3 5 7 9 0 2 4 6))


; Son Son -> Son
; Produces a set that contains the elements that are both in set1 and set2
(define (intersect set1 set2)
  (cond
;    [(and (empty? set1) (empty? set2)) '()]
;    [(and (empty? set1) (cons? set2)) '()]
;    [(and (cons? set1) (empty? set2)) '()]
;    [(and (cons? set1) (cons? set2))
    [(empty? set1) '()]
    [(cons? set1)
     (local ((define first-set1 (first set1)))
       (if (in? first-set1 set2)
           (cons first-set1
                 (intersect (rest set1) (remove-all first-set1 set2)))
           (intersect (rest set1) set2)))]))

(check-expect (intersect '() '()) '())
(check-expect (intersect '() '(0 2 4 6)) '())
(check-expect (intersect '(0 1 3 5 6 7 9) '()) '())
(check-expect (intersect '(0 1 3 5 6 7 9) '(0 2 4 6)) '(0 6))
