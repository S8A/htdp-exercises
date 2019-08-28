;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex238) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; (Number Number->Boolean) Nelon -> Number
; Determines the first item of l when ordered by comparator R
(define (first-by-comparator R l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (if (R (first l) (first-by-comparator R (rest l)))
         (first l)
         (first-by-comparator R (rest l)))]))


; Nelon -> Number
; determines the smallest number on l
(define (inf-1 l)
  (first-by-comparator < l))

;(check-expect (inf-1 (list 25 24 23 22 21 20 19 18 17 16 15 14 13 
;                           12 11 10 9 8 7 6 5 4 3 2 1))
;              1)
;(check-expect (inf-1 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 
;                           17 18 19 20 21 22 23 24 25))
;              1)


; Nelon -> Number
; determines the largest number on l
(define (sup-1 l)
  (first-by-comparator > l))

;(check-expect (sup-1 (list 25 24 23 22 21 20 19 18 17 16 15 14 13 
;                           12 11 10 9 8 7 6 5 4 3 2 1))
;              25)
;(check-expect (sup-1 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 
;                           17 18 19 20 21 22 23 24 25))
;              25)


; Q: Why are these functions slow on some of the long lists?
; A: Because to find the smallest/largest number in the list they have to
; find the smallest/largest number in the list without its first element
; and compare them. Finding the smallest/largest number for (rest l), in turn,
; repeats the same process. Furthermore, for each iteration if the comparison
; produces #false, the function has to find the smallest/largest number in
; (rest l) since it was not stored anywhere before being used in the comparison.
; To sum up, the iterations of this process, and therefore its runtime, seems
; to grow exponentially with the size of the list.


; (Number Number->Boolean) Nelon -> Number
; Determines the first item of l when ordered by comparator R
(define (first-by-comparator-2 R l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (R (first l) (first-by-comparator-2 R (rest l)))]))


; Nelon -> Number
; determines the smallest number on l
(define (inf-2 l)
  (first-by-comparator-2 min l))

(check-expect (inf-2 (list 25 24 23 22 21 20 19 18 17 16 15 14 13 
                           12 11 10 9 8 7 6 5 4 3 2 1))
              1)
(check-expect (inf-2 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 
                           17 18 19 20 21 22 23 24 25))
              1)


; Nelon -> Number
; determines the largest number on l
(define (sup-2 l)
  (first-by-comparator-2 max l))

(check-expect (sup-2 (list 25 24 23 22 21 20 19 18 17 16 15 14 13 
                           12 11 10 9 8 7 6 5 4 3 2 1))
              25)
(check-expect (sup-2 (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 
                           17 18 19 20 21 22 23 24 25))
              25)


; Q: Why are these versions so much faster?
; A: To find the smallest/largest element of l with these functions
; requires applying min/max to (first l) and the smallest/largest element of
; (rest l), and the process is repeated for the latter, and so on.
; But the big difference is that this process only has to occur once per item
; of the list, since min/max does the comparison with the result of those
; processes without having to do them again (i.e. it somehow stores the
; parameters and just passes the smallest/largest of the two as a result).
; Therefore, the number of steps, and therefore the runtime required for
; these functions grows only linearly with the length of l.
