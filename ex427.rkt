;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex427) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; For time comparisons
(define SHORT (build-list 100 (lambda (n) (random 100))))
(define LONG (build-list 10000 (lambda (n) (random 10000))))
(define VERY-LONG (build-list 100000 (lambda (n) (random 100000))))
(define TOO-LONG (build-list 1000000 (lambda (n) (random 1000000))))


; [List-of Number] -> [List-of Number]
; produces a sorted version of alon without duplicates
(define (fast-sort< alon)
  (cond
    [(< (length alon) 10) (sort< alon)]
    [else (local ((define pivot (first alon)))
            (append (fast-sort< (smallers alon pivot))
                    (list pivot)
                    (fast-sort< (largers alon pivot))))]))


; List-of-numbers -> List-of-numbers
; produces a sorted version of l without duplicates
(define (sort< l)
  (cond
    [(empty? l) '()]
    [(cons? l) (insert (first l) (sort< (rest l)))]))
 
; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers l 
(define (insert n l)
  (cond
    [(empty? l) (cons n '())]
    [else (cond
            [(< n (first l)) (cons n l)]
            [(= n (first l)) l]
            [else (cons (first l) (insert n (rest l)))])]))


; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
; assume the numbers are all distinct 
(define (quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [(= (length alon) 1) alon]
    [else (local ((define pivot (first alon)))
            (append (quick-sort< (smallers alon pivot))
                    (list pivot)
                    (quick-sort< (largers alon pivot))))]))
 
; [List-of Number] Number -> [List-of Number]
; produces a list of those numbers from the given list that
; are larger than n
(define (largers alon n)
  (cond
    [(empty? alon) '()]
    [else (if (> (first alon) n)
              (cons (first alon) (largers (rest alon) n))
              (largers (rest alon) n))]))
 
; [List-of Number] Number -> [List-of Number]
; produces a list of those numbers from the given list that
; are smaller than n
(define (smallers alon n)
  (cond
    [(empty? alon) '()]
    [else (if (< (first alon) n)
              (cons (first alon) (smallers (rest alon) n))
              (smallers (rest alon) n))]))
