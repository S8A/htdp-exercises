;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex486) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Q: In the first subsection, we stated that the function f(n) = n² + n
; belongs to the class O(n²). Determine the pair of numbers c and bigEnough
; that verify this claim.
; A: To say that n² + n is a member of O(n²) is to say that there exist two
; numbers c and bigEnough such that for all n >= bigEnough it is true that
; n² + n <= c·n²
; First, we choose bigEnough = 1 (because 0 is a trivial solution).
; Now, assuming that n > 1, we find c from the second inequality:
;                   n² + n <= c·n²
;                  1 + 1/n <= c
; To prove that c exists we have to check if the left hand expression grows
; indefinitely as n grows or not:
;   lim_{n->inf} [1 + 1/n] = 1 + 1/inf = 1 + 0 = 1
; Therefore, there must be a constant c > 1 such that it can be multiplied
; by n² to make it always greater than or equal to n² + n. Thus, we have proved
; that n² + n belongs to O(n²).
; Since we have to choose a specific number, we can go with c = 2 along with
; the previously chosen bigEnough = 1.
