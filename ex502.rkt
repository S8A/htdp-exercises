;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex502) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [NEList-of 1String] -> [NEList-of 1String]
; creates a palindrome from s0
(define (mirror s0)
  (append (all-but-last s0)
          (list (last s0))
          (reverse (all-but-last s0))))

(check-expect (mirror (explode "abc")) (explode "abcba"))

; [NEList-of X] -> X
; extracts the last item from the list
(define (last l)
  (cond
    [(empty? (rest l)) (first l)]
    [(cons? (rest l)) (last (rest l))]))

; [NEList-of X] -> [List-of X]
; removes the last item from the list
(define (all-but-last l)
  (cond
    [(empty? (rest l)) '()]
    [(cons? (rest l)) (cons (first l) (all-but-last (rest l)))]))


; [NEList-of X] -> [NEList-of X]
; creates a palindrome from s0
(define (palindrome s0)
  (local (; [NEList-of X] [List-of X] -> [NEList-of X]
          ; creates a palindrome from s and a
          ; accumulator a is the reverse of s0 without the items
          ; in s
          (define (palindrome/a s a)
            (cond
              [(empty? (rest s)) (append s0 a)]
              [(cons? (rest s)) (palindrome/a (rest s) (cons (first s) a))])))
    (palindrome/a s0 '())))

(check-expect (palindrome (explode "abc")) (explode "abcba"))
