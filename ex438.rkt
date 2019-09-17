;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex438) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N[>= 1] N[>= 1] -> N
; finds the greatest common divisor of n and m
(define (gcd-structural n m)
  (local (; N -> N
          ; determines the gcd of n and m less than i
          (define (greatest-divisor-<= i)
            (cond
              [(= i 1) 1]
              [else
               (if (= (remainder n i) (remainder m i) 0)
                   i
                   (greatest-divisor-<= (- i 1)))])))
    (greatest-divisor-<= (min n m))))

(check-expect (gcd-structural 6 25) 1)
(check-expect (gcd-structural 18 24) 6)


; Q: In your words: how does greatest-divisor-<= work?
; Use the design recipe to find the right words.
; A: It finds the GCD of n and m less than i in the trivial case and
; the non-trivial case. The trivial case is i equal to 1, in which case
; 1 is the GCD. In the non-trivial case, we first check if both n and m
; are evenly divisible by i, which would mean that i is the GCD by definition;
; otherwise it recurs itself with i substracted by 1. The termination argument
; is that at some point either a GCD is found or i reaches 1 (and the GCD would
; be 1).
; Q: Why does the locally defined greatest-divisor-<= recur on (min n m)?
; A: Because the first candidate for the GCD of two numbers is the smaller of
; the two (i.e. one number is evenly divisible by the other, which must be
; the smaller one). If they are not evenly divisible by that, the locally
; defined function will recur until the GCD is found.
