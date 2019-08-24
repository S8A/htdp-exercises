;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex186) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; List-of-numbers -> List-of-numbers 
; rearranges alon in descending order
(define (sort> alon)
  (cond
    [(empty? alon) '()]
    [else
     (insert (first alon) (sort> (rest alon)))]))

(check-satisfied (sort> (list 3 2 1)) sorted>?)
(check-satisfied (sort> (list 1 2 3)) sorted>?)
(check-satisfied (sort> (list 12 20 -5)) sorted>?)


; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers alon
(define (insert n alon)
  (cond
    [(empty? alon) (list n)]
    [else
     (if (>= n (first alon))
         (cons n alon)
         (cons (first alon) (insert n (rest alon))))]))

(check-expect (insert 5 '()) (list 5))
(check-expect (insert 5 (list 6)) (list 6 5))
(check-expect (insert 5 (list 4)) (list 5 4))
(check-expect (insert 12 (list 20 -5))
              (list 20 12 -5))
(check-expect (insert 5 (list 12 10 8 7 3 2))
              (list 12 10 8 7 5 3 2))
(check-expect (insert 7 (list 6 5 4))
              (list 7 6 5 4))
(check-expect (insert 0 (list 6 2 1 -1))
              (list 6 2 1 0 -1))


; List-of-numbers -> Boolean
; is the list of numbers sorted in descending order
(define (sorted>? list)
  (cond
    [(empty? (rest list)) #true]
    [(cons? (rest list))
     (and (>= (first list) (first (rest list))) (sorted>? (rest list)))]))

(check-expect (sorted>? (list 2)) #true)
(check-expect (sorted>? (list 1 2)) #false)
(check-expect (sorted>? (list 3 2)) #true)
(check-expect (sorted>? (list 0 3 2)) #false)


; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(define (sort>/bad l)
  (list 9 8 7 6 5 4 3 2 1 0))

(check-satisfied (sort>/bad (list 3 5 4)) sorted>?)
(check-satisfied (sort>/bad '()) sorted>?)
