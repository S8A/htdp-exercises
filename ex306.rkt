;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex306) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; Use loops to define a function that:

; creates the list (list 0 ... (- n 1)) for any natural number n;
(define (list-numbers-0 n)
  (for/list ([i n]) i))

(check-expect (list-numbers-0 5) '(0 1 2 3 4))


; creates the list (list 1 ... n) for any natural number n;
(define (list-numbers-1 n)
  (for/list ([i n]) (add1 i)))

(check-expect (list-numbers-1 5) '(1 2 3 4 5))


; creates the list (list 1 1/2 ... 1/n) for any natural number n;
(define (inverses n)
  (for/list ([i n]) (/ 1 (add1 i))))

(check-expect (inverses 5) '(1 1/2 1/3 1/4 1/5))


; creates the list of the first n even numbers; and
(define (list-first-even n)
  (for/list ([i n]) (* 2 i)))

(check-expect (list-first-even 5) '(0 2 4 6 8))


; creates a diagonal square of 0s and 1s; see exercise 262.
(define (identityM n)
  (for/list ([i n]) (for/list ([j n]) (if (= i j) 1 0))))

(check-expect (identityM 1) (list (list 1)))
(check-expect (identityM 2)
              (list (list 1 0) (list 0 1)))
(check-expect (identityM 3)
              (list (list 1 0 0) (list 0 1 0) (list 0 0 1)))


; Finally, use loops to define tabulate from exercise 250.
(define (tabulate n f)
  (reverse (for/list ([i (add1 n)]) (f i))))

(check-within (tabulate 0 sin) (list (sin 0)) 0.00001)
(check-within (tabulate 2 sin) (list (sin 2) (sin 1) (sin 0)) 0.00001)
(check-within (tabulate 0 sqrt) (list (sqrt 0)) 0.00001)
(check-within (tabulate 2 sqrt) (list (sqrt 2) (sqrt 1) (sqrt 0)) 0.00001)
