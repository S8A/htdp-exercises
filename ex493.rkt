;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex493) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] -> [List-of X]
; constructs the reverse of alox
(define (invert alox)
  (cond
    [(empty? alox) '()]
    [else
     (add-as-last (first alox) (invert (rest alox)))]))
 
(check-expect (invert '(a b c)) '(c b a))

 
; X [List-of X] -> [List-of X]
; adds an-x to the end of alox
(define (add-as-last an-x alox)
  (cond
    [(empty? alox) (list an-x)]
    [else
     (cons (first alox) (add-as-last an-x (rest alox)))]))
 
(check-expect (add-as-last 'a '(c b)) '(c b a))


; Q: Argue that [...] invert consumes O(n²) time when the given list
; consists of n items.
; A: It's evident that for a list of n items, invert applies add-as-last
; once for each (first) item and invert to the rest of the list once
; per item except the last one. On the other hand, add-as-last is a simple
; list processing function that calls itself on the rest of the given list
; for each item except the last one; thus, add-as-last requires n-1 recursive
; calls to itself. Therefore, invert requires n-1 recursive calls to itself
; and, for each of those, n-1 recursive calls to add-as-last, producing an
; abstract time of (n-1)² which belongs to O(n²).
