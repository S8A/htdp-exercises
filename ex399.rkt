;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex399) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; [List-of String] -> [List-of String] 
; picks a random non-identity arrangement of names
(define (gift-pick names)
  (random-pick
    (non-same names (arrangements names))))


; .: From intermezzo 3 :.
; [List-of X] -> [List-of [List-of X]]
; creates a list of all rearrangements of the items in w
(define (arrangements w)
  (cond
    [(empty? w) '(())]
    [else (for*/list ([item w]
                      [arrangement-without-item
                       (arrangements (remove item w))])
            (cons item arrangement-without-item))]))


; [NEList-of X] -> X 
; returns a random item from the list 
(define (random-pick l)
  (list-ref l (random (length l))))

(check-random (random-pick '(a b c d e f)) (list-ref '(a b c d e f) (random 6)))

 
; [List-of String] [List-of [List-of String]] -> [List-of [List-of String]]
; produces the list of those lists in ll that do 
; not agree with names at any place 
(define (non-same names ll)
  (cond
    [(empty? ll) ll]
    [(cons? ll)
     (if (equal? names (first ll))
         (non-same names (rest ll))
         (cons (first ll) (non-same names (rest ll))))]))

(check-expect (non-same '() '()) '())
(check-expect (non-same '() '((a b c) (d e))) '((a b c) (d e)))
(check-expect (non-same '(a b) '((a b c) (d e))) '((a b c) (d e)))
(check-expect (non-same '(a b c) '((a b c) (d e))) '((d e)))
