;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex423) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; String N -> [List-of String]
; produces a list of string chunks of size n from the given string
(define (partition s n)
  (cond
    [(zero? n) '()]
    [(< (string-length s) n) (list s)]
    [else
     (cons (substring s 0 n) (partition (substring s n) n))]))


(check-expect (partition "" 0) '())
(check-expect (partition "abcdefg" 0) '())
(check-expect (partition "" 3) '(""))
(check-expect (partition "abcdefg" 3) '("abc" "def" "g"))
