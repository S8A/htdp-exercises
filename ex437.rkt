;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex437) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;Define solve and combine-solutions so that

 ;special computes the length of its input,

; [List-of X] -> Number
; computes the length of P
(define (special1 P)
  (local ((define (solve p) 0)
          (define (combine-solutions p next)
            (+ 1 next)))
    (cond
      [(empty? P) (solve P)]
      [else
       (combine-solutions P (special1 (rest P)))])))

(check-expect (special1 '()) 0)
(check-expect (special1 '(a b c d e)) 5)


;special negates each number on the given list of numbers, and

; [List-of Number] -> [List-of Number]
; negates each number on the given list
(define (special2 P)
  (local ((define (solve p) '())
          (define (combine-solutions p next)
            (cons (- (first p)) next)))
    (cond
      [(empty? P) (solve P)]
      [else
       (combine-solutions P (special2 (rest P)))])))

(check-expect (special2 '()) '())
(check-expect (special2 '(-2 -1 0 1 2)) '(2 1 0 -1 -2))


;special uppercases the given list of strings.

; [List-of String] -> [List-of String]
; uppercases each string on the given list
(define (special3 P)
  (local ((define (solve p) '())
          (define (combine-solutions p next)
            (cons (string-upcase (first p)) next)))
    (cond
      [(empty? P) (solve P)]
      [else
       (combine-solutions P (special3 (rest P)))])))

(check-expect (special3 '()) '())
(check-expect (special3 '("all down" "ALL UP" "Mixed seNTence cAse"))
              '("ALL DOWN" "ALL UP" "MIXED SENTENCE CASE"))


; Q: What do you conclude from these exercises?
; A: That all list processing functions can be generalized to a single template.

