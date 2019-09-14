;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex394) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] [List-of Number] -> [List-of Number]
; Takes two lists of numbers sorted in ascending order and
; merges them into a single sorted list. Keeps duplicates.
(define (merge lon1 lon2)
  (local (; Number [List-of Number] -> [List-of Number]
          (define (insert n lon)
            (cond
              [(empty? lon) (list n)]
              [(cons? lon)
               (if (<= n (first lon))
                   (cons n lon)
                   (cons (first lon) (insert n (rest lon))))])))
    (cond
;      [(and (empty? lon1) (empty? lon2)) '()]
;      [(and (empty? lon1) (cons? lon2)) lon2]
;      [(and (cons? lon1) (empty? lon2)) lon1]
;      [(and (cons? lon1) (cons? lon2))
      [(empty? lon1) lon2]
      [(cons? lon1)
       (insert (first lon1) (merge (rest lon1) lon2))])))

(check-expect (merge '() '()) '())
(check-expect (merge '() '(0 2 4 6)) '(0 2 4 6))
(check-expect (merge '(0 1 3 5 6 7 9) '()) '(0 1 3 5 6 7 9))
(check-expect (merge '(0 1 3 5 6 7 9) '(0 2 4 6)) '(0 0 1 2 3 4 5 6 6 7 9))
