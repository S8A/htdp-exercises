;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex477) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] -> [List-of [List-of X]]
; creates a list of all rearrangements of the items in w
; by prepending each item in w to the arrangements of w
; without said item
; termination the function removes one item from w on each
; recursive call, therefore it will reach '() at some point
(define (arrangements w)
  (cond
    [(empty? w) '(())]
    [else
      (foldr (lambda (item others)
               (local ((define without-item
                         (arrangements (remove item w)))
                       (define add-item-to-front
                         (map (lambda (a) (cons item a))
                              without-item)))
                 (append add-item-to-front others)))
        '()
        w)]))
 
(define (all-words-from-rat? w)
  (and (member (explode "rat") w)
       (member (explode "art") w)
       (member (explode "tar") w)))
 
(check-satisfied (arrangements '("r" "a" "t"))
                 all-words-from-rat?)


; Q: What is a trivially solvable problem?
; A: Producing the arrangements of an empty list.
; Q: How are trivial solutions solved?
; A: An empty list has no arrangements (returns the empty list).
; Q: How does the algorithm generate new problems that are more easily
; solvable than the original one? Is there one new problem that we generate or
; are there several?
; A: We have two new problems: finding the arrangements of w without a
; given item and adding the given item to the beginning of each of those
; arrangements. This must be done for each item in w.
; Q: Is the solution of the given problem the same as the solution of (one of)
; the new problems? Or, do we need to combine the solutions to create a
; solution for the original problem? And, if so, do we need anything from
; the original problem data?
; A: As explained above, we need to solve two problems for each item in w and
; then combine their solutions in a list. Therefore we use foldr to append
; the final solutions one after the other. To solve the first problem
; we just have to recursively call arrangements on w with the given item
; removed (using a built-in function). To solve the second problem we use
; the map function to cons the given item into the result of the first problem.
