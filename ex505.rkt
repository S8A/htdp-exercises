;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex505) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N [>=1] -> Boolean
; determines whether n0 is a prime number
(define (is-prime? n0)
  (local (; N [>=1] [List-of N] -> Boolean
          ; determines whether n0 is a prime number by checking
          ; if n is one of its divisors or not
          ; accumulator divs is the list of known divisors of n0
          (define (prime-check n divs)
            (cond
              [(= n 1) (= (length divs) 0)]
              [else
               (prime-check (sub1 n)
                            (if (= (remainder n0 n) 0)
                                (cons n divs)
                                divs))])))
    (prime-check (sub1 n0) '())))

(check-expect (is-prime? 5870) #false)
(check-expect (is-prime? 3023) #true)
