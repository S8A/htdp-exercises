;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex270) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Use build-list to define a function that:

; creates the list (list 0 ... (- n 1)) for any natural number n;
(define (list-numbers-0 n)
  (local ((define (echo x) x))
    (build-list n echo)))

(check-expect (list-numbers-0 5) '(0 1 2 3 4))


; creates the list (list 1 ... n) for any natural number n;
(define (list-numbers-1 n)
  (build-list n add1))

(check-expect (list-numbers-1 5) '(1 2 3 4 5))


; creates the list (list 1 1/2 ... 1/n) for any natural number n;
(define (list-inverses n)
  (local ((define (inverse x) (/ 1 (add1 x))))
    (build-list n inverse)))

(check-expect (list-inverses 5) '(1 1/2 1/3 1/4 1/5))


; creates the list of the first n even numbers; and
(define (list-first-even n)
  (local ((define (double x) (* 2 x)))
    (build-list n double)))

(check-expect (list-first-even 5) '(0 2 4 6 8))


; creates a diagonal square of 0s and 1s; see exercise 262.
(define (identityM n)
  (local (; N -> N
          ; Generates each item of the first row.
          (define (first-row-item i) (if (= i 0) 1 0))
          ; Row -> Row
          ; Adds a zero at the start of the row.
          (define (prepend0 row) (cons 0 row)))
    (cond
      [(zero? n) '()]
      [else
       (cons (build-list n first-row-item)
             (map prepend0 (identityM (sub1 n))))])))

(check-expect (identityM 1) (list (list 1)))
(check-expect (identityM 2) (list (list 1 0) (list 0 1)))
(check-expect (identityM 3) (list (list 1 0 0) (list 0 1 0) (list 0 0 1)))


; Finally, define tabulate from exercise 250 using build-list.
(define (tabulate n f)
  (reverse (build-list (add1 n) f)))

(check-within (tabulate 0 sin) (list (sin 0)) 0.00001)
(check-within (tabulate 2 sin) (list (sin 2) (sin 1) (sin 0)) 0.00001)
(check-within (tabulate 0 sqrt) (list (sqrt 0)) 0.00001)
(check-within (tabulate 2 sqrt) (list (sqrt 2) (sqrt 1) (sqrt 0)) 0.00001)
