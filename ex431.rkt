;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex431) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Answer the four key questions for the bundle problem and the first three
; questions for the quick-sort< problem.

; .: bundle :.
; Q: What is a trivially solvable problem?
; A: Bundling the chunks of an empty list.
; Q: How are trivial solutions solved?
; A: An empty list has no chunks. Therefore, the result is an empty list.
; Q: How does the algorithm generate new problems that are more easily
; solvable than the original one? Is there one new problem that we
; generate or are there several?
; A: We have two new problems: taking the first n elements from the list
; to make the first chunk and bundling the chunks of the list elements
; that come after that. The first problem requires a function take, whose
; result is consed to the result of recursively applying bundle to
; the result of another function drop.

; .: quick-sort< :.
; Q: What is a trivially solvable problem?
; A: Sorting an empty list and a list of one element.
; Q: How are trivial solutions solved?
; A: In both cases the result is the same list.
; Q: How does the algorithm generate new problems that are more easily
; solvable than the original one? Is there one new problem that we
; generate or are there several?
; A: We have two new problems: sorting the list items that are smaller than
; the pivot, and sorting the list items that are larger than the pivot.
; Those problems require two new functions (smallers and largers)
; whose results must each be sorted with recursive applications of quick-sort<.
; Q: Is the solution of the given problem the same as the solution of
; (one of) the new problems? Or, do we need to combine the solutions to
; create a solution for the original problem? And, if so, do we need
; anything from the original problem data?
; A: The solutions to those two new problems are appended to the left and
; right of the pivot to create the solution of the main problem. Also, the
; pivot is needed as an argument to both smallers and largers, to make the
; required comparisons.


; Q: How many instances of generate-problem are needed?
; A: In both cases two instances are required.
