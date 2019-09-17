;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex430) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of X] [X X -> Boolean] -> [List-of X]
; produces a version of l sorted according to comparator cmp
(define (quick-sort l cmp)
  (cond
    [(empty? l) '()]
    [(= (length l) 1) l]
    [else (local ((define pivot (first l))
                  (define next (rest l))
                  (define before
                    (filter (lambda (n) (cmp n pivot)) next))
                  (define after
                    (filter (lambda (n) (not (cmp n pivot))) next)))
            (append (quick-sort before cmp)
                    (list pivot)
                    (quick-sort after cmp)))]))

(check-expect (quick-sort '(11 8 14 7) <) '(7 8 11 14))
(check-expect (quick-sort '(11 9 3 2 18 3 6 12 3 4 14 2 7 4 1) <)
                           '(1 2 2 3 3 3 4 4 6 7 9 11 12 14 18))
(check-expect
 (quick-sort '("Superman" "Batman" "Wonder Woman" "Flash" "Aquaman") string>?)
 '("Wonder Woman" "Superman" "Flash" "Batman" "Aquaman"))
