;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex387) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; [List-of Symbol] [List-of Number] -> [List-of [List Symbol Number]]
; produces all possible ordered pairs of symbols and numbers from
; the given lists of each
(define (cross los lon)
  (cond
    [(empty? los) '()]
    [(cons? los)
     (append (map (lambda (n) (list (first los) n)) lon)
             (cross (rest los) lon))]))

(check-expect (cross '(a b c) '(1 2))
              '((a 1) (a 2) (b 1) (b 2) (c 1) (c 2)))
(check-expect (cross '() '(1 2)) '())
(check-expect (cross '(a b c) '()) '())
