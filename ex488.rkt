;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex488) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Q: Compare f(n) = n·log(n) and g(n)=n². Does f belong to O(g) or g to O(f)?
; A: To say that f belongs to O(g) is to say that there exist two numbers c and
; bigEnough such that for all n >= bigEnough it is true that f(n) <= c·g(n)
; First, we choose bigEnough = 1 (because 0 is a trivial solution).
; Now, assuming that n > 1, we find c from the second inequality:
;                         f(n) <= c·g(n)
;                     n·log(n) <= c·n²
;                     log(n)/n <= c
; To prove that c exists we have to check if the left hand expression grows
; indefinitely as n grows or not:
;   lim_{n->inf} [log(n)/n] = lim_{n->inf} [(1/n) / 1]      L'Hopital
;                           = lim_{n->inf} [1/n]
;                           = 0
; Since it doesn't grow indefinitely, there must be a constant number c > 0
; that can be multiplied by g to make it always greater than or equal to f.
; Thus, we have proved that f belongs to O(g).
; Just to be sure, let's go through the same process for the other hypothesis.
; To say that g belongs to O(f) is to say that there exist two numbers c and
; bigEnough such that for all n >= bigEnough it is true that g(n) <= c·f(n)
; First, we choose bigEnough = 1
; Now, assuming that n > 1, we find c from the second inequality:
;                         g(n) <= c·f(n)
;                           n² <= cn·log(n)
;                     n/log(n) <= c
; To prove that c exists we have to check if the left hand expression grows
; indefinitely as n grows or not:
;   lim_{n->inf} [n/log(n)] = lim_{n->inf} [1 / (1/n)]      L'Hopital
;                           = lim_{n->inf} n
;                           = inf
; Since it grows indefinitely, there is no constant number that can be
; multiplied by f to make it always greater than or equal to g.
; Therefore, g doesn't belong to O(f).
