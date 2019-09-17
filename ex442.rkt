;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex442) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N -> [List-of [List-of Number]]
; Creates 10 lists of n random numbers in the range [0, n)
; and tests the sorting functions.
(define (create-tests n)
  (build-list 10 (lambda (l) (build-list n (lambda (i) (random n))))))

(define TEST25 (create-tests 25))
(define TEST50 (create-tests 50))
(define TEST75 (create-tests 75))
(define TEST100 (create-tests 100))
(define TEST1000 (create-tests 1000))
(define TEST10000 (create-tests 10000))


; [[List-of Number] -> [List-of Number]] [List-of [List-of Number]
; -> [List-of Number]
; Takes a sorting function and a list of lists of numbers and
; runs the function on each list, measuring the time it takes on
; each input
(define (test-sort f lln)
  (map (lambda (alon) (time (f alon))) lln))


; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
; assume the numbers are all distinct 
(define (quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [else (local ((define pivot (first alon)))
            (append (quick-sort< (smallers (rest alon) pivot))
                    (list pivot)
                    (quick-sort< (largers (rest alon) pivot))))]))
 
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
(define (smallers l n)
  (cond
    [(empty? l) '()]
    [else (if (<= (first l) n)
              (cons (first l) (smallers (rest l) n))
              (smallers (rest l) n))]))


; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(define (sort< l)
  (cond
    [(empty? l) '()]
    [(cons? l) (insert (first l) (sort< (rest l)))]))
 
; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers l 
(define (insert n l)
  (cond
    [(empty? l) (cons n '())]
    [else (if (<= n (first l))
              (cons n l)
              (cons (first l) (insert n (rest l))))]))


; ..:: TEST RESULTS ::..
; Based on the time measurements recorded in the file ex442.times.txt
; Q: Does the experiment confirm the claim that the plain sort< function
; often wins over quick-sort< for short lists and vice versa?
; A: The functions have about the same perfomance on lists of 25 and 50 items.
; On lists of 75 items and above quick-sort< is faster, by more than one order
; of magnitude in lists of 1000 items and more.
; Q: Determine the cross-over point. Use it to build a clever-sort function
; that behaves like quick-sort< for large lists and like sort< for lists
; below this cross-over point.
; A: Seems to be about 75 items, instead of the 100 items threshold used in
; exercise 427.

; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
(define (clever-sort< alon)
  (cond
    [(< (length alon) 75) (sort< alon)]
    [else (local ((define pivot (first alon)))
            (append (clever-sort< (smallers (rest alon) pivot))
                    (list pivot)
                    (clever-sort< (largers (rest alon) pivot))))]))
