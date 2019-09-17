;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex429) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
(define (quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [(= (length alon) 1) alon]
    [else (local ((define pivot (first alon))
                  (define others (rest alon)))
            (append (quick-sort< (smallers others pivot))
                    (list pivot)
                    (quick-sort< (largers others pivot))))]))

(check-expect (quick-sort< '(11 8 14 7)) '(7 8 11 14))
(check-expect (quick-sort< '(11 9 3 2 18 3 6 12 3 4 14 2 7 4 1))
                           '(1 2 2 3 3 3 4 4 6 7 9 11 12 14 18))


; [List-of Number] Number -> [List-of Number]
; produces a list of those numbers from the given list that
; are larger than n
(define (largers alon n)
  (filter (lambda (i) (>= i n)) alon))
 
; [List-of Number] Number -> [List-of Number]
; produces a list of those numbers from the given list that
; are smaller than n
(define (smallers alon n)
  (filter (lambda (i) (< i n)) alon))
