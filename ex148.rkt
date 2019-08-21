;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex148) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Q: Is it better to work with data definitions that accommodate
; empty lists as opposed to definitions for non-empty lists? Why? Why not?
; A: It's hard to say whether one is always better than the other since
; there are infinite possibilities and not all problems are the same.
; However, there are cases where it's obvious that accommodating empty
; lists in the data definition is counter-productive. The all-true and
; one-true functions are good examples. The all-true function determines
; whether all the elements in a list of booleans are true, but to work
; it needs the base case of an empty list to be true, which doesn't make
; much sense on its face (if the list is empty there are no elements
; to be true or false). The one-true function determines whether at least
; one element is true, and says that this is false for the base case of an
; empty list, which does make sense since there are no items that are true.
; But now there's a contradiction: all-true says that all the elements of an
; empty list are true but one-true says that an empty list doesn't have even
; one item that is true.

