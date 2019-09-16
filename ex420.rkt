;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex420) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N -> [List-of Number]
(define (oscillate n)
  (local ((define (O i)
            (cond
              [(> i n) '()]
              [else
               (cons (expt #i-0.99 i) (O (+ i 1)))])))
    (O 1)))


; [List-of Number] -> Number
; Sums the numbers in the given list
(define (sum l)
  (foldl + 0 l))

; Summing its results from left to right computes a different result
; than from right to left:
; > (sum (oscillate #i1000.0))
; #i-0.49746596003269394
; > (sum (reverse (oscillate #i1000.0)))
; #i-0.4974659600326953
; Again, the difference may appear to be small until we see the context:
; > (- (* 1e+16 (sum (oscillate #i1000.0)))
;      (* 1e+16 (sum (reverse (oscillate #i1000.0)))))
; #i14.0

; Q: Can this difference matter? Can we trust computers?
; A: It may matter for specific, high-accuracy applications. Perhaps
; we should not trust them blindly, but I still trust them more than
; humans on many tasks.
