;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex395) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] N -> [List-of X]
; Produces the first n items of l
(define (take n l)
  (cond
    [(and (= n 0) (empty? l)) '()]
    [(and (= n 0) (cons? l)) '()]
    [(and (> n 0) (empty? l)) '()]
    [(and (> n 0) (cons? l))
     (cons (first l) (take (sub1 n) (rest l)))]))

(check-expect (take 0 '()) '())
(check-expect (take 0 '(a b c d e)) '())
(check-expect (take 3 '()) '())
(check-expect (take 3 '(a b c d e)) '(a b c))


; [List-of X] N -> [List-of X]
; Produces l with the first n items removed
(define (drop n l)
  (cond
    [(and (= n 0) (empty? l)) '()]
    [(and (= n 0) (cons? l)) l]
    [(and (> n 0) (empty? l)) '()]
    [(and (> n 0) (cons? l))
     (drop (sub1 n) (rest l))]))

(check-expect (drop 0 '()) '())
(check-expect (drop 0 '(a b c d e)) '(a b c d e))
(check-expect (drop 3 '()) '())
(check-expect (drop 3 '(a b c d e)) '(d e))
