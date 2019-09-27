;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex518) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Q: Argue that our-cons takes a constant amount of time to compute its result,
; regardless of the size of its input.
; A: If n is the size of the r argument, we can prove that our-cons always takes
; a constant amount of time to run. In the case that r is empty (n=0), our-cons
; just creates a new pair with the given arguments and a count of 1, which is a
; "primitive" operation i.e. O(1). In the case that r is a list (n>0), our-cons
; just creates a new pair with the given arguments and the count of r plus 1,
; two primitive operations i.e. O(1). Otherwise, r is not a valid argument and
; our-cons just displays an error i.e. O(1).


(define-struct cpair [count left right])
; A [MyList X] is one of:
; – '()
; – (make-cpair (tech "N") X [MyList X])
; accumulator the count field is the number of cpairs
 
; Any ConsOrEmpty -> ConsOrEmpty
; data definitions, via a constructor-function 
(define (our-cons f r)
  (cond
    [(empty? r) (make-cpair 1 f r)]
    [(cpair? r) (make-cpair (+ (cpair-count r) 1) f r)]
    [else (error 'our-cons "not a list")]))
 
; ConsOrEmpty -> Any
; extracts the left part of the given pair
(define (our-first l)
  (if (empty? l)
      (error 'our-first "empty list")
      (cpair-left l)))

; ConsOrEmpty -> Any
; extracts the right part of the given pair
(define (our-rest l)
  (if (empty? l)
      (error 'our-rest "empty list")
      (cpair-right l)))

; Any -> N
; how many items does l contain
(define (our-length l)
  (cond
    [(empty? l) 0]
    [(cpair? l) (cpair-count l)]
    [else (error 'our-length "not a list")]))
