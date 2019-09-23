;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex487) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Q: Consider the functions f(n) = 2^n and g(n) = 1000 n. Show that g belongs
; to O(f), which means that f is, abstractly speaking, more (or at least
; equally) expensive than g.
; A: To say that g belongs to O(f) is to say that there exist numbers c and
; bigEnough such that for all n >= bigEnough it is true that g(n) <= c·f(n)
; First, we choose bigEnough = 1 (because 0 is a trivial solution).
; Now, assuming n > 1, we find c from the second inequality:
;                      g(n) <= c·f(n)
;                     1000n <= c·2^n
;                 1000n/2^n <= c
; To prove that c exists we have to check if the left hand expression grows
; indefinitely as n grows or not:
;   lim_{n->inf} [1000n/2^n] = 1000 · lim_{n->inf} [n/2^n]
;                (L'Hopital) = 1000 · lim_{n->inf} [1/(2^n · log(2))]
;                            = 1000/ln(2) · lim_{n->inf} [1/2^n]
;                            = 1000/ln(2) · 0
;                            = 0
; As n approaches infinity, the left hand expression approaches 0. That means
; that there is a constant c > 0 such that it can be multiplied by f to make
; it always greater than or equal to g.
; Thus, we have proved that g belongs to O(f).
; Q: If the input size is guaranteed to be between 3 and 12,
; which function is better?
; A: As shown above, g is better than f in abstract terms. In concrete terms,
; we have to compare the actual values of the functions. Assuming that both
; have their respective cost constants plugged in (1 per recursive step in f,
; 1000 per step in g), we can simply tabulate some values from the interval
; [3,12] to make the comparison:
;
; n        3     4     5     6     7     8     9    10    11    12
; f(n)  3000  4000  5000  6000  7000  8000  9000 10000 11000 12000
; g(n)     8    16    32    64   128   256   512  1024  2048  4096
;
; For all the given values, g takes less time than f. Since both functions
; are continuous increasing functions, we can use induction to say that
; this is true for all values in between. Therefore, g is better than f
; in the given interval.
